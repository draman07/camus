class Trampa extends Elemento {
}

class Spike extends Trampa {
  int frame;
  Spike(int x, int y) {
    this.x = x; 
    this.y = y; 
    w = h = 16;
    puntos = false;
  }
  void act() {
    if (frameCount%5 == 0) {
      frame++;
      frame %= 4;
    }
  }
  void dibujar() {
    image(img_tiles[6+frame][0], x-w/2, y-h/2);
  }
}

class Plant extends Trampa {
  int frame;
  float velx, vely, vel;
  Plant(int x, int y) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = h = 32;
    vel = 0.5; 
    puntos = true;
    p1 = new Punto(x, y);
    p2 = new Punto(x, y-100);
    obj = new Punto(p2.x, p2.y);
  }
  Plant(int x, int y, int p1x, int p1y, int p2x, int p2y) {
    this.x = x; 
    this.y = y;
    w = h = 32;
    vel = 0.5; 
    puntos = true;
    p1 = new Punto(p1x, p1y);
    p2 = new Punto(p2x, p2y);
    obj = new Punto(p2.x, p2.y);
  }  
  void act() {
    frame++;
    frame %= 20;
    float ang = atan2(obj.y-y, obj.x-x);
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    x += velx;
    y += vely;

    if (dist(x, y, obj.x, obj.y) < vel) {
      if (dist(p1.x, p1.y, obj.x, obj.y) < vel) {
        obj.x = p2.x;
        obj.y = p2.y;
      }
      else if (dist(p2.x, p2.y, obj.x, obj.y) < vel) {
        obj.x = p1.x;
        obj.y = p1.y;
      }
    }
  }
  void dibujar() {
    float dis = abs(p1.y-y);
    if (p1.y < p2.y) {
      for (int i = 0; i < dis; i+=10) {
        image(sprites_plants[10][0], p1.x-w/2, p1.y-h/2+i-11);
      }
      image(voltear(sprites_plants[frame%10][frame/10]), x-w/2, y-h/2);
      /*
      fill(255, 0, 0, 80);
      rectMode(CENTER);
      rect(x, y-dis/2-h/2, w/2-4, dis);
      rect(x, y-5, w-6, h-10);
      rectMode(CORNER);*/
    }
    else {
      for (int i = 0; i < dis; i+=10) {
        image(sprites_plants[10][0], p1.x-w/2, p1.y-h/2-i+11);
      }
      image(sprites_plants[frame%10][frame/10], x-w/2, y-h/2);
      /*
      fill(255, 0, 0, 80);
      rectMode(CENTER);
      rect(x, y+dis/2+h/2, w/2-4, dis);
      rect(x, y+5, w-6, h-10);
      rectMode(CORNER);*/
    }
  }
  boolean colisiona(Jugador ju) {
    float dis = abs(p1.y-y);
    /*
    rectMode(CENTER);
     rect(x, y+dis/2+h/2, w/2, dis);
     rectMode(CORNER);
     */
    if (p1.y < p2.y) {
      if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y-dis/2-h/2, w/2-4, dis)) {
        return true;
      }
      if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y-5, w-6, h-10)) {
        return true;
      }
    }
    else {
      if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y+dis/2+h/2, w/2-4, dis)) {
        return true;
      }
      if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y+5, w-6, h-10)) {
        return true;
      }
    }
    return false;
  }
}
