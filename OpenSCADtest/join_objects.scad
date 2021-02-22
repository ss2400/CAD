

module cylinders(points, diameter, thickness){
    for (p=points){
        translate(p) cylinder(d=diameter, h=thickness, center=true);
    }
}
 
module plate(points, diameter, thickness, hole_diameter){
    difference(){
        hull() cylinders(points, diameter, thickness);
        cylinders(points, hole_diameter, thickness+1);
    }
}
 
module bar(length, width, thickness, hole_diameter){
    plate([[0,0,0], [length,0,0]], width, thickness, hole_diameter);
}

points = [ [0,0,0], [40,0,0], [23,-10,0], [60,19,10] ];
difference(){
    plate(points, 10, 1, 5.5);
    for (p=points){
        translate(p + [0,0,1])
            cylinder(d1=10, d2=15, h=7);
        translate(p + [0,0,-1])
            mirror([0,0,1])
            cylinder(d1=10, d2=15, h=7);
    }
}