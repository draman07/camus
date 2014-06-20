class Enemigo extends Elemento { //<>// //<>// //<>//
  float dano = 0.1;
  void dano(Jugador j) {
    if (eliminar) return;
    if (colisiona(j) && !j.inmune && !j.invisible) {
      if (this instanceof Huevo) eliminar = true;
      ui.score -= 250;
      j.dano(dano);
    }
  }
}

class Mouse extends Enemigo {
  int frame;
  float vel, velx, vely;
  Mouse(int x, int y) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = 21;
    h = 11;
    p1 = null;
    p2 = null;
    vel = 1;
    velx = vel;
    vely = 0;
    puntos = false;
  }
  void act() {
    if (frameCount%6 == 0) frame++;
    frame %= 4;
    float antx = x; 
    float anty = y;
    x += velx;
    if (nivel.colisiona(this)) {
      velx *= -1;
      x = antx;
    }
    vely += 1;
    y += vely;
    if (nivel.colisiona(this)) {
      y = anty;
      vely = 0;
    }
  }
  void dibujar() {
    int dir = 0;
    if (velx < 0) dir = 1;
    if (dir == 0) {
      image(sprites_mouse[frame][0], x-w/2, y-h/2);
    } else {
      image(espejar(sprites_mouse[frame][0]), x-w/2, y-h/2);
    }
  }
  boolean colisiona(Jugador ju) {
    if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y+3, w, h-6)) {
      return true;
    }
    return false;
  }
}

class Dove extends Enemigo {
  boolean posarse;
  int frame, tposarse, alturaMax;
  float vel, velx, vely;
  Dove(int x, int y, int px1, int py1, int px2, int py2) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = h = 16;
    alturaMax = tam*2;
    p1 = new Punto(px1, py1);
    p2 = new Punto(px2, py2);
    obj = new Punto(px1, py1);
    float ang = atan2(obj.y-y, obj.x-x);
    vel = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    puntos = true;
  }
  void act() {
    if (posarse) {
      if (frameCount%6 == 0) { 
        frame++;
        frame = (frame%2)+3;
      }
      tposarse--;
      if (tposarse <= 0) posarse = false;
    } else {
      if (frameCount%6 == 0) frame++;
      frame %= 3;
      float ang = atan2(obj.y-y, obj.x-x);
      velx = cos(ang)*vel;
      vely = sin(ang)*vel;
      x += velx;
      y += vely;
    }
    float dis = min(dist(x, y, p1.x, p1.y), dist(x, y, p2.x, p2.y));
    if (dis < alturaMax) {
      dy = -dis*cos(map(dis, alturaMax, 0, 0, PI/2));
    } else {
      dy = -alturaMax;
    }
    if (dist(x, y, obj.x, obj.y) < vel) {
      posarse = true;
      tposarse = 80;
      if (dist(p1.x, p1.y, obj.x, obj.y) < vel) {
        obj.x = p2.x;
        obj.y = p2.y;
      } else if (dist(p2.x, p2.y, obj.x, obj.y) < vel) {
        obj.x = p1.x;
        obj.y = p1.y;
      }
    }
  }
  void dibujar() {
    int dir = 0;
    if (velx < 0) dir = 1;
    if (dir == 0) image(sprites_dove[frame][0], x-w/2, y-h/2+dy);
    else image(espejar(sprites_dove[frame][0]), x-w/2, y-h/2+dy);
    /*
    fill(255, 0, 0, 120);
     rect(x-w/2, y-h/2+dy, w, h);
     */
  }
  boolean colisiona(Jugador ju) {
    if (colisionRect(ju.x, ju.y, ju.w, ju.h, x, y+dy, w, h)) {
      return true;
    }
    return false;
  }
}

