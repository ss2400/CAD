use <hull.scad>

w = 66.35;
l = 79;
pin_locations = [ [-w/2, -l/2, 0], [-w/2, l/2, 0], 
							    [ w/2, -l/2, 0], [ w/2, l/2, 0] ];

thickness = 1;
$fn = 24;

module place(i){
	translate(pin_locations[i])
		children(0);
}

module foot(){
	cylinder(d=7, h=thickness);
}

module standoff(){
	cylinder(d1=7, d2=5, h=3);
	cylinder(d=5, h=7);
}

module cross_bottom(){
	multiHull(){
		cylinder(d=10, h=thickness);
		place(0) foot();
		place(1) foot();
		place(2) foot();
		place(3) foot();
	}
}

module ring_bottom(){
	sequentialHull(){
		place(0) foot();
		place(1) foot();
		place(3) foot();
		place(2) foot();
		place(0) foot();
	}
}

module bumper(){
	difference(){
		rounded_box(pin_locations, radius=9/2, height=10);
		translate([0,0,-1])
			rounded_box(pin_locations, radius=7/2, height=12);
	}
}

module PCB_case(){
	difference(){ 
		// frame
		union(){
			 cross_bottom();
			 ring_bottom();
			 bumper();
			 for (i=[0:3]){
				place(i) standoff();
			}
		}
		// difference screw holes
		for (i=[0:3]){
			place(i) cylinder(d=3, h=100, center=true);
		}
	}
}

PCB_case();