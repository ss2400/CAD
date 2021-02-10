// PIDbox.scad - PID controller housing in OpenSCAD

$fn = 100;
$pp1_colour = "DimGray";
$pp2_colour = "SlateGray";

include <NopSCADlib/core.scad>
include <NopSCADlib/vitamins/toggles.scad>
include <NopSCADlib/vitamins/ssrs.scad>
include <NopSCADlib/vitamins/iecs.scad>
use <NopSCADlib/printed/foot.scad>
use <NopSCADlib/printed/printed_box.scad>


/* Box dimensions */
Width   = 140;  // Width (X)
Depth   = 80;   // Depth (Y)
Height  = 125;  // Height (Z)
Ridges  = [8,1];

m = 0.2;

wall = 3;
top_thickness = 3;
base_thickness = 3;
inner_rad = 15;

/* Arduino dimensions */
NanoPosX = 18;
NanoPosY = -22;
NanoPosZ = base_thickness-0.01;
NanoHeight = 6;

/* Connector dimensions */
Cable = 6.5;

/* [STL element to export] */
Shell       = 1;    // Shell [0:No, 1:Yes]
FPanel      = 1;    // Front panel [0:No, 1:Yes]
Components  = 1;    // Parts

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
    translate([p.x * (Width / 2 - x_inset), Depth / 2 + wall + pbox_ridges(box1).y, top_thickness + h / 2 + p.y * (h / 2 - z_inset)])
      rotate([90, 0, 0])
        children();
}

module box1_internal_additions() {
  d = washer_diameter(screw_washer(foot_screw(foot))) + 1;
  h = pbox_ridges(box1).y;
  box1_feet_positions()
    translate_z(wall - eps)
      cylinder(d2 = d, d1 = d + 2 * h, h = h);
}

module box1_external_additions() {
  amp = pbox_ridges(box1).y + eps;
  d = foot_diameter(foot) + 1;
  box1_feet_positions()
    cylinder(d1 = d, d2 = d + 2 * amp, h = amp);
}

module box1_holes() {
  // Feet
  box1_feet_positions()
    teardrop_plus(r = screw_pilot_hole(foot_screw(foot)), h = 10, center = true);

  // SSR
  //translate([-Width*0.25, Depth*0.44, top_thickness])
    //rotate([0,0,90])
      //ssr_hole_positions(type=SSR25DA);

}

module box1_case_stl() {
  pbox(box1) {
    box1_internal_additions();
    box1_holes();
    box1_external_additions();
  }
}

module box1_base_additions() {
  /*
  
  // Nano Mount
  translate([NanoPosX, NanoPosY, NanoPosZ])
    rotate([0,0,90]) {
      stl_colour(pp2_colour)
        nano_mount(h=NanoHeight);
      if(Components)
        %nano(h=NanoHeight);
    }

  // OLED Display
  if(Components)
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([180,0,0])
        %DisplayModule(type=OledType, align=1, G_COLORS=true);

  // OLED posts    
  stl_colour(pp1_colour) {
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([180,0,0])
        oled_posts(type=OledType);
  }
  */
}

module box1_base_holes() {
  /*
  // OLED cutout
  translate([OledPosX, OledPosY, OledPosZ])
    rotate([180,0,0])
      oled_cutout(type=OledType);
   */
}

module box1_base_stl()
  pbox_base(box1) {
    box1_base_additions();
    box1_base_holes();
  }

module box1_assembly()
  assembly("box1") {
    if(Shell) {
      stl_colour(pp1_colour)
        render()
          box1_case_stl();

      if(Components) {
        %pbox_inserts(box1);
        %pbox_base_screws(box1);
        
        // SSR
        vflip()
          translate_z(10)
            ssr_assembly(SSR25DA, M4_cap_screw, top_thickness);

        // Toggle switch
        translate_z(140)
          toggle(CK7105, base_thickness);
        
        // Line power IEC connector
        rotate(90)
        vflip()
          translate([0,-50,20])
            iec_assembly(IEC_inlet);
        // Load power connecter
        
        // Thermal couple connector
        
      }
    }
    
    box1_feet_positions() {
        foot_assembly(0, foot);

        vflip()
            translate_z(foot_thickness(foot))
                screw_and_washer(foot_screw(foot), 6);
    }
        
    if(FPanel) {
      translate_z(Height + top_thickness + base_thickness + 2 * eps)
        vflip()
          %render() box1_base_stl();
    }

  }

module printed_boxes() {
  rotate(180)
    box1_assembly();
}

if($preview)
    printed_boxes();

//echo(pbox_insert(box1));
//echo(pbox_screw(box1));
//echo(pbox_screw_inset(box1));
//echo(pbox_screw_length(box1));
