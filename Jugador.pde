class Jugador {
  boolean inmune, invisible, mover, salto, agachadito, alentizar;
  int dir, frame, inmuneTime, cant_sal, max_sal;
  float x, y, antx, anty, w, h, velx, vely, acey, vida, invisibilidad;
  Jugador(float x, float y) {
    this.x = x; 
    this.y = y;
    w = 32; 
    h = 32;
    velx = 4; 
    vely = 0;
    acey = 1;
    vida = 1;
    invisibilidad = 1;
    inmune = true;
    inmuneTime = 0;
    salto = false;
    agachadito = false;
    cant_sal = 0;
    max_sal = 2;
  } 
  void act() {
    if (inmune) inmuneTime -= 1;
    if (inmuneTime <= 0) inmune = false;
    if (!invisible && invisibilidad < 1) invisibilidad += 0.001;
    if (invisible) invisibilidad -= 0.002;
    if (invisibilidad <= 0) invisible = false;
    mover = false;
    if (input.ABAJO.click) {
      w = 56; 
      h = 24;
      if (!agachadito && !nivel.colisiona(this)) {
        y += 4;
        velx = 2;
        agachadito = true;
      }
      else {
        w = 32; 
        h = 32;
      }
    }
    if (input.ABAJO.release) {
      w = 32; 
      h = 32;
      if (agachadito) {
        y -= 8;
        velx = 4;
        x = int(x)-int(x%4);
        agachadito = false;
      }
    }
    antx = x; 
    anty = y;
    if (input.IZQUIERDA.press) {
      mover = true;
      dir = 1;
      x -= velx;
    }
    if (input.DERECHA.press) {
      mover = true;
      dir = 0;
      x += velx;
    }
    if (nivel.colisiona(this)) {
      x = antx;
    }
    else {
      Plataforma aux = nivel.colisionPlataforma(); 
      if (aux != null) {
        x = antx;
      }
      y += 1;
      aux = nivel.colisionPlataforma(); 
      if (aux != null) {
        x += aux.velx;
      }
      y -= 1;
    }
    if (input.SALTAR.click && cant_sal < max_sal) {
      salto = true;
      cant_sal++;
      vely = -18;
    }
    if (alentizar) acey = 0.05;
    else acey = 1;
    vely += acey; 
    //if(vely > 16) vely = 16;
    y += vely;
    if (nivel.colisiona(this)) {
      y = anty;
      salto = false;
      if (vely > 0) {
        cant_sal = 0;
      }
      vely = 0;
    }
    else {
      /*
      Plataforma aux = nivel.colisionPlataforma(); 
       if (aux != null) {
       y += aux.vely;
       y = anty;
       salto = false;
       vely = 0;
       }*/
      Plataforma aux = nivel.colisionPlataforma(); 
      if (aux != null) {
        y += aux.vely;
        y = anty;
        salto = false;
        if (vely > 0) {
          cant_sal = 0;
        }
        vely = 0;
      }
      x += 1;
      aux = nivel.colisionPlataforma(); 
      if (aux != null) {
        y += aux.vely;
      }
      x -= 1;
    }
    //animacion
    if (agachadito) {
      if (!mover) {
        frame = 20;
      }
      else if (x != antx) {
        if (frameCount%4 == 0) frame+=2; 
        if (frame < 20 || frame >= 36) frame = 20;
      }
    }
    else {
      if (y != anty) {
        if (frameCount%6 == 0) frame++;
        if (frame < 12 || frame >= 16) frame = 12;
        /*
      if (vely > 0) frame = 3;
         else frame = 4;*/
      }
      else if (x != antx && mover) {
        if (frameCount%2 == 0) frame++;
        if (frame < 4 || frame >= 12) frame = 4;
      }
      else {
        if (frameCount%16 == 0) frame++;
        if (frame >= 4) frame = 0;
      }
    }
    for (int i = 0;i < nivel.powerups.size(); i++) {
      PowerUp es = nivel.powerups.get(i);
      es.colisiona(this);
    }
    for (int i = 0;i < nivel.enemigos.size(); i++) {
      Enemigo pr = nivel.enemigos.get(i);
      pr.dano(this);
    }    
    for (int i = 0;i < nivel.trampas.size(); i++) {
      Trampa t = nivel.trampas.get(i);
      if (t instanceof Spike) {
        if (t.colisiona(this) && !inmune) {
          dano(0.2);
          break;
        }
      }
      if (t instanceof Plant) {
        if (t.colisiona(this) && !inmune) {
          dano(0.2);
          break;
        }
      }
    }
    if (input.INVISIBLE.click) {
      invisible = !invisible;
    }
    if (vida <= 0) {
      ui.cant_vidas--;
      nivel.iniciar();
    }
  }
  void dibujar() {
    if (inmune && inmuneTime%12 < 6) return;
    if (agachadito) {
      if (dir == 0) {
        image(sprites_leon[frame%4][frame/4], x-35, y-h/2-12);
        image(sprites_leon[frame%4+1][frame/4], x, y-h/2-12);
      }
      else {
        image(espejar(sprites_leon[frame%4+1][frame/4]), x-35, y-h/2-10); 
        image(espejar(sprites_leon[frame%4][frame/4]), x, y-h/2-10);
      }
    }
    else {
      if (dir == 0)
        image(sprites_leon[frame%4][frame/4], x-w/2-2, y-h/2-2);
      else
        image(espejar(sprites_leon[frame%4][frame/4]), x-w/2-1, y-h/2-2);
    }
    /*
    fill(255, 0, 0, 120);
     rect(x-w/2, y-h/2, w, h);*/
  }
  void dano(float d) {
    if (inmune) return;
    inmuneTime = 30;
    inmune = true;
    this.vida -= d;
  }
}
