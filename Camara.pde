class Camara {
  float x, y;
  Camara(float x, float y) {
    this.x = x; 
    this.y = y;
  }
  void act() {
    translate(int(x), int(y));
  }
  void ira(float mx, float my) {
    x += (mx-x)/6;
    y += (my-y)/6;
  }
  void mover(float mx, float my) {
    x += mx;
    y += my;
  }
  void set(float mx, float my) {
    x = mx; 
    y = my;
  }
}
