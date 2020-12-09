$fn=50;

WIDTH = 78.58;
HEIGHT = 24;
LENGTH = 63.54;

LID_THICKNESS = 2;
BOARD_THICKNESS=1.54;
POST_HEIGHT=3;
    
OFFSET1 = 1;
RADIUS = 1;
     
    difference() { 
     union() {     
         mirror([0,0,1]) translate([0,2,0]) filletedPosts( 6 );

         linear_extrude( LID_THICKNESS ) {
              minkowski() {
                square( [WIDTH - OFFSET1 - RADIUS, LENGTH - OFFSET1 - RADIUS ] );
                circle( RADIUS );
                }
            }
    }
    
    #translate([0,2,0]) translate ([0,0,-5]) usbandpower();
    #translate([0,2,0]) translate ([0,0,-5]) header_openings();
}

module header_openings() {
    header_1_size = [20.57,2.286,8.89];
    header_2_size = [15.24,2.286,8.89];
    header_3_size = [20.82,2.286,8.89];
    header_4_size = [25.65,2.286,8.89];
    
    header_1_position = [26.92,49.78,1.524];
    header_2_position = [49.65,49.78,1.524];
    header_3_position = [17.15,1.27,1.524];
    header_4_position = [42.80,1.27,1.524];

        translate( header_1_position ) cube( header_1_size);
        translate( header_2_position ) cube( header_2_size);
        translate( header_3_position ) cube( header_3_size);
        translate( header_4_position ) cube( header_4_size);
}

module usbandpower() {
    power_size_array=[13.208,8.89,10.922];
    power_position_array=[-1.524,3.81,1.524];

    usb_size_array=[16.218,11.849,10.668];
    usb_position_array=[-6.35,32.601,1.524];
    
        //POWER
        translate( power_position_array  ) {
          cube ( power_size_array  );
            
        // I don't love this but it puts an opening for a plug if the offset is too big
        // Some may want this, sort of a hidden plug
        // it feels like a hack, but so does most of this thing.
        translate([power_size_array[0]/2-8,
                  power_size_array[1]/2,
                  power_size_array[2]/2
                    ])    
          rotate([0,90,0]) cylinder ( r=3.5,h=14,center=true );
        }
        
        //USB
        translate( usb_position_array )
        cube ( usb_size_array  );    
}
        
    
module filletedPosts( height ){
    
    post1=[13.97, 2.54,0];
    post2=[66.04, 7.62,0];
    post3=[66.04,35.60,0];
    post4=[ 6.35,49.53,0];

    offset=[-15,-5,0];

    translate(post1) boardscrewmount(height); 
    translate(post2) boardscrewmount(height); 
    translate(post3) boardscrewmount(height); 
    translate(post4) boardscrewmount(height);  
}

module boardscrewmount( height ){
    difference(){
        cylinder(r=2.5,h=height);
        
        //Z translate puts bottom of post in same plane as bottom of case.
        //Height needs to be parametric otherwise a very tall post has no hole
        #translate([0,0,1])cylinder(r=1.5,h=height);
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