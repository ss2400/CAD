// test_extrude.scad

$fn = 50;

include <NopSCADlib/lib.scad>
include <Round-Anything/MinkowskiRound.scad>
include <Round-Anything/polyround.scad>

/* Box dimensions */
Width1  = 60; // Width (X)
Width2  = 70; // Width (X)
Depth   = 70; // Depth (Y)
Height1 = 25; // Height (Z)
Height2 = 35; // Height (Z)
Wall    = 3;
HeightSw = 27;
Angle = -9;

module body() {
  HeightCalc = Depth*Depth/(Height2-Height1);
  WidthCalc = Depth*Depth/(Width2-Width1);
  
  linear_extrude(height = 50, scale=[1.1,1.4], slices=20, twist=0)
    rounded_rectangle([Width1,Height1],
                       r=3,
                       center=true);

}
//  for(i=[0:0.5:Depth]) {
//    hull() {
//      //Top
//      translate([i-Depth/2,-Width1-(i*i/WidthCalc),Height1+(i*i/HeightCalc)])
//        sphere(d=Wall);
//      translate([i-Depth/2,Width1+(i*i/WidthCalc),Height1+(i*i/HeightCalc)])
//        sphere(d=Wall);
//    }
//  }

//  for(i=[0:1:Depth]) {
//    difference() {
//      hull() {
//        translate([i-Depth/2,0,0])
//          rounded_cube_yz([1,Width1+(i*i/WidthCalc),Height1+(i*i/HeightCalc)],
//                          r=3,
//                          xy_center=true,
//                          z_center=false);
//        translate([i-Depth/2+1,0,0])
//          rounded_cube_yz([1,Width1+(i*i/WidthCalc),Height1+(i*i/HeightCalc)],
//                          r=3,
//                          xy_center=true,
//                          z_center=false);
//      }
//      translate([i-Depth/2,0,Wall])
//        rounded_cube_yz([1.02,Width1-Wall*2+(i*i/WidthCalc),Height1-Wall*2+(i*i/HeightCalc)],
//                        r=3,
//                        xy_center=true,
//                        z_center=false);
//    }
//  }
//}

//module switch() {
//  translate([0,0,HeightSw])
//    rotate([0,Angle,0])
//      extrudeWithRadius(length=3,r1=-3.0,r2=0.95,fn=50)
//        circle(9,$fn=30);
//}
//extrudeWithRadius(3,-0.5,0.95,50)circle(1,$fn=30);

//difference() {
//  union() {
    body();
//    switch();
//  }
//  translate([0,0,HeightSw])
//    rotate([0,Angle,0])
//      cylinder(d=16, h=25, center=true);
//}
