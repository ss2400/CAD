$fn=100;

include <BOSL/constants.scad>
use <BOSL/shapes.scad>

difference(){
  union(){
    cyl(d=110, l=6, fillet=1);
    tube(h=38, id=20, wall=4);
    }
    
    translate([32,0,-10]) scale([1,0.25,1])
      #cylinder(h=20,d=28);
    
    translate([-32,0,-10]) scale([1,0.25,1])
      #cylinder(h=20,d=28);

}