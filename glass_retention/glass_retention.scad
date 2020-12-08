// stockstop.scad - Stock stop in OpenSCAD
$fn=150;

echo(version=version());

L = 13.7;    // Body length(Radius center to center)
W = 8.3;     // Body width
H = 3.2;     // Body height

D1 = 11.6;   // Large end diameter
D2 = W;      // Small end diameter and lip
D3 = 4.9;    // Pin diameter

H2 = H;  // Small end lip height
H3 = 10.5;    // Pin height

difference() {
  union() {
    // Body
    translate([0, 0, 0])
      cube([L, W, H], center = true);
      
    // Large End
    translate([-L/2, 0, 0])
      cylinder(h=H, d=D1, center = true);
      
    // Small End
    translate([L/2, 0, (H2-H)/2])
      cylinder(h=H2, d=D2, center = true);
      
    // Pin
    translate([L/2, 0, H3/2-H/2])
      cylinder(h=H3, d=D3, center = true);      

  }
    // Holes
    translate([-L/2, 0,0])
      cylinder(h=1.01*H, d1=7, d2 =3.7, center = true);
}

