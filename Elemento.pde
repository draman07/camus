class Elemento {
  boolean eliminar, mover, sel, puntos;
  float x, y, w, h, dy;
  Punto p1, p2, obj, ini;
  void act() {
  }
  void dibujar() {
  }
  void dibujarSeleccion() {
    if (!sel) return;
    noFill();
    stroke(0, 255, 0);
    rect(x-w/2, y-h/2+dy, w, h);
    if (puntos && p1 != null &&  p2 != null) {
      line(p1.x, p1.y, p2.x, p2.y);
      ellipse(p1.x, p1.y, 6, 6); 
      ellipse(p2.x, p2.y, 6, 6);
      fill(0,255,0);
      text("p1", p1.x+10, p1.y);
      text("p2", p2.x+10, p2.y);
    }
  }
  boolean sobre(int cx, int cy) {
    if (cx >= x-w/2 && cx < x+w/2 && cy >= y-h/2+dy && cy < y+h/2+dy) {
      return true;
    }
    if (puntos && p1 != null && p2 != null) {
      if (dist(p1.x, p1.y, cx, cy) <= 3) {
        return true;
      }
      if (dist(p2.x, p2.y, cx, cy) <= 3) {
        return true;
      }
    }
    return false;
  }
  boolean seleccionar(int x1, int y1, int x2, int y2) {
    if (x1 == x2 && y1 == y2) {
      return seleccionar(x1, y1);
    }
    int ax = max(x1, x2);
    int ay = max(y1, y2);
    x1 = min(x1, x2);
    y1 = min(y1, y2);
    x2 = ax;
    y2 = ay;
    int w2 = x2-x1;
    int h2 = y2-y1;
    sel = colisionRect(x, y+dy, w, h, x1+w2/2, y1+h2/2, w2, h2);
    return sel;
  }
  boolean seleccionar(int cx, int cy) {
    if (sobre(cx, cy)) sel = true; 
    else sel = false;
    return sel;
  }
  boolean colisiona(Jugador ju) {
    if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y, w, h)) {
      return true;
    }
    return false;
  }
  void mover(int x, int y) {
    float mx = mouseX-camara.x;
    float my = mouseY-camara.y;
    if (puntos && p1 != null && p2 != null && !input.CONTROL.press) {
      if (dist(p1.x, p1.y, mx, my) <= 4 || dist(p1.x+x, p1.y+y, mx, my) <= 4) {
        p1.x += x;
        p1.y += y;
        return;
      }
      if (dist(p2.x, p2.y, mx, my) <= 4  || dist(p2.x+x, p2.y+y, mx, my) <= 4) {
        p2.x += x;
        p2.y += y;
        return;
      }
      p1.x += x;
      p1.y += y;
      p2.x += x;
      p2.y += y;
    }
    this.x += x;
    this.y += y;
    this.ini.x = x;
    this.ini.y = y;
  }
}
