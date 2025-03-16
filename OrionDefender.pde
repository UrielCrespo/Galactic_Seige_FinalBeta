// Orion defender class
class OrionDefender {
  // Orion defender attributes
  private float orion_x, orion_y;
  private float orion_width, orion_height;
  private float orion_speed;
  private ArrayList<Bullet> orion_bullets;
  private int orion_lives;
  private int orion_score;
  
  // default bullet
  private float orionBulletSpeed = 5;
  private int orionBulletDamage = 10;
  private final float orionBulletWidth = 10;
  private final float orionBulletHeight = 20;
  
  private PImage orionSprite;
  private float visualWidth = 150;  // Ancho visual de la imagen
  private float visualHeight = 150;

  // Constructor
  OrionDefender(float orion_x, float orion_y, float orion_width, float orion_height, float orion_speed) {
    this.orion_x = orion_x;
    this.orion_y = orion_y;
    this.orion_width = orion_width;
    this.orion_height = orion_height;
    this.orion_speed = orion_speed;
    this.orion_bullets = new ArrayList<Bullet>();
    this.orion_lives = 3;
    this.orion_score = 0;
    
    this.orionSprite = loadImage("orionSkin.png");
  }
  
  // Display Orion Defender skin
  void displayOrionDefender() {
    float setCenterX = (orion_width - visualWidth) / 2; // Centrar horizontalmente
    float setCenterY = (orion_height - visualHeight) / 2; // Centrar verticalmente
    image(orionSprite, orion_x + setCenterX, orion_y + setCenterY, visualWidth, visualHeight);
  }

  // Move left right orion defender
  void moveOrionDefender(boolean moveLeft, boolean moveRight) {
    if (moveLeft && orion_x > 0) {
      orion_x -= orion_speed;
    }
    if (moveRight && orion_x + orion_width < width) {
      orion_x += orion_speed;
    }
  }
  
  // Shoot orion defender doble canion
  void shootOrionDefender() {
    Bullet bulletLeft = new Bullet(orion_x - 32, orion_y, orionBulletSpeed, orionBulletDamage, orionBulletWidth, orionBulletHeight, 1);
    Bullet bulletRight = new Bullet(orion_x + orion_width -8, orion_y, orionBulletSpeed, orionBulletDamage, orionBulletWidth, orionBulletHeight, 1);
    orion_bullets.add(bulletLeft);
    orion_bullets.add(bulletRight);
    
    shotSound.play();
  }
  
  // Collect supply by type
  void collectSupply(int upgradeType) {
    final int DAMAGE_UPGRADE = 5;
    final float SPEED_UPGRADE = 2.0;
    final int POINTS_BASE = 10;
    final int POINTS_EXTRA = 15;
  
    orion_score += POINTS_BASE;
  
    if (upgradeType == 1) {
      upgradeBulletDamage(DAMAGE_UPGRADE); 
    } else if (upgradeType == 2) {
      upgradeBulletSpeed(SPEED_UPGRADE);  
    } else if (upgradeType == 3) { 
      orion_score += POINTS_EXTRA;
    }
  }
 
 // check collision with any object (BBAA)
  boolean checkCollisionOrionDefenderObject(float x, float y, float w, float h) {
     return (orion_x < x + w &&
             orion_x + orion_width > x &&
             orion_y < y + h &&
             orion_y + orion_height > y);
  }

  // Getters
  ArrayList<Bullet> getBullets() { 
    return orion_bullets; 
  }
  
  int getLives() {
    return orion_lives; 
  }
  
  int getScore() {
    return orion_score;
  }
  
  // take damage
  void takeDamageOrionDefender() {
    orion_lives--; 
  }
  
  // bullet boosters
  void upgradeBulletDamage(int additionalDamage) {
    orionBulletDamage += additionalDamage;
  }

  void upgradeBulletSpeed(float additionalSpeed) {
    orionBulletSpeed += additionalSpeed;
  } 
}
