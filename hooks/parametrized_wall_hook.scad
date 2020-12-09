$fn=50;

width=8;
thick=8;
rad=26;
roundrad=3.5; //less than thick/2
height=40;
theight=15;
hole=4.1;

sthick=thick-roundrad*2;

wall_hook();

module wall_hook()
{
  difference(){
    translate([0,0,0.5])
      minkowski(){
        union() {
		// hook
          difference() {
            cylinder(h=width-1, r=rad+sthick/2);
            translate(v=[0,0,-1]) cylinder(h=width+1, r=rad-sthick/2);
            translate(v=[-rad-sthick,0,-1]) cube(size=[2*rad+2*sthick, rad+sthick,width+4]);
          }
        // wall 
		translate(v=[-rad-sthick/2,0,0])
          cube(size=[sthick,height,width-1]);
          
        // end-tip
		translate(v=[rad-sthick/2,0,0])
          cube(size=[sthick, theight, width-1]);
        }
	  cylinder(h=1, r=roundrad, center=true);
      }

    // screw hole 1
    translate(v=[-rad,height-10, width/2])
      rotate(a=[0,90,0])
        cylinder(h=15, d=hole, center=true);

    translate(v=[-rad+thick/2,height-10, width/2]) 
      rotate(a=[0,90,0]) 
        cylinder(h=5, d1=hole, d2=2.11*hole, center=true);
      
    // screw hole 2
    if (height>30) {
      translate(v=[-rad,theight,width/2])
        rotate(a=[0,90,0])
          cylinder(h=15, d=hole, center=true);
    
      translate(v=[-rad+thick/2, theight, width/2])
        rotate(a=[0,90,0])
          cylinder(h=5, d1=hole, d2=2.11*hole, center=true);
    }
  }
}



