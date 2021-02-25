include <BOSL2/std.scad>
//include <BOSL2/rounding.scad>
include <BOSL2/hull.scad>
include <BOSL2/skin.scad>

$fn=100;
Points = 10;

/* [Box dimensions] */
Width1    = 75; // Width (X)
Width2    = 95; // Width (X)
WidthDiff = 10; // Width trapezoid effect
Depth     = 90; // Depth (Y)
Height1   = 25; // Height (Z)
Height2   = 45; // Height (Z)
Radius    =  6; // External filet
Wall      =  3;
AngleFace = -25;

module myBox() {
  RatioW = pow(Points-1,2)/(Width2/Width1-1);
  RatioH = pow(Points-1,2)/(Height2/Height1-1);
  RatioY = pow(Points-1,2)/((Height2-Height1)/2);
  ScaleX = [for (i=[0:1:Points-1]) 1+(i*i/RatioW)];
  ScaleY = [for (i=[0:1:Points-1]) 1+(i*i/RatioH)];
  MoveY =  [for (i=[0:1:Points-1]) 1+(i*i/RatioY)];
  OuterZ = [for (i=[0:1:Points-1]) i*Depth/(Points-1)];
  InnerZ = [for (i=[0:1:Points-1]) i*(Depth+0.02)/(Points-1)-0.01];

  ProfOuter = [for (x=[0:1:Points-1])
                apply(back(MoveY[x])*
                  yscale(ScaleY[x])*
                  xscale(ScaleX[x]),
                  rect([Width1,Height1],rounding=5, center=true))];

  ProfInner = [for (x=[0:1:Points-1])
                apply(back(MoveY[x])*
                  yscale(ScaleY[x])*
                  xscale(ScaleX[x]),
                  rect([Width1-Wall*2,Height1-Wall*2],rounding=5, center=true))];

  difference() {
    skin(ProfOuter, z=OuterZ, slices=10,sampling="segment",method="reindex"); 
    skin(ProfInner, z=InnerZ, slices=2 ,sampling="segment",method="reindex"); 
  }
  echo(ScaleX);
  echo(ScaleY);
  echo(OuterZ);
  echo(InnerZ);
}

module myBox2() {
  base = round_corners(square([2,4],center=true), radius=0.5);

  ProfOuter = [path3d(base,0),
               back(1,path3d(base,1)),
               xrot(15,[0,0,3],path3d(circle(r=0.5),3)),
               path3d(circle(r=0.5),4),
               for(i=[0:2]) each [path3d(circle(r=0.6), i+4),
                                  path3d(circle(r=0.5), i+5)]
              ];

  skin(ProfOuter,slices=0,sampling="segment",method="reindex");
}

// *** So far, this method is the best ***
module myBox3() {
  // Lists
  ScaleX = [for (i=[0:1:Points-1]) 1+(i*i) * (Width2/Width1-1)/pow(Points-1,2)];
  ScaleY = [for (i=[0:1:Points-1]) 1+(i*i) * (Height2/Height1-1)/pow(Points-1,2)];
  MoveY  = [for (i=[0:1:Points-1]) Height1/2+(i*i) * ((Height2-Height1)/2)/pow(Points-1,2)];
  OuterZ = [for (i=[0:1:Points-1]) i * Depth/(Points-1)];
  InnerZ = [for (i=[0:1:Points-1]) i * (Depth+0.02)/(Points-1)-0.01];
  Angle  = [for (i=[0:1:Points-1]) i * AngleFace/(Points-1)];
  
  // Baseline 2D shape
  OuterBase = trapezoid(h =Height1,
                        w1=Width1,
                        w2=Width1-WidthDiff,
                        rounding=Radius);

  InnerBase = trapezoid(h =Height1-Wall*2,
                        w1=Width1-Wall*2,
                        w2=Width1-WidthDiff-Wall*2,
                        rounding=Radius-Wall);

  // 3D profiles
  ProfOuter = [for(i=[0:1:Points-1])
                apply(
                  back(MoveY[i])*
                  xscale(ScaleX[i])*
                  yscale(ScaleY[i])*
                  xrot(a=Angle[i],cp=[0,-Height1/2,OuterZ[i]]),
                  path3d(OuterBase, OuterZ[i])
                )
              ];

  ProfInner = [for(i=[0:1:Points-1])
                apply(
                  back(MoveY[i])*
                  xscale(ScaleX[i])*
                  yscale(ScaleY[i])*
                  xrot(a=Angle[i],cp=[0,-Height1/2,InnerZ[i]]),
                  path3d(InnerBase, InnerZ[i])
                )
              ];
  
  // Skin and hollow
  difference() {
    skin(ProfOuter,slices=10,method="tangent");
    skin(ProfInner,slices=2,sampling="segment",method="direct");
  }
  echo(MoveY);
}
translate([0,0,90]) #cube([50,50,0.1]);
//myBox();
//myBox2();
myBox3();