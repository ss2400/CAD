use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
use <list-comprehension-demos/skin.scad>
use <list-comprehension-demos/extrusion.scad>

fn=72;
$fn=72;

r1 = 25;
r2 = 10;
R = 40;
th = 2;

/* Box dimensions */
Width1    = 75; // Width (X)
Width2    = 95; // Width (X)
Depth     = 90; // Depth (Y)
Height1   = 25; // Height (Z)
Height2   = 45; // Height (Z)
Wall      = 3;
AngleFace = -15;
HeightSw  = 0;
AngleSw   = -14;

module tube() {
  difference() {
    skin([for(i=[0:fn]) 
      transform(rotation([0,180/fn*i,0])*translation([-R,0,0]), 
        circle(r1+(r1-r2)/fn*i))]);
    let(r1 = r1-th, r2 = r2-th)
    skin([for(i=[0:fn]) 
      transform(rotation([0,180/fn*i,0])*translation([-R,0,0]), 
        circle(r1+(r1-r2)/fn*i))]);
  }
}

tube();
