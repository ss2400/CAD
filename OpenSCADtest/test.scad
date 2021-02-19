// test_extrude.scad

$fn = 40;

include <NopSCADlib/lib.scad>
include <Round-Anything/MinkowskiRound.scad>
include <Round-Anything/polyround.scad>

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
  Height = Depth*Depth/(Height2-Height1);
  Width = Depth*Depth/(Width2-Width1);
  
  for(i=[0:0.5:Depth])
    difference() {
      translate([i-Depth/2,0,(i*i/Height)/2])
        rotate([0,-AngleFace*i/Depth,0])
          rounded_cube_yz([0.6,Width1+(i*i/Width),Height1+(i*i/Height)],
                          r=3,
                          xy_center=true,
                          z_center=true);
                          
      translate([i-Depth/2,0,((i*i/Height-Wall*2)/2+Wall)])
        rotate([0,-AngleFace*i/Depth,0])
          rounded_cube_yz([0.7,Width1+(i*i/Width)-Wall*2,Height1+(i*i/Height-Wall*2)],
                          r=3,
                          xy_center=true,
                          z_center=true);
    }
}

module switch() {
  translate([0,0,HeightSw])
    rotate([0,AngleSw,0])
      extrudeWithRadius(length=4,r1=-3.0,r2=0.95,fn=50)
        circle(11,$fn=30);
}

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
