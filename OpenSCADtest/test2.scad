a=30;
b=20;
c=10;    //half-axes of ellipse

Step=1;
 
function P(u,v)=[a*cos(u)*sin(v),b*sin(u)*sin(v),c*cos(v)];  //point on the surface of an ellipsoid
 
function SurfaceElement(u,v) = let(hs = Step / 2) [ P(u - hs, v - hs),
                                                    P(u + hs, v - hs),
                                                    P(u + hs, v + hs),
                                                    P(u - hs, v + hs)];

function quad(i) = let(p = i * 4) [[p, p + 1, p + 2], [p, p + 2, p + 3]];
 
function flatten(l) = [ for (a = l) for (b = a) b ] ;
   
elements = flatten([let(s = Step / 2) for(v = [s : Step : 180 - s]) for(u = [s : Step: 360 - s]) SurfaceElement(u, v)]);
faces    = flatten([for(v = [0 : 180 / Step - 1]) for(u = [0 : 360 / Step - 1]) quad(v * 360 / Step + u) ]);

difference() {
    polyhedron(elements, faces);
    cylinder(h=40, d=8, center=true, $fn=20);
} 