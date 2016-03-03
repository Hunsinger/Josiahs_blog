final int screenWidth = 512;
final int screenHeight = 432;

float DOWN_FORCE = 2;
float ACCELERATION = 1.3;
float DAMPENING = 0.75;

void initialize() {
  addScreen("level", new MarioLevel(4*width, height));
  frameRate(30);
}

class MarioLevel extends Level {
  MarioLevel(float levelWidth, float levelHeight) {
    super(levelWidth, levelHeight);
    addLevelLayer("background", new BackgroundLayer(this));
    addLevelLayer("layer", new MarioLayer(this));
    setViewBox(0,0,screenWidth,screenHeight);
  }
}

class BackgroundLayer extends LevelLayer {
  BackgroundLayer(Level owner) {
    super(owner, owner.width, owner.height, 0, 0, 0.75, 0.75);
    setBackgroundColor(color(0, 100, 190));
  addBackgroundSprite(new TilingSprite(new Sprite("graphics/sky_2.gif"),0,0,width,height));
  }
}

class MarioLayer extends LevelLayer {
  Mario mario;

  MarioLayer(Level owner) {
    super(owner);
    Sprite background_picture = new Sprite("graphics/sky.gif");
    TilingSprite background = new TilingSprite(background_picture,0,0,width,height);
    addBackgroundSprite(background);
    addBackgroundSprite(new TilingSprite(new Sprite("graphics/sky.gif"),0,0,width,height));

    addBoundary(new Boundary(0,height-48,width,height-48));
    addBoundary(new Boundary(-1,0, -1,height));
    addBoundary(new Boundary(width+1,height, width+1,0));
    addGround(-32,height-48, width+32,height);
    addSlant(256, height-48);
    addSlant(1300, height-48);
    addSlant(1350, height-48);
    addGroundPlatform(928, height-224, 96, 112);
    addGroundPlatform(920, height-176, 32, 64);
    addGroundPlatform(912, height-128, 128, 80);
    addGroundPlatform(976, height-96, 128, 48);
    addGroundPlatform(1442, height-128, 128, 80);
    addGroundPlatform(1442+64, height-96, 128, 48);
    showBoundaries = true;

    mario = new Mario(32, height-64, 'A', 'W', 'D', 'mario');
    luigi = new Mario(46, height-64, 'J', 'I', 'L', 'luigi1');
    addPlayer(mario);
    addPlayer(luigi);
  }

  void draw() {
    super.draw();
    viewbox.track(parent, mario);
  }

  void addGround(float x1, float y1, float x2, float y2) {
    Sprite grassy = new Sprite("graphics/ground-top.gif");
    TilingSprite groundline = new TilingSprite(grassy, x1,y1,x2,y1+16);
    addBackgroundSprite(groundline);
    Sprite filler = new Sprite("graphics/ground-filler.gif");
    TilingSprite groundfiller = new TilingSprite(filler, x1,y1+16,x2,y2);
    addBackgroundSprite(groundfiller);
    addBoundary(new Boundary(x1,y1,x2,y1));
  }

  void addSlant(float x, float y) {
    Sprite groundslant = new Sprite("graphics/ground-slant.gif");
    groundslant.align(LEFT, BOTTOM);
    groundslant.setPosition(x, y);
    addBackgroundSprite(groundslant);
    addBoundary(new Boundary(x, y + 48 - groundslant.height, x + 48, y - groundslant.height));
  }

  void addGroundPlatform(float x, float y, float w, float h) {
    Sprite lc = new Sprite("graphics/ground-corner-left.gif");
    lc.align(LEFT, TOP);
    lc.setPosition(x, y);
    Sprite tp = new Sprite("graphics/ground-top.gif");
    Sprite rc = new Sprite("graphics/ground-corner-right.gif");
    rc.align(LEFT, TOP);
    rc.setPosition(x+w-rc.width, y);
    TilingSprite toprow = new TilingSprite(tp, x+lc.width, y, x+(w-rc.width), y+tp.height);
    addBackgroundSprite(lc);
    addBackgroundSprite(toprow);
    addBackgroundSprite(rc);

    TilingSprite sideleft = new TilingSprite(new Sprite("graphics/ground-side-left.gif"), x, y+tp.height, x+lc.width, y+h);
    TilingSprite filler = new TilingSprite(new Sprite("graphics/ground-filler.gif"), x+lc.width, y+tp.height, x+(w-rc.width), y+h);
    TilingSprite sideright = new TilingSprite(new Sprite("graphics/ground-side-right.gif"), x+w-rc.width, y+tp.height, x+w, y+h);
    addBackgroundSprite(sideleft);
    addBackgroundSprite(filler);
    addBackgroundSprite(sideright);

    addBoundary(new Boundary(x, y, x+w, y));
  }
}

class Mario extends Player {
  
  char left;
  char up;
  char right;
  string name;

  Mario(float x, float y, char _left, char _up, char _right, string _name) {
    left = _left;
    up = _up;
    right = _right;
    name = _name;

    super("Mario");
    setupStates();
    setPosition(x,y);
    handleKey(left);
    handleKey(up);
    handleKey(right);
    setForces(0,DOWN_FORCE);
    setAcceleration(0,ACCELERATION);
    setImpulseCoefficients(DAMPENING,DAMPENING);
  }
  void setupStates() {
    addState(new State("idle", "graphics/Standing-" + name + ".gif")); 
    addState(new State("running", "graphics/Running-" + name + ".gif",1,4));

    State jumping = new State("jumping", "graphics/Jumping-" + name + ".gif");
    jumping.setDuration(15);
    addState(jumping);

    State dead = new State("dead", "graphics/Dead-" + name + ".gif",1,2);
    dead.setAnimationSpeed(0.25);
    dead.setDuration(100);
    addState(dead);

    setCurrentState("idle");
  }

  void handleStateFinished(State which) {
    setCurrentState("idle");
  }

  void handleInput() {
    if(isKeyDown(left) || isKeyDown(right)) {
      if (isKeyDown(left)) {
        setHorizontalFlip(true);
        addImpulse(-2, 0);
      }
      if (isKeyDown(right)) {
        setHorizontalFlip(false);
        addImpulse(2, 0);
      }
    }

    if(isKeyDown(up) && active.name!="jumping" && boundaries.size()>0) {
      addImpulse(0,-35);
      setCurrentState("jumping");
    }
    
    if (active.mayChange()) {
      if(isKeyDown(left) || isKeyDown(right)) {
        setCurrentState("running");
      }
      else { setCurrentState("idle"); }
    }
  }
}

class MarioPickup extends Pickup {
  MarioPickup(String name, String spritesheet, int rows, int columns, float x, float y, boolean visible) {
    super(name, spritesheet, rows, columns, x, y, visible);
  }
}

class Coin extends MarioPickup {
  Coin(float x, float y) {
    super("Regular coin", "graphics/assorted/Regular-coin.gif", 1, 4, x, y, true);
  }
}

class DragonCoin extends MarioPickup {
  DragonCoin(float x, float y) {
    super("Dragon coin", "graphics/assorted/Dragon-coin.gif", 1, 10, x, y, true);
  }
}