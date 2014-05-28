class UI {
  int max_tem;
  int tiempo, score;
  UI(int t) {
    max_tem = t;
    iniciar();
  }
  void iniciar() {
    score = 0; 
    tiempo = max_tem;
  }
  void act() {
    if (!pausa && frameCount%60 == 0) tiempo = max_tem--;
    if (tiempo < 0) {
      tiempo = max_tem;
    }
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
    int vida = (frameCount/120)%10; 
    fill(#a60F00);
    textAlign(CENTER, CENTER);
    textFont(font_chiqui, 22);
    text(vida, 179, 40);
    image(recortar(sprites, 340, 96, 138, 40), width/2-69, cy);
    textFont(font_chiqui, 13);
    textAlign(LEFT, DOWN);
    fill(#00592B);
    int minuto = tiempo/60;
    int segundo = tiempo%60;
    //if(frameCount%60 == 0) println(tiempo, minuto, segundo);
    String msn = "Time ";
    msn += minuto+":";
    if (segundo < 10) msn += "0";
    msn += segundo;
    text(msn, width/2-31, 36);
    text("Score: "+score, width/2-46, 54);
  }
  void maScore(int sco) {
    score += sco;
  }
}
