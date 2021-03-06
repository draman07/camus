class PowerUp extends Elemento {
  float my;
  int frame, t;
  PowerUp(int x, int y, int t) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    this.t = t;
    w = 32;
    h = 17;
    eliminar = false;
    puntos = false;
  }
  void act() {
    if (frameCount%15 == 0) frame++;
    frame %= 2;
    my = cos(((frameCount%120)/120.)*TWO_PI)*8-4;
  }
  void dibujar() {
    image(sprites_powerups[frame+t*2][0], x-w/2, y-h/2+my);
  }

  boolean colisiona(Jugador ju) {
    if(eliminar) return false;
    if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y, w, h)) {
      switch(t) {
      case 0:
        sonido.ladybug.trigger();
        ju.vida += 0.2;
        if (ju.vida > 1) ju.vida = 1;
        break;
      case 1:
        sonido.spider.trigger();
        ju.invisibilidad += 0.2;
        if (ju.invisibilidad > 1) ju.invisibilidad = 1;
        break;
      case 2:
        sonido.beatle.trigger();
        ui.maScore(100);
        break;
      case 3:
        sonido.firefly.trigger();
        ju.inmuneTime += 60*5;
        ju.inmune = true;
        break;
      }
      ui.powers++;
      eliminar = true;
      return true;
    }
    return false;
  }
}
