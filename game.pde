import processing.serial.*;

 // Global
import processing.sound.*; 
OrionDefender orion;
Mothership mothership;
SoundFile bombSound, shotSound, mothershipShotSound, bulletImpact, boostSound;
int gameState = 0; // 0: playing, 1: Game Over, 2: victory

PImage backgroundImage;
SoundFile backgroundMusic;

// SERIAL
Serial myPort;  // Objeto para la comunicación serial
boolean moveLeft = false;
boolean moveRight = false;
boolean shooting = false; // Variable para disparo automático si se mantiene presionado




// Setup
void setup() {
  size(800, 600);
  
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  myPort.clear(); 
  
  orion = new OrionDefender(width/2, height -100, 60, 60, 7); // 75x75
  mothership = new Mothership(width/2, -280, 650, 400);
  bombSound = new SoundFile(this, "bombExplosion.wav");
  shotSound = new SoundFile(this, "orionShot.wav"); //Listo
  mothershipShotSound = new SoundFile(this, "mothershipShot.wav"); // Listo
  bulletImpact = new SoundFile(this, "bulletImpact.wav"); // Listo
  boostSound = new SoundFile(this, "boostSound.wav"); //
  backgroundMusic = new SoundFile(this, "orionTheme.mp3"); //Listo
  backgroundMusic.loop(); // Música de fondo en loop
  backgroundMusic.amp(1.0); //bajar o subir sonido
  bombSound.amp(0.2); // Sonido de explosión de bomba
  shotSound.amp(0.2); // Sonido del disparo del jugador
  mothershipShotSound.amp(0.2); // Sonido del disparo de la nave nodriza
  bulletImpact.amp(0.2); // Sonido de impacto de bala
  boostSound.amp(0.2); // Sonido de potenciador
  
  
  background(0);
}

// Draw
void draw() {
  if (gameState == 0) {
    background(0);
    readSerialData(); 
    updateGame();
    displayGame();
  } else {
    displayGameOver();
  }
}

// Visual updates
void updateGame() {
  mothership.spawnObject();
  orion.moveOrionDefender(moveLeft, moveRight);
  
  updateBullets();
  updateBombs();
  updateSupplies();
  
  checkCollisions();
  checkGameState();
}

// display game objects
void displayGame() {
  orion.displayOrionDefender();
  mothership.displayMothership();
  
  // Display bullets for Orion Defender
  for (int i = 0; i < orion.getBullets().size(); i++) {
    Bullet b = orion.getBullets().get(i);
    b.displayBullet();
  }
  
  // Display bullets for Mothership
  for (int i = 0; i < mothership.getBullets().size(); i++) {
    Bullet b = mothership.getBullets().get(i);
    b.displayBullet();
  }
  
  // Display bombs:
  for (int i = 0; i < mothership.getBombs().size(); i++) {
    Bomb b = mothership.getBombs().get(i);
    b.displayBomb();
  }
  
  // Display supplies:
  for (int i = 0; i < mothership.getSupplies().size(); i++) {
    Supply s = mothership.getSupplies().get(i);
    s.displaySupply();
  }
  
  // Display user interface
  displayHUD();
}

// Bullets of screen
void updateBullets() {
  // update orion defender bullets
  for (int i = orion.getBullets().size() - 1; i >= 0; i--) {
    Bullet b = orion.getBullets().get(i);
    boolean isBulletOnScreen = b.moveBullet();
   
    if (!isBulletOnScreen) {
      orion.getBullets().remove(i);
    }
  }
  // update mothership bullets
  for (int i = mothership.getBullets().size() - 1; i >= 0; i--) {
    Bullet b = mothership.getBullets().get(i);
    boolean isBulletOnScreen = b.moveBullet();
    
    if (!isBulletOnScreen) {
      mothership.getBullets().remove(i);
    }
  }
}

// Bonbs of screen
void updateBombs() {
  // Update mothership bombs
  for (int i = mothership.getBombs().size() - 1; i >= 0; i--) {
    Bomb b = mothership.getBombs().get(i);
    b.moveDownBomb();
    boolean isBombOffScreen = b.isOffScreenBomb();
  
    if (isBombOffScreen) {
      mothership.getBombs().remove(i);
    }
  }
}

// Supplies off screen
void updateSupplies() {
  // Update mothership supplies
  for (int i = mothership.getSupplies().size() - 1; i >= 0; i--) {
    Supply s = mothership.getSupplies().get(i); 
    s.moveDownSupply();
    boolean isSupplyOffScreen = s.isOffScreenSupply();
    
    if (isSupplyOffScreen) {
      mothership.getSupplies().remove(i);
    }
  }
}

