// preview[view:north east, tilt:top diagonal]

// width of hook
hook_width = 45; //[5:100]

// thickness of part
hook_thick = 8; //[1:10]

// length of top we hang on
hook_top = 59; //[5:100]

// length of overhang latch (twice as long on hanger side)
hook_latch = 60; //[5:100]

// angle of the tongue
hook_angle = 35; //[0:55]

// length of the tongue that sticks out
hook_tongue = 100; //[0:100]

coathook(hook_width, hook_thick, hook_top, hook_latch, hook_angle, hook_tongue);

module coathook(hookwidth, hookthick, hooktop, hooklatch, hookangle, hooktongue) {
  rotate ([90,0,0]) union () {
    // Top
    cube ([hooktop+hookthick, hookwidth, hookthick]);
      
    // Back
    rotate ([0,90,0]) cube ([hooklatch, hookwidth, hookthick]);
      
    // Front
    rotate ([0,90,0]) {
      translate ([-hookthick, 0, hooktop+hookthick]) {
          
        union (){
          cube ([(hooklatch*2) + hookthick, hookwidth, hookthick]);
          rotate ([-90,0,0]) 
            #cylinder (h = hookwidth, r = (hookthick / 4) + 1, $fn = 50);
        }
        //union () {
          //cube ([(hooklatch*2) + hookthick, hookwidth, hookthick]);
              //translate ([(hooklatch*2) + hookthick, 0, hookthick]) 
              //  rotate ([0,-90-hookangle,0]) 
              //    #cube ([hooktongue, hookwidth, hookthick]);
              //translate ([(hooklatch*2) - hookthick/2, 0, hookthick])
              //  rotate ([-90,0,0]) 
              //    #cylinder (
              //      h = hookwidth, 
              //      r = (hookthick / 2) + 1, 
              //      $fn = 50);
        //}
      }
    }
  }
}


