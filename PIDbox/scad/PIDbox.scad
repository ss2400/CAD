// PIDbox.scad - PID controller housing in OpenSCAD

$fn = 100;
$pp1_colour = "Orange";
$pp2_colour = "SlateGray";

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/toggles.scad>
include <NopSCADlib/vitamins/ssrs.scad>
include <NopSCADlib/vitamins/iecs.scad>
use <NopSCADlib/printed/foot.scad>
use <NopSCADlib/printed/printed_box.scad>

use <OpenSCAD_Libs/ta4_mnt.scad>
use <OpenSCAD_Libs/nema515snap_mnt.scad>
use <OpenSCAD_Libs/kcouple_mnt.scad>

/* Box dimensions */
Width   = 145;      // Width (X)
Depth   = 86;       // Depth (Y)
Height  = 125;      // Height (Z)
Ridges  = [8,1];
wall    = 3;        // Box side wall thickness
top_thickness = 4;  // Fixed box panel thickness
base_thickness = 4; // Removable front panel
inner_rad = 15;
m = 0.2;

/* PID dimensions */
PidPosX = 0;
PidPosY = 0;
PidPosZ = base_thickness;

/* Switch dimensions */
SwPosX = 44;
SwPosY = 18;
SwPosZ = base_thickness/2;
SwDia  = 12.4;

/* Thermocouple connector dimensions */
ThermPosX = -44;
ThermPosY = -18;
ThermPosZ = base_thickness;

/* Load connector dimensions */
LoadPosX = 55;
LoadPosY = 0;
LoadPosZ = 0;

/* Line connector dimensions */
LinePosX = -55;
LinePosY = 0;
LinePosZ = 0;

/* SSR connector dimensions */
SsrPosX = 0;
SsrPosY = 0;
SsrPosZ = 0;
SsrWidth  = 62;
SsrHeight = 45;
SsrScrewDist = 47;
SsrThick = 6;

/* [STL element to export] */
Shell       = 1;    // Show shell [0:No, 1:Yes]
FPanel      = 0;    // Show front panel [0:No, 1:Yes]
Components  = 1;    // Show components

foot = Foot(d = 13, h = 5, t = 2, r = 1, screw = M3_cs_cap_screw);
module foot_stl() foot(foot);

box1 = pbox(name = "box1",
            wall = wall,
            top_t = top_thickness,
            base_t = base_thickness,
            radius = inner_rad,
            size = [Width, Depth, Height],
            screw = M3_cap_screw,
            ridges = Ridges);

module box1_feet_positions() {
  clearance = 2;
  foot_r = foot_diameter(foot) / 2;
  x_inset = inner_rad + foot_r - pbox_ridges(box1).y;
  z_inset = foot_r + clearance;
  h = Height + base_thickness;

  for(p = [[-1, -1], [1, -1], [-1, 1], [1, 1]])
    translate([p.x * (Width / 2 - x_inset),
               Depth / 2 + wall + pbox_ridges(box1).y,
               top_thickness + h / 2 + p.y * (h / 2 - z_inset)])
      rotate([90, 0, 0])
        children();
}

module box1_internal_additions() {
  d = washer_diameter(screw_washer(foot_screw(foot))) + 1;
  h = pbox_ridges(box1).y;
  box1_feet_positions()
    translate_z(wall - eps)
      cylinder(d2 = d, d1 = d + 2 * h, h = h);

  // SSR mount expansion
  translate([SsrPosX,SsrPosY,SsrThick/2])
    rounded_cube_xy([SsrWidth+12,SsrHeight+6,SsrThick], r=3, xy_center=true, z_center=true);
}

module box1_external_additions() {
  amp = pbox_ridges(box1).y + eps;
  d = foot_diameter(foot) + 1;
  box1_feet_positions()
    cylinder(d1 = d, d2 = d + 2 * amp, h = amp);
  