class Serpent extends Enemigo { 
  int frame;
  float vel, velx, vely;
  Serpent(int x, int y, int px1, int py1, int px2, int py2) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = 32;
    h = 8;
    p1 = new Punto(px1, py1);
    p2 = new Punto(px2, py2);
    obj = new Punto(px1, py1);
    float ang = atan2(obj.y-y, obj.x-x);
    vel = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    puntos = true;
  }
  void act() {
    if (frameCount%6 == 0) frame++;
    frame %= 5;
    float antx = x; 
    float anty = y;
    float ang = atan2(obj.y-y, obj.x-x);
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    x += velx;
    y += vely;

    if (dist(x, y, obj.x, obj.y) < vel) {
      if (dist(p1.x, p1.y, obj.x, obj.y) < vel) {
        obj.x = p2.x;
        obj.y = p2.y;
      } else if (dist(p2.x, p2.y, obj.x, obj.y) < vel) {
        obj.x = p1.x;
        obj.y = p1.y;
      }
    }
  }
  void dibujar() {
    int dir = 0;
    if (velx < 0) dir = 1;
    if (dir == 0) image(sprites_serpent[frame][0], x-w/2, y-h/2);
    else image(espejar(sprites_serpent[frame][0]), x-w/2, y-h/2);
  }
}

class Rat extends Enemigo {
  boolean seguir, salto;
  int frame, dir, tiempo_reposo;
  float vel, velx, vely, max_dis;
  Rat(int x, int y) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = h = 33;
    p1 = null;
    p2 = null;
    obj = new Punto(x, y);
    float ang = atan2(obj.y-y, obj.x-x);
    vel = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    max_dis = 250;
    seguir = false;
    puntos = false;
    tiempo_reposo = 0;
  }
  void act() {
    obj = new Punto(nivel.jugador.x, nivel.jugador.y);
    float dis = dist(obj.x, obj.y, x, y);
    if (dis < max_dis && !nivel.jugador.invisible) {
      if (!seguir && ((dir == 0 && x-obj.x < 0) || (dir == 1 && x-obj.x > 0) || dis < max_dis*0.25)) {
        seguir = true;
      }
    } else {
      seguir = false;
    }
    if (seguir) {
      if (obj.x-(x-10) < 0) {
        velx = -vel;
      } else if (obj.x-(x+10) > 0) {
        velx = vel;
      }
      dir = 0;
      if (velx < 0) dir = 1;
    } else {
      velx = 0;
      tiempo_reposo++;
      dir = (tiempo_reposo/180)%2;
      if (seguir) { 
        tiempo_reposo = 0;
        seguir = false;
      }
    }

    float antx = x; 
    float anty = y;
    x += velx;
    if (nivel.colisiona(this)) {
      x = antx;
      if (!salto) {
        salto = true;
        vely = -16;
      }
    }

    vely += 1;
    y += vely;
    if (nivel.colisiona(this)) {
      y = anty;
      salto = false;
      if (vely > 0) {
        //cant_sal = 0;
      }
      vely = 0;
    }
    if (seguir) {
      if (frameCount%3 == 0) frame++;
      frame %= 8;
    } else {
      if (frameCount%8 == 0) frame++;
      frame = frame%2 + 8;
    }
  }
  void dibujar() {
    if (dir == 0) {
      image(sprites_rat[frame][0], x-w/2, y-h/2);
    } else {
      image(espejar(sprites_rat[frame][0]), x-w/2, y-h/2);
    }
  }
}

