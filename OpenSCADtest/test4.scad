use <scad-utils/transformations.scad>
use <scad-utils/trajectory_path.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/shapes.scad>

use <list-comprehension-demos/skin.scad>
use <list-comprehension-demos/sweep.scad>

//path_definition = [
//  trajectory(forward = 10, roll  =  0),
//  trajectory(forward = 5*3.14159265359, pitch = 180),
//  trajectory(forward = 10, roll  =  0)
//];

path_definition = [
  trajectory(forward = 10, pitch  =  0, roll=0)];

// sweep
//path = quantize_trajectories(path_definition, steps=100);
//sweep(rectangle_profile([2,3]), path);

// skin
//myLen = len(path)-1;
//trans = [ for (i=[0:len(path)-1]) transform(path[i], rounded_rectangle_profile([4,4], i/myLen*2)) ];

//translate([0,10,0])
//  skin(trans);