class Editor { //<>//
  ArrayList<Elemento> selecionados;
  ArrayList<Ventana> ventanas;
  boolean dibujar, mover, sel, sel_obj;
  int tam, her, val;
  int px, py, mx, my;
  int sx1, sy1, sx2, sy2, mx1, my1;
  Menu menu;
  Minimapa minimapa;
  Niveles niveles;
  Opciones opciones; 
  PImage moviendo;
  Editor() {
    selecionados = new ArrayList<Elemento>();
    tam = 16;
    menu = new Menu(0, -30, width, 38);
    minimapa = new Minimapa(nivel.w, nivel.h); 
    opciones = new Opciones(width-220, 50, 200, 280);
    niveles = new Niveles(10, 48, 140, 260);
    ventanas = new ArrayList<Ventana>();
    ventanas.add(minimapa);
    ventanas.add(opciones);
    ventanas.add(niveles);
    dibujar = sel = false;
  }
  void act() {
    menu.act();
    for (int i = 0; i < ventanas.size (); i++) {
      Ventana v = ventanas.get(i);
      v.act();
    }
    if (input.EDITAR.click || menu.jugar.click) {
      nivel.actualizarJson();
      float ax = nivel.jugador.x;
      float ay = nivel.jugador.y;
      nivel.iniciar();
      nivel.jugador.x = ax;
      nivel.jugador.y = ay;
      estado = "juego";
    }
    if (menu.nuevo.click) {
      nivel = new Nivel();
      nivel.iniciar();
      niveles.sel = -1;
      minimapa.iniciar(nivel.w, nivel.h);
    }
    if (menu.cargar.click) {
      selectInput("Seleciona el mapa", "cargarNvl");
      return;
    }
    //println(key, keyCode, int(key), int(keyCode));
    if (menu.guardar.click || (input.CONTROL.press && input.kclick) && int(key) == 19) {
      if (nivel.src.equals("")) selectOutput("Guardar como:", "guardarSelecionar");
      else nivel.guardar();
    }

    if (menu.guardarComo.click) {
      selectOutput("Guardar como:", "guardarSelecionar");
    }
    if (input.released) {
      dibujar = false;
      mover = false;
    }
    if (input.ELIMINAR.click) {
      if (sel) {
        for (int j = sy1; j < sy2; j+=tam) { 
          for (int i = sx1; i < sx2; i+=tam) {
            setTile(i/tam, j/tam, 0);
          }
        }
      }
      if (selecionados.size() > 0) {
        for (int i = 0; i < selecionados.size (); i++) {
          Elemento aux = selecionados.get(i);
          nivel.eliminar(aux);
        }
      }
    }
    if (keyPressed && key >= '1' && key <= '7') {
      menu.herramientas.val = int(key-49);
    }
    her = int(menu.herramientas.val);
    val = int(menu.elementos.val);
    boolean sobre = false;
    for (int i = 0; i < ventanas.size (); i++) {
      Ventana v = ventanas.get(i);
      if (v.sobre) sobre = true;
    }
    float velcam = 5;
    if (input.SALTAR.press) {
      camara.mover(0, velcam);
    }
    if (input.ABAJO.press) {
      camara.mover(0, -velcam);
    }
    if (input.IZQUIERDA.press) {
      camara.mover(velcam, 0);
    } 
    if (input.DERECHA.press) {
      camara.mover(-velcam, 0);
    }
    if (!menu.sobre && !sobre) {
      /*
      float dis = dist(width/2, height/2, mouseX, mouseY);
       if (dis > 220) {
       int amx = (width/2-mouseX)/160;
       int amy = (height/2-mouseY)/160;
       //if (camara.x+amx >= nivel.w*tam-width){// && 
       if (camara.x+amx >= width-nivel.w*tam && camara.x+amx < 8) {
       camara.mover(amx, 0);
       }
       //if (camara.y+amy >= nivel.h*tam-height){// && 
       if (camara.y+amy >= height-nivel.h*tam-16 && camara.y+amy < 0) {
       camara.mover(0, amy);
       }
       }
       */
      if (true) {
        int amx = 0;
        int amy = 0;
        int vel = 4;
        if (mouseX < 30) amx = vel;
        if (mouseX > width-30) amx = -vel;
        if (mouseY < 58) amy = vel;
        if (mouseY > height-30) amy = -vel;
        if ((camara.x+amx >= width-nivel.w*tam-8 && amx < 0) || (camara.x+amx < 8 && amx > 0)) {
          camara.mover(amx, 0);
        }
        if ((camara.y+amy >= height-nivel.h*tam-8 && amy < 0) || (camara.y+amy < 8 && amy > 0)) {
          camara.mover(0, amy);
        }
      }
      mx = int(mouseX-camara.x);
      my = int(mouseY-camara.y);
      if (opciones.ajustar.press) {
        int mt = tam/2;
        mx = ((mx+mt/2)/mt)*mt;
        my = ((my+mt/2)/mt)*mt;
      }
      px = floor((mx)/tam);
      py = floor((my)/tam);
      if (her == 0) {
        if (input.dclick) {
          for (int i = 0; i < selecionados.size (); i++) {
            Elemento aux = selecionados.get(i);
            if (aux.sobre(mx, my)) {
              if (aux instanceof Plataforma) {
                aux.puntos = !aux.puntos;
                if (!aux.puntos) {
                  aux.p1 = aux.p2 = aux.obj = null;
                } else {
                  aux.p1 = new Punto(aux.x, aux.y);
                  aux.p2 = new Punto(aux.x, aux.y);
                  aux.obj = new Punto(aux.x, aux.y);
                }
              }
            }
          }
        }
        if (input.click) {
          mx1 = mx;
          my1 = my;
          sel_obj = true;
          for (int i = 0; i < selecionados.size (); i++) {
            Elemento aux = selecionados.get(i);
            if (aux.sobre(mx, my)) {
              aux.mover = true;
              sel_obj = false;
            } else {
              aux.mover = false;
            }
          }
          if (sel_obj) deseleccionar();
        }
        if (input.press) {
          for (int i = 0; i < selecionados.size (); i++) {
            Elemento aux = selecionados.get(i);
            aux.mover(mouseX-pmouseX, mouseY-pmouseY);
          }
        }
        if (input.released) {
          deseleccionar();
          for (int i = nivel.elementos.size ()-1; i >= 0; i--) {
            Elemento aux = nivel.elementos.get(i);
            if (mouseX == input.amouseX && mouseY == input.amouseY) {
              aux.seleccionar(mx, my);
              if (aux.sel) {
                selecionados.add(aux);
                break;
              }
            } else if (sel_obj) {
              aux.seleccionar(mx, my, int(input.amouseX-camara.x), int(input.amouseY-camara.y));
            }
            if (aux.sel) {
              if (sel) {
                if (aux.seleccionar(sx1, sy1, sx2, sy2)) selecionados.add(aux);
              } else selecionados.add(aux);
            }
          }
          sel_obj = false;
        }
      }
      if (her != 0 && input.click) {
        deseleccionar();
      }
      if (her == 1) {
        if (val < 2) {
          if (input.click) {
            dibujar = true;
          }
          if (dibujar && mouseButton == LEFT) {
            setTile(px, py, int(opciones.tiles.val+1));
          }
          if (dibujar && mouseButton == RIGHT) {
            setTile(px, py, 0);
          }
        } else if (val == 2 && input.click) {
          PowerUp aux = new PowerUp(mx, my, int(opciones.powerups.val));
          nivel.powerups.add(aux);
          nivel.elementos.add(aux);
        } else if (val == 3 && input.click) {
          Plataforma aux = new Plataforma(mx, my, 64, 16);
          nivel.plataformas.add(aux);
          nivel.elementos.add(aux);
        } else if (val == 4 && input.click) {
          Enemigo aux = null;
          switch(int(opciones.enemigos.val)) {
          case 0:
            aux = new Mouse(mx, my);
            break;
          case 1:
            aux = new Dove(mx, my, mx-64, my, mx+64, my);
            break;
          case 2:
            aux = new Serpent(mx, my, mx-64, my, mx+64, my);
            break;
          case 3:
            aux = new Rat(mx, my);
            break;
          case 4:
            aux = new Hawk(mx, my, mx-64, my, mx+64, my);
            break;
          case 5:
            aux = new Viper(mx, my, mx-64, my, mx+64, my);
            break;
          case 6:
            aux = new Wolf(mx, my);
            break;
          case 7:
            aux = new Vulture(mx, my, mx-64, my, mx+64, my);
            break;
          case 8:
            aux = new Cobra(mx, my);
            break;
          }
          if (aux != null) {
            nivel.enemigos.add(aux);
            nivel.elementos.add(aux);
          }
        } else if (val == 5 && input.click) {
          Trampa aux = null;
          switch(int(opciones.trampas.val)) {
          case 0:
            aux = new Plant(mx, my);
            break;
          case 1:
            aux = new Spike(mx, my);
            break;
          }
          nivel.trampas.add(aux);
          nivel.elementos.add(aux);
        }
      }
      if (her == 2 && input.press) {
        setTile(px, py, 0);
      }
      if (her == 3) {
        if (input.click) {
          sx1 = mx;
          sy1 = my;
        } 
        if (input.released) {
          sel = true;
          sx2 = max(mx, sx1);
          sy2 = max(my, sy1);
          sx1 = min(mx, sx1);
          sy1 = min(my, sy1);
          sx1 = floor((sx1)/tam)*tam;
          sy1 = floor((sy1)/tam)*tam;
          sx2 = floor((sx2)/tam)*tam;
          sy2 = floor((sy2)/tam)*tam;
          if (sx1 < 0) sx1 = 0;
          if (sy1 < 0) sy1 = 0;
          if (sx2 >= nivel.w*tam) sx2 = nivel.w*tam;
          if (sy2 >= nivel.h*tam) sy2 = nivel.h*tam;
          if (sx1 == sx2 || sy1 == sy2) {
            sx1 = sy1 = sx2 = sy2 = 0;
            sel = false;
            for (int i = 0; i < selecionados.size (); i++) {
              Elemento aux = selecionados.get(i);
              aux.sel = false;
            }
            selecionados = new ArrayList<Elemento>();
          }
          if (sel) {
            selecionados = new ArrayList<Elemento>();
            for (int i = 0; i < nivel.elementos.size (); i++) {
              Elemento aux = nivel.elementos.get(i);
              aux.seleccionar(sx1, sy1, sx2, sy2);
              if (aux.sel) {
                selecionados.add(aux);
              }
            }
          }
        }
      }
      if (her == 4) {
        if (input.click) {
          mx1 = mx;
          my1 = my;
          mover = true;
          moviendo = null;
        } 
        if (input.released) {
          moviendo = null;
          int w = (sx2-sx1)/tam;
          int h = (sy2-sy1)/tam;
          int x = sx1/tam;
          int y = (sy1)/tam;
          if (x < 0) { 
            w -= x;
            x = 0;
          }
          if (y < 0) { 
            h -= y;
            y = 0;
          }
          if (w >= nivel.w) {
            w -= w-nivel.w;
            if (w < 0) w = 0;
          }
          if (h >= nivel.h) {
            h -= h-nivel.h;
            if (h < 0) h = 0;
          }
          int amx = (mx/tam)-(mx1/tam);
          int amy = (my/tam)-(my1/tam);
          if ((amx != 0 || amy != 0) && w > 0 && h > 0) {
            int copia[][] = new int[w][h];
            for (int j = 0; j < h; j++) {
              for (int i = 0; i < w; i++) {
                copia[i][j] = nivel.tiles[x+i][y+j];
                //borra lo que habia antes si no esta presionada control
                if (!input.CONTROL.press) setTile(x+i, y+j, 0);
              }
            }
            //mueve la seleccion
            sx1 += amx*tam;
            sy1 += amy*tam;
            sx2 += amx*tam;
            sy2 += amy*tam;
            if (sx1 < 0) sx1 = 0;
            if (sy1 < 0) sy1 = 0;
            if (sx2 >= nivel.w*tam) sx2 = nivel.w*tam;
            if (sy2 >= nivel.h*tam) sy2 = nivel.h*tam;
            //termina de copiar 
            for (int j = 0; j < h; j++) {
              for (int i = 0; i < w; i++) {
                setTile(x+i+amx, y+j+amy, copia[i][j]);
              }
            }
          }
        }
      }
      if (her == 5 && input.click) {
        balder(px, py, -1, int(opciones.tiles.val+1));
      }
      if (her == 6 && input.press) {
        if (opciones.puntos.val == 0) {
          nivel.ix = mx;
          nivel.iy = my;
        } else {
          nivel.portal.x = mx;
          nivel.portal.y = my;
        }
      }
    }
    dibujar();
  }
  void dibujar() {
    background(10);
    noStroke();
    fill(40);
    rect(0, 0, nivel.w*tam, nivel.h*tam);
    nivel.dibujarTiles();
    if (mover) {
      if (moviendo == null) {
        int w = abs(sx2-sx1)/tam;
        int h = abs(sy2-sy1)/tam;
        moviendo = nivel.dibujarTiles(sx1/tam, sy1/tam, w, h);
      } else {
        fill(40);
        int mx = int(mouseX-mx1-camara.x);
        int my = int(mouseY-my1-camara.y);
        if (!input.CONTROL.press) rect(sx1, sy1, moviendo.width, moviendo.height);
        tint(255, 128);
        image(moviendo, sx1+mx, sy1+my);
        noTint();
      }
    }
    for (int i = 0; i < nivel.trampas.size (); i++) {
      Trampa t = nivel.trampas.get(i);
      t.dibujar();
      t.dibujarSeleccion();
    }
    for (int i = 0; i < nivel.plataformas.size (); i++) {
      Plataforma e = nivel.plataformas.get(i);
      e.dibujar();
      e.dibujarSeleccion();
    }
    for (int i = 0; i < nivel.enemigos.size (); i++) {
      Enemigo e = nivel.enemigos.get(i);
      e.dibujar();
      e.dibujarSeleccion();
    }
    for (int i = 0; i < nivel.powerups.size (); i++) {
      PowerUp e = nivel.powerups.get(i);
      image(sprites_powerups[0+e.t*2][0], e.x-e.w/2, e.y-e.h/2);
      e.dibujarSeleccion();
    }
    noStroke();
    fill(#53FA05);
    ellipse(nivel.ix, nivel.iy, 32, 32);
    fill(250, 255, 20);
    ellipse(nivel.portal.x, nivel.portal.y, nivel.portal.w, nivel.portal.h);
    pushMatrix();
    resetMatrix();

    stroke(255, 30);
    for (float i = (int (camara.x)%tam); i < width; i+=tam) {
      line(i, 0, i, height);
    }
    for (float i = (int (camara.y)%tam); i < height; i+=tam) {
      line(0, i, width, i);
    }

    popMatrix();
    if (her == 0 && input.press && sel_obj) {
      noFill();
      stroke(180);
      rectMode(CORNERS);
      rect(mx, my, mx1, my1);
      rectMode(CORNER);
    }
    if (her == 3 || sel) {
      noFill();
      stroke(0, 255, 0, 155+abs(100*map(frameCount%40, 0, 40, -1, 1)));
      rectMode(CORNERS);
      if (her == 3 && !menu.sobre && input.press) {
        rect(mx, my, sx1, sy1);
      } else {
        int amx = 0; 
        int amy = 0;
        if (mover) {
          amx = mx-mx1;
          amy = my-my1;
        }
        rect(sx1+amx, sy1+amy, sx2+amx, sy2+amy);
      }
      rectMode(CORNER);
    }
    resetMatrix();
    String text = "w:"+nivel.w+" h:"+nivel.h+"  x:"+px+" y:"+py;
    noStroke();
    fill(0, 220);
    rect(8, height-30, textWidth(text)+4, 16);
    fill(255, 200);
    text(text, 10, height-20);
    for (int i = 0; i < ventanas.size (); i++) {
      Ventana v = ventanas.get(i);
      v.dibujar();
    }
    menu.dibujar();
  }
  boolean setTile(int x, int y, int val) {
    if (sel && (x*tam < sx1 || x*tam >= sx2 || y*tam < sy1 || y*tam >= sy2)) {
      return false;
    }
    if (x >= 0 && x < nivel.w && y >= 0 && y < nivel.h) {
      nivel.tiles[x][y] = val;
      return true;
    }
    return false;
  }
  void balder(int x, int y, int ov, int nv) {
    if (x < 0 || x >= nivel.w || y < 0 || y >= nivel.h) return;
    if (ov == -1) ov = nivel.tiles[x][y];
    if (nivel.tiles[x][y] != ov || ov == nv) return;
    if (setTile(x, y, nv)) {
      balder(x-1, y, ov, nv);
      balder(x+1, y, ov, nv);
      balder(x, y-1, ov, nv);
      balder(x, y+1, ov, nv);
    }
  }
  void deseleccionar() {
    for (int i = 0; i < selecionados.size (); i++) {
      Elemento aux = selecionados.get(i);
      if (aux.mover && opciones.ajustar.press) {
        int mt = tam/2;
        aux.x = (int(aux.x+mt/2)/mt)*mt;
        aux.y = (int(aux.y+mt/2)/mt)*mt;
        if (aux.puntos) {
          aux.p1.x = (int(aux.p1.x+mt/2)/mt)*mt;
          aux.p1.y = (int(aux.p1.y+mt/2)/mt)*mt;
          aux.p2.x = (int(aux.p2.x+mt/2)/mt)*mt;
          aux.p2.y = (int(aux.p2.y+mt/2)/mt)*mt;
        }
      }
      aux.sel = false;
    }
    selecionados = new ArrayList<Elemento>();
  }
}

class Boton2 {
  boolean sobre, click; 
  int time;
  float x, y, w, h;
  String nombre;
  PImage imgf, imgs, imgp;
  Boton2(float x, float y, float w, float h, String nombre) {
    this.x = x;
    this.y = y;
    this.w = w; 
    this.h = h;
    this.nombre = nombre;
    sobre = click = false;
    imgf = crearDegrade(int(w), int(h), color(58), color(42));
    imgs = crearDegrade(int(w), int(h), color(108), color(92));
    imgp = crearDegrade(int(w), int(h), color(48), color(32));
  }
  void act() {
    sobre = click = false;
    if (mouseX >= x && mouseX < x+w && mouseY >= y && mouseY < y+h) {
      sobre = true;
      time ++;
      if (input.click) {
        click = true;
      }
    } else {
      time = 0;
    }
  }
  void dibujar() {
    /*
    int alp;
     if (time > 11) alp = 22;
     else alp = time*2;
     fill(78+alp);
     rect(x, y, w, h);
     */
    if (sobre) {
      if (click) image(imgp, x, y);
      else image(imgs, x, y);
    } else image(imgf, x, y);

    textAlign(CENTER);
    fill(255);
    text(nombre, x, y+2, w, h);
  }
}

class Menu {
  boolean sobre;
  Boton2 jugar, nuevo, cargar, guardar, guardarComo;
  int x, y, w, h, dy;
  Selector elementos, herramientas; 
  PImage fondo;
  Menu(int x, int y, int w, int h) {
    this.x = x; 
    this.y = y; 
    this.w = w;
    this.h = h;
    dy = 30;
    jugar = new Boton2(15, 8, 60, 20, "JUGAR");
    nuevo = new Boton2(85, 8, 60, 20, "NUEVO");
    cargar = new Boton2(155, 8, 60, 20, "CARGAR");
    guardar = new Boton2(225, 8, 60, 20, "GUARDAR");
    guardarComo = new Boton2(295, 8, 60, 20, "SAVE AS");
    herramientas = new Selector(width-150, 8, 140, 20, 7, 0, "");
    elementos = new Selector(width-300, 8, 140, 20, 7, 0, "");
    fondo = crearDegrade(w, h, color(88), color(72));
  }
  void act() {
    if (mouseX >= x && mouseX < x+w && mouseY >= y+dy && mouseY < y+dy+h) {
      sobre = true;
      //dy+=2;
      if (dy > 30) dy = 30;
    } else {
      sobre = false;
      //dy-=2;
      if (dy < 0) dy = 0;
    }
    int yy = y+dy+8;
    jugar.y = yy;
    jugar.act();
    nuevo.y = yy;
    nuevo.act();
    cargar.y = yy;
    cargar.act();
    guardar.y = yy;
    guardar.act();
    guardarComo.y = yy;
    guardarComo.act();
    elementos.y = yy;
    elementos.act();
    if (elementos.click) {
      herramientas.val = 1;
    }
    herramientas.y = yy;
    herramientas.act();
  }
  void dibujar() {
    //fill(80);
    //rect(x, y+dy, w, h);
    image(fondo, x, y+dy);
    jugar.dibujar();
    nuevo.dibujar();
    cargar.dibujar();
    guardar.dibujar();
    guardarComo.dibujar();
    elementos.dibujar();
    image(recortar(sprites, 0, 196, 140, 20), elementos.x, elementos.y);
    herramientas.dibujar();
    image(recortar(sprites, 0, 176, 140, 20), herramientas.x, herramientas.y);
  }
}

void cargarNvl(File f) {
  if (f == null) {
  } else {
    String ruta = f.toString();
    String extension = ruta.substring(ruta.lastIndexOf(".") + 1, ruta.length());
    if (extension.equals("json")) {
      nivel = new Nivel();
      nivel.cargarNivel(f.toString());
    }
  }
}


void guardarSelecionar(File sel) {
  if (sel != null) {
    nivel.src = sel.toString();
    nivel.guardar();
  }
}

class Ventana {
  boolean mover, mostrar, sobre;  
  int x, y, w, h;
  PImage barra; 
  Ventana(int x, int y, int w, int h) {
    this.x = x; 
    this.y = y; 
    mostrar = true;
    resize(w, h);
  }
  void act() {
    if (mostrar) {
      if (mouseX >= x && mouseX < x+w && mouseY >= y && mouseY < y+h && input.amouseX >= x && input.amouseX < x+w && input.amouseY >= y && input.amouseY < y+h) {
        sobre = true;
      } else sobre = false;
      if (input.click && mouseButton == LEFT) {
        if (sobre && mouseY < y+20) {
          mover = true;
          if (mouseX >= x+w-20) { 
            mover = false;
            sobre = false;
            mostrar = false;
          }
        }
      }
    }
    if (input.released) {
      mover = false;
    }
    if (mover) {
      x += mouseX-pmouseX;
      y += mouseY-pmouseY;
    }
  }
  void dibujar() {
    noStroke();
    if (!mostrar) return;
    fill(30);
    rect(x, y+20, w, h-20);
    image(barra, x, y);
    stroke(200);
    line(x+w-14, y+3, x+w-3, y+14);
    line(x+w-14, y+14, x+w-3, y+3);
  }
  void resize(int nw, int nh) {
    this.w = nw; 
    this.h = nh+20;
    barra = crearDegrade(w, 20, color(20), color(10));
  }
}

class Opciones extends Ventana {
  Check ajustar;
  Selector enemigos, powerups, trampas, tiles, puntos;
  Opciones(int x, int y, int w, int h) {
    super(x, y, w, h);
    ajustar = new Check(10, 60, 20, 20, "ajustar");
    ajustar.press = true;
    tiles = new Selector(10, 30, 80, 20, 4, 0, "tiles");
    enemigos = new Selector(10, 90, 180, 20, 9, 0, "enemigos");
    powerups = new Selector(10, 120, 80, 20, 4, 0, "powerups");
    trampas = new Selector(10, 150, 40, 20, 2, 0, "trampas");
    puntos = new Selector(10, 180, 40, 20, 2, 0, "puntos interes");
  }
  void act() {
    super.act();
    ajustar.act(x, y);
    enemigos.act(x, y);
    if (enemigos.click) {
      editor.menu.herramientas.val = 1;
      editor.menu.elementos.val = 4;
    }
    powerups.act(x, y);
    if (powerups.click) { 
      editor.menu.herramientas.val = 1;
      editor.menu.elementos.val = 2;
    }
    tiles.act(x, y);
    if (tiles.click) { 
      editor.menu.herramientas.val = 1;
      editor.menu.elementos.val = 1;
    }
    trampas.act(x, y);
    if (trampas.click) { 
      editor.menu.herramientas.val = 1;
      editor.menu.elementos.val = 5;
    }
    puntos.act(x, y);
    if (puntos.click) { 
      editor.menu.herramientas.val = 6;
      editor.menu.elementos.val = 5;
    }
  }
  void dibujar() {
    if (!mostrar) return;
    super.dibujar();
    ajustar.dibujar(x, y);
    enemigos.dibujar(x, y);
    image(recortar(sprites, 140, 196, 160, 20), x+enemigos.x, y+enemigos.y);
    powerups.dibujar(x, y);
    image(recortar(sprites, 220, 176, 80, 20), x+powerups.x, y+powerups.y);
    tiles.dibujar(x, y);
    image(recortar(sprites, 140, 176, 80, 20), x+tiles.x, y+tiles.y);
    trampas.dibujar(x, y);
    image(recortar(sprites, 300, 196, 40, 20), x+trampas.x, y+trampas.y);
    puntos.dibujar(x, y);
  }
}

class Niveles extends Ventana {
  ArrayList<Nivel> niveles;
  ArrayList<String> nombres;
  int sel;
  Niveles(int x, int y, int w, int h) {
    super(x, y, w, h);
    niveles = new ArrayList<Nivel>();
    nombres = new ArrayList<String>();
    sel = -1;
    File file = new File(sketchPath);
    File[] files = null;
    if (file.isDirectory()) {
      files = file.listFiles();
    } 
    for (int i = 0; i < files.length; i++) {
      String ruta = files[i].toString();
      String nombre = split(files[i].getName(), ".")[0];
      String extension = ruta.substring(ruta.lastIndexOf(".") + 1, ruta.length());
      if (extension.equals("json")) {
        Nivel aux = new Nivel();
        aux.cargarNivel(ruta);
        niveles.add(aux);
        nombres.add(nombre);
      }
    }
  }
  void act() {
    super.act();
    if (sobre && input.click) {
      for (int i = 0; i < nombres.size (); i++) {
        if (mouseX >= x && mouseX < x+w && mouseY >= (y+20+20*i) && mouseY < (y+20+20*i)+20) {
          sel = i;
          nivel = niveles.get(i);
          nivel.iniciar();
        }
      }
    }
  }
  void dibujar() {
    if (!mostrar) return;
    super.dibujar();
    noStroke();
    fill(255);
    for (int i = 0; i < nombres.size (); i++) {
      if (i == sel)
        fill(50);
      else 
        fill(26);
      rect(x, y+20+20*i, w, 20);
      fill(255);
      text(nombres.get(i), x+10, y+30+i*20);
    }
  }
}

class Minimapa extends Ventana {
  boolean mover;
  int mw, mh, es;
  PImage img;
  Minimapa(int mw, int mh) {
    super(580, 360, 100, 100);
    iniciar(mw, mh);
  }
  void iniciar(int mw, int mh) {
    this.mw = mw;
    this.mh = mh;
    es = 2;
    if (mw > 60 || mh > 60) es = 1;
    w = mw*es+20;
    h = mh*es+20;
    resize(w, h);
    img = createImage(mw*es, mh*es, RGB);
    for (int j = 0; j < mh; j++) {
      for (int i = 0; i < mw; i++) {
        color col = color(0);
        switch(nivel.tiles[i][j]) {
        case 0:
          col = color(0);
          break;
        case 1:
          col = color(#330000);
          break;
        case 2:
          col = color(#39B54A);
          break;
        case 3:
          col = color(#1A32FF);
          break;
        case 4:
          col = color(#FFEC1A);
          break;
        }
        for (int sw = 0; sw < es; sw++) {
          for (int sh = 0; sh < es; sh++) {
            img.set(i*es+sw, j*es+sh, col);
          }
        }
      }
    }
  }
  void act() {
    super.act();
    if (mostrar) {
      if (sobre && input.press && mouseX >= x+10 && mouseX < x+w-10 && mouseY >= y+30 && mouseY < y+h-10) {
        mover = true;
      }
      if (!(mouseX >= x+10 && mouseX < x+w-10 && mouseY >= y+30 && mouseY < y+h-10)) {
        mover = false;
      }
      if (input.released) {
        mover = false;
      }
      if (mover) {
        camara.set((x+10-mouseX+width/2*es/tam)*tam/es, (y+30-mouseY+height/2*es/tam)*tam/es);
      }
    }
  }
  void dibujar() {
    if (!mostrar) return;
    super.dibujar();
    if (frameCount%60 == 0) {
      for (int j = 0; j < mh; j++) {
        for (int i = 0; i < mw; i++) {
          color col = color(0);
          switch(nivel.tiles[i][j]) {
          case 0:
            col = color(0);
            break;
          case 1:
            col = color(#330000);
            break;
          case 2:
            col = color(#39B54A);
            break;
          case 3:
            col = color(#1A32FF);
            break;
          case 4:
            col = color(#FFEC1A);
            break;
          }
          for (int sw = 0; sw < es; sw++) {
            for (int sh = 0; sh < es; sh++) {
              img.set(i*es+sw, j*es+sh, col);
            }
          }
        }
      }
    }
    image(img, x+10, y+30);
    stroke(200);
    noFill();
    rect(x+10-camara.x/16*es, y+30-camara.y/16*es, width/16*es, height/16*es);
  }
}

class Check {
  boolean click, press, eliminar;
  float x, y, w, h;
  String nombre;
  Check(float x, float y, float w, float h, String nombre) {
    this.x = x; 
    this.y = y;
    this.w = w;
    this.h = h;
    this.nombre = nombre;
    press = false;
  }
  void act(float cx, float cy) {
    click = false;
    float x = cx + this.x;
    float y = cy + this.y;
    if (input.click) {
      if ( mouseX >= x  && mouseX < x + w ) {
        if ( mouseY >= y  && mouseY < y + h ) {
          click = true;
          press = !press;
        }
      }
    }
  }
  void dibujar(float cx, float cy) {
    float x = cx + this.x;
    float y = cy + this.y;
    noStroke();
    if (press) fill(150);
    else fill(120);
    rect(x, y, w, h);
    fill(255);
    textAlign(LEFT, CENTER);
    text(nombre, x+w+4, y+9);
  }
}

class Selector {
  boolean aux, click, eliminar;
  float x, y, w, h, val;
  int cant;
  String nombre;
  Selector(float nx, float ny, float nw, float nh, int nc, int nv, String n) {
    x = nx;
    y = ny;
    w = nw;
    h = nh;
    cant = nc;
    val = nv;
    nombre = n;
    aux = false;
  }

  void act() {
    act(0, 0);
  }

  void act(float cx, float cy) {
    click = false;
    float x = cx + this.x;
    float y = cy + this.y;
    if (input.click) {
      if ( mouseX >= x  && mouseX < x + w ) {
        if ( mouseY >= y  && mouseY < y + h ) {
          click = true;
          val = int((mouseX - x)/(w/cant));
        }
      }
    }
  }
  void dibujar() {
    dibujar(0, 0);
  }
  void dibujar(float cx, float cy) {
    float x = cx + this.x;
    float y = cy + this.y;
    noStroke();
    for (int i = 0; i < cant; i++) {
      if (val == i) {
        fill(150);
      } else {
        fill(120);
      }
      rect(x+(w)/cant*i, y, w/cant, h);
    }
    fill(255);

    textAlign(LEFT, CENTER);
    text(nombre, x+w+4, y+9);
  }
}

PImage crearDegrade(int w, int h, color c1, color c2) {
  PImage aux = createImage(w, h, RGB);
  for (int j = 0; j < h; j++) {
    for (int i = 0; i < w; i++) {
      color c = lerpColor(c1, c2, map(j, 0, h, 0, 1));
      color ac = c;
      if ((i+j)%2 == 0) ac = lerpColor(c, color(#325E93), 0.04);
      aux.set(i, j, ac);
    }
  }
  return aux;
}
