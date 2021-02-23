use <scad-utils/transformations.scad>
use <scad-utils/shapes.scad>
//use <scad-utils/morphology.scad>
use <list-comprehension-demos/skin.scad>
use <list-comprehension-demos/extrusion.scad>

fn=100;
$fn=100;

r1 = 35;
r2 = 10;
R = 40;
th = 2;

module tube() {
  difference() {
    skin([for(i=[0:fn]) 
      transform(rotation([0,180/fn*i,0])*translation([-R,0,0]), 
        circle(r1+(r1-r2)/fn*i))]);
    let(r1 = r1-th, r2 = r2-th)
    skin([for(i=[0:fn]) 
      transform(rotation([0,180/fn*i,0])*translation([-R,0,0]), 
        circle(r1+(r1-r2)/fn*i))]);
  }
}

module tube2() {
  //difference() {
    skin([for(i=[0:fn]) 
      transform(rotation([0,0,0])*translation([0,0,i/2]), 
        rounded_rectangle_profile(size=[r1+(r1-r2)/fn*i*i/600,r1+(r1-r2)/fn*i*i/600],r=4,fn=100) )]);
    //let(r1 = r1-th, r2 = r2-th)
    //skin([for(i=[0:fn]) 
      //transform(rotation([0,180/fn*i,0])*translation([-R,0,0]), 
        //circle(r1+(r1-r2)/fn*i))]);
  //}
}

//tube();
tube2();
//module shape() {
//    polygon([[0,0],[1,0],[1.5,1],[2.5,1],[2,-1],[0,-1]]);
//}
//rounding(r=0.3) shape();

