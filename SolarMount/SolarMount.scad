// solar_mount.scad - Solar panel clip in OpenSCAD

$fn = 100;

include <NopSCADlib/lib.scad>
include <Round-Anything/MinkowskiRound.scad>

/* Box dimensions */
Height  = 25.8; // Height (X)
Width   = 3.3;  // Width (Y)
Dia     = 7;    // Post diameter
Wall    = 5;    // Wall thickness

m       = 0.5;  // Slop
Enable  = 0;

PosX = 18;
PosY = -22;
PosZ = 0;

module post() {
X = Dia-0.01;

  translate([4,-10,0]) {
  
    translate([-4,10,0])
      rotate([90,0,90]) {
        // Fillet
        rotate_extrude(convexity =10 )
          translate([X/2,0,0]) {
              intersection(){
                  square(X);
                  difference(){
                      square(X, center=true);
                      translate([X/2,X/2]) circle(X/2);
                  }
              }
          }
        // Small extension
        cylinder(r=Dia/2,h=4);
      }
    // Bend
    rotate_extrude(angle=90, convexity=20)
      translate([10,0]) circle(Dia/2);
    // Large Extension
    translate([10,0,0]) 
      rotate([90,0,0]) rounded_cylinder(r=Dia/2,h=10, r2=2, ir=0);
  }
}

module clip() {

  difference() {
    union() {
      rounded_rectangle(size=[Width+Wall*2,Height+Wall*2,Dia*2], r=1);
      translate([(Width+Wall*2)/2-0.01,Height/3,0]) post();
    }
    rounded_rectangle(size=[Width+m,Height+m,Dia*3], r=1);
    translate([0,0,Dia/2+5]) cube([Height,Height*2,10],center=true);
    translate([0,0,-Dia/2-5]) cube([Height,Height*2,10],center=true);
  }

}

clip();
