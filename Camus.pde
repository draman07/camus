import ddf.minim.*; //<>// //<>//

Minim minim;

AudioSample mouse_squeak, vulture_screech;
boolean pausa, cargar;
Boton2 editar;
Camara camara;
Datos datos;
Editor editor;
Input input;
int tiempoEstado;
int pause_time;
int tam = 16;
Nivel nivel;
Scroll vol_music, vol_sound;
ScrollV scrollNivs;
String estado = "splash";
PFont font_chiqui, font_chiqui22, font_chiqui24, font_chiqui54, font_chiqui100;
PImage sprites, arboles;
PImage boton_start, boton_sound, boton_music, boton_pause, img_barra, img_bbarra, img_pauseMenu, tileMenu;
PImage[] fondo_menu, img_arbol;
PImage[][] sprites_cobra, sprites_dove, sprites_hawk, sprites_leon, sprites_mouse, sprites_serpent, sprites_plants, sprites_portal, sprites_powerups, sprites_rat, sprites_viper, sprites_vulture, sprites_wolf;
PImage[][] img_tiles;
UI ui;

void setup() {
  size(800, 600);
  minim = new Minim(this);
  cargarImagenes();
  cargarSonidos();
  datos = new Datos();
  font_chiqui = createFont("slkscr.ttf", 14, false);//loadFont("Silkscreen-14.vlw");
  font_chiqui22 = createFont("slkscr.ttf", 22, false);//loadFont("Silkscreen-22.vlw");
  font_chiqui24 = createFont("slkscr.ttf", 24, false);//loadFont("Silkscreen-22.vlw");
  font_chiqui54 = createFont("slkscr.ttf", 54, false);
  font_chiqui100 = createFont("slkscr.ttf", 100, false);
  vol_music = new Scroll(374, 500, img_barra.width-img_barra.height, img_barra.height/2, 0, 1, 1);
  vol_sound = new Scroll(374, 560, img_barra.width-img_barra.height, img_barra.height/2, 0, 1, 0);
  scrollNivs = new ScrollV(690, 160, 10, 370, 0, 1, 0);
  input = new Input();
  ui = new UI(0);
  nivel = new Nivel();
  arboles = crearFondo();
  editar = new Boton2(15, height-24, 60, 20, "EDITAR");
  editor = new Editor();
  camara = new Camara(0, 0);
}  

