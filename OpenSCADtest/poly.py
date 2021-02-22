#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import math

print("Starting")

# define parameters
rr = 26                     # radius of rotation
r1 = 10                     # outer radius of tube                      
r2 = 8                      # inner radius of tube
scale = 2                   # scalefactor over rotation
segments = 90               # segments of base circle   -> resolution
rAngle = 180                # angle of rotation
rSegments = 45              # segments of rotation      -> resolution

def polyhedron(rr,radius,scale, segments, rAngle, rSegments):
    stepAngle = 360/segments
    rotAngle = rAngle/rSegments
    points = '['                # string with the vector of point-vectors
    faces = '['                 # string with the vector of face-vectors
    sprs = (scale-1)/rSegments                  # scale per rSegment

    # construct all points
    for j in range(0,rSegments+1):
        angle = j*rotAngle
        for i in range(0,segments):
            xflat = (math.sin(math.radians(i*stepAngle))*radius)            # x on base-circle
            xscaled = xflat*(1 + sprs*j) + rr                       # x scaled (+ rr -> correction of centerpoint
            xrot = math.cos(math.radians(angle))*xscaled                # x rotated
            yflat = (math.cos(math.radians(-i*stepAngle))*radius)           # y on base-circle
            yscaled = yflat*(1 + sprs*j)                        # y scaled
            z = math.sin(math.radians(angle))*xscaled                   # z rotated
            string  = '[{},{},{}],'.format(xrot,yscaled,z)
            points += string

    points += ']' 

    # construct all faces
    # bottom
    f = '['
    for i in range(segments-1,-1,-1):
        f += '{},'.format(i)
    f += '],'
    faces += f                  # add bottom to faces

    # all faces on the side of the tube
    for p in range(0, segments*rSegments):
        p1 = p
        p2 = p + 1 -segments if p%segments == segments-1 else p +1
        p3 = p + segments
        p4 = p3 + 1 -segments if p%segments == segments-1 else p3 +1
        f = '[{},{},{}],'.format(p1,p4,p3)
        faces += f
        f = '[{},{},{}],'.format(p1,p2,p4)
        faces += f
    # top
    f = '['
    for i in range(segments*rSegments,segments*(rSegments+1)):
        f += '{},'.format(i)
    f += ']'
    faces += f                  # add top to faces
    faces += ']'

    string = 'polyhedron( points = {}, faces = {});'.format(points,faces)
    return string    

# output in openscad-file
print("Writing file")
wobj = open('horn.scad','w')            # open openscad-file for writing
wobj.write('difference() {\n')
string = '    '
string += polyhedron(rr,r1,scale,segments,rAngle,rSegments)
string += '\n'
wobj.write(string)
string = '    '
string += polyhedron(rr,r2,scale,segments,rAngle,rSegments) 
string += '\n'
wobj.write(string)
wobj.write('}')
wobj.close()                        # close openscad-file
print("Finished")
# finally open openscad-file in openscad
