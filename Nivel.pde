class Nivel { //<>//
  ArrayList<Elemento> elementos;
  ArrayList<Enemigo> enemigos;
  ArrayList<PowerUp> powerups;
  ArrayList<Plataforma> plataformas;
  ArrayList<Trampa> trampas;
  boolean pasarNivel;
  int w, h, ix, iy, tiempo;
  int[][] tiles;
  JSONObject json;
  Jugador jugador;
  String src, nombre;
  Portal portal;
  Nivel() {
    src = "";
    nuevo();
  }
  Nivel(String src) {
    this.src = src;
    cargarNivel(src);
    actualizarJson();
    iniciar();
  }
  void act() {
    if (input.REINICIAR.click) { 
      iniciar();
    }
    for (int i = 0; i < elementos.size (); i++) {
      Elemento aux = elementos.get(i);
      if (!aux.eliminar) aux.act();
    }
    jugador.act();
    if (portal.toca) {
      pasarNivel = true;
    }
    if (jugador.y >= nivel.h*tam+100) {
      jugador.vida = 0;
    }
    ui.act();
    dibujar();
  }
  void dibujar() {
    if(estado.equals("gameover")) return;
    pushMatrix();
    resetMatrix();
    if (!jugador.invisible) {    
      translate(int(camara.x)/2, int(camara.y)/2);
      //image(arboles, 0, 0);
    }
    resetMatrix();
    fill(0, 40+jugador.invisibilidad*40);
    rect(0, 0, width, height);
    popMatrix();
    dibujarTiles();
    for (int i = 0; i < elementos.size (); i++) {
      Elemento aux = elementos.get(i);
      if (dist(aux.x, aux.y, jugador.x, jugador.y) < width) {
        if (!aux.eliminar) aux.dibujar();
      }
    }
    jugador.dibujar();
    if (jugador.invisible) {
      dibujarInvisibilidad();
    }
    resetMatrix();
    ui.dibujar();
  }
  void dibujarInvisibilidad() {
    float w, h;
    w = h = 100 + 180*jugador.invisibilidad;
    float x = jugador.x-w/2;
    float y = jugador.y-h/2;
    float kappa = 0.5522848;
    float ox = (w / 2) * kappa;
    float oy = (h / 2) * kappa;
    float xe = x + w;
    float ye = y + h;
    float xm = x + w / 2;
    float ym = y + h / 2;
    fill(0, 30);
    beginShape();
    vertex(-camara.x, ym);
    vertex(-camara.x, -camara.y+height);
    vertex(-camara.x+width, -camara.y+height);
    vertex(-camara.x+width, -camara.y);
    vertex(-camara.x, -camara.y);
    vertex(-camara.x, ym);
    vertex(x, ym);
    bezierVertex(x, ym - oy, xm - ox, y, xm, y);
    bezierVertex(xm + ox, y, xe, ym - oy, xe, ym);
    bezierVertex(xe, ym + oy, xm + ox, ye, xm, ye);
    bezierVertex(xm - ox, ye, x, ym + oy, x, ym);
    vertex(x, ym);
    endShape(CLOSE);
  }
  void dibujarTiles() {
    int tam = 16;
    int x0 = floor(int(-camara.x)/tam);
    int y0 = floor(int(-camara.y)/tam);
    int x1 = x0+width/tam+1;
    int y1 = y0+height/tam+2;
    if (x0 < 0) x0 = 0;
    if (x0 > w) x0 = w;
    if (y0 < 0) y0 = 0;
    if (y0 > h) y0 = h;
    if (x1 < 0) x1 = 0;
    if (x1 > w) x1 = w;
    if (y1 < 0) y1 = 0;
    if (y1 > h) y1 = h;
    for (int j = y0; j < y1; j++) {
      for (int i = x0; i < x1; i++) {
        if (tiles[i][j] == 0) continue;
        int dx = 1; 
        int dy = 1;
        if (tiles[i][j] == 1 || tiles[i][j] == 2) {
          if (i-1 >= 0 && tiles[i-1][j] <= 0) dx = 0;
          if (i+1 < w && tiles[i+1][j] <= 0) { 
            if (dx == 0)dx = -1;
            else dx = 2;
          }
          if (j-1 >= 0 && tiles[i][j-1] <= 0) dy = 0;
          if (j+1 < h && tiles[i][j+1] <= 0) {
            if (dy == 0)dy = -1;
            else dy = 2;
          }
          if (dy == 0 || dy == -1) {
            int dd = dx;
            if (dd == -1) dd = 2;
            image(img_tiles[6+dd][2], i*16, (j-1)*16+1);
          }
          if (dx == -1 && dy == -1) {
            dy = -2;
            dx = 1;
          } else {
            if (dx == -1) {
              switch(dy) {
              case 0:
                dx = 2;
                dy = -2;
                break;
              case 1:
                dx = 6;
                dy = -1;
                break;
              case 2:
                dx = 2;
                dy = -1;
                break;
              }
            } else if ( dy == -1) {
              switch(dx) {
              case 0:
                dx = 0;
                dy = -1;
                break;
              case 1:
                dx = 0;
                dy = -2;
                break;
              case 2:
                dx = 1;
                dy = -1;
                break;
              }
            }
          }
          if (tiles[i][j] == 1) {
            image(img_tiles[0+dx][2+dy], i*16, j*16);
          }
          if (tiles[i][j] == 2) {
            image(img_tiles[3+dx][2+dy], i*16, j*16);
          }
        } else {
          if (i-1 >= 0 && tiles[i-1][j] <= 0) dx = 0;
          if (i+1 < w && tiles[i+1][j] <= 0) dx = 2;
          if (j-1 >= 0 && tiles[i][j-1] <= 0) dy = 0;
          //if (j+1 < h && tiles[i][j+1] <= 0) dy = 2;
          if (tiles[i][j] == 3) {
            image(img_tiles[10+dx][1+dy], i*16, j*16);
          }
          if (tiles[i][j] == 4) {
            image(img_tiles[10+dx][3+dy], i*16, j*16);
          }
        }
      }
    }
  }
  PGraphics dibujarTiles(int xx, int yy, int ww, int hh) {
    if (ww <= 0 || hh <= 0) return null;
    int tam = 16;
    PGraphics aux = createGraphics(ww*tam, hh*tam);
    aux.beginDraw();
    int x0 = xx;
    int y0 = yy;
    int x1 = xx+ww;
    int y1 = yy+hh;
    if (x0 < 0) x0 = 0;
    if (x0 > w) x0 = w;
    if (y0 < 0) y0 = 0;
    if (y0 > h) y0 = h;
    if (x1 < 0) x1 = 0;
    if (x1 > w) x1 = w;
    if (y1 < 0) y1 = 0;
    if (y1 > h) y1 = h;
    for (int j = y0; j < y1; j++) {
      for (int i = x0; i < x1; i++) {
        if (tiles[i][j] == 0) continue;
        int dx = 1; 
        int dy = 1;
        if (tiles[i][j] == 1 || tiles[i][j] == 2) {
          if (i-1 >= 0 && tiles[i-1][j] <= 0) dx = 0;
          if (i+1 < w && tiles[i+1][j] <= 0) { 
            if (dx == 0)dx = -1;
            else dx = 2;
          }
          if (j-1 >= 0 && tiles[i][j-1] <= 0) dy = 0;
          if (j+1 < h && tiles[i][j+1] <= 0) {
            if (dy == 0)dy = -1;
            else dy = 2;
          }
          if (dy == 0 || dy == -1) {
            int dd = dx;
            if (dd == -1) dd = 2;
            aux.image(img_tiles[6+dd][2], (i-xx)*16, (j-1-yy)*16+1);
          }
          if (dx == -1 && dy == -1) {
            dy = -2;
            dx = 1;
          } else {
            if (dx == -1) {
              switch(dy) {
              case 0:
                dx = 2;
                dy = -2;
                break;
              case 1:
                dx = 6;
                dy = -1;
                break;
              case 2:
                dx = 2;
                dy = -1;
                break;
              }
            } else if ( dy == -1) {
              switch(dx) {
              case 0:
                dx = 0;
                dy = -1;
                break;
              case 1:
                dx = 0;
                dy = -2;
                break;
              case 2:
                dx = 1;
                dy = -1;
                break;
              }
            }
          }
          if (tiles[i][j] == 1) {
            aux.image(img_tiles[0+dx][2+dy], (i-xx)*16, (j-yy)*16);
          }
          if (tiles[i][j] == 2) {
            aux.image(img_tiles[3+dx][2+dy], (i-xx)*16, (j-yy)*16);
          }
        } else {
          if (i-1 >= 0 && tiles[i-1][j] <= 0) dx = 0;
          if (i+1 < w && tiles[i+1][j] <= 0) dx = 2;
          if (j-1 >= 0 && tiles[i][j-1] <= 0) dy = 0;
          //if (j+1 < h && tiles[i][j+1] <= 0) dy = 2;
          if (tiles[i][j] == 3) {
            aux.image(img_tiles[10+dx][1+dy], (i-xx)*16, (j-yy)*16);
          }
          if (tiles[i][j] == 4) {
            aux.image(img_tiles[10+dx][3+dy], (i-xx)*16, (j-yy)*16);
          }
        }
      }
    }
    aux.endDraw();
    return aux;
  }
  void nuevo() {  
    pasarNivel = false;
    src = "";
    ix = 80;
    iy = 80; 
    w = 52;
    h = 40;
    tiles = new int[w][h];
    portal = new Portal((w-4)*tam, (h-2.5)*tam, "");
    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        tiles[i][j] = 0;
        if ( i == 0 || i == w-1 || j == 0 || j == h-1) tiles[i][j] = 1;
      }
    }
    tiempo = 60;
    elementos = new ArrayList<Elemento>();
    plataformas = new ArrayList<Plataforma>();
    enemigos = new ArrayList<Enemigo>();
    powerups = new ArrayList<PowerUp>();
    trampas = new ArrayList<Trampa>();
    actualizarJson();
    iniciar();
  }
  void cargarNivel(String src) {
    cargar = true;
    if (!src.equals("")) {
      this.src = src;
      json = loadJSONObject(src);
      iniciar();
    } else {
      iniciar();
    }
    cargar = false;
  }
  void actualizarJson() {
    JSONObject aux = new JSONObject();
    aux.setString("nombre", nombre);
    aux.setInt("width", w);
    aux.setInt("height", h);
    aux.setInt("inicialx", ix);
    aux.setInt("inicialy", iy);
    aux.setInt("tiempo", tiempo);

    JSONArray Portal = new JSONArray();
    Portal.append(portal.x);
    Portal.append(portal.y);
    Portal.append(portal.src);
    aux.setJSONArray("portal", Portal);

    JSONArray a1 = new JSONArray();
    for (int j = 0; j < h; j++) {
      JSONArray a2 = new JSONArray();
      for (int i = 0; i < w; i++) {
        a2.append(tiles[i][j]);
      }
      a1.append(a2);
    }
    aux.setJSONArray("tiles", a1);

    JSONArray plants = new JSONArray();
    JSONArray spikes = new JSONArray();
    for (int i = 0; i < trampas.size (); i++) {
      Trampa t = trampas.get(i);
      JSONArray a2 = new JSONArray();
      if (t instanceof Spike) {
        a2.append(t.x);
        a2.append(t.y);
        a2.append(t.w);
        a2.append(t.h);
        spikes.append(a2);
      }
      if (t instanceof Plant) {
        Plant p = (Plant) t;
        a2.append(p.x);
        a2.append(p.y);
        a2.append(p.p1.x);
        a2.append(p.p1.y);
        a2.append(p.p2.x);
        a2.append(p.p2.y);
        a2.append(p.t);
        plants.append(a2);
      }
    }
    aux.setJSONArray("plants", plants);
    aux.setJSONArray("spikes", spikes);

    a1 = new JSONArray();
    for (int i = 0; i < plataformas.size (); i++) {
      Plataforma p = plataformas.get(i);
      JSONArray a2 = new JSONArray();
      a2.append(p.x);
      a2.append(p.y);
      a2.append(p.w);
      a2.append(p.h);
      if (p.puntos) {
        a2.append(p.p1.x);
        a2.append(p.p1.y);
        a2.append(p.p2.x);
        a2.append(p.p2.y);
      }
      a1.append(a2);
    }
    aux.setJSONArray("plataformas", a1);

    a1 = new JSONArray();
    for (int i = 0; i < powerups.size (); i++) {
      PowerUp e = powerups.get(i);
      JSONArray a2 = new JSONArray();
      a2.append(e.x);
      a2.append(e.y);
      a2.append(e.t);
      a1.append(a2);
    }
    aux.setJSONArray("powerups", a1);

    JSONArray mouses = new JSONArray();
    JSONArray doves = new JSONArray();
    JSONArray serpents = new JSONArray();
    JSONArray rats = new JSONArray();
    JSONArray hawks = new JSONArray();
    JSONArray vipers = new JSONArray();
    JSONArray wolfs = new JSONArray();
    JSONArray vultures = new JSONArray();
    JSONArray cobras = new JSONArray();

    for (int i = 0; i < enemigos.size (); i++) {
      Enemigo e = enemigos.get(i);
      if (e instanceof Huevo) continue; 
      JSONArray a2 = new JSONArray();
      a2.append(e.ini.x);
      a2.append(e.ini.y);
      if (!(e instanceof Rat) && !(e instanceof Wolf) && !(e instanceof Cobra) && !(e instanceof Mouse)) {
        a2.append(e.p1.x);
        a2.append(e.p1.y);
        a2.append(e.p2.x);
        a2.append(e.p2.y);
      }
      if (e instanceof Mouse) {
        mouses.append(a2);
      } else if (e instanceof Dove) {
        doves.append(a2);
      } else if (e instanceof Serpent) {
        serpents.append(a2);
      } else if (e instanceof Rat) {
        rats.append(a2);
      } else if (e instanceof Hawk) {
        hawks.append(a2);
      } else if (e instanceof Viper) {
        vipers.append(a2);
      } else if (e instanceof Wolf) {
        wolfs.append(a2);
      } else if (e instanceof Vulture) {
        vultures.append(a2);
      } else if (e instanceof Cobra) {
        cobras.append(a2);
      }
    }
    aux.setJSONArray("mouses", mouses);
    aux.setJSONArray("doves", doves);
    aux.setJSONArray("serpents", serpents);
    aux.setJSONArray("rats", rats);
    aux.setJSONArray("hawks", hawks);
    aux.setJSONArray("vipers", vipers);
    aux.setJSONArray("wolfs", wolfs);
    aux.setJSONArray("vultures", vultures);
    aux.setJSONArray("cobras", cobras);

    json = aux;
  }
  void guardar() {
    actualizarJson();
    saveJSONObject(json, src);
  }
  void iniciar() {
    pasarNivel = false;
    if(json.hasKey("nombre")){
        nombre = json.getString("nombre");
    }else{
      String aux[] = split(src, "/");
      nombre = split(aux[aux.length-1], ".")[0];
    }
    ix = json.getInt("inicialx");
    iy = json.getInt("inicialy");
    if (json.hasKey("tiempo")) {
      tiempo = json.getInt("tiempo");
    } else {
      tiempo = 60;
    }
    ui.setTime(tiempo);
    jugador = new Jugador(ix, iy); 
    elementos = new ArrayList<Elemento>();
    plataformas = new ArrayList<Plataforma>();
    enemigos = new ArrayList<Enemigo>();
    powerups = new ArrayList<PowerUp>();
    trampas = new ArrayList<Trampa>();
    w = json.getInt("width");
    h = json.getInt("height");
    if (frameCount > 0 ) { 
      arboles = crearFondo();
    }
    //println((w*tam*2)-width, (h*tam*2)-height);
    tiles = new int[w][h];
    if (json.hasKey("portal")) {
      JSONArray p = json.getJSONArray("portal");
      portal = new Portal(p.getInt(0), p.getInt(1), p.getString(2));
    } else {
      portal = new Portal((w-3)*tam, (h-3)*tam, "");
    }
    elementos.add(portal);

    JSONArray a1 = json.getJSONArray("plants");
    for (int i = 0; i < a1.size (); i++) {
      JSONArray a2 = a1.getJSONArray(i);
      if (a2.size() <= 2) {
        int t = 0; 
        trampas.add(new Plant(a2.getInt(0), a2.getInt(1), t));
      } else {
        int t = 0; 
        if (a2.size() == 7) t = a2.getInt(6);
        trampas.add(new Plant(a2.getInt(0), a2.getInt(1), a2.getInt(2), a2.getInt(3), a2.getInt(4), a2.getInt(5), t));
      }
    } 
    a1 = json.getJSONArray("tiles"); 
    int jw = a1.getJSONArray(0).size();
    int jh = a1.size();
    int ww = min(w, jw);
    int hh = min(h, jh);
    for (int j = 0; j < hh; j++) {
      JSONArray a2 = a1.getJSONArray(j);
      for (int i = 0; i < ww; i++) {
        tiles[i][j] = a2.getInt(i);
      }
    }
    a1 = json.getJSONArray("plataformas");
    for (int i = 0; i < a1.size (); i++) {
      JSONArray a2 = a1.getJSONArray(i);
      if (a2.size() == 4) {
        plataformas.add(new Plataforma(a2.getInt(0), a2.getInt(1), a2.getInt(2), a2.getInt(3)));
      } else {
        plataformas.add(new Plataforma(a2.getInt(0), a2.getInt(1), a2.getInt(2), a2.getInt(3), a2.getInt(4), a2.getInt(5), a2.getInt(6), a2.getInt(7)));
      }
    }
    a1 = json.getJSONArray("powerups");
    for (int i = 0; i < a1.size (); i++) {
      JSONArray a2 = a1.getJSONArray(i);
      powerups.add(new PowerUp(a2.getInt(0), a2.getInt(1), a2.getInt(2)));
    }
    a1 = json.getJSONArray("mouses");
    for (int i = 0; i < a1.size (); i++) {
      JSONArray a2 = a1.getJSONArray(i);
      enemigos.add(new Mouse(a2.getInt(0), a2.getInt(1)));
    }
    a1 = json.getJSONArray("doves");
    for (int i = 0; i < a1.size (); i++) {
      JSONArray a2 = a1.getJSONArray(i);
      enemigos.add(new Dove(a2.getInt(0), a2.getInt(1), a2.getInt(2), a2.getInt(3), a2.getInt(4), a2.getInt(5)));
    }
    a1 = json.getJSONArray("serpents");
    for (int i = 0; i < a1.size (); i++) {
      JSONArray a2 = a1.getJSONArray(i);
      enemigos.add(new Serpent(a2.getInt(0), a2.getInt(1), a2.getInt(2), a2.getInt(3), a2.getInt(4), a2.getInt(5)));
    }
    a1 = json.getJSONArray("rats");
    for (int i = 0; i < a1.size (); i++) {
      JSONArray a2 = a1.getJSONArray(i);
      enemigos.add(new Rat(a2.getInt(0), a2.getInt(1)));
    }
    if (json.hasKey("hawks")) {   
      a1 = json.getJSONArray("hawks");
      for (int i = 0; i < a1.size (); i++) {
        JSONArray a2 = a1.getJSONArray(i);
        enemigos.add(new Hawk(a2.getInt(0), a2.getInt(1), a2.getInt(2), a2.getInt(3), a2.getInt(4), a2.getInt(5)));
      }
    }
    if (json.hasKey("vipers")) {   
      a1 = json.getJSONArray("vipers");
      for (int i = 0; i < a1.size (); i++) {
        JSONArray a2 = a1.getJSONArray(i);
        enemigos.add(new Viper(a2.getInt(0), a2.getInt(1), a2.getInt(2), a2.getInt(3), a2.getInt(4), a2.getInt(5)));
      }
    }
    if (json.hasKey("wolfs")) {   
      a1 = json.getJSONArray("wolfs");
      for (int i = 0; i < a1.size (); i++) {
        JSONArray a2 = a1.getJSONArray(i);
        enemigos.add(new Wolf(a2.getInt(0), a2.getInt(1)));
      }
    }
    if (json.hasKey("vultures")) {   
      a1 = json.getJSONArray("vultures");
      for (int i = 0; i < a1.size (); i++) {
        JSONArray a2 = a1.getJSONArray(i);
        enemigos.add(new Vulture(a2.getInt(0), a2.getInt(1), a2.getInt(2), a2.getInt(3), a2.getInt(4), a2.getInt(5)));
      }
    }
    if (json.hasKey("cobras")) {   
      a1 = json.getJSONArray("cobras");
      for (int i = 0; i < a1.size (); i++) {
        JSONArray a2 = a1.getJSONArray(i);
        enemigos.add(new Cobra(a2.getInt(0), a2.getInt(1)));
      }
    }
    a1 = json.getJSONArray("spikes");
    for (int i = 0; i < a1.size (); i++) {
      JSONArray a2 = a1.getJSONArray(i);
      trampas.add(new Spike(a2.getInt(0), a2.getInt(1)));
    }
    for (int i = 0; i < plataformas.size (); i++) {
      elementos.add(plataformas.get(i));
    }
    for (int i = 0; i < enemigos.size (); i++) {
      elementos.add(enemigos.get(i));
    }
    for (int i = 0; i < powerups.size (); i++) {
      elementos.add(powerups.get(i));
    }
    for (int i = 0; i < trampas.size (); i++) {
      elementos.add(trampas.get(i));
    }
    if (editor != null) {
      /*
      editor.ventanas.remove(editor.minimapa);
       //editor.minimapa = new Minimapa(w, h);
       editor.ventanas.add(editor.minimapa);
       */
    }
  }
  boolean colisiona(Jugador ju) {
    int x0 = int((ju.x - ju.w)/tam); 
    if (x0 < 0) x0 = 0;
    int y0 = int((ju.y - ju.h)/tam); 
    if (y0 < 0) y0 = 0;
    int x1 = int((ju.x + ju.w)/tam);
    if (x1 > w) x1 = w; 
    int y1 = int((ju.y + ju.h)/tam);
    if (y1 > h) y1 = h; 
    boolean colisiona, alentizar;
    colisiona = alentizar = false;
    for (int j = y0; j < y1; j++) {
      for (int i = x0; i < x1; i++) {
        if (tiles[i][j] != 0 && tiles[i][j] != 3) {
          if (colisionRect(ju.x, ju.y, ju.w, ju.h, i*tam+tam/2, j*tam+tam/2, tam, tam)) {
            colisiona = true;
          }
        }
        if (tiles[i][j] == 3) {
          if (colisionRect(ju.x, ju.y, ju.w, ju.h, i*tam+tam/2, j*tam+tam/2, tam, tam)) {
            alentizar = true;
          }
        }
      }
    }
    if (!colisiona && alentizar) {
      if (!ju.alentizar) {
        ju.cant_sal = 0;
        ju.alentizar = true;
        ju.vely = 0;
      }
    } else if (ju.acey != 1) { 
      ju.y = ju.y-(ju.y%ju.acey);
      ju.acey = 1;
      ju.alentizar = false;
    }
    return colisiona;
  }
  boolean colisiona(Enemigo e) {
    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        if (tiles[i][j] != 0) {
          if (colisionRect(e.x, e.y, e.w, e.h, i*tam+tam/2, j*tam+tam/2, tam, tam)) {
            return true;
          }
        }
      }
    }
    return false;
  }
  Plataforma colisionPlataforma() {
    for (int i = 0; i < plataformas.size (); i++) {
      Plataforma aux = plataformas.get(i);
      if (aux.colisiona(jugador)) {
        return aux;
      }
    }
    return null;
  }
  void eliminar(Elemento e) {
    elementos.remove(e);
    powerups.remove(e);
    plataformas.remove(e);
    enemigos.remove(e);
    trampas.remove(e);
  }
}

