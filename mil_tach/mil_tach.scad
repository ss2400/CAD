// mil_tach.scad - Miling machine tachometer in OpenSCAD
//
/////////////////////////// - Info - //////////////////////////////
// All coordinates are starting as integrated circuit pins.
// From the top view :
//   CoordD           <---       CoordC
//                                 ^
//                                 ^
//                                 ^
//   CoordA           --->       CoordB
////////////////////////////////////////////////////////////////////

include <NopSCADlib/lib.scad>

include <OpenSCAD_Libs/models/096OledDim.scad>;
use <OpenSCAD_Libs/models/096Oled.scad>;
use <OpenSCAD_Libs/096_oled_mnt.scad>
use <OpenSCAD_Libs/nano_mnt.scad>
use <OpenSCAD_Libs/hx711_mnt.scad>
use <OpenSCAD_Libs/models/batteries.scad>

$fn = 100;

/* Box dimensions */
Length        = 110; // Length 
Width         = 70;  // Width
Height        = 42;  // Height  
Thick         = 3;   // Wall thickness [2:5]  
  
/* Box options */
Vent          = 0;   // Decorations to ventilation holes [0:No, 1:Yes]
Vent_width    = 1.5; // Holes width (in mm)  
txt           = "HeartyGFX"; // Text you want
TxtSize       = 3;   // Font size  
Police        = "Arial Black"; // Font
Filet         = 2;   // Fillet diameter [0.1:12] 
Resolution    = 50;  // Fillet smoothness [1:100] 
m             = 0.9; // Tolerance (Panel/rails gap)

/* Arduino dimensions */
NanoPosX = 10;
NanoPosY = 10;
NanoPosZ = Thick-0.01;
NanoHeight = 6;

/* Amplifier dimensions */
HX711PosX = 60;
HX711PosY = 10;
HX711PosZ = Thick-0.01;
HX711Height = 6;

/* Display dimensions */
OledPosX = Length-7;
OledPosY = Width/2;
OledPosZ = Height/2;

/* Battery dimensions */
BattPosX = 30;
BattPosY = 42;
BattPosZ = Thick-0.01;
BattLength = 60;
BattWidth  = 17;
BattHeight = 30;
BattPost = 6;
BattSlop = 2;

/* Switch dimensions */
SwPosX = Length-Thick*2-m/2-0.1; // Backside of face (and a touch back)
SwPosY = Width*0.2;
SwPosZ = Height*0.62;
SwDia = 6.5;

/* Connector dimensions */
ConnPosX = Thick*1.5+m/2; // Backside of face (and a touch back)
ConnPosY = Width*0.7;
ConnPosZ = Height*0.5;
ConnDia = 15.8;
ConnFlat = 14.8;

/* [STL element to export] */
TShell        = 0;   // Top shell [0:No, 1:Yes]
BShell        = 1;   // Bottom shell [0:No, 1:Yes]
BPanel        = 0;   // Back panel [0:No, 1:Yes]
FPanel        = 0;   // Front panel [0:No, 1:Yes]
Text          = 0;   // Front text [0:No, 1:Yes]
Components    = 1;   // Arduino parts [0:No, 1:Yes]
alpha         = 1.0;

/* [Hidden] */
Color1    = "Orange";    // Shell color  
Color2    = "OrangeRed"; // Panels color    
Dec_Thick = Vent ? Thick*2 : Thick; // Thick X 2 - make sure they go through shell
Dec_size  = Vent ? Thick*2 : 0.8; // Depth decoration

/////////// - Generic Filleted box - //////////
module RoundBox($a=Length, $b=Width, $c=Height){
  $fn=Resolution;            
  translate([0,Filet,Filet]){  
    minkowski (){          
      cube ([$a-(Length/2),$b-(2*Filet),$c-(2*Filet)], center = false);
      rotate([0,90,0]){    
        cylinder(r=Filet,h=Length/2, center = false);
      } 
    }
  }
}// End of RoundBox Module
      
