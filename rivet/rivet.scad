// rivet.scad Customizable plastic rivet

$fn = 100;

/* Rivet dimensions */
Base_Dia      = 8;
Base_Length   = 2;

Shaft_Dia     = 4.5;
Shaft_Length  = 4.4;

Head_Dia      = 5.4;
Head_Length   = 3;

Slot_Width    = 1;
Slot_Height   = Base_Length-0.1;

difference() {
  union() {
    translate([0, 0, 0])
      cylinder(d=Base_Dia, h=Base_Length, center=false);

    translate([0, 0, Base_Length-0.01])
      cylinder(d=Shaft_Dia, h=Shaft_Length, center=false);

    translate([0, 0, Base_Length+Shaft_Length-0.01])
      cylinder(d1=Head_Dia, h=Head_Length, d2=Shaft_Dia);
  }
  translate([-Slot_Width/2,-25, Slot_Height])
    cube([Slot_Width,50,50]);
}      