void draw() {
  if (frameCount%10 == 0) frame.setTitle("FPS:"+frameRate);
  if (cargar) return;
  //background(200);
  dibujarPantallasInicio();
  if (estado.equals("juego")) {
    if (input.PAUSA.click) {
      pausa = !pausa;
    }
    if (pausa || pause_time > 0) {
      if (pausa && pause_time < 10)
        pause_time++; 
      if (!pausa) {
        pause_time--;
      }
      float av = pause_time/10.;
      camara.act();
      nivel.dibujar();
      fill(#1E0826, 255*0.2*av);
      rect(0, 0, width, height);
      image(img_pauseMenu, 0, height-130*av);
      image(recortar(sprites, 202, 402, 53, 54), 30, 30);
      if (input.click && mouseX > 30 && mouseX < 85&&  mouseY >= 30 && mouseY < 85) {
        cambiarEstado("main");
      }
      if (frameCount%80 < 50) image(boton_pause, width/2-boton_pause.width/2, height/2-boton_pause.height/2-60);
      vol_music.x = 480;
      vol_music.y = int(636-130*av);
      vol_music.act();
      vol_sound.x = 480;
      vol_sound.y = int(689-130*av);
      vol_sound.act();
    } else {
      float camx = width/2-nivel.jugador.x;
      if (camx > -tam) camx = -tam;
      if (camx < width-tam*nivel.w+tam) camx = width-tam*nivel.w+tam;
      float camy = height*0.6-nivel.jugador.y;

      if (camy > -tam) camy = -tam;
      if (camy < height-tam*nivel.h) camy = height-tam*nivel.h;

      camara.ira(camx-1, camy-1);
      camara.act();
      nivel.act();
      if (nivel.pasarNivel) {
        cambiarEstado("score");
      }
    }
    editar.act();
    if (input.EDITAR.click || editar.click) {
      float ax = nivel.jugador.x;
      float ay = nivel.jugador.y;
      nivel.iniciar();
      nivel.jugador.x = ax;
      nivel.jugador.y = ay;
      cambiarEstado("editor");
    }
  } else if (estado.equals("editor")) {
    camara.act();
    editor.act();
    if (input.PAUSA.click) {
      cambiarEstado("main");
    }
  }
  datos.act();
  input.act();
}

void dispose() {
  datos.guardar();
}

void keyPressed() {
  input.event(true);
  if (key == ESC) key=0;
}
void keyReleased() {
  input.event(false);
}

void mousePressed() {
  input.mpress();
}
void mouseReleased() {
  input.mreleased();
}

void dibujarPantallasInicio() {
  if (estado.equals("juego")) frameRate(60);
  else {
    frameRate(30);
    pausa = false;
  }
  String titulo = "";
  if (estado.equals("juego") || estado.equals("editor")) return;
  //dibujar fondo
  if (!estado.equals("gameover")) {
    int tt = tileMenu.width;
    int dd = (frameCount)%tt;
    for (int j = -1; j < height/tt; j++) {
      for (int i = -1; i < width/tt; i++) {
        image(tileMenu, i*tt+dd, j*tt+dd);
      }
    }
  }
  if (estado.equals("splash")) {
    image(fondo_menu[0], 0, 0);
    image(boton_start, width/2-boton_start.width/2, 210);
    if (input.ENTER.click || (input.click && mouseX >= width/2-boton_start.width/2 && mouseX < width/2+boton_start.width/2 && mouseY > 210 && mouseY < 210+boton_start.height)) {
      cambiarEstado("main");
    }
    if (input.PAUSA.click) exit();
  } else if (estado.equals("main")) {
    titulo = "main menu";
    //image(fondo_menu[1], 0, 0);
    String campos[] = {"start game", "select level", "scoreboard", "options", "editor"};
    textFont(font_chiqui24);
    stroke(#00592b);
    strokeWeight(3);
    for(int i = 0; i < campos.length; i++){
      fill(#18f283);
      rect(300, 186+77*i, 200, 50, 8);
      fill(#00592b);
      textAlign(CENTER, TOP);
      text(campos[i], width/2, 200+77*i);
    }
    if (input.click && mouseX >= 300 && mouseX < 500) {
      if (mouseY >= 190 && mouseY < 240) {
        cambiarEstado("juego");
        ui.iniciar();
      }
      if (mouseY >= 270 && mouseY < 315) {
        cambiarEstado("levels");
      }
      if (mouseY >= 340 && mouseY < 395) {
        cambiarEstado("scoreboard");
      }
      if (mouseY >= 420 && mouseY < 470) {
        cambiarEstado("options");
      }
      if (mouseY >= 495 && mouseY < 550) {
        cambiarEstado("editor");
      }
    }
    if (input.PAUSA.click) exit();
  } else if (estado.equals("scoreboard")) {
    titulo = "high\nscores";
    //image(fondo_menu[2], 0, 0);
    String campos[] = {"total points", "total time played", "total deaths", "levels"};
    int valores[] = {datos.totalPuntos, datos.tiempoJugado, datos.cantidadMuertes, editor.niveles.niveles.size()};
    textFont(font_chiqui24);
    stroke(#00592b);
    strokeWeight(3);
    for(int i = 0; i < campos.length; i++){
      fill(#18f283);
      textAlign(LEFT, TOP);
      text(campos[i], 150, 252+77*i);
      rect(485, 238+77*i, 204, 53, 8);
      fill(#00592b);
      textAlign(CENTER, CENTER);
      text(valores[i], 590, 262+77*i);
    }
    /*
    text(, 590, 262);
    text(, 590, 340);
    text(, 590, 416);
    text(, 590, 494);
    */
  } else if (estado.equals("levels")) {
    titulo = "levels";
    //image(fondo_menu[3], 0, 0);
    ArrayList<Nivel> niveles = editor.niveles.niveles;
    float wb = 104;
    float hb = 104;
    float borde = wb/4;
    float desx = wb+borde;
    float desy = hb+borde;
    float inix = (width-(desx*4-borde))/2;
    float iniy = 160;
    textFont(font_chiqui);
    textAlign(CENTER, CENTER);
    strokeWeight(3);
    int cant = niveles.size();
    int des = 0;
    int max = cant;
    if(cant > 12){
      scrollNivs.max_val = (cant-12)/4+1.95;
      scrollNivs.act();
      des = int(scrollNivs.val)*4;
      max = des+12;
      if(max > cant) max = cant;
    }
    for (int i = des; i < max; i++) {
      float x = inix + desx*((i-des)%4);
      float y = iniy + desy*((i-des)/4);
      stroke(#00592b);
      fill(#18f283);
      rect(x, y, wb, hb, 18);
      String nombre = niveles.get(i).nombre;
      if (nombre.length() > 9) nombre = nombre.substring(0, 9);
      fill(#00592b);
      text(nombre, x+wb/2, y+16);
      if (input.click && mouseX >= x && mouseX < x+wb && mouseY >= y && mouseY < y+hb) {
        nivel = niveles.get(i);
        cambiarEstado("juego");
        ui.iniciar();
      }
    }
  } else if (estado.equals("options")) {
    titulo = "options";
    //image(fondo_menu[4], 0, 0);
    textFont(font_chiqui24);
    textAlign(CENTER, CENTER);
    strokeWeight(3);
    stroke(#00592b);
    fill(#18f283);
    rect(88, 186, 130, 30, 6);
    rect(88, 244, 130, 30, 6);
    fill(#00592b);
    text("sound", 88, 242, 130, 30);
    text("music", 88, 184, 130, 30);
    vol_music.x = 385;
    vol_music.y = 195;
    vol_music.act();
    vol_sound.x = 385;
    vol_sound.y = 255;
    vol_sound.act();
  } else if (estado.equals("score")) {
    titulo = "score";
    fill(#00592B);
    image(fondo_menu[5], 0, 0);
    textAlign(CENTER, CENTER);
    textFont(font_chiqui54);
    text(ui.score, width/2, 138);
    textFont(font_chiqui24);
    text(stringTime(ui.max_tem-ui.tiempo), width/2, 226);
    int puntosPower = int(ui.powers*100);
    text(ui.powers, width/2, 292);
    int puntosTiempo = int(3.*(ui.tiempo*1./ui.max_tem)*4000);
    int puntosBonus = puntosPower+puntosTiempo; 
    text(puntosBonus, width/2, 358);
    int puntosTotal = puntosBonus+ui.score;
    text(puntosTotal, width/2, 456);
    image(recortar(sprites, 254, 397, 166, 58), width/2-83, 512);  
    if (input.click && mouseX >= 318 && mouseX < 484 && mouseY >= 512 && mouseY < 570) { 
      String src = nivel.portal.src;
      if (!src.equals("")) {
        editor.niveles.sel = -1;
        ArrayList<Nivel> nivs = editor.niveles.niveles;
        for (int i = 0; i < nivs.size (); i++) {
          Nivel n = nivs.get(i);
          if (src.equals(n.src)) {
            editor.niveles.sel = i;
            nivel = n; 
            break;
          }
        }
      }
      nivel.iniciar();
      nivel.iniciar(); 
      ui.iniciar();
      cambiarEstado("juego");
    }
  } else if (estado.equals("gameover")) {
    if (input.click && mouseX >= 318 && mouseX < 484 && mouseY >= 462 && mouseY < 520) { 
      nivel.iniciar(); 
      ui.iniciar();
      cambiarEstado("juego");
    }
  }
  
  if (!estado.equals("gameover") && !estado.equals("splash")) {
    float des = 1;
    if(tiempoEstado < 8) des = sin(map(tiempoEstado, 0, 8, 0, PI/2));
    //if(des > 1) des = 1;
    textFont(font_chiqui100);
    textAlign(CENTER,TOP);
    fill(#18f283);
    textLeading(94);
    text(titulo, width/2, 16-200+200*des);
  }
  
  if (estado.equals("scoreboard") || estado.equals("levels") || estado.equals("options") || estado.equals("score") || estado.equals("gameover")) { 
    image(recortar(sprites, 201, 402, 53, 54), 30, 30);
    if (input.click && mouseX > 30 && mouseX < 83&&  mouseY >= 30 && mouseY < 84) {
      cambiarEstado("main");
    }
    if (input.PAUSA.click) {
      cambiarEstado("main");
    }
  }
  tiempoEstado++;
}
void cambiarEstado(String nestado) {
  tiempoEstado = 0;
  estado = nestado;
}
void cargarImagenes() {
  sprites = loadImage("img/sprites.png");
  sprites_cobra = recortarImagen(loadImage("img/sprites_cobra.png"), 100, 50, 1);
  sprites_dove = recortarImagen(loadImage("img/sprites_dove.png"), 16, 16, 1);
  sprites_hawk = recortarImagen(loadImage("img/sprites_hawk.png"), 60, 50, 1);
  sprites_leon = recortarImagen(loadImage("img/sprites_leon.png"), 35, 35, 1);
  sprites_mouse = recortarImagen(loadImage("img/sprites_mouse.png"), 21, 11, 1);
  sprites_serpent = recortarImagen(loadImage("img/sprites_serpent.png"), 32, 6, 1);
  sprites_plants = recortarImagen(loadImage("img/sprites_plants.png"), 32, 32, 1);  
  sprites_portal = recortarImagen(loadImage("img/sprites_portal.png"), 50, 50, 1);
  sprites_powerups = recortarImagen(loadImage("img/sprites_powerups.png"), 32, 17, 1);
  sprites_rat = recortarImagen(loadImage("img/sprites_rat.png"), 33, 33, 1);
  sprites_viper = recortarImagen(loadImage("img/sprites_viper.png"), 91, 35, 1);
  sprites_vulture = recortarImagen(loadImage("img/sprites_vulture.png"), 93, 70, 1); 
  sprites_wolf = recortarImagen(loadImage("img/sprites_wolf.png"), 114, 57, 1);
  img_arbol = new PImage[5];
  for (int i = 0; i < 5; i++) {
    img_arbol[i] = loadImage("img/arbol"+(i+1)+".png");
  }
  fondo_menu = new PImage[7];
  for (int i = 0; i < 7; i++) {
    fondo_menu[i] = loadImage("img/fondomenu"+i+".png");
  }
  boton_start = recortar(sprites, 0, 352, 201, 50);
  boton_sound = recortar(sprites, 0, 402, 130, 30);
  boton_music = recortar(sprites, 0, 432, 130, 30);
  boton_pause = recortar(sprites, 201, 352, 130, 45);
  img_pauseMenu = loadImage("img/pMenu.png");
  img_barra = recortar(sprites, 0, 462, 253, 13);
  img_bbarra = recortar(sprites, 130, 402, 34, 34);
  img_tiles = recortarImagen(loadImage("img/sprites_tiles.png"), 16, 16, 1);
  tileMenu = loadImage("img/tileMenu.png");
}

void cargarSonidos() {
  mouse_squeak = minim.loadSample( "sound/mouse_squeak.wav", 512);
  vulture_screech = minim.loadSample( "sound/vulture_screech.wav", 512);
}
PImage recortar(PImage ori, int x, int y, int w, int h) {
  PImage aux = createImage(w, h, ARGB);
  aux.copy(ori, x, y, w, h, 0, 0, w, h);
  return aux;
}

PImage[][] recortarImagen(PImage ori, int ancho, int alto, int es) {
  int cw = ori.width/ancho;
  int ch = ori.height/alto;
  PImage res[][] = new PImage[cw][ch];
  for (int j = 0; j < ch; j++) {
    for (int i = 0; i < cw; i++) {
      PImage aux = recortar(ori, i*ancho, j*alto, ancho, alto);
      res[i][j] = ampliar(aux, es);
    }
  }
  return res;
}

PImage ampliar(PImage ori, int es) {
  int ancho =  ori.width; 
  int alto = ori.height;
  PImage res = createImage(ancho*es, alto*es, ARGB);
  for (int j = 0; j < alto; j++) {
    for (int i = 0; i < ancho; i++) {
      color col = ori.get(i, j);
      for (int k = 0; k < es; k++) {
        for (int l = 0; l < es; l++) {
          res.set(i*es+l, j*es+k, col);
        }
      }
    }
  }
  return res;
}

PImage voltear(PImage ori) {
  int w =  ori.width; 
  int h = ori.height;
  PImage aux = createImage(w, h, ARGB);
  for (int j = 0; j < h; j++) {
    for (int i = 0; i < w; i++) {
      color col = ori.get(i, j);
      aux.set(i, h-j-1, col);
    }
  }
  return aux;
}

PImage espejar(PImage ori) {
  int w =  ori.width; 
  int h = ori.height;
  PImage aux = createImage(w, h, ARGB);
  for (int j = 0; j < h; j++) {
    for (int i = 0; i < w; i++) {
      color col = ori.get(i, j);
      aux.set(w-i-1, j, col);
    }
  }
  return aux;
}

boolean colisionRect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  float disX = w1/2 + w2/2;
  float disY = h1/2 + h2/2;
  if (abs(x1 - x2) < disX && abs(y1 - y2) < disY) {
    return true;
  }  
  return false;
}