class Hawk extends Enemigo {
  int frame, tataque;
  float vel, velx, vely;
  String estado;
  Hawk(int x, int y, int px1, int py1, int px2, int py2) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = 60;
    h = 50;
    p1 = new Punto(px1, py1);
    p2 = new Punto(px2, py2);
    obj = new Punto(px1, py1);
    float ang = atan2(obj.y-y, obj.x-x);
    vel = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    puntos = true;
    estado = "normal";
    tataque = int(random(300, 600));
  }
  void act() {
    if (estado.equals("normal")) {
      if (frameCount%6 == 0) frame++;
      frame %= 10;
      float ang = atan2(obj.y-y, obj.x-x);
      velx = cos(ang)*vel;
      vely = sin(ang)*vel;
      x += velx;
      y += vely;
      if (dist(x, y, obj.x, obj.y) < vel) {
        vel = 1;
        if (dist(p1.x, p1.y, obj.x, obj.y) < vel) {
          obj.x = p2.x;
          obj.y = p2.y;
        } else if (dist(p2.x, p2.y, obj.x, obj.y) < vel) {
          obj.x = p1.x;
          obj.y = p1.y;
        }
      }
      tataque--;
      if (tataque < 0 && dist(x, y, nivel.jugador.x, nivel.jugador.y) < 280 && !nivel.jugador.invisible) {
        estado = "atacar";
        obj = new Punto(nivel.jugador.x, nivel.jugador.y);
      }
    } else if (estado.equals("atacar")) {
      vel = 6;
      if (frameCount%3 == 0) frame++;
      frame %= 10;
      float ang = atan2(obj.y-y, obj.x-x);
      velx = cos(ang)*vel;
      vely = sin(ang)*vel;
      x += velx;
      y += vely;
      if (dist(x, y, obj.x, obj.y) < vel) {
        tataque = int(random(300, 600));
        vel = 2;
        estado = "normal";
        if (dist(p1.x, p1.y, x, y) < dist(p2.x, p2.y, x, y)) { 
          obj.x = p1.x;
          obj.y = p1.y;
        } else {
          obj.x = p2.x;
          obj.y = p2.y;
        }
      }
    }
  }
  void dibujar() {
    int dir = 0;
    if (velx < 0) dir = 1;
    if (dir == 0) image(sprites_hawk[frame%2][frame/2], x-w/2, y-h/2);
    else image(espejar(sprites_hawk[frame%2][frame/2]), x-w/2, y-h/2);
  }
}

class Viper extends Enemigo {
  int dir, frame, ataquet;
  float vel, velx, vely, max_dis;
  String estado;
  Viper(int x, int y, int px1, int py1, int px2, int py2) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = 101;
    h = 35;
    p1 = new Punto(px1, py1);
    p2 = new Punto(px2, py2);
    obj = new Punto(px1, py1);
    float ang = atan2(obj.y-y, obj.x-x);
    vel = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    max_dis = 200;
    puntos = true;
    estado = "normal";
  }
  void act() {
    if (estado.equals("normal")) {
      if (frameCount%6 == 0) frame++;
      frame %= 8;
    }
    if (estado.equals("seguir")) {
      if (frameCount%3 == 0) frame++;
      frame %= 8;
    } else if (estado.equals("atacar")) {
      frame -= 8;
      if (frame < -1) frame = -1;
      if (frameCount%6 == 0) frame++;
      frame %= 5;
      frame += 8;
    }
    if (estado.equals("normal")) {
      vel = 1;
      if (obj.x-(x-10) < 0) {
        velx = -vel;
      } else if (obj.x-(x+10) > 0) {
        velx = vel;
      }
      x += velx;
      dir = 0;
      if (velx < 0) dir = 1;
      if (dist(x, y, obj.x, obj.y) < vel) {
        if (dist(p1.x, p1.y, obj.x, obj.y) < vel) {
          obj.x = p2.x;
          obj.y = p2.y;
        } else if (dist(p2.x, p2.y, obj.x, obj.y) < vel) {
          obj.x = p1.x;
          obj.y = p1.y;
        }
      }

      Punto jug = new Punto(nivel.jugador.x, nivel.jugador.y);
      float dis = dist(jug.x, jug.y, x, y);
      if (dis < max_dis && !nivel.jugador.invisible) {
        if ((dir == 0 && x-jug.x < 0) || (dir == 1 && x-jug.x > 0)) {
          obj = jug;
          estado = "seguir";
        }
      }
    } else if (estado.equals("seguir")) {
      vel = 4;
      if (obj.x-x < 0) {
        velx = -vel;
      } else if (obj.x-x > 0) {
        velx = vel;
      }
      x += velx;
      float dis = dist(obj.x, 0, x, 0);
      if (dis <= vel) {
        ataquet = 120;
        estado = "atacar";
      }
    } else if (estado.equals("atacar")) { 
      ataquet--;
      if (ataquet <= 0) {
        float d1 = dist(p1.x, p1.y, x, y);
        float d2 = dist(p2.x, p2.y, x, y);
        if (d1 < d2) {
          obj.x = p1.x;
          obj.y = p1.y;
        } else {
          obj.x = p2.x;
          obj.y = p2.y;
        }
        estado = "normal";
      }
    }
  }
  void dibujar() {
    if (dir == 0) image(sprites_viper[0][frame], x-w/2, y-h/2);
    else image(espejar(sprites_viper[0][frame]), x-w/2, y-h/2);
  }
}

