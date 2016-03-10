final int screenWidth = 512;
final int screenHeight = 432;

float DOWN_FORCE = 2;
float ACCELERATION = 1.3;
float DAMPENING = 0.75;

void initialize() {
  frameRate(30);
  addScreen("level", new MarioLevel(4*width, height));
}

void reset() {
  clearScreens();
  addScreen("level", new MarioLevel(4*width, height))
}

class MarioLevel extends Level {
  MarioLevel(float levelWidth, float levelHeight) {
    super(levelWidth, levelHeight);
    setViewBox(0,0,screenWidth,screenHeight);
    addLevelLayer("background", new BackgroundLayer(this));
    addLevelLayer("layer", new MarioLayer(this));
  }
}

class BackgroundLayer extends LevelLayer {
  BackgroundLayer(Level owner) {
    super(owner, owner.width, owner.height, 0,0, 0.75,0.75);
    setBackgroundColor(color(0, 100, 190));
    addBackgroundSprite(new TilingSprite(new Sprite("Mario/graphics/sky_2.gif"),0,0,width,height));
  }
}

class MarioLayer extends LevelLayer {
  Mario mario;
  MarioLayer(Level owner) {
    super(owner);
    addBackgroundSprite(new TilingSprite(new Sprite("Mario/graphics/sky.gif"),0,0,width,height));
    addBoundary(new Boundary(0,height-48,width,height-48));
    addBoundary(new Boundary(-1,0, -1,height));
    addBoundary(new Boundary(width+1,height, width+1,0));

    mario = new Mario(32, height-64);
    addPlayer(mario);
    Koopa koopa = new Koopa(264, height-178);
    addInteractor(koopa);

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

    addCoins(928,height-236,96);
    addCoins(912,height-140,128);
    addCoins(1442,height-140,128);
    addForPlayerOnly(new DragonCoin(352,height-164));

    addGoal(1920, height-48);
  }

  void addGround(float x1, float y1, float x2, float y2) {
    TilingSprite groundline = new TilingSprite(new Sprite("Mario/graphics/ground-top.gif"), x1,y1,x2,y1+16);
    addBackgroundSprite(groundline);
    TilingSprite groundfiller = new TilingSprite(new Sprite("Mario/graphics/ground-filler.gif"), x1,y1+16,x2,y2);
    addBackgroundSprite(groundfiller);
    addBoundary(new Boundary(x1,y1,x2,y1));
  }

  void addSlant(float x, float y) {
    Sprite groundslant = new Sprite("Mario/graphics/ground-slant.gif");
    groundslant.align(LEFT, BOTTOM);
    groundslant.setPosition(x, y);
    addBackgroundSprite(groundslant);
    addBoundary(new Boundary(x, y + 48 - groundslant.height, x + 48, y - groundslant.height));
  }

  void addGroundPlatform(float x, float y, float w, float h) {
    Sprite lc = new Sprite("Mario/graphics/ground-corner-left.gif");
    lc.align(LEFT, TOP);
    lc.setPosition(x, y);
    Sprite tp = new Sprite("Mario/graphics/ground-top.gif");
    Sprite rc = new Sprite("Mario/graphics/ground-corner-right.gif");
    rc.align(LEFT, TOP);
    rc.setPosition(x+w-rc.width, y);
    TilingSprite toprow = new TilingSprite(tp, x+lc.width, y, x+(w-rc.width), y+tp.height);
    addBackgroundSprite(lc);
    addBackgroundSprite(toprow);
    addBackgroundSprite(rc);
    TilingSprite sideleft  = new TilingSprite(new Sprite("Mario/graphics/ground-side-left.gif"), x, y+tp.height, x+lc.width, y+h);
    TilingSprite filler    = new TilingSprite(new Sprite("Mario/graphics/ground-filler.gif"), x+lc.width, y+tp.height, x+(w-rc.width), y+h);
    TilingSprite sideright = new TilingSprite(new Sprite("Mario/graphics/ground-side-right.gif"), x+w-rc.width, y+tp.height, x+w, y+h);
    addBackgroundSprite(sideleft);
    addBackgroundSprite(filler);
    addBackgroundSprite(sideright);
    addBoundary(new Boundary(x, y, x+w, y));
  }

  void addCoins(float x, float y, float w) {
    float step = 16, i = 0, last = w/step;
    for(i=0; i<last; i++) {
      addForPlayerOnly(new Coin(x+8+i*step,y));
    }
  }

  void addGoal(float xpos, float hpos) {
    Sprite back_post = new Sprite("Mario/graphics/Goal-back.gif");
    back_post.align(CENTER, BOTTOM);
    back_post.setPosition(xpos, hpos);
    addBackgroundSprite(back_post);

    Sprite front_post = new Sprite("Mario/graphics/Goal-front.gif");
    front_post.align(CENTER, BOTTOM);
    front_post.setPosition(xpos+32, hpos);
    addForegroundSprite(front_post);

    addForPlayerOnly(new Rope(xpos, hpos-16));
  }

  void draw() {
    super.draw();
    viewbox.track(parent, mario);
  }
}

