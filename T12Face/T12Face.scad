// T12Face.scad - T12 soldering station face plate

$pp2_colour = "BurlyWood";
$pp1_colour = "SlateGray";

include <NopSCADlib/core.scad>
include <NopSCADlib/lib.scad>

$fn=100;

/* Box dimensions */
l1 = 84;  // Top
l2 = 86;  // Bottom
h = 34;
r = 8;
Thick = 3.0;
m = 0.2;

/* Connector dimensions */
ConnDia = 11.7;
ConnFlat = 10.8;
ConnPosX = -27;
ConnPosY = 0;

/* Switch dimensions */
SwDia = 6.8;
SwPosX = 26;
SwPosY = 0;

/* Screen dimensions */
ScreenPosX = SwPosX-27;
ScreenPosY = -1;
ScreenSize = [24,13,Thick*3];

/* Screw dimensions */
ScrewType = M3_cs_cap_screw;
ScrewLen = 8;
Screw1 = [-l2/2 + 5,-h/2 + 5, Thick];
Screw2 = [-l1/2 + 5, h/2 - 5, Thick];
Screw3 = [ l2/2 - 5,-h/2 + 5, Thick];
Screw4 = [ l1/2 - 5, h/2 - 5, Thick];

/* Port dimensions */
translate(Screw1+[0,0,10])
  %screw(ScrewType, ScrewLen);

profile = [
    [ -l2/2 + r, -h/2 + r, r],
    [ -l1/2 + r,  h/2 - r, r],
    [  l1/2 - r,  h/2 - r, r],
    [  l2/2 - r, -h/2 + r, r],
];

translate([-42.9, 17, 5])
  rotate([180,0,0])
    %import("M18_soldering_front_panel.STL", convexity =4);

module fpanel_internal_additions() {
}

module fpanel_holes() {
  // OLED cutout
  translate([ScreenPosX, ScreenPosY, 0])
    #rounded_rectangle(ScreenSize, r=2, center=true);
        
  // Switch cutout
  translate([SwPosX, SwPosY, 0])
    #cylinder(d=SwDia+m, h=Thick*3, center=true);
  
  // Connector cutout
  translate([ConnPosX, ConnPosY, 0])
    rotate([0,0,90])
      #intersection() {
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


