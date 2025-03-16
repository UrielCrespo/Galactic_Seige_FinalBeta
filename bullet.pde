// Bullet Class
class Bullet {
  // Bullet Attributes
  private float bullet_x, bullet_y;
  private float bullet_speed;
  private int bullet_damage;
  private float bullet_width, bullet_height;
  private int bullet_type;
  
  private PImage motherBullet;
  private float visualWidthMother = 25;  // Ancho visual de la imagen
  private float visualHeightMother = 50;
  
  private PImage orionBullet;
  private float visualWidthOrion = 40;  // Ancho visual de la imagen
  private float visualHeightOrion = 40;
   
  // Constructor
  Bullet(float bullet_x, float bullet_y, float bullet_speed, int bullet_damage, float bullet_width, float bullet_height, int bullet_type) {
    this.bullet_x = bullet_x;
    this.bullet_y = bullet_y;
    this.bullet_speed = bullet_speed;
    this.bullet_damage = bullet_damage;
   
    // Mothership bullet
    if (bullet_type == 2) {
        this.bullet_width = visualWidthMother;  
        this.bullet_height = visualHeightMother;
        this.motherBullet = loadImage("motherBullet.png");
    } else {
     // OrionDefender Bullet
        this.bullet_width = bullet_width;
        this.bullet_height = bullet_height;
        this.orionBullet = loadImage("bullet.png");
    }
   
        this.bullet_type = bullet_type;
  }
  
  // Orion and Mothership bullet movement 
  boolean moveBullet() {
    if (bullet_type == 1) {
      // Orion bullet moving up
      bullet_y -= bullet_speed;
    } else if (bullet_type == 2) {
      // Mothership bullet moving down
      bullet_y += bullet_speed;
    }
     
    // Check if the bullets are in the screen
    if (bullet_y < 0 || bullet_y > height) {
      return false; 
    } else {
      return true;  
    }
  }
  
  // Display Orion and Mothership bullet skin
  void displayBullet() {
    // Orion bullet skin
    if (bullet_type == 1) {
      image(orionBullet, bullet_x, bullet_y, visualWidthOrion, visualHeightOrion);
    // Mothership bullet skin
    } else if (bullet_type == 2) {
      image(motherBullet, bullet_x, bullet_y, visualWidthMother, visualHeightMother);
    }
  }
  
  // Collision between bullet and bomb (BBAA collition detection)
  boolean collidesBulletWithBomb(Bomb bomb) {
    if (bullet_x < bomb.getX() + bomb.getWidth() &&  // side to side 1
        bullet_x + bullet_width > bomb.getX() &&     // side to side 2
        bullet_y < bomb.getY() + bomb.getHeight() && // up to down 3
        bullet_y + bullet_height > bomb.getY()) {    // up to down 4
        bombSound.play();
      return true;
    } else {
      return false;
    }
  }
  
  // getters
  float getX() {
    return bullet_x;
  }
  
  float getY() {
    return bullet_y;
  }
  
  float getWidth() {
    return bullet_width;
  }
  
  float getHeight() {
    return bullet_height;
  }
  
  int getType() {
    return bullet_type;
  }
  
  int getDamage() {
    return bullet_damage;
  }
 
}
