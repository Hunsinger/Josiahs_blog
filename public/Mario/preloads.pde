/**
 * override!
 * this disables the default "loop()" when using addScreen
 */
void addScreen(String name, Screen screen) {
  screenSet.put(name, screen);
  if (activeScreen == null) { activeScreen = screen; }
  else { SoundManager.stop(activeScreen); }
}

/* @pjs pauseOnBlur="true";
        font="fonts/acmesa.ttf";
        preload=" 
                  graphics/Standing-mario.gif,
                  graphics/Running-mario.gif,
                  graphics/Jumping-mario.gif,
                  graphics/Dead-mario.gif,
                  graphics/Standing-luigi1.gif,
                  graphics/Running-luigi1.gif,
                  graphics/Jumping-luigi1.gif,
                  graphics/Dead-luigi1.gif,
                  graphics/sky.gif,
                  graphics/sky_2.gif,
                  graphics/ground-top.gif,
                  graphics/ground-filler.gif,
                  graphics/ground-slant.gif,
                  graphics/ground-corner-left.gif,
                  graphics/ground-corner-right.gif,
                  graphics/ground-side-left.gif,
                  graphics/ground-side-right.gif; */