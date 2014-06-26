class Key { 
  boolean press, click, release;
  int clickCount;
  void act() {
    if (!focused) release();
    click = release = false;
    if (press) clickCount++;
  }
  void press() {
    if (!press) {
      click = true; 
      press = true;
      clickCount = 0;
    }
  }
  void release() {
    release = true;
    press = false;
  }
  void event(boolean estado) {
    if (estado) press();
    else release();
  }
}

class Input {
  boolean click, dclick, press, released, kclick, kpress, kreleased;
  int amouseX, amouseY;
  int pressCount, mouseWheel, timepress;
  Key SALTAR, IZQUIERDA, DERECHA, ABAJO, REINICIAR, INVISIBLE, EDITAR, ELIMINAR, PAUSA;
  Key CONTROL, ENTER, BACKSPACE; 
  Input() {
    click = dclick = released = press = false;
    kclick = kreleased = kpress = false;
    pressCount = 0;

    SALTAR = new Key();
    IZQUIERDA = new Key();
    ABAJO = new Key();
    DERECHA = new Key();
    REINICIAR = new Key();
    INVISIBLE = new Key();
    EDITAR = new Key();
    ELIMINAR = new Key();
    PAUSA = new Key();
    CONTROL = new Key();
    ENTER = new Key();
    BACKSPACE = new Key();
  }
  void act() {
    mouseWheel = 0;
    if (press) {
      pressCount++;
    }
    click = dclick = released = false;
    kclick = kreleased = false;

    SALTAR.act();
    IZQUIERDA.act();
    ABAJO.act();
    DERECHA.act();
    REINICIAR.act();
    INVISIBLE.act();
    EDITAR.act();
    ELIMINAR.act();
    PAUSA.act();
    CONTROL.act();
    ENTER.act();
    BACKSPACE.act();
  }
  void mpress() {
    amouseX = mouseX;
    amouseY = mouseY;
    click = true;
    press = true;
  }
  void mreleased() {
    released= true;
    press = false;
    if (millis() - timepress < 400) dclick = true;
    timepress = millis();
  }

  void event(boolean estado) {
    if (estado) {
      kclick = true;
      kpress= true;
    }
    else {
      kreleased = true;
      press = false;
    }
    if (key == 'w' || key == 'W' || keyCode == UP) SALTAR.event(estado);
    if (key == 'a' || key == 'A' || keyCode == LEFT) IZQUIERDA.event(estado);
    if (key == 's' || key == 'S' || keyCode == DOWN) ABAJO.event(estado);
    if (key == 'd' || key == 'D' || keyCode == RIGHT) DERECHA.event(estado);
    if (key == 'r' || key == 'R') REINICIAR.event(estado);
    if (key == ' ') INVISIBLE.event(estado);
    if (key == 'e' || key == 'E') EDITAR.event(estado);
    if (keyCode == 127) ELIMINAR.event(estado);
    if (key == ESC) PAUSA.event(estado);
    if (keyCode == 17) CONTROL.event(estado);
    if (keyCode == 10) ENTER.event(estado);
    if (keyCode == 8) BACKSPACE.event(estado);
  }
}

class Scroll {
  boolean sobre, mover;
  float val, min_val, max_val, bor;
  int x, y, w, h;
  Scroll(int x, int y, int w, float bor, float min_val, float max_val, float val) {
    this.x = x; 
    this.y = y; 
    this.w = w;
    this.bor = bor; 
    this.val = val;
    this.min_val = min_val;
    this.max_val = max_val;
    h = 13;
  }
  void act() {
    if (dist(x+map(val, min_val, max_val, 0, w)+h/2, y+h/2, mouseX, mouseY) < 20||(mouseX >= x+bor && mouseX < x+w+bor && mouseY >= y && mouseY < y+h)) {
      sobre = true;
    }
    else {
      sobre = false;
    }  
    if (input.click && sobre) {
      mover = true;
    }
    if (input.released) {
      mover = false;
    }
    if (mover) {
      val = map(mouseX, x, x+w, min_val, max_val);
      val = constrain(val, min_val, max_val);
    }
    dibujar();
  }
  void dibujar() {
    image(img_barra, x, y);
    float dx = map(val, min_val, max_val, 0, w)-bor*2;
    float dy = -img_bbarra.height/2+img_barra.height/2;
    image(img_bbarra, x+dx, y+dy);
    fill(255,0,0, 80);
    //ellipse(x+map(val, min_val, max_val, 0, w)+h/2, y+h/2, 40, 40);
  }
}
