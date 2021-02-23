include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/skin.scad>

myScale = [1,  2,  4];
myZ = [0, 15, 22];
myProfs = [for (x=[0:1:2])
          apply(right(1)*xscale(x*x/10), rect([15,15],rounding=5))];
          //apply(right(1)*xscale(x*x/10), circle(d = 15, $fn = 80))];

skin(myProfs, z=myZ, slices=10, method="reindex"); 