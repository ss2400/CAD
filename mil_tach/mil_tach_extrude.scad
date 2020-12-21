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
use <NopSCADlib/printed/foot.scad>
use <NopSCADlib/printed/printed_box.scad>

include <OpenSCAD_Libs/models/096OledDim.scad>;
use <OpenSCAD_Libs/models/096Oled.scad>;
use <OpenSCAD_Libs/096_oled_mnt.scad>
use <OpenSCAD_Libs/nano_mnt.scad>

$fn = 100;

/* Box dimensions */
Width   = 62;  // Width
Height  = 15;  // Height
Depth   = 55;
Thick   = 2.4;  // Wall thickness [2:5]  
m = 0.2;

/* Arduino dimensions */
NanoPosX = 18;
NanoPosY = -22;
NanoPosZ = Thick-0.01;
NanoHeight = 6;

/* Display dimensions */
OledPosX = -12;
OledPosY = 2;
OledPosZ = Thick;

/* Connector dimensions */
ConnPosX = Thick*1.5+m/2; // Backside of face (and a touch back)
ConnPosY = Width*0.7;
ConnPosZ = Height*0.5;
ConnDia = 15.8;
ConnFlat = 14.8;

/* [STL element to export] */
Shell       = 1;   // Shell [0:No, 1:Yes]
FPanel      = 1;   // Front panel [0:No, 1:Yes]
Components  = 0;   // Arduino parts [0:No, 1:Yes]

foot = Foot(d = 13, h = 5, t = 2, r = 1, screw = M3_pan_screw);
module foot_stl() foot(foot);

wall = 2;
top_thickness = 2;
base_thickness = Thick;
inner_rad = 8;

//box1 = pbox(name = "box1", wall = wall, top_t = top_thickness, base_t = base_thickness, radius = inner_rad, size = [Width, Depth, Height], screw = M2_cap_screw, ridges = [8, 1]);
box1 = pbox(name = "box1", wall = wall, top_t = top_thickness, base_t = base_thickness, radius = inner_rad, size = [Width, Depth, Height], screw = M2_cap_screw);

module box1_internal_additions() {
}

module box1_external_additions() {
}

module box1_holes() {
}

module box1_case_stl() {
     pbox(box1) {
        box1_internal_additions();
        box1_holes();
        box1_external_additions();
     }
}

module box1_base_additions() {

  // Nano Mount
  translate([NanoPosX, NanoPosY, NanoPosZ])
    rotate([0,0,90]) {
      nano_mount(h=NanoHeight);
      %nano(h=NanoHeight);
    }

  // OLED Display
  translate([OledPosX, OledPosY, OledPosZ])
    rotate([180,0,0])
      %DisplayModule(type=I2C4, align=1, G_COLORS=true);

  // OLED posts    
  color(pp1_colour) {
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([180,0,0])
        oled_posts();
  }
}

module box1_base_holes() {
  // OLED cutout
  translate([OledPosX, OledPosY, OledPosZ])
    rotate([180,0,0])
      oled_cutout();
}

module box1_base_stl()
    pbox_base(box1) {
        box1_base_additions();
        box1_base_holes();
    }

module box1_assembly()
  assembly("box1") {
    if(Shell) {
      stl_colour(pp1_colour)
        render()
          box1_case_stl();

      pbox_inserts(box1);

      pbox_base_screws(box1);
    }

    if(FPanel) {
      translate_z(Height + top_thickness + base_thickness + eps)
        vflip()
          %render()
            box1_base_stl();
    }

  }

module printed_boxes() {
  //rotate(180)
    box1_assembly();
}

//if($preview)
    printed_boxes();