  // SSR component model
  if (Components)
    translate([SsrPosX,SsrPosY,SsrPosZ-5])
      %ssr_assembly(type=SSR25DA, screw=M4_cap_screw, thickness=top_thickness);
      
  // Line connector model
  if (Components)
    translate([LinePosX,LinePosY,LinePosZ])
      vflip() rotate(270) %iec_assembly(IEC_inlet, thickness=base_thickness);

  // Load connector model
  if (Components)
    translate([LoadPosX,LoadPosY,LoadPosZ])
      hflip() %nema515snap();
}

module box1_holes() {
  // Feet
  box1_feet_positions()
    teardrop_plus(r = screw_pilot_hole(foot_screw(foot)), h = 10, center = true);

  // SSR cutout
  translate([SsrPosX,SsrPosY,0]) {
    difference() {
      rounded_cube_xy([SsrWidth+4,SsrHeight+4,SsrThick*3], r=1, xy_center=true, z_center=true);
      // SSR mount wings
      translate([-26,0,0])
        rounded_cube_xy([20,9,SsrThick*3], r=4.49, xy_center=true, z_center=true);
      translate([26,0,0])
        rounded_cube_xy([20,9,SsrThick*3], r=4.49, xy_center=true, z_center=true);
    }
    // SSR screw slots
    for (i=[0:0.2:2]) {
      translate([-SsrScrewDist/2-i+1,0,0])
      cylinder(d=4.5, h=SsrThick*3);
      translate([SsrScrewDist/2+i-1,0,0])
      cylinder(d=4.5, h=SsrThick*3);
    }
  }
  
  // Line cutout
  translate([LinePosX,LinePosY,LinePosZ])
    vflip() rotate(90) iec_holes(type=IEC_inlet, insert=true);
      
  // Load cutout
  translate([LoadPosX,LoadPosY,LoadPosZ])
    hflip() nema515snap_cutout();
}

module box1_case_stl() {
  pbox(box1) {
    box1_internal_additions();
    box1_holes();
    box1_external_additions();
  }
}

module box1_base_additions() {
  // Thermocouple mount
  translate([ThermPosX,ThermPosY,ThermPosZ]) {
    kcouple_mount();
      if (Components) %kcouple();
  }
  
  // PID mount
  translate([PidPosX,PidPosY,PidPosZ]) {
    ta4_mount(thick=10, offset=7);
      if (Components) %ta4(offset=7);  
  }
}

module box1_base_holes() {
  // Toggle switch cutout
  translate([SwPosX,SwPosY,SwPosZ])
    cylinder(d=SwDia, h = base_thickness*2, center=true);

  // Thermocouple cutout
  translate([ThermPosX,ThermPosY,ThermPosZ+0.01])
    kcouple_cutout();

  // PID cutout
  translate([PidPosX,PidPosY,PidPosZ])
    ta4_cutout();
}

module box1_base_stl() {
  pbox_base(box1) {
    box1_base_additions();
    box1_base_holes();
  }
}

module box1_assembly() {
  assembly("box1") {
    explode(50, true) {

      // Case
      if(Shell) {
        render() box1_case_stl();

        // Box screws and heat inserts
        pbox_inserts(box1);
        pbox_base_screws(box1);
    
        // Feet
        box1_feet_positions() {
          foot_assembly(0, foot);

          vflip()
            translate_z(foot_thickness(foot))
              screw_and_washer(foot_screw(foot), 6);
        }
      }
      
      // Base
      if(FPanel) {        
        translate_z(Height + top_thickness + 2 * eps)
          rotate(180)
            render() box1_base_stl();
      }
    }
  }
}

module main_assembly()
  assembly("main") {
    rotate(180)
      box1_assembly();
}

if($preview)
  main_assembly();

echo(pbox_insert(box1));
echo(pbox_screw(box1));
echo(pbox_screw_inset(box1));
echo(pbox_screw_length(box1));
