
/*//////////////////////////////////////////////////////////////////
              -    FB Aka Heartman/Hearty 2016     -                   
              -   http://heartygfx.blogspot.com    -                  
              -       OpenScad Parametric Box      -                     
              -         CC BY-NC 3.0 License       -                      
////////////////////////////////////////////////////////////////////                                                                                                             
12/02/2016 - Fixed minor bug 
28/02/2016 - Added holes ventilation option                    
09/03/2016 - Added PCB feet support, fixed the shell artefact on export mode. 

*/////////////////////////// - Info - //////////////////////////////

// All coordinates are starting as integrated circuit pins.
// From the top view :

//   CoordD           <---       CoordC
//                                 ^
//                                 ^
//                                 ^
//   CoordA           --->       CoordB


////////////////////////////////////////////////////////////////////
use <OpenSCAD_Libs/nano.scad>
use <OpenSCAD_Libs/hx711.scad>
use <Batteries_in_OpenSCAD/batteries.scad>
include <OpenSCAD_Libs/models/096OledDim.scad>
use <OpenSCAD_Libs/models/096Oled.scad>

////////// - Box parameters - /////////////

/* [Box dimensions] */
// Length  
  Length        = 100;       
// Width
  Width         = 64;                     
// Height  
  Height        = 40;  
// Wall thickness  
  Thick         = 2;//[2:5]  
  
/* [Box options] */
// Decorations to ventilation holes
  Vent          = 0;// [0:No, 1:Yes]
// Holes width (in mm)
  Vent_width    = 1.5;   
// Text you want
  txt           = "HeartyGFX";           
// Font size  
  TxtSize       = 3;                 
// Font  
  Police        ="Arial Black"; 
// Filet diameter  
  Filet         = 2;//[0.1:12] 
// Filet smoothness  
  Resolution    = 50;//[1:100] 
// Tolerance (Panel/rails gap)
  m             = 0.9;
  
/* [PCB_Feet--the_board_will_not_be_exported) ] */
//All dimensions are from the center foot axis
// Low left corner X position
PCBPosX         = 7;
// Low left corner Y position
PCBPosY         = 6;
// PCB Length
PCBLength       = 70;
// PCB Width
PCBWidth        = 50;
// Feet height
FootHeight      = 10;
// Foot diameter
FootDia         = 8;
// Hole diameter
FootHole        = 3;  
  
OledPosX = Length-5;
OledPosY = Width/2;
OledPosZ = Height/2;


/* [STL element to export] */
// Top shell
  TShell        = 0;// [0:No, 1:Yes]
// Bottom shell
  BShell        = 1;// [0:No, 1:Yes]
// Back panel  
  BPanel        = 1;// [0:No, 1:Yes]
// Front panel
  FPanel        = 1;// [0:No, 1:Yes]
// Front text
  Text          = 0;// [0:No, 1:Yes]
//Arduino Uno
  Components    = 1;// [0:No, 1:Yes]

  
/* [Hidden] */
// Shell color  
Couleur1        = "Orange";       
// Panels color    
Couleur2        = "OrangeRed";    
// Thick X 2 - making decorations thicker if it is a vent to make sure they go through shell
Dec_Thick       = Vent ? Thick*2 : Thick; 
// - Depth decoration
Dec_size        = Vent ? Thick*2 : 0.8;

//////////////////// Oversize PCB limitation -Actually disabled - ////////////////////
PCBL=PCBLength;
PCBW=PCBWidth;


/////////// - Generic Fileted box - //////////

module RoundBox($a=Length, $b=Width, $c=Height){// Cube bords arrondis
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

module Coque(){// Shell  
    Thick = Thick*2;  
    difference(){    
        difference(){//sides decoration
            union(){    
                     difference() {//soustraction de la forme centrale - Substraction Fileted box
                      
                        difference(){//soustraction cube median - Median cube slicer
                            union() {//union               
                            difference(){//Coque    
                                RoundBox();
                                translate([Thick/2,Thick/2,Thick/2]){     
                                        RoundBox($a=Length-Thick, $b=Width-Thick, $c=Height-Thick);
                                        }
                                        }//Fin diff Coque                            
                                difference(){//largeur Rails        
                                     translate([Thick+m,Thick/2,Thick/2]){// Rails
                                          RoundBox($a=Length-((2*Thick)+(2*m)), $b=Width-Thick, $c=Height-(Thick*2));
                                                          }//fin Rails
                                     translate([((Thick+m/2)*1.55),Thick/2,Thick/2+0.1]){ // +0.1 added to avoid the artefact
                                          RoundBox($a=Length-((Thick*3)+2*m), $b=Width-Thick, $c=Height-Thick);
                                                    }           
                                                }//Fin largeur Rails
                                    }//Fin union                                   
                               translate([-Thick,-Thick,Height/2]){// Cube à soustraire
                                    cube ([Length+100, Width+100, Height], center=false);
                                            }                                            
                                      }//fin soustraction cube median - End Median cube slicer
                               translate([-Thick/2,Thick,Thick]){// Forme de soustraction centrale 
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
                    } //Fin fixation box legs
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
  
                
                    }// fin de for
               // }
                }//fin union decoration
            }//fin difference decoration


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
            }//fin de sides holes

        }//fin de difference holes
}// fin coque 

////////////////////////////// - Experiment - ///////////////////////////////////////////


///////////////////////////////// - Module Front/Back Panels - //////////////////////////
                            
module Panels(){// Panels
    color(Couleur2){
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
  
module Oled() {
    //////////////////// - OLED - /////////////////////   

    // Align the glass side of the PCB under the XY plane (align=1)
    %DisplayModule(type=I2C4, align=1, G_COLORS=true);
    
    // Localize a cutout volume over the view area
    DisplayLocalize(type=I2C4, align=0, dalign=1)
        translate([0,0,6.0/2])
            #cube([I2C4_LVW,I2C4_LVL,6.0], center=true);
    // ... another one over the module glass...
    DisplayLocalize(type=I2C4, align=1, dalign=2)
        translate([0,0,(I2C4_LH+0.2)/2])
            #cube([I2C4_LGW+0.2, I2C4_LGL+0.2, I2C4_LH+0.2], center=true);
    // ... and the last one to cutout a volume for the OLED's internal flat cable
    DisplayLocalize(type=I2C4, align=4, dalign=1)
        translate([0,0,OLED[I2C4][0][2]/2])
            #cube([I2C4_PCW,I2C4_PL-I2C4_LGL-I2C4_LGLO,I2C4_LH], center=true);
}

///////////////////////////////////// - Main - ///////////////////////////////////////

//Back Panel
if(BPanel==1)
translate ([-m/2,0,0]){
    Panels();
}

//Front Panel
if(FPanel==1)
difference() {
    rotate([0,0,180]){
        translate([-Length-m/2,-Width,0]){
            Panels();
        }
    }
    // OLED
    translate([OledPosX, OledPosY, OledPosZ])
        rotate([90,0,90])
            Oled();       
}

// Front text
if(Text==1)
color(Couleur1){     
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
color(Couleur1){ 
Coque();
}

// Top Shell
if(TShell==1)
color( Couleur1,1){
    translate([0,Width,Height+0.2]){
        rotate([0,180,180]){
                Coque();
                }
        }
}

// Nano
translate([5, 6, Thick/2]) {
    %nano();
    nano_mount();
    }
    
 // HX711
 translate([5, 36, Thick/2]) {
    %hx711();
    hx711_mount();
    }
    
// Battery
translate([56, 6, Thick/2])
    rotate([90,270,180]) %9V();