class Mario extends Player {
  float speed = 2;
  Mario(float x, float y) {
    super("Mario");
    setupStates();
    setPosition(x,y);
    handleKey('W');
    handleKey('A');
    handleKey('D');
    setForces(0,DOWN_FORCE);
    setAcceleration(0,ACCELERATION);
    setImpulseCoefficients(DAMPENING,DAMPENING);
  }

  void setupStates() {
    addState(new State("idle", "Mario/graphics/Standing-mario.gif")); 
    addState(new State("running", "Mario/graphics/Running-mario.gif",1,4));

    State jumping = new State("jumping", "Mario/graphics/Jumping-mario.gif");
    jumping.setDuration(15);
    addState(jumping);

    State dead = new State("dead", "Mario/graphics/Dead-mario.gif",1,2);
    dead.setAnimationSpeed(0.25);
    dead.setDuration(15);
    addState(dead);

    State won = new State("won", "Mario/graphics/Standing-mario.gif");
    won.setDuration(15);
    addState(won);

    setCurrentState("idle");

  }

  void handleStateFinished(State which) {
    setCurrentState("idle");
  }

  void handleInput() {
    if(isKeyDown('A') || isKeyDown('D')) {
      if (isKeyDown('A')) {
        setHorizontalFlip(true);
        addImpulse(-2, 0);
      }
      if (isKeyDown('D')) {
        setHorizontalFlip(false);
        addImpulse(2, 0);
      }
    }

    if(isKeyDown('W') && active.name!="jumping" && boundaries.size()>0) {
      addImpulse(0,-35);
      setCurrentState("jumping");
    }
    
    if (active.mayChange()) {
      if(isKeyDown('A') || isKeyDown('D')) {
        setCurrentState("running");
      }
      else { setCurrentState("idle"); }
    }
  }

  void overlapOccurredWith(Actor other, float[] direction) {
    if (other instanceof Koopa) {
      Koopa koopa = (Koopa) other;
      float angle = direction[2];
      float tolerance = radians(75);
      if (PI/2 - tolerance <= angle && angle <= PI/2 + tolerance) {
        koopa.squish();
        stop(0,0);
        setImpulse(0, -30);
        setCurrentState("jumping");
      }
    else { die(); }
    }
  }

  void die() {
    setCurrentState("dead");
    setInteracting(false);
    addImpulse(0,-30);
    setForces(0,3);
  }

  void handleStateFinished(State which) {
    if(which.name == "dead" || which.name == "won") {
      removeActor();
      reset();
    }
    else {
      setCurrentState("idle");
    }
  }

  void pickedUp(Pickup pickup) {
    if (pickup.name=="Finish line") {
      setCurrentState("won");
    }
  }
}

class MarioPickup extends Pickup {
  MarioPickup(String name, String spritesheet, int rows, int columns, float x, float y, boolean visible) {
    super(name, spritesheet, rows, columns, x, y, visible);
  }
  void gotBlocked(Boundary b, float[] intersection) {
    if (intersection[0]-x==0 && intersection[1]-y==0) {
      fx = -fx;
      active.sprite.flipHorizontal();
    }
  }
}

class Coin extends MarioPickup {
  Coin(float x, float y) {
    super("Regular coin", "Mario/graphics/Regular-coin.gif", 1, 4, x, y, true);
  }
}

class DragonCoin extends MarioPickup {
  DragonCoin(float x, float y) {
    super("Dragon coin", "Mario/graphics/Dragon-coin.gif", 1, 10, x, y, true);
  }
}

class Rope extends MarioPickup {
  Rope(float x, float y) {
    super("Finish line", "Mario/graphics/Goal-slider.gif", 1, 1, x, y, true);
    Sprite rope_sprite = getState("Finish line").sprite;
    rope_sprite.align(LEFT, TOP);
    rope_sprite.addPathLine(0,0,1,1,0,0,-116,1,1,0,50);
    rope_sprite.addPathLine(0,-116,1,1,0,0,0,1,1,0,50);
    rope_sprite.setNoRotation(true);
    rope_sprite.setLooping(true);
  }
}

class Koopa extends Interactor {
  Koopa(float x, float y) {
    super("Koopa Trooper");
    setStates();
    setForces(-0.25, DOWN_FORCE);    
    setImpulseCoefficients(DAMPENING, DAMPENING);
    setPosition(x,y);
  }

  void setStates() {
    State walking = new State("idle", "Mario/graphics/Red-koopa-walking.gif", 1, 2);
    walking.setAnimationSpeed(0.12);
    addState(walking);

    State noshell = new State("noshell", "Mario/graphics/Naked-koopa-walking.gif", 1, 2);
    noshell.setAnimationSpeed(0.12);
    addState(noshell);

    setCurrentState("idle");
  }

  void gotBlocked(Boundary b, float[] intersection) {
    if (b.x == b.xw) {
      fx = -fx;
      setHorizontalFlip(fx > 0);
    }
  }

  void squish() {
    if (active.name != "noshell") {
      setCurrentState("noshell");
      return;
    }

    removeActor();
  }
}