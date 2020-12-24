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

$fn = 100;
$pp1_colour = "DimGray";
$pp2_colour = "SlateGray";

include <NopSCADlib/lib.scad>
use <NopSCADlib/printed/printed_box.scad>

include <OpenSCAD_Libs/models/096OledDim.scad>;
use <OpenSCAD_Libs/models/096Oled.scad>;
use <OpenSCAD_Libs/096_oled_mnt.scad>
use <OpenSCAD_Libs/nano_mnt.scad>

/* Box dimensions */
Width   = 60; // Width (X)
Depth   = 55; // Depth (Y)
Height  = 15; // Height (Z)

m = 0.2;

wall = 2;
top_thickness = 2;
base_thickness = 2.4;
inner_rad = 8;

/* Arduino dimensions */
NanoPosX = 18;
NanoPosY = -22;
NanoPosZ = base_thickness-0.01;
NanoHeight = 6;

/* Display dimensions */
OledType = DORHEA;
OledPosX = -12;
OledPosY = 2;
OledPosZ = base_thickness;

/* Connector dimensions */
Cable = 6.5;

/* [STL element to export] */
Shell       = 1;    // Shell [0:No, 1:Yes]
FPanel      = 1;    // Front panel [0:No, 1:Yes]
Components  = 1;    // Parts

//box1 = pbox(name = "box1", wall = wall, top_t = top_thickness, base_t = base_thickness, radius = inner_rad, size = [Width, Depth, Height], screw = M2_cap_screw, ridges = [8, 1]);
box1 = pbox(name = "box1", wall = wall, top_t = top_thickness, base_t = base_thickness, radius = inner_rad, size = [Width, Depth, Height], screw = M2_cap_screw);

module box1_internal_additions() {
}

module box1_external_additions() {
}

module box1_holes() {
  // Cable hole
  translate([-Width*0.25, Depth*0.44, top_thickness])
    rotate([0,0,90])
      cylinder(d=Cable, h=top_thickness*2.5, center=true);
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
      stl_colour(pp2_colour)
        nano_mount(h=NanoHeight);
      if(Components)
        %nano(h=NanoHeight);
    }

  // OLED Display
  if(Components)
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([180,0,0])
        %DisplayModule(type=OledType, align=1, G_COLORS=true);

  // OLED posts    
  color(pp1_colour) {
    translate([OledPosX, OledPosY, OledPosZ])
      rotate([180,0,0])
        stl_colour(pp2_colour)
          oled_posts(type=OledType);
  }
}

module box1_base_holes() {
  // OLED cutout
  translate([OledPosX, OledPosY, OledPosZ])
    rotate([180,0,0])
      oled_cutout(type=OledType);
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

      if(Components) {
        %pbox_inserts(box1);
        %pbox_base_screws(box1);
      }
    }

    if(FPanel) {
      translate_z(Height + top_thickness + base_thickness + eps)
        vflip()
          box1_base_stl();
    }

  }

box1_assembly();

echo(pbox_insert(box1));
echo(pbox_screw(box1));
echo(pbox_screw_inset(box1));
echo(pbox_screw_length(box1));
