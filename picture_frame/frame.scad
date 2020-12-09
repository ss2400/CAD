$fn=50;


//Triangle
Profile1=[
  [0,80],
  [-66,20],
  [-66,0],
  [-56,0],
  [-10,20],
  [10,20],
  [56,00],
  [66,0],
  [66,20],
  [0,80]];

length=5;
width=25;
height=75;
    
Points1=[
[0,0,0],
[length,0,0],
[length,width,0],
[0,width,0],
[0,width,height],
[length,width,height]];

Faces1=[
[0,1,2,3],
[5,4,3,2],
[0,4,5,1],
[0,3,4],
[5,2,1]];
        
difference(){
    main();
    
    translate([-60,8,0])
    rotate([-27,0,0])
        #cylinder(h=50,r=7,center=true);
        
    translate([60,8,0])
    rotate([-27,0,0])
        #cylinder(h=50,r=7,center=true);
};

module main() {
    linear_extrude(5)
    polygon(Profile1);

    translate([-length/2,20,0])
    polyhedron(Points1,Faces1);
    
    translate([-61,10,0])
        cylinder(h=9,r=14,center=false);
    translate([61,10,0])
        cylinder(h=9,r=14,center=false);
    translate([0,70,0])
        cylinder(h=9,r=14,center=false);
}