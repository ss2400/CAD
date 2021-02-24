include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/skin.scad>

$fn=100;
/* Box dimensions */
Width1    = 75; // Width (X)
Width2    = 95; // Width (X)
Depth     = 90; // Depth (Y)
Height1   = 25; // Height (Z)
Height2   = 45; // Height (Z)
Wall      = 3;
AngleFace = 15;

HeightSw = 18;
AngleSw = -14;

module myBox() {
  Range = 9;
  myScaleX = [for (i=[0:1:Range]) 1+i*i/400];
  myScaleY = [for (i=[0:1:Range]) 1+i*i/200];
  myMoveY =  [for (i=[0:1:Range]) 1+i*i/19.92];
  myZ = [for (i=[0:1:Range]) i*10];

  myProfs = [for (x=[0:1:Range])
            apply(back(myMoveY[x])*
                  yscale(myScaleY[x])*
                  xscale(myScaleX[x]),
                  rect([Width1,Height1],rounding=5, center=true))];

  skin(myProfs, z=myZ, slices=25,sampling="segment",method="reindex"); 

  echo(myScaleX);
  echo(myScaleY);
  echo(myZ);
  //echo(myProfs);
}

module myBox2() {
  xrot(90)down(1.5)
  difference() {
    skin(
        [square([2,.2],center=true),
         circle($fn=64,r=0.5)], z=[0,3],
        slices=40,sampling="segment",method="reindex");
    skin(
        [square([1.9,.1],center=true),
         circle($fn=64,r=0.45)], z=[-.01,3.01],
        slices=40,sampling="segment",method="reindex");
  }
}

myBox();
//myBox2();