$fn=100;

include <BOSL/constants.scad>
use <BOSL/shapes.scad>

difference(){
  union(){
    // Body
    tube(h=40, od=90.2, wall=5);
    // Lip
    translate([0,0,-10])
      tube(h=50, id=90, wall=2);
  }
  
  // Port hole
  translate([30,0,16])
    rotate(a=[0,90,0])
      cylinder(h=30,d=31);
}

// Top
translate([0,0,40])
  cylinder(h=2,d=94);
    
