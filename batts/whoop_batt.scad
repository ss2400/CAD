$fn=50;

// 0=Whoop 1s, 1=Large 1S, 2=Large 2s, 3=experiment
Part=3;
Rows=[5,4,3,2];
Columns=[5,3,3,2];
Length=[12,17,17,12];
Width=[6.5,8.5,13,6.5];
Wall=[5,5,5,5];
Height=[20,20,20,20];

Box_Radius=1;   // min/max: [1:5]
Box_Floor=1;   // min/max: [1:10]

Box_Length=(Length[Part]+Wall[Part])*Columns[Part];
Box_Width=(Width[Part]+Wall[Part])*Rows[Part];
// Total box height = height+2*radius

difference() {
    // Create box
    minkowski(){
        cube([Box_Width, Box_Length, Height[Part]], center = true);
        sphere(Box_Radius);
    }

    // Hollow slots inside
    translate([-(Width[Part]+Wall[Part])*(Rows[Part]-1)/2,-(Length[Part]+Wall[Part])*(Columns[Part]-1)/2,Box_Floor-Box_Radius])
        #slots();
}

module slots() {
    for (i=[0:Columns[Part]-1]) {
        for (j=[0:Rows[Part]-1]) {
            translate([j*(Width[Part]+Wall[Part]), i*(Length[Part]+Wall[Part]), 5])
                cube([Width[Part], Length[Part], Height[Part]+10], center = true);
        }
    }
}
