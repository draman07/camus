class Sonido {
  AudioSample mouse_squeak, vulture_screech;
  AudioPlayer musica_menu, musica_juego;
  int tiempoMusica;
  float volMusic, volSound;
  Sonido() {
    cargarSonidos();
  }
  void act() {
    actMusica();
  }
  void actMusica() {
    if (vol_music.mover) {
      volMusic = (float)(log(vol_music.val)/log(10.0)*20.0);
      musica_menu.setGain(volMusic);
      musica_juego.setGain(volMusic);
      datos.volMusic = vol_music.val;
    }
    if (estado.equals("juego")) {
      if (!musica_juego.isPlaying()) {
        tiempoMusica = 0;
        musica_juego.shiftGain(-50, volMusic, 200);
        musica_juego.rewind();
        musica_juego.loop();
        musica_menu.shiftGain(volMusic, -60, 800);
      }
      if (tiempoMusica > 60) musica_menu.pause();
    } else {
      if (!musica_menu.isPlaying()) {
        tiempoMusica = 0;
        musica_menu.shiftGain(-50, volMusic, 200);
        musica_menu.rewind();
        musica_menu.loop();
        musica_juego.shiftGain(volMusic, -60, 800);
      }
      if (tiempoMusica > 60) musica_juego.pause();
    }
    tiempoMusica++;
  }
  void actSound() {
    if (vol_sound.mover) {
      volSound = (float)(log(vol_sound.val)/log(10.0)*20.0);
      datos.volSound = vol_sound.val;
    }
  }
  void cargarSonidos() {
    musica_menu = minim.loadFile("sound/musica_menu.mp3", 2048);
    musica_juego = minim.loadFile("sound/musica_juego.mp3", 2048);
    volMusic = (float)(log(vol_music.val)/log(10.0)*20.0);
    musica_menu.setGain(volMusic);
    musica_juego.setGain(volMusic);


    volSound = (float)(log(vol_sound.val)/log(10.0)*20.0);
    //mouse_squeak = minim.loadSample( "sound/mouse_squeak.wav", 512);
    //vulture_screech = minim.loadSample( "sound/vulture_screech.wav", 512);
  }
  void stop() {
    musica_menu.close();
    musica_juego.close();
  }
}
