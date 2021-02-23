// test_extrude.scad

fn=72;
$fn=72;

use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <list-comprehension-demos/skin.scad>
use <list-comprehension-demos/extrusion.scad>

//include <NopSCADlib/lib.scad>
//include <Round-Anything/MinkowskiRound.scad>
//include <Round-Anything/polyround.scad>

/* Box dimensions */
Width1    = 75; // Width (X)
Width2    = 95; // Width (X)
Depth     = 90; // Depth (Y)
Height1   = 25; // Height (Z)
Height2   = 45; // Height (Z)
Wall      = 3;
AngleFace = 15;

HeightSw = 18;
AngleSw = -14;

module body() {
  CalcH = fn*fn/(Height2-Height1);
  CalcW = fn*fn/(Width2-Width1);
  function Width(i) = Width1+(i*i/CalcW);
  function Height(i) = Height1+(i*i/CalcH);
  
  function Y(i) = i*i/(CalcH*2);
  function Z(i) = Depth*i/fn-Depth/fn;

  outside = [for(i=[0:fn])
    transform(rotation([0,0,0])*
              translation([0,Y(i),Z(i)]), 
              rounded_rectangle_profile(size=[Width(i),Height(i) ],
                                        r=4,
                                        fn=fn)
              )];

  inside = [for(i=[0:fn]) 
    transform(rotation([0,0,0])*
              translation([0,i*i/(CalcH*2-Wall*4),Z(i)]), 
              rounded_rectangle_profile(size=[Width(i)-Wall*2, Height(i)-Wall*2],
                                        r=4,
                                        fn=fn)
              )];
              
  difference() {  
    skin(outside);
    skin(inside);
  }
}

module switch() {
  translate([0,0,HeightSw])
    rotate([0,AngleSw,0])
      extrudeWithRadius(length=4,r1=-3.0,r2=0.95,fn=50)
        circle(11,$fn=30);
}
/*
difference() {
  union() {
    body();
    switch();
  }
  translate([0,0,HeightSw])
    rotate([0,AngleSw,0])
      cylinder(d=16, h=25, center=true);
      
  translate([0,0,HeightSw-Wall])
    rotate([0,AngleSw,0])
      cylinder(d=30, h=Wall, center=true);
}

difference() {
  body();
  translate([0,0,Depth+10-3])
    rotate([AngleFace,0,0])
      cube([Width2*2, Height2*2, 20], center = true);
}
*/
body();