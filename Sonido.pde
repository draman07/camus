class Sonido {
  ArrayList<AudioSample> sounds;
  AudioSample beatle, firefly, ladybug, spider;
  AudioSample jump, invi;
  AudioPlayer musica_menu, musica_juego;
  int tiempoMusica;
  float volMusic, volSound;
  Sonido() {
    sounds = new ArrayList<AudioSample>();
    cargarSonidos();
  }
  void act() {
    actMusica();
    actSound();
  }
  void actMusica() {
    if (vol_music.mover || frameCount < 20) {
      volMusic = (float)(log(vol_music.val)/log(10.0)*20.0);
      musica_menu.setGain(volMusic);
      musica_juego.setGain(volMusic);
      datos.volMusic = vol_music.val;
    }
    if (estado.equals("juego")) {
      if (!musica_juego.isPlaying()) {
        volMusic = (float)(log(vol_music.val)/log(10.0)*20.0);
        tiempoMusica = 0;
        musica_juego.rewind();
        musica_juego.shiftGain(-50, volMusic, 200);
        musica_juego.loop();
        musica_menu.shiftGain(volMusic, -50, 200);
      }
      if (tiempoMusica > 8) musica_menu.pause();
    } else {
      if (!musica_menu.isPlaying()) {
        volMusic = (float)(log(vol_music.val)/log(10.0)*20.0);
        tiempoMusica = 0;
        musica_menu.rewind();
        musica_menu.shiftGain(-50, volMusic, 200);
        musica_menu.loop();
        musica_juego.shiftGain(volMusic, -50, 200);
      }
      if (tiempoMusica > 8) musica_juego.pause();
    }
    tiempoMusica++;
  }
  void actSound() {
    if (vol_sound.mover) {
      volSound = (float)(log(vol_sound.val)/log(10.0)*20.0);
      for (int i = 0; i < sounds.size (); i++) {
        sounds.get(i).setGain(volSound);
      }
      datos.volSound = vol_sound.val;
    }
  }
  void cargarSonidos() {
    musica_menu = minim.loadFile("sound/musica_menu.mp3", 2048);
    musica_juego = minim.loadFile("sound/musica_juego.mp3", 2048);
    musica_menu.rewind();
    musica_menu.pause();
    musica_juego.rewind();
    musica_juego.pause();
    volMusic = (float)(log(vol_music.val)/log(10.0)*20.0);

    beatle = minim.loadSample( "sound/powerUps/beatle.wav", 512);
    firefly = minim.loadSample( "sound/powerUps/firefly.wav", 512);
    ladybug = minim.loadSample( "sound/powerUps/ladybug.wav", 512);
    spider = minim.loadSample( "sound/powerUps/spider.wav", 512); 
    sounds.add(beatle);
    sounds.add(firefly);
    sounds.add(ladybug);
    sounds.add(spider);
    jump = minim.loadSample( "sound/leonJump.wav", 512);
    invi = minim.loadSample( "sound/leonInvis.wav", 512);
    sounds.add(jump);
    sounds.add(invi);
    volSound = (float)(log(vol_sound.val)/log(10.0)*20.0);
    for (int i = 0; i < sounds.size (); i++) {
      sounds.get(i).setGain(volSound);
    }
    //mouse_squeak = minim.loadSample( "sound/mouse_squeak.wav", 512);
    //vulture_screech = minim.loadSample( "sound/vulture_screech.wav", 512);
  }
  void stop() {
    musica_menu.close();
    musica_juego.close();
  }
}
