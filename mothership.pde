// Mothership class
class Mothership {
  // Mothership attributes
  private float mothership_x, mothership_y;
  private float mothership_width, mothership_height;
  private ArrayList<Bullet> mothership_bullets;
  private ArrayList<Bomb> bombs;
  private ArrayList<Supply> supplies;
  private int health = 5000;
  
  private PImage mothershipSprite;
  private float visualWidth = 950;  // Ancho visual de la imagen
  private float visualHeight = 750;
  
  // Constructor
  Mothership(float mothership_x, float mothership_y, float mothership_width, float mothership_height) {
    this.mothership_x = mothership_x - mothership_width/2;
    this.mothership_y = mothership_y;
    this.mothership_width = mothership_width;
    this.mothership_height = mothership_height;
    this.mothership_bullets = new ArrayList<Bullet>();
    this.bombs = new ArrayList<Bomb>();
    this.supplies = new ArrayList<Supply>();
    
    this.mothershipSprite = loadImage("mothership.png");

  }
  
  // Spawn objects probability
  void spawnObject() {
    if (random(1) < 0.05) spawnBomb();
    if (random(1) < 0.04) spawnSupply();  
    if (random(1) < 0.03) shootMothership();
  }
  
  // Shoot for Mothership
  void shootMothership() {
    float x = mothership_x + random(mothership_width);
    mothership_bullets.add(new Bullet(x, mothership_y + mothership_height, 5, 10, 8, 24, 2));
    
    mothershipShotSound.play();
  }
  
  // Spawn bomb
  void spawnBomb() {
    float x = mothership_x + random(mothership_width);
    bombs.add(new Bomb(x, mothership_y + mothership_height, 3, 75, 20));
  }
  
  // Spawn supply
  void spawnSupply() {
    float x = mothership_x + random(mothership_width);
    float r = random(1);
    int type;
    
    // propability of spawn by type
    if (r < 0.5){
      // 50% extra point
      type = 3;
    } else if(r < 0.8) {
      // 30% velocity
      type = 2;
    } else {
      // 20% damage
      type = 1;
    }
   
    supplies.add(new Supply(x, mothership_y + mothership_height, 2, 50, 40, type));
  }
  
  // Take damage
  void takeDamageMothership(int damage) {
    health = max(0, health - damage);
  }
  
  // Display Mothership skin
  void displayMothership() {
    float setCenterX = (mothership_width - visualWidth) / 2; // Centrar horizontalmente
    float setCenterY = (mothership_height - visualHeight) / 2; // Centrar verticalmente
    image(mothershipSprite, mothership_x + setCenterX, mothership_y + setCenterY, visualWidth, visualHeight);
  }
  
  // Getters
  ArrayList<Bullet> getBullets() {
    return mothership_bullets;
  }
  
  ArrayList<Bomb> getBombs() {
    return bombs;
  }
  
  ArrayList<Supply> getSupplies() {
    return supplies;
  }
  int getHealth() {
    return health;
  }
  
  float getY() { return mothership_y; }
  float getHeight() { return mothership_height; }
}
