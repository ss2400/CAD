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

Range = 9;

//myScale = [1,  2,  4];
//myZ = [0, 15, 22];
myScaleX = [for (i=[0:1:Range]) 1+i*i/400];
myScaleY = [for (i=[0:1:Range]) 1+i*i/200];
myMoveY =  [for (i=[0:1:Range]) 1+i*i/19.92];
myZ = [for (i=[0:1:Range]) i*10];

myProfs = [for (x=[0:1:Range])
          apply(back(myMoveY[x])*yscale(myScaleY[x])*xscale(myScaleX[x]), rect([Width1,Height1],rounding=5, center=true))];
          //apply(xscale(myScale[x]), rect([15,15],rounding=5))];
          //apply(right(1)*xscale(x*x/10), circle(d = 15, $fn = 80))];

skin(myProfs, z=myZ, slices=10, method="reindex"); 

echo(myScaleX);
echo(myScaleY);
echo(myZ);
