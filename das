diff --git a/Camus.pde b/Camus.pde
index c2ca71d..8eb8634 100644
--- a/Camus.pde
+++ b/Camus.pde
@@ -1,5 +1,4 @@
- //<>// //<>//
-import ddf.minim.*;
+import ddf.minim.*; //<>// //<>//
 
 Minim minim;
 
@@ -7,6 +6,7 @@ AudioSample mouse_squeak, vulture_screech;
 boolean pausa, cargar;
 Boton2 editar;
 Camara camara;
+Datos datos;
 Editor editor;
 Input input;
 int pause_time;
@@ -27,6 +27,7 @@ void setup() {
   minim = new Minim(this);
   cargarImagenes();
   cargarSonidos();
+  datos = new Datos();
   font_chiqui = loadFont("Silkscreen-14.vlw");
   font_chiqui22 = loadFont("Silkscreen-22.vlw");
   vol_music = new Scroll(374, 500, img_barra.width-img_barra.height, img_barra.height/2, 0, 1, 1);
@@ -44,77 +45,8 @@ void draw() {
   if (frameCount%10 == 0) frame.setTitle("FPS:"+frameRate);
   if (cargar) return;
   //background(200);
-  if (estado.equals("splash")) {
-    image(fondo_menu[0], 0, 0);
-    image(boton_start, width/2-boton_start.width/2, 210);
-    if (input.ENTER.click || (input.click && mouseX >= width/2-boton_start.width/2 && mouseX < width/2+boton_start.width/2 && mouseY > 210 && mouseY < 210+boton_start.height)) {
-      estado = "main";
-    } 
-    vol_music.act();
-    vol_sound.act();   
-    image(boton_music, 172, 490);
-    image(boton_sound, 172, 550);
-  } else if (estado.equals("main")) {
-    image(fondo_menu[1], 0, 0);
-    if (input.click && mouseX >= 300 && mouseX < 500) {
-      if (mouseY >= 190 && mouseY < 240) {
-        estado = "juego";
-      }
-      if (mouseY >= 270 && mouseY < 315) {
-        estado = "level";
-      }
-      if (mouseY >= 340 && mouseY < 395) {
-        estado = "score";
-      }
-      if (mouseY >= 420 && mouseY < 470) {
-        estado = "options";
-      }
-      if (mouseY >= 495 && mouseY < 550) {
-        estado = "editor";
-      }
-    }
-  } else if (estado.equals("score")) {
-    image(fondo_menu[2], 0, 0);
-    if (input.click && mouseX > 15 && mouseX < 70 &&  mouseY >= 10 && mouseY < 68) {
-      estado = "main";
-    }
-    if (input.PAUSA.click) {
-      estado = "main";
-    }
-  } else if (estado.equals("level")) {
-    image(fondo_menu[3], 0, 0);
-    ArrayList<Nivel> niveles = editor.niveles.niveles;
-    float borde = boton_level.width/4;
-    float desx = boton_level.width+borde;
-    float desy = boton_level.height+borde;
-    float inix = (width-(desx*4-borde))/2;
-    float iniy = 160;
-    for (int i = 0; i < niveles.size (); i++) {
-      float x = inix + desx*(i%4);
-      float y = iniy + desy*(i/4);
-      image(boton_level, x, y);
-    }
-    if (input.click && mouseX > 15 && mouseX < 70 &&  mouseY >= 10 && mouseY < 68) {
-      estado = "main";
-    }
-    if (input.PAUSA.click) {
-      estado = "main";
-    }
-  } else if (estado.equals("options")) {
-    image(fondo_menu[4], 0, 0);
-    vol_music.x = 385;
-    vol_music.y = 195;
-    vol_music.act();
-    vol_sound.x = 385;
-    vol_sound.y = 255;
-    vol_sound.act();
-    if (input.click && mouseX > 15 && mouseX < 70 &&  mouseY >= 10 && mouseY < 68) {
-      estado = "main";
-    }
-    if (input.PAUSA.click) {
-      estado = "main";
-    }
-  } else if (estado.equals("juego")) {
+  dibujarPantallasInicio();
+  if (estado.equals("juego")) {
     if (input.PAUSA.click) {
       pausa = !pausa;
     }
@@ -130,6 +62,10 @@ void draw() {
       fill(#1E0826, 255*0.2*av);
       rect(0, 0, width, height);
       image(img_pauseMenu, 0, height-130*av);
+      image(recortar(sprites,202,402,55,55),30,30);
+      if (input.click && mouseX > 30 && mouseX < 85&&  mouseY >= 30 && mouseY < 85) {
+        estado = "main";
+      }
       if (frameCount%80 < 50) image(boton_pause, width/2-boton_pause.width/2, height/2-boton_pause.height/2-60);
       vol_music.x = 480;
       vol_music.y = int(636-130*av);
@@ -186,13 +122,8 @@ void draw() {
     if (input.PAUSA.click) {
       estado = "main";
     }
-  } else if (estado.equals("arboles")) {
-    if (input.kclick) {
-      int w = int(random(40, 120));
-      arboles = crearFondo();
-      image(arboles, 0, 0, width, height);
-    }
   }
+  datos.act();
   input.act();
 }
 
@@ -212,6 +143,72 @@ void mousePressed() {
 void mouseReleased() {
   input.mreleased();
 }
+
+void dibujarPantallasInicio(){
+  if (estado.equals("splash")) {
+    image(fondo_menu[0], 0, 0);
+    image(boton_start, width/2-boton_start.width/2, 210);
+    if (input.ENTER.click || (input.click && mouseX >= width/2-boton_start.width/2 && mouseX < width/2+boton_start.width/2 && mouseY > 210 && mouseY < 210+boton_start.height)) {
+      estado = "main";
+    } 
+    vol_music.act();
+    vol_sound.act();   
+    image(boton_music, 172, 490);
+    image(boton_sound, 172, 550);
+  } else if (estado.equals("main")) {
+    image(fondo_menu[1], 0, 0);
+    if (input.click && mouseX >= 300 && mouseX < 500) {
+      if (mouseY >= 190 && mouseY < 240) {
+        estado = "juego";
+      }
+      if (mouseY >= 270 && mouseY < 315) {
+        estado = "level";
+      }
+      if (mouseY >= 340 && mouseY < 395) {
+        estado = "scoreboard";
+      }
+      if (mouseY >= 420 && mouseY < 470) {
+        estado = "options";
+      }
+      if (mouseY >= 495 && mouseY < 550) {
+        estado = "editor";
+      }
+    }
+  } else if(estado.equals("scoreboard") || estado.equals("level") || estado.equals("options") || estado.equals("gameover")){  //<>//
+    if (input.click && mouseX > 30 && mouseX < 85&&  mouseY >= 30 && mouseY < 85) {
+      estado = "main";
+    }
+    if (input.PAUSA.click) {
+      estado = "main";
+    } 
+  }
+  if (estado.equals("scoreboard")) {
+    image(fondo_menu[2], 0, 0);
+  } else if (estado.equals("level")) {
+    image(fondo_menu[3], 0, 0);
+    ArrayList<Nivel> niveles = editor.niveles.niveles;
+    float borde = boton_level.width/4;
+    float desx = boton_level.width+borde;
+    float desy = boton_level.height+borde;
+    float inix = (width-(desx*4-borde))/2;
+    float iniy = 160;
+    for (int i = 0; i < niveles.size (); i++) {
+      float x = inix + desx*(i%4);
+      float y = iniy + desy*(i/4);
+      image(boton_level, x, y);
+    }
+  } else if (estado.equals("options")) {
+    image(fondo_menu[4], 0, 0);
+    vol_music.x = 385;
+    vol_music.y = 195;
+    vol_music.act();
+    vol_sound.x = 385;
+    vol_sound.y = 255;
+    vol_sound.act();
+  } else if(estado.equals("gameover")){
+    
+  }
+}
 void cargarImagenes() {
   sprites = loadImage("img/sprites.png");
   sprites_cobra = recortarImagen(loadImage("img/sprites_cobra.png"), 100, 50, 1);
@@ -231,8 +228,8 @@ void cargarImagenes() {
   for (int i = 0; i < 5; i++) {
     img_arbol[i] = loadImage("img/arbol"+(i+1)+".png");
   }
-  fondo_menu = new PImage[5];
-  for (int i = 0; i < 5; i++) {
+  fondo_menu = new PImage[7];
+  for (int i = 0; i < 7; i++) {
     fondo_menu[i] = loadImage("img/fondomenu"+i+".png");
   }
   boton_start = recortar(sprites, 0, 352, 201, 50);
diff --git a/Nivel.pde b/Nivel.pde
index 0f71fec..c79550c 100644
--- a/Nivel.pde
+++ b/Nivel.pde
@@ -1,4 +1,4 @@
-class Nivel { //<>// //<>//
+class Nivel { //<>//
   ArrayList<Elemento> elementos;
   ArrayList<Enemigo> enemigos;
   ArrayList<PowerUp> powerups;
@@ -31,7 +31,7 @@ class Nivel { //<>// //<>//
       if (!aux.eliminar) aux.act();
     }
     jugador.act();
-    if (portal.toca){
+    if (portal.toca) {
       pasarNivel = true;
     }
     if (jugador.y >= nivel.h*tam+100) {
@@ -41,14 +41,12 @@ class Nivel { //<>// //<>//
     dibujar();
   }
   void dibujar() {
+    if(estado.equals("gameover")) return;
     pushMatrix();
     resetMatrix();
     if (!jugador.invisible) {    
-      //image(img_fondo[1], 0, 0);
-      //fill(180, 180, 255);
-      //rect(0, 0, width, height);
       translate(int(camara.x)/2, int(camara.y)/2);
-      image(arboles, 0, 0);
+      //image(arboles, 0, 0);
     }
     resetMatrix();
     fill(0, 40+jugador.invisibilidad*40);
@@ -57,7 +55,9 @@ class Nivel { //<>// //<>//
     dibujarTiles();
     for (int i = 0; i < elementos.size (); i++) {
       Elemento aux = elementos.get(i);
-      if (!aux.eliminar) aux.dibujar();
+      if (dist(aux.x, aux.y, jugador.x, jugador.y) < width) {
+        if (!aux.eliminar) aux.dibujar();
+      }
     }
     jugador.dibujar();
     if (jugador.invisible) {
@@ -488,7 +488,7 @@ class Nivel { //<>// //<>//
     trampas = new ArrayList<Trampa>();
     w = json.getInt("width");
     h = json.getInt("height");
-    if (frameCount > 0) { 
+    if (frameCount > 0 ) { 
       arboles = crearFondo();
     }
     //println((w*tam*2)-width, (h*tam*2)-height);
@@ -613,9 +613,9 @@ class Nivel { //<>// //<>//
     if (editor != null) {
       /*
       editor.ventanas.remove(editor.minimapa);
-      //editor.minimapa = new Minimapa(w, h);
-      editor.ventanas.add(editor.minimapa);
-      */
+       //editor.minimapa = new Minimapa(w, h);
+       editor.ventanas.add(editor.minimapa);
+       */
     }
   }
   boolean colisiona(Jugador ju) {
diff --git a/UI.pde b/UI.pde
index e002a89..599c5c0 100644
--- a/UI.pde
+++ b/UI.pde
@@ -16,10 +16,15 @@ class UI {
     if (tiempo < 0) {
       tiempo = max_tem;
     }
-    if (score >= 4000 && cant_vidas < 9) {
+    if (score >= 4000) {
       cant_vidas++;
       score -= 4000;
     }
+    if(cant_vidas <= 0){
+       estado = "gameover"; 
+       resetMatrix();
+       image(fondo_menu[6], 0, 0);
+    }
     if(score < 0) score = 0;
   }
   void dibujar() {
diff --git a/img/fondomenu2.png b/img/fondomenu2.png
index 9d130d5..2c3a62d 100644
Binary files a/img/fondomenu2.png and b/img/fondomenu2.png differ
diff --git a/img/sprites.png b/img/sprites.png
index 04569fb..97694e4 100644
Binary files a/img/sprites.png and b/img/sprites.png differ
