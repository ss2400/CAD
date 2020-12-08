$fn=100;

include <BOSL/constants.scad>
use <BOSL/shapes.scad>

base_w=90;
base_d=42;
base_t=4;

face_w=60;
face_h=46;
face_t=4;

hole=29;
screw=5;

difference(){
  // Base
  translate([0,0,0])
    cuboid([base_w,base_d,base_t], fillet=base_t-2, edges=EDGES_Z_ALL, $fn=100);

  // Screw holes
  translate([-base_w/2+screw*1.5,0,0])
    cylinder(d=screw, h=base_t*2, center=true);
    
  translate([base_w/2-screw*1.5,0,0])
    cylinder(d=screw, h=base_t*2, center=true);
}

difference(){
  // Face
  translate([0,base_d/2-face_t/2,face_h/2-base_t/2])
    rotate(a=[270,0,0])
      cuboid([face_w,face_h,face_t], fillet=face_t-1, edges=EDGE_FR_RT+EDGE_FR_LF, $fn=100);
    
  // Hole
  translate([0,base_d/2-face_t/2,face_h/2])
    rotate(a=[270,0,0])
      cylinder(d=hole, h=face_t*2, center=true);
}
// Reinforcement
 translate([-face_w/2,20,0])
  rotate(a=[0,0,270])
    right_triangle([base_d/1.1,face_t/2,face_h/1.1]);

 translate([face_w/2-face_t/2,20,0])
  rotate(a=[0,0,270])
    right_triangle([base_d/1.1,face_t/2,face_h/1.1]);

