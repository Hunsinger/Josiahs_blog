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
                  graphics/Dead-mario.gif",
                  graphics/Standing-luigi1.gif; */