// Collision detections
void checkCollisions() {
  checkBulletCollisions();
  checkBombCollisions();
  checkSupplyCollisions();
  checkMothershipBulletCollisions();
}

// Collision between bullets
void checkBulletCollisions() {
  for (int i = orion.getBullets().size()-1; i >= 0; i--) {
    Bullet b = orion.getBullets().get(i);
    
    // Collision between orion bullets and mothership
    if (mothership.getHealth() > 0 && 
        b.getY() < mothership.getY() + mothership.getHeight()) {
      mothership.takeDamageMothership(b.getDamage());
      bulletImpact.play();
      orion.getBullets().remove(i);
    }
    
    // Collision between orion bullets and mothership bombs
    for (int j = mothership.getBombs().size()-1; j >= 0; j--) {
      if (b.collidesBulletWithBomb(mothership.getBombs().get(j))) {
        orion.getBullets().remove(i);
        mothership.getBombs().remove(j);
        break;
      }
    }
  }
}

// Bomb collisions
void checkBombCollisions() {
  for (int i = mothership.getBombs().size()-1; i >= 0; i--) {
    Bomb b = mothership.getBombs().get(i);
    // Collisions between bombs and orion
    if (orion.checkCollisionOrionDefenderObject(b.getX(), b.getY(), b.getWidth(), b.getHeight())) {
      orion.takeDamageOrionDefender();
      bombSound.play();
      mothership.getBombs().remove(i);
    }
  }
}

// Supply collisions
void checkSupplyCollisions() {
  for (int i = mothership.getSupplies().size()-1; i >= 0; i--) {
    Supply s = mothership.getSupplies().get(i);
    // Collision between supplys and orion by type
    if (orion.checkCollisionOrionDefenderObject(s.getX(), s.getY(), s.getWidth(), s.getHeight())) {
      orion.collectSupply(s.getType());
      boostSound.play();
      mothership.getSupplies().remove(i);
    }
  }
}

// Mothership bullets collision
void checkMothershipBulletCollisions() {
  for (int i = mothership.getBullets().size()-1; i >= 0; i--) {
    Bullet b = mothership.getBullets().get(i);
    // Collision between mothership bullets and orion
    if (orion.checkCollisionOrionDefenderObject(b.getX(), b.getY(), b.getWidth(), b.getHeight())) {
      orion.takeDamageOrionDefender();
      bulletImpact.play();
      mothership.getBullets().remove(i);
    }
  }
}

// Game state
void checkGameState() {
  // Orion 0 lives
  if (orion.getLives() <= 0) {
    gameState = 1; // game over
  }
  // Mothership destroyed
  if (mothership.getHealth() <= 0) {
    gameState = 2; // victory
  }
}


// User interface
void displayHUD() {
  fill(255);
  textSize(16);
  textAlign(LEFT);
  text("LIVES: " + orion.getLives(), 10, 20);
  text("SCORE: " + orion.getScore(), 10, 40);
  text("MOTHERSHIP HP: " + mothership.getHealth(), 10, 60);
}

// Game over, you win
void displayGameOver() {
  background(0);
  textSize(32);
  textAlign(CENTER);
  
  if (gameState == 1) {
    fill(255, 0, 0);
    text("GAME OVER", width/2, height/2);
    textSize(24);
    text("FINAL SCORE: " + orion.getScore(), width/2, height/2 + 40);
  } else if (gameState == 2) {
    fill(0, 255, 0);
    text("¡YOU WIN!", width/2, height/2);
    textSize(24);
    text("FINAL SCORE: " + orion.getScore(), width/2, height/2 + 40);
  }
}

void readSerialData() {
  while (myPort.available() > 0) { // Mientras haya datos disponibles
    char comando = myPort.readChar();  // Leer un carácter
    
    // Mapeo de comandos de la FPGA a las acciones del juego
    if (comando == 'L') {
      moveLeft = true;
      moveRight = false;
    } else if (comando == 'R') {
      moveRight = true;
      moveLeft = false;
    } else if (comando == 'S') {
      shooting = true;
      orion.shootOrionDefender();  // Disparar
    }
  }
}


// Función que se ejecuta cuando se suelta una tecla
void keyReleased() {
  if (keyCode == LEFT) {
    moveLeft = false;
  }
  if (keyCode == RIGHT) {
    moveRight = false;
  }
  if (key == ' ') {
    shooting = false;
  }
}
