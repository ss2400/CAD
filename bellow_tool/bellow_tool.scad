$fn=100;

diameter1=94.75;
height1=5;

diameter2=108;
height2=8;

difference(){
    union(){
        cylinder(r=diameter2/2, h=height2);
        translate([0,0,height2])
            cylinder(r=diameter1/2, h=height1);
    }
    translate([0,0,-2])
        cylinder(r=20, h=height1+height2+4);
}
