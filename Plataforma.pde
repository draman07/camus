class Plataforma extends Elemento {
  boolean traspasable;
  float vel, velx, vely;
  Plataforma(int x, int y, int w, int h) {
    this.x = x;//+w/2; 
    this.y = y;//y+h/2; 
    this.w = w;
    this.h = h;
    traspasable = false;
    p1 = p2 = obj = null;
    estatico = true;
  }
  Plataforma(int x, int y, int w, int h, int px1, int py1, int px2, int py2) {
    this(x, y, w, h);
    estatico = false;
    traspasable = false;
    p1 = new Punto(px1, py1);
    p2 = new Punto(px2, py2);
    obj = new Punto(px1, py1);
    vel = 1;
  }
  void act() {
    if (!estatico) {
      float ang = atan2(obj.y-y, obj.x-x);
      velx = cos(ang)*vel;
      vely = sin(ang)*vel;
      x += velx;
      y += vely;

      if (dist(x, y, obj.x, obj.y) < vel) {
        if (obj.x == p1.x && obj.y == p1.y) {
          obj.x = p2.x;
          obj.y = p2.y;
        }
        else if (obj.y == p2.y && obj.y == p2.y) {
          obj.x = p1.x;
          obj.y = p1.y;
        }
      }
    }
  }
  void dibujar() {
    for (int j = 0; j< h/16; j++) {
      for (int i = 0; i < w/16; i++) {
        int dx = 0;
        if (i == 0) dx = -1;
        if (i == w/16-1) dx = 1;
        image(img_tiles[7+dx][3], x-w/2+16*i, y-h/2+16*j);
      }
    }
  }
  boolean colisiona(Jugador ju) {
    if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y, w, h)) {
      if (ju.y != ju.anty && false) {
        //if (abs(velx) > abs(vely) || colisionRect(ju.x, ju.anty, ju.w, ju.h, x, y, w, h)) return false;
        if (abs(velx) > abs(vely)) {
          //if (colisionRect(ju.x, ju.anty, ju.w, ju.h, x, y, w, h)) return false;
        }
        else {
          //print(frameCount, ju.y, y, " ");
          ju.y += vely;
          ju.y = 0;//round(ju.y);
          if (vely >= 0) { 
            //println("vertical baja");
          }
          else {        
            //println("vertical sube");
          }
        }
        /*
        if (!estatico) {
         ju.x += velx;
         ju.y += vely;
         }*/
        /*
      if (traspasable) {
         if (abs(vely) > abs(velx) || colisionRect(ju.x, ju.anty, ju.w, ju.h, x, y, w, h)) return false;
         if (ju.vely < 0 || input.ABAJO.press) {
         return false;
         }
         }
         */
      }
      return true;
    }
    return false;
  }
}


class Punto {
  float x, y; 
  Punto(float x, float y) {
    this.x = x; 
    this.y = y;
  }
}
