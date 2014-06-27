import ddf.minim.*; //<>// //<>//

Minim minim;

AudioSample mouse_squeak, vulture_screech;
boolean pausa, cargar;
Boton2 editar;
Camara camara;
Datos datos;
Editor editor;
Input input;
int pause_time;
int tam = 16;
Nivel nivel;
Scroll vol_music, vol_sound;
String estado = "splash";
PFont font_chiqui, font_chiqui22, font_chiqui24;
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
  font_chiqui = createFont("slkscr.ttf", 14, true);//loadFont("Silkscreen-14.vlw");
  font_chiqui22 = createFont("slkscr.ttf", 22, true);//loadFont("Silkscreen-22.vlw");
  font_chiqui24 = createFont("slkscr.ttf", 24, true);//loadFont("Silkscreen-22.vlw");
  vol_music = new Scroll(374, 500, img_barra.width-img_barra.height, img_barra.height/2, 0, 1, 1);
  vol_sound = new Scroll(374, 560, img_barra.width-img_barra.height, img_barra.height/2, 0, 1, 0);
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
      image(recortar(sprites, 202, 402, 55, 55), 30, 30);
      if (input.click && mouseX > 30 && mouseX < 85&&  mouseY >= 30 && mouseY < 85) {
        estado = "main";
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
        String src = nivel.portal.src;
        if (src.equals("")) {
          nivel.iniciar();
        } else {
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
          if (editor.niveles.sel == -1) {
            nivel = new Nivel(src);
          }
        }
        nivel.iniciar();
      }
    }
    editar.act();
    if (input.EDITAR.click || editar.click) {
      float ax = nivel.jugador.x;
      float ay = nivel.jugador.y;
      nivel.iniciar();
      nivel.jugador.x = ax;
      nivel.jugador.y = ay;
      estado = "editor";
    }
  } else if (estado.equals("editor")) {
    camara.act();
    editor.act();
    if (input.PAUSA.click) {
      estado = "main";
    }
  }
  datos.act();
  input.act();
}

void dispose() {
  datos.guardar();
  println("Se cerro el juego!");
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
      estado = "main";
    }
    if (input.PAUSA.click) exit();
  } else if (estado.equals("main")) {
    image(fondo_menu[1], 0, 0);
    if (input.click && mouseX >= 300 && mouseX < 500) {
      if (mouseY >= 190 && mouseY < 240) {
        estado = "juego";
      }
      if (mouseY >= 270 && mouseY < 315) {
        estado = "level";
      }
      if (mouseY >= 340 && mouseY < 395) {
        estado = "scoreboard";
      }
      if (mouseY >= 420 && mouseY < 470) {
        estado = "options";
      }
      if (mouseY >= 495 && mouseY < 550) {
        estado = "editor";
      }
    }
    if (input.PAUSA.click) exit();
  } else if (estado.equals("scoreboard")) {
    image(fondo_menu[2], 0, 0);
    fill(#00592b);
    textFont(font_chiqui24);
    textAlign(CENTER, CENTER);
    text(datos.totalPuntos, 590, 262);
    text(datos.tiempoJugado, 590, 340);
    text(datos.cantidadMuertes, 590, 416);
    text(editor.niveles.niveles.size(), 590, 494);
  } else if (estado.equals("level")) {
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
    strokeWeight(4);
    for (int i = 0; i < niveles.size (); i++) {
      float x = inix + desx*(i%4);
      float y = iniy + desy*(i/4);
      stroke(#00592b);
      fill(#18f283);
      rect(x, y, wb, hb, 24);
      String nombre = niveles.get(i).nombre;
      if (nombre.length() > 9) nombre = nombre.substring(0, 9);
      fill(#00592b);
      text(nombre, x+wb/2, y+20);
      if (input.click && mouseX >= x && mouseX < x+wb && mouseY >= y && mouseY < y+hb) {
        nivel = niveles.get(i);
        estado = "juego";
      }
    }
  } else if (estado.equals("options")) {
    image(fondo_menu[4], 0, 0);
    vol_music.x = 385;
    vol_music.y = 195;
    vol_music.act();
    vol_sound.x = 385;
    vol_sound.y = 255;
    vol_sound.act();
  } else if (estado.equals("gameover")) {
    if(input.click && mouseX >= 318 && mouseX < 484 && mouseY >= 462 && mouseY < 520) { 
      nivel.iniciar(); 
      ui.iniciar();
      estado = "juego";
    }
  }
  if (estado.equals("scoreboard") || estado.equals("level") || estado.equals("options") || estado.equals("gameover")) { 
    if (input.click && mouseX > 30 && mouseX < 85&&  mouseY >= 30 && mouseY < 85) {
      estado = "main";
    }
    if (input.PAUSA.click) {
      estado = "main";
    }
  }
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
