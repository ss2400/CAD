$fn=50;



post1=[13.97, 2.54,0];
post2=[66.04,7.62,0];
post3=[66.04,35.6,0];
post4=[6.35,49.53,0];

offset =[-12,-5,0];


translate( post1 ) screwmount();
    translate( post1 + offset ) text(str(1));

translate( post2 ) screwmount();
    translate( post2 + offset ) text(str(2));

translate( post3 ) screwmount();
    translate( post3 + offset ) text(str(3));

translate( post4 ) screwmount();
    translate( post4 + offset ) text(str(4));



module screwmount() {

difference(){
    cylinder(r=2.5,h=10);
    translate([0,0,-1]) cylinder(r=1.5,h=12);
}

rotate_extrude(convexivity =10 )
    translate([2.5,0,0]) {
        intersection(){
            square(5);
            difference(){
                square(5, center=true);
                translate([2.5,2.5]) circle(2.5);
            }
        }
    }    
}