////////////////////////////////// - Module Shell - //////////////////////////////////         
module Shell(){// Shell  
  Thick = Thick*2;  
  difference(){    
    difference(){//sides decoration
      union(){    
        difference() {// Subtraction Filleted box
    
          difference(){// Median cube slicer
            union() {// Union               
              difference(){//S hell    
                RoundBox();
                translate([Thick/2,Thick/2,Thick/2]){     
                  RoundBox($a=Length-Thick, $b=Width-Thick, $c=Height-Thick);
                }
              }//End diff Shell          
              difference(){//larger Rails        
                translate([Thick+m,Thick/2,Thick/2]){// Rails
                  RoundBox($a=Length-((2*Thick)+(2*m)), $b=Width-Thick, $c=Height-(Thick*2));
                }//End Rails
                translate([((Thick+m/2)*1.55),Thick/2,Thick/2+0.1]){ // +0.1 added to avoid the artifact
                  RoundBox($a=Length-((Thick*3)+2*m), $b=Width-Thick, $c=Height-Thick);
                }           
              }//End larger Rails
            }//End union                 
            translate([-Thick,-Thick,Height/2]){
              cube ([Length+100, Width+100, Height], center=false);
            }        
          }// End Median cube slicer
          translate([-Thick/2,Thick,Thick]){
            RoundBox($a=Length+Thick, $b=Width-Thick*2, $c=Height-Thick);       
          }        
        }      

        difference(){// Fixation box legs
          union(){
            translate([3*Thick +5,Thick,Height/2]){
              rotate([90,0,0]){
                $fn=6;
                cylinder(d=16,Thick/2);
              }   
            }

            translate([Length-((3*Thick)+5),Thick,Height/2]){
              rotate([90,0,0]){
                $fn=6;
                cylinder(d=16,Thick/2);
              }   
            }

          }
          translate([4,Thick+Filet,Height/2-57]){   
            rotate([45,0,0]){
              cube([Length,40,40]);    
            }
          }
          translate([0,-(Thick*1.46),Height/2]){
            cube([Length,Thick*2,10]);
          }
        } //End fixation box legs
      }

      union(){// outbox sides decorations
        //if(Thick==1){Thick=2;
        for(i=[0:Thick:Length/4]){

          // Ventilation holes part code submitted by Ettie - Thanks ;) 
          translate([10+i,-Dec_Thick+Dec_size,1]){
            cube([Vent_width,Dec_Thick,Height/4]);
          }
          translate([(Length-10) - i,-Dec_Thick+Dec_size,1]){
            cube([Vent_width,Dec_Thick,Height/4]);
          }
          translate([(Length-10) - i,Width-Dec_size,1]){
            cube([Vent_width,Dec_Thick,Height/4]);
          }
          translate([10+i,Width-Dec_size,1]){
            cube([Vent_width,Dec_Thick,Height/4]);
          }
                  
        }// End for
               // }
      }//End union decoration
    }//End difference decoration

    union(){ //sides holes
      $fn=50;
      translate([3*Thick+5,20,Height/2+4]){
        rotate([90,0,0]){
          cylinder(d=2,20);
        }
      }
      translate([Length-((3*Thick)+5),20,Height/2+4]){
        rotate([90,0,0]){
          cylinder(d=2,20);
        }
      }
      translate([3*Thick+5,Width+5,Height/2-4]){
        rotate([90,0,0]){
          cylinder(d=2,20);
        }
      }
      translate([Length-((3*Thick)+5),Width+5,Height/2-4]){
        rotate([90,0,0]){
          cylinder(d=2,20);
        }
      }
    }//End sides holes

  }//End difference holes
}// End Shell 