class Wolf extends Enemigo {
  boolean salto;
  int frame, dir, tiempo_reposo;
  float vel, velx, vely, max_dis, dis_sal;
  String estado;
  Wolf(float x, float y) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = 114;
    h = 57;
    obj = new Punto(nivel.jugador.x, nivel.jugador.y);
    float ang = atan2(obj.y-y, obj.x-x);
    vel = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    max_dis = 300;
    dis_sal = 250;
    puntos = false;
    tiempo_reposo = 0;
    estado = "normal";
  }
  void act() {
    if (estado.equals("normal")) {
      frame = 0;
    } else if (estado.equals("seguir")) {
      if (frameCount%4 == 0) frame++;
      frame %= 12;
      if (frame > 0 && frame < 5) frame = 5;
    } else if (estado.equals("atacar")) {
      if (frameCount%4 == 0 && frame != 4) frame++;
      if (frame <= 0 || frame > 4) frame = 1;
    }
    float dis = dist(obj.x, obj.y, x, y);  
    tiempo_reposo--;
    if (!estado.equals("atacar") && !nivel.jugador.invisible) {
      obj = new Punto(nivel.jugador.x, nivel.jugador.y);
      if (dis < dis_sal && tiempo_reposo <= 0) {
        vel = 4;
        tiempo_reposo = 180;
        estado = "atacar";
      } else if (dis < max_dis) {
        vel = 1;
        estado = "seguir";
      }
      velx = vel;
      if (obj.x-x < 0) velx = -vel;
    }
    if (estado.equals("seguir")) {
      dir = 0;
      if (velx < 0) dir = 1;
      if (obj.x-(x-10) < 0) {
        velx = -vel;
      } else if (obj.x-(x+10) > 0) {
        velx = vel;
      }
    } else if (estado.equals("atacar")) {
      if (abs(obj.x-x) < vel) {
        estado = "normal";
      }
      if (frame == 3) {
        vely = -14;
      }
    }

    float antx = x; 
    float anty = y;
    if(estado.equals("normal")){
      x += velx;
      if (nivel.colisiona(this)) {
        x = antx;
        if (!salto) {
          salto = true;
          vely = -16;
        }
        if (estado.equals("atacar")) {
          estado = "seguir";
        }
      }
    }

    vely += 1;
    y += vely;
    if (nivel.colisiona(this)) {
      y = anty;
      salto = false;
      vely = 0;
    }
  }
  void dibujar() {
    if (dir == 0)
      image(sprites_wolf[frame%2][frame/2], x-w/2, y-h/2);
    else
      image(espejar(sprites_wolf[frame%2][frame/2]), x-w/2, y-h/2);
  }
}

