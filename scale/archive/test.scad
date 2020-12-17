$fn=100;

include <OpenSCAD_Arduino_Lib/hx711.scad>

cube([36, 24, 1]);

hx711();
hx711_mount();