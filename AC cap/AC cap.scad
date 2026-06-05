$fn=100;

include <BOSL/constants.scad>
use <BOSL/shapes.scad>

Height=40;
Diameter=90.2;
PortDiam=31;
Thickness=5;
VentCount=10;

module polar_array(count, radius, angle_offset = 0) {
    step = 360 / count;
    for (i = [0 : step : 360 - step]) {
        rotate([0, 0, i + angle_offset]) {
            translate([radius, 0, 0]) {
                children(); // Inserts whatever object is called after the module
            }
        }
    }
}

module main() {
  difference() {
    union() {
      // Inside body
      tube(h=Height, od=Diameter, wall=Thickness);
      // Outside body
      translate([0,0,-10])
        tube(h=Height+10, id=Diameter-0.2, wall=Thickness-3);
    }
    // Port hole
    translate([30,0,16])
      rotate(a=[0,90,0])
        cylinder(h=4*Thickness,d=PortDiam);
  }

  difference() {
    // Top
    translate([0,0,40])
      cylinder(h=2,d=94);
    // Vents
    polar_array(VentCount, Diameter/2-14) {
      cylinder(h=2*Height, r=4);
    }
  }

}

main();