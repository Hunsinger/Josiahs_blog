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
        font="Mario/fonts/acmesa.ttf";
        preload=" 
                  Mario/graphics/Standing-mario.gif,
                  Mario/graphics/Running-mario.gif,
                  Mario/graphics/Jumping-mario.gif,
                  Mario/graphics/Dead-mario.gif,
                  Mario/graphics/sky.gif,
                  Mario/graphics/sky_2.gif,
                  Mario/graphics/ground-top.gif,
                  Mario/graphics/ground-filler.gif,
                  Mario/graphics/ground-slant.gif,
                  Mario/graphics/ground-corner-left.gif,
                  Mario/graphics/ground-corner-right.gif,
                  Mario/graphics/ground-side-left.gif,
                  Mario/graphics/ground-side-right.gif,
                  Mario/graphics/Regular-coin.gif,
                  Mario/graphics/Dragon-coin.gif,
                  Mario/graphics/Red-koopa-walking.gif,
                  Mario/graphics/Naked-koopa-walking.gif,
                  Mario/graphics/Goal-back.gif,
                  Mario/graphics/Goal-front.gif,
                  Mario/graphics/Goal-slider.gif; */