///////////////////////////////// - Module Front/Back Panels - //////////////////////////
module Panels(){// Panels
  color(Color2){
    translate([Thick+m,m/2,m/2]){
      difference(){
        translate([0,Thick,Thick]){ 
          RoundBox(Length,Width-((Thick*2)+m),Height-((Thick*2)+m));}
        translate([Thick,-5,0]){
          cube([Length,Width+10,Height]);}
      }
    }
  }
}

///////////////////////////////// - Module Battery Box - //////////////////////////
module BattBox(){
  color(Color2){

    translate([0, BattWidth*0.5+BattPost, 0])
      rounded_cylinder(r=BattPost/2, h=BattHeight, r2=1, ir=0, angle=360);
    hull(){
      translate([BattLength*0.25, 0, 0])
        rounded_cylinder(r=BattPost/2, h=BattHeight, r2=1, ir=0, angle=360);
        
      translate([BattLength*0.75, 0, 0])
        rounded_cylinder(r=BattPost/2, h=BattHeight, r2=1, ir=0, angle=360);
    }
    translate([BattLength, BattWidth*0.5+BattPost, 0])
      rounded_cylinder(r=BattPost/2, h=BattHeight, r2=1, ir=0, angle=360);
  }
}

///////////////////////////////////// - Main - ///////////////////////////////////////

//Back Panel
if(BPanel==1) {
  difference() {
    translate ([-m/2,0,0])
      Panels();
      
    // Connector cutout
    translate([ConnPosX, ConnPosY, ConnPosZ])
      rotate([90,0,90])
        intersection() {
          cylinder(d=ConnDia, h=Thick*2, center=true);
          cube([ConnFlat, ConnDia, Thick*2], center=true);
        }
  }
}

//Front Panel
if(FPanel==1) {
  difference() {
    rotate([0,0,180]){
      translate([-Length-m/2,-Width,0]){
        Panels();
      }
    }
    // OLED cutout
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([90,0,90])
        oled_cutout();
        
    // Switch cutout
    translate([SwPosX, SwPosY, SwPosZ])
      rotate([90,0,90])
        cylinder(d=SwDia, h=Thick*2);
    // Switch key
    translate([SwPosX, SwPosY, SwPosZ+6.5])
      rotate([90,0,90])
        cylinder(d=2.5, h=2);
  }
  // Toggle switch
  translate([SwPosX, SwPosY,SwPosZ])
    rotate([90,0,90])
      %toggle(CK7101,Thick);
  
  // OLED posts    
  color(Color2) {
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([90,0,90])
        oled_posts();
  }
}

// Front text
if(Text==1)
color(Color1){     
  translate([Length-(Thick),Thick*4,(Height-(Thick*4+(TxtSize/2)))]){// x,y,z
    rotate([90,0,90]){
      linear_extrude(height = 0.25){
        text(txt, font = Police, size = TxtSize,  valign ="center", halign ="left");
      }
    }
  }
}

// Bottom shell
if(BShell==1)
  color(Color1, alpha){ 
    Shell();
  }

// Top Shell
if(TShell==1)
  color(Color1, alpha){
    translate([0,Width,Height+0.2]){
      rotate([0,180,180]){
        Shell();
      }
    }
  }

if(Components==1){
	// Nano Mount
	translate([NanoPosX, NanoPosY, NanoPosZ]) {
		nano_mount(h=NanoHeight);
    %nano(h=NanoHeight);
  }

	// HX711 Mount
  translate([HX711PosX, HX711PosY, HX711PosZ]) {
    hx711_mount(h=HX711Height);
    %hx711(h=HX711Height);
   }

	// Battery Box
  translate([BattPosX, BattPosY, BattPosZ]) {
    BattBox();
      translate([BattPost,BattPost/2+BattSlop,BattHeight-2])
        rotate([0,90,0])
          %9V();
    }

  // OLED Display
  translate([OledPosX, OledPosY, OledPosZ])
    rotate([90,0,90])
      %DisplayModule(type=I2C4, align=1, G_COLORS=true);
}
