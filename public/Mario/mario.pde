final int screenWidth = 512;
final int screenHeight = 432;

float DOWN_FORCE = 2;
float ACCELERATION = 1.3;
float DAMPENING = 0.75;

void initialize() {
  addScreen("level", new MarioLevel(width, height));  
}

class MarioLevel extends Level {
  MarioLevel(float levelWidth, float levelHeight) {
    super(levelWidth, levelHeight);
    addLevelLayer("layer", new MarioLayer(this));
  }
}

class MarioLayer extends LevelLayer {
  MarioLayer(Level owner) {
    super(owner);
    setBackgroundColor(color(0, 100, 190));
    addBoundary(new Boundary(0,height-48,width,height-48));
    showBoundaries = true;
    Mario mario = new Mario(width/2, height/2, 'A', 'W', 'D', 'mario');
    Mario luigi = new Mario((width/2) + 5, height/2, 'J', 'I', 'L', 'luigi1');
    addPlayer(mario);
    addPlayer(luigi);
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
    addState(new State("running", "graphics/Running-mario.gif",1,4));
    addState(new State("jumping", "graphics/Jumping-mario.gif"));
    addState(new State("dead", "graphics/Dead-mario.gif",1,2));
    setCurrentState("idle");    
  }

  void handleInput() {
    if (isKeyDown(left)) { addImpulse(-2, 0); }
    if (isKeyDown(right)) { addImpulse(2, 0); }
    if (isKeyDown(up)) { addImpulse(0,-10); }
  }
}