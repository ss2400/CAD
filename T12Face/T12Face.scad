// T12Face.scad - T12 soldering station face plate

$pp2_colour = "BurlyWood";
$pp1_colour = "SlateGray";

include <NopSCADlib/core.scad>
include <NopSCADlib/lib.scad>

$fn=100;

/* Box dimensions */
l1 = 83.4;  // Top (84)
l2 = 85.2;  // Bottom (86)
h = 34;
r = 8;
Thick = 3.0;
m = 0.5;

/* Connector dimensions */
ConnDia = 11.7;
ConnFlat = 10.8;
ConnPosX = -27;
ConnPosY = 0;

/* Dial dimensions */
DialDia = 6.8;
DialPosX = 25;
DialPosY = 2.6;

/* Screen dimensions */
ScreenPosX = DialPosX - 27;
ScreenPosY = DialPosY - 1;
ScreenSize = [24,13,1];

/* Screw dimensions */
ScrewType = M3_cs_cap_screw;
ScrewLen = 8;
Screw1 = [-l2/2 + 4.8,-h/2 + 5, Thick+0.5];
Screw2 = [-l1/2 + 4.8, h/2 - 5, Thick+0.5];
Screw3 = [ l2/2 - 4.8,-h/2 + 5, Thick+0.5];
Screw4 = [ l1/2 - 4.8, h/2 - 5, Thick+0.5];

/* Port dimensions */
translate(Screw1+[0,0,10])
  %screw(ScrewType, ScrewLen);

/* Face Shape */
profile = [
    [ -l2/2 + r, -h/2 + r, r],
    [ -l1/2 + r,  h/2 - r, r],
    [  l1/2 - r,  h/2 - r, r],
    [  l2/2 - r, -h/2 + r, r],
];

/* Original face */
if($preview)
  translate([-42.9, 17, 5])
    rotate([180,0,0])
      %import("M18_soldering_front_panel.STL", convexity =4);

module fpanel_internal_additions() {
}

module fpanel_holes() {
  // OLED cutout
  for (i=[0:0.1:Thick+1])
    translate([ScreenPosX, ScreenPosY, 0.49+i])
      rounded_rectangle(ScreenSize+[i,i,0], r=2);
        
  // Dial cutout
  translate([DialPosX, DialPosY, 0])
    cylinder(d=DialDia+m, h=Thick*3, center=true);
  // Dial tab
  translate([DialPosX, DialPosY+6, 0])
    cylinder(d=2.1, h=Thick, center=true);
  
  
  // Connector cutout
  translate([ConnPosX, ConnPosY, 0])
    rotate([0,0,90])
      intersection() {
        cylinder(d=ConnDia+m, h=Thick*3, center=true);
        cube([ConnFlat+m, ConnDia+m, Thick*3], center=true);
      }
  
  // Screw Holes
  translate(Screw1) {
    screw_countersink(ScrewType, drilled = true);
    cylinder(d=3,h=Thick *3, center=true);
    }
  translate(Screw2) {
    screw_countersink(ScrewType, drilled = true);
    cylinder(d=3,h=Thick *3, center=true);
    }
  translate(Screw3) {
    screw_countersink(ScrewType, drilled = true);
    cylinder(d=3,h=Thick *3, center=true);
  }
  translate(Screw4) {
    screw_countersink(ScrewType, drilled = true);
    cylinder(d=3,h=Thick *3, center=true);
  }
}

module box1_fpanel_stl() {
  // Front Panel
  tangents = rounded_polygon_tangents(profile);
  length = rounded_polygon_length(profile, tangents);
  
  difference(){
    union(){
      stl_colour(pp2_colour)
        linear_extrude(Thick)
          rounded_polygon(profile, tangents);

      fpanel_internal_additions();
    }
    fpanel_holes();
  }
}
 
box1_fpanel_stl();


