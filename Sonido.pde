class Sonido {
  AudioSample mouse_squeak, vulture_screech;
  AudioPlayer musica_menu, musica_juego;
  Sonido() {
    cargarSonidos();
  }
  void act() {
    if(vol_music.mover){
      musica_menu.setGain(vol_music.val);
      musica_juego.setGain(vol_music.val);
    }
    if(estado.equals("juego")){
       if(!musica_juego.isPlaying())  musica_juego.play();
       if(musica_menu.isPlaying())  musica_menu.pause();
    }else{
       if(!musica_menu.isPlaying())  musica_menu.play();
       if(musica_juego.isPlaying())  musica_juego.pause();
    }
  }
  void cargarSonidos() {
    musica_menu = minim.loadFile("sound/musica_menu.mp3", 512);
    musica_juego = minim.loadFile("sound/musica_juego.mp3", 512);
    //mouse_squeak = minim.loadSample( "sound/mouse_squeak.wav", 512);
    //vulture_screech = minim.loadSample( "sound/vulture_screech.wav", 512);
  }
}