class Portal extends Elemento {
  boolean toca;
  String src;
  Portal(float x, float y, String src) {
    this.x = x; 
    this.y = y;
    ini = new Punto(x, y);
    this.src = src;
    w = 50; 
    h = 50;
    puntos = false;
    eliminar = false;
  }
  void act() {
    Jugador j = nivel.jugador;
    toca = false;
    if (dist(j.x, j.y, x, y) < ((j.w+w)/2+(j.h+h)/2)/2) {
      toca = true;
    }
    dibujar();
  }
  void dibujar() {
    noStroke();
    image(sprites_portal[0][((frameCount%60) < 30)? 0 : 1], x-w/2, y-h/2);
  }
}

PImage crearFondo() {
  int w = width+(nivel.w*tam-width)/2;
  int h = height+(nivel.h*tam-height)/2;
  int cant = w/180;
  //println("Se a creado un nuevo arbol", w, h, cant);
  PGraphics aux = createGraphics(w, h);
  aux.beginDraw();
  aux.background(180, 180, 255);
  for (int i = 0; i < cant; i++) {
    PImage arb = img_arbol[int(random(img_arbol.length))];
    aux.image(arb, random(-arb.width, w), random(h-arb.height*0.8, h));
  }
  aux.endDraw();
  PImage ret = createImage(w, h, ARGB);
  for (int i = 0; i < aux.pixels.length; i++) {
    ret.pixels[i] =  aux.pixels[i];
  }
  return aux;
}
