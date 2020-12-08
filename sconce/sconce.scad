$fn=50;

height=20;
width_top=6;
width_bottom=12;
thickness=1.5;
steps=16
;

width_step=(width_bottom - width_top + thickness/2) / steps;
height_step=(height - thickness/2) / steps;

for (i=[0:steps-1]){
    z=i*height_step + thickness/2;
    d=width_bottom - i*width_step - thickness;
    
    color("gray")
        translate([0,0,z])
            toroid(thickness, d);
}

module toroid(profile, diameter){
    rotate_extrude(convexity = 10, $fn = 50)
        translate([diameter/2, 0, 0])
            circle(r = profile/2, $fn = 50);
}
