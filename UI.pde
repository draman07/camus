class UI {
  int max_tem;
  int cant_vidas;
  int tiempo, score, powers;
  UI(int t) {
    max_tem = t;
    iniciar();
  }
  void iniciar() {
    if(score != 0) datos.totalPuntos += score;
    score = 0; 
    cant_vidas = 2;
    powers = 0;
    tiempo = max_tem;
  }
  void act() {
    if (!pausa && frameCount%60 == 0) tiempo--;
    if (tiempo < 0) {
      tiempo = max_tem;
    }
    if (score >= 4000) {
      cant_vidas++;
      score -= 4000;
    }
    if (cant_vidas <= 0) {
      cambiarEstado("gameover"); 
      resetMatrix();
      image(fondo_menu[6], 0, 0);
    }
    if (score < 0) score = 0;
  }
  void dibujar() {
    int cx = 20;
    int cy = 20;
    image(recortar(sprites, 160, 96, 180, 40), cx, cy);
    int desx = int(110*nivel.jugador.vida);
    if (desx > 0) {
      image(recortar(sprites, 160, 136, 10+desx, 18), cx+12, cy+4);
      image(recortar(sprites, 280, 136, 10, 18), cx+22+desx, cy+4);
    }
    desx = int(91*nivel.jugador.invisibilidad);
    if (desx > 0) {
      image(recortar(sprites, 160, 154, 5+desx, 10), cx+22, cy+26);
      image(recortar(sprites, 256, 154, 4, 10), cx+27+desx, cy+26);
    } 
    //fill(#a60F00);
    fill(#00592B);
    image(recortar(sprites, 340, 96, 138, 40), width/2-69, cy);
    textFont(font_chiqui, 13);
    textAlign(LEFT, DOWN);
    text("Time "+stringTime(tiempo), width/2-33, 36);
    text("Score: "+score, width/2-46, 54);
    fill(#EDD9D7);
    textFont(font_chiqui22);
    textAlign(CENTER, CENTER);
    text(cant_vidas, 178, 38);
  }
  void maScore(int sco) {
    score += sco;
  }
  void setTime(int t) {
    max_tem = tiempo = t;
  }
}

String stringTime(int tiempo) {
  int minuto = tiempo/60;
  int segundo = tiempo%60;
  String t = "";
  t += minuto+":";
  if (segundo < 10) t += "0";
  t += segundo;
  return t;
}
