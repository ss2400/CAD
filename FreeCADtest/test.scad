include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/layout.scad>

include <NopSCADlib/vitamins/inserts.scad>

// Threaded inserts
//
//                     l    o    h    s    b     r    r    r
//                     e    u    o    c    a     i    i    i
//                     n    t    l    r    r     n    n    n
//                     g    e    e    e    r     g    g    g
//                     t    r         w    e     1    2    3
//                     h         d         l
//                          d         d          h    d    d
//                                         d
//
F2BM2   = [ "F2BM2",   4.0, 3.5, 3.1, 2,   2.8,  1.0, 3.5, 3.5];

module inserts() {

  for(i = [0: len(inserts) -1])
    // Inserts
    translate([10 * i+10, 0])
      %insert(inserts[i]);

  // My insert
  %insert(F2BM2);
  
  stl_colour(pp1_colour) {
  
    // Lug
    translate([10, 10,20])
      %insert_lug(inserts[0], 2, 1);

    // Boss
    translate([20, 10, 20])
      %insert_boss(inserts[0], z = 10, wall = 2);
      
      
    // Panel
    difference() {
      cube([40,20,5]);
      
      for(i = [1: 7])
        translate([i*5,10,5])
          #insert_hole(F1BM2, counterbore = 0, horizontal = false);
    }
  }
}

//if($preview)
//    let($show_threads = true)
        inserts();
