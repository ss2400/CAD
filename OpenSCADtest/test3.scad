use <Parkinbot/Naca_sweep.scad>

outer = traj();
//inner = conicbow_traj(r=100, a1=180, a2 = 0, r1=18, r2=8, N=100);

//sweep(concat(outer, inner), close = true);  
sweep(outer, close = false);  

//function conicbow_traj(r=100, a1=0, a2 = 180, r1=10, r2=20, N=100) =
//  [for (i=[0:N-1]) let(R = r1+i*(r2-r1)/N) Rx_(a1+i*(a2-a1)/(N-1), Ty_(r, circle_(R)))];

//function circle_(r=10, N=30) =
//  [for (i=[0:N-1]) [r*sin(i*360/N), r*cos(i*360/N), 0]];

function traj(N=60) =
  [for (i=[0:N-1])
    let(R=i*i/600)
      Ty_(R/2,
        Tz_(i,
          circle_(R+30)))];

function circle_(r=10) =
  [ [ r,-r/2,0],
    [ r, r/2,0],
    [-r, r/2,0],
    [-r,-r/2,0],
    ];