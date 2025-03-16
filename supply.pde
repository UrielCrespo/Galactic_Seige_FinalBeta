// Supply class
class Supply{
  // Supply attributes
  private float supply_x, supply_y;
  private float supply_speed;
  private float supply_width, supply_height;
  private int supply_type;
  
  private PImage supplyG;
  private float visualWidthSupplyG = 50;  // Ancho visual de la imagen
  private float visualHeightSupplyG = 50;
  
  private PImage supplyD;
  
  private PImage supplyV;


  
  // Constructor
  Supply(float supply_x, float supply_y, float supply_speed, float supply_width, float supply_height, int supply_type){
  this.supply_x = supply_x;
  this.supply_y = supply_y;
  this.supply_speed = supply_speed;
  this.supply_width = supply_width;
  this.supply_height = supply_height;
  this.supply_type = supply_type;
  
  this.supplyG = loadImage("pointsG.png");
  this.supplyD = loadImage("newSupply.jpg");
  this.supplyV = loadImage("velocityBooster.png");



  }
  
  // Move down supply
  void moveDownSupply() {
    supply_y += supply_speed;
  }
  
  // Display supplies skins
  void displaySupply(){
    noStroke();
    // Damage supply skin
    if (supply_type == 1) {
      image(supplyD, supply_x, supply_y, visualWidthSupplyG, visualHeightSupplyG); 
    // Speed supply skin
    } else if (supply_type == 2) {
      fill(0, 0, 255); 
      image(supplyV, supply_x, supply_y, visualWidthSupplyG, visualHeightSupplyG);
      // Extra points supply skin
    } else if (supply_type == 3){
      image(supplyG, supply_x, supply_y, visualWidthSupplyG, visualHeightSupplyG);
     
    }
  
  }
  
  // Is off screen supply?
  boolean isOffScreenSupply() {
  return (supply_y > height); 
  }
  
  //getters
  float getX() {
    return supply_x;
  }
  
  float getY() {
    return supply_y;
  }
  
  float getWidth() {
    return supply_width; 
  }
  
  float getHeight() {
    return supply_height;
  }
  
  int getType() {
    return supply_type; 
  }
}
