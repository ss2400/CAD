include <BOSL2/std.scad>
include <BOSL2/hull.scad>
include <BOSL2/skin.scad>

$fn=100;
Points = 20;
PointsF = 14;

/* [Box dimensions] */
Width1    = 75; // Width (X)
Width2    = 95; // Width (X)
WidthDiff = 10; // Width trapezoid effect
Depth     = 90; // Depth (Y)
Height1   = 25; // Height (Z)
Height2   = 45; // Height (Z)
Radius    =  6; // External filet
Wall      =  3;
FaceAngle = -25;
FaceRadius = 2;

module myBox() {
  RatioW = pow(Points-1,2)/((Width2/Width1)-1);
  RatioH = pow(Points-1,2)/((Height2/Height1)-1);
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

  Start = 0;
  Incr = 1;
  End = Points-1;
  
  EndF = PointsF-1;

  ScaleX1 = [for (i=[Start:Incr:End]) 1+(i*i) * ((Width2/Width1)-1)/pow(End,2)];
  ScaleX2 = [for (i=[Start:Incr:End]) 1+(i*i) * ((Width2-WidthDiff)/(Width1-WidthDiff)-1)/pow(End,2)];
  ScaleY  = [for (i=[Start:Incr:End]) 1+(i*i) * ((Height2/Height1)-1)/pow(End,2)];
  MoveY   = [for (i=[Start:Incr:End]) Height1/2+(i*i) * ((Height2-Height1)/2)/pow(End,2)];
  OuterZ  = [for (i=[Start:Incr:End]) i * Depth/(End)];
  InnerZ  = [for (i=[Start:Incr:End]) i * (Depth+0.02)/(End)-0.01];
  Angle   = [for (i=[Start:Incr:End]) i * FaceAngle/(End)];

  FaceX  = [for (i=[Start:Incr:EndF]) FaceRadius-FaceRadius*cos(90*i/EndF)];
  FaceZ  = [for (i=[Start:Incr:EndF]) FaceRadius*sin(90*i/EndF)];

  // Baseline 2D shape
  function OuterBase(i) = trapezoid(h =Height1*ScaleY[i],
                                    w1=Width1*ScaleX1[i],
                                    w2=(Width1-WidthDiff)*ScaleX2[i],
                                    rounding=Radius);

  function InnerBase(i) = trapezoid(h =Height1*ScaleY[i]-Wall*2,
                                    w1=Width1*ScaleX1[i]-Wall*2,
                                    w2=(Width1-WidthDiff)*ScaleX2[i]-Wall*2,
                                    rounding=Radius-Wall);

  // 3D face
  function Face(i) = trapezoid(h =Height2-2*FaceX[i],
                               w1=Width2-2*FaceX[i],
                               w2=(Width2-WidthDiff)-2*FaceX[i],
                               rounding=Radius);

  // 3D profiles
  ProfOuter = [for(i=[Start:Incr:End])
                apply(
                  xrot(a=Angle[i],cp=[0,0,OuterZ[i]])*
                  back(MoveY[i]),
                  path3d(OuterBase(i), OuterZ[i])
                ),
              // Face
              for(i=[0:1:EndF])
                apply(xrot(a=Angle[End],cp=[0,0,OuterZ[End]])*
                  back(MoveY[End]),
                  path3d(Face(i), Depth+FaceZ[i])
                )
              ];

  ProfInner = [for(i=[Start:Incr:End])
                apply(
                  xrot(a=Angle[i],cp=[0,0,InnerZ[i]])*
                  back(MoveY[i]),
                  path3d(InnerBase(i), InnerZ[i])
                ),
                // Face
                apply(
                  xrot(a=Angle[End],cp=[0,0,InnerZ[End]])*
                  back(MoveY[End]),
                  path3d(InnerBase(End), InnerZ[End]+FaceRadius)
                )
              ];

  // Skin and hollow
  difference() {
    skin(ProfOuter,slices=10,method="reindex");
    skin(ProfInner,slices=2,sampling="segment",method="direct");
  }

  echo("FaceX",FaceX);
  echo("FaceZ",FaceZ);
  //echo(OuterZ);
  //echo(MoveY);
  //echo(Angle);
  //echo(Height1*ScaleY);
  //echo(Width1*ScaleX1);
  //echo((Width1-WidthDiff)*ScaleX2);
}

module myBox4() {
  
  /*
  shape = star(n=5, r=10, ir=5);
  rpath = [[0,0,0],[0,0,50],[0,15,70],[0,20,90]];
  trans = path_sweep(shape, rpath, transforms=true);
  outside = [for(i=[0:len(trans)-1]) trans[i]*scale(lerp(1,1.5,i/(len(trans)-1)))];
  inside = [for(i=[len(trans)-1:-1:0]) trans[i]*scale(lerp(1.1,1.4,i/(len(trans)-1)))];
  sweep(shape, concat(outside,inside),closed=true);
  */

  shape = subdivide_path(square(30,center=true), 40, closed=true);
  outside = [for(i=[0:24]) up(i)*scale(1.25*i/24+1)];
  inside = [for(i=[24:-1:2]) up(i)*scale(1.1*i/24+1)];
  sweep(shape, concat(outside,inside));

  // Skin and hollow
  //difference() {
    //sweep(ProfOuter, path_transforms);
    //sweep(ProfInner,slices=2,sampling="segment",method="direct");
  //}
}

//translate([0,0,90])
  //rotate([FaceAngle,0,0])
    //translate([-Width2/2,0,0])
      //%cube([Width2,Height2,0.1]);

//myBox();
//myBox2();
myBox3();
//myBox4();