$fn=50;

// Length of project enclosure
LENGTH=53.54;  // min/max: [10:100]

//Width of prject enclosure
WIDTH=68.58;   // min/max: [10:100]

//Radiues of curved corners
RADIUS=1;   // min/max: [1:5]

//Offset to internal walls
OFFSET=1;   // min/max: [1:10]

//Height
HEIGHT=18;

//Parametric Version

linear_extrude(5){
translate([-60,-60,0]) text( str("Don't print this, it's for tutorial"));
}

difference() {
minkowski(){
    cube([WIDTH,LENGTH,HEIGHT], center = true);
    sphere(RADIUS);
}

// Chop off the top

translate([0,0,HEIGHT/2]) 
  cube([WIDTH + RADIUS*2 + OFFSET,
        LENGTH + RADIUS*2 + OFFSET,
        HEIGHT+1], center = true);

// Hollow inside

minkowski(){
    cube([WIDTH - RADIUS - OFFSET,
          LENGTH - RADIUS - OFFSET,
          HEIGHT-2], center = true);
    sphere(RADIUS);
}

//Make a Ledge ( To receive top half later )
    translate([0,0,-1]) {
        linear_extrude(10) {
            minkowski(){
                square([WIDTH-OFFSET, LENGTH-OFFSET], center = true );
                circle(RADIUS);
            }
        }
    }

}

translate([0,0,0]){
     
    translate ([ -WIDTH/2,
                -LENGTH/2,
                -HEIGHT/2
    ])   

    filletedPosts();
}


module filletedPosts(){
    post1=[13.97, 2.54,0];
    post2=[66.04, 7.62,0];
    post3=[66.04,35.60,0];
    post4=[ 6.35,49.53,0];

offset=[-15,-5,0];

//post1 
translate( post1 ) screwmount();
    //translate(post1 + offset) text(str(1));  // Not part of obejct
    
//post2
translate( post2 ) screwmount();
    //translate(post2 + offset) text(str(2)); // Not part of obejct
    
//post3
translate(  post3) screwmount();
    //translate(post3 + offset) text(str(3)); // Not part of obejct

//post4
translate( post4) screwmount();
    //translate(post4 + offset) text(str(4)); // Not part of obejct
    
module screwmount()     {
difference(){
    cylinder(r=2.5,h=10);
    translate([0,0,-1])cylinder(r=1.5,h=12);
   } 

rotate_extrude(convexity = 10)
    translate([2.5,0,0])
    intersection(){       
        square(5);
                difference(){
                  square(5, center=true);
                  translate([2.5,2.5,0])circle(r = 2.5, $fn = 100);                  
                    }   
         }  

     }
 }