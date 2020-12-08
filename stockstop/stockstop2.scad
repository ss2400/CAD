// stockstop.scad - Stock stop in OpenSCAD
$fn=150;

echo(version=version());

L = 77;      // Body length(Pin center to end)
W = 8.0;     // Body width
H = 3.8;     // Body height

Dstop = 24;  // Stop distance from pin center

Dpin = 66;   // Pin center to center distance
Wpin = 7.6 ; // Pin width
Hpin = 3.5;  // Pin height

difference() {
  union() {
    // Body
    translate([(L-Dpin)/2, 0, 0])
      cube([L, W, H], center = true);
      
    // Pins (with slight taper)
    translate([-Dpin/2, 0, -Hpin/2])
      cylinder(h=Hpin+H, d1=0.94*Wpin, d2=Wpin, center = true);

    translate([Dpin/2, 0, -Hpin/2])
      cylinder(h=Hpin+H, d1=0.94*Wpin, d2=Wpin, center = true);
      
    // Stop
    translate([-Dpin/2, -W/2, H/2])
      prism (Dstop,W,0.6*H);
  }
    // Holes
    translate([-Dpin/2, 0, 0])
      cylinder(h=2*(Hpin+H), d=0.5*Wpin, center = true);
  
    translate([Dpin/2, 0, 0])
      cylinder(h=2*(Hpin+H), d=0.5*Wpin, center = true); 
}

module prism(l, w, h){
       polyhedron(
               points=[[0,0,0],
                       [0,w,0],
                       [l/2,0,h],
                       [l/2,w,h],
                       [l,0,h],
                       [l,w,h],
                       [l,0,0],
                       [l,w,0]],
               faces=[[0,1,3,2],
                      [2,3,5,4],
                      [0,2,4,6],
                      [7,5,3,1],
                      [6,4,5,7],
                      [1,0,6,7]]
               );
}