class Vulture extends Enemigo {
  int dir, frame, cargarHuevo;
  float vel, velx, vely;
  Vulture(int x, int y, int px1, int py1, int px2, int py2) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = 93;
    h = 70;
    p1 = new Punto(px1, py1);
    p2 = new Punto(px2, py2);
    obj = new Punto(px1, py1);
    float ang = atan2(obj.y-y, obj.x-x);
    vel = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    puntos = true;
    cargarHuevo = 0;
  }
  void act() {
    if (frameCount%6 == 0) frame++;
    frame %= 3;
    float ang = atan2(obj.y-y, obj.x-x);
    dir = 0;
    if (velx < 0) dir = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    x += velx;
    y += vely;
    cargarHuevo++;
    if (abs(nivel.jugador.x-x) < w/8 && cargarHuevo > 80 && random(10) < 1) {
      Huevo h = new Huevo(x-6+12*dir, y+10);
      nivel.elementos.add(0, h); 
      nivel.enemigos.add(0, h);
      cargarHuevo = 0;
    }
    if (dist(x, y, obj.x, obj.y) < vel) {
      if (dist(p1.x, p1.y, obj.x, obj.y) < vel) {
        obj.x = p2.x;
        obj.y = p2.y;
      } else if (dist(p2.x, p2.y, obj.x, obj.y) < vel) {
        obj.x = p1.x;
        obj.y = p1.y;
      }
    }
  }
  void dibujar() {
    if (dir == 0) image(sprites_vulture[frame][0], x-w/2, y-h/2);
    else image(espejar(sprites_vulture[frame][0]), x-w/2, y-h/2);
  }
}

class Cobra extends Enemigo {
  boolean seguir, salto;
  int frame, dir, tiempo_reposo;
  float vel, velx, vely, max_dis;
  Cobra(float x, float y) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    w = 100;
    h = 50;
    obj = new Punto(x, y);
    float ang = atan2(obj.y-y, obj.x-x);
    vel = 1;
    velx = cos(ang)*vel;
    vely = sin(ang)*vel;
    max_dis = 250;
    seguir = false;
    puntos = false;
    tiempo_reposo = 0;
  }
  void act() {
    if (frameCount%6 == 0) frame++;
    frame %= 9;
    obj = new Punto(nivel.jugador.x, nivel.jugador.y);
    float dis = dist(obj.x, obj.y, x, y);
    if (dis < max_dis && !nivel.jugador.invisible) {
      if (!seguir && (dir == 0 && x-obj.x < 0) || (dir == 1 && x-obj.x > 0)) {
        seguir = true;
      }
    } else {
      seguir = false;
    }
    if (seguir) {
      if (obj.x-(x-10) < 0) {
        velx = -vel;
      } else if (obj.x-(x+10) > 0) {
        velx = vel;
      }
      seguir = true;
      dir = 0;
      if (velx < 0) dir = 1;
    } else {
      velx = 0;
      tiempo_reposo++;
      dir = (tiempo_reposo/180)%2;
      if (seguir) { 
        tiempo_reposo = 0;
        seguir = false;
      }
    }

    float antx = x; 
    float anty = y;
    x += velx;
    if (nivel.colisiona(this)) {
      x = antx;
      if (!salto) {
        salto = true;
        vely = -16;
      }
    }

    vely += 1;
    y += vely;
    if (nivel.colisiona(this)) {
      y = anty;
      salto = false;
      if (vely > 0) {
        //cant_sal = 0;
      }
      vely = 0;
    }
  }
  void dibujar() {
    if (dir == 0)
      image(sprites_cobra[frame%2][frame/2], x-w/2, y-h/2);
    else
      image(espejar(sprites_cobra[frame%2][frame/2]), x-w/2, y-h/2);
  }
}

class Huevo extends Enemigo {
  float vely;
  Huevo(float x, float y) {
    this.x = x;
    this.y = y;
    w = 18;
    h = 24;
    vely = 0;
  }
  void act() {
    vely += 0.5;
    y += vely;
    if (nivel.colisiona(this)) eliminar = true;
  }
  void dibujar() {
    noStroke();
    fill(230);
    ellipse(x, y, w, h);
  }
}
