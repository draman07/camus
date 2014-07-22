class Datos {  
  boolean terminaste;
  JSONArray nivelesPasados;
  JSONObject jdatos;
  int tiempoJugado, cantidadMuertes, totalPuntos;
  float volMusic, volSound;
  Datos() {
    cargarDatos();
  }
  void act() {
  }
  void cargarDatos() {
    File file = new File(sketchPath("datos.json"));
    if (file.exists()) {
      jdatos = loadJSONObject("datos.json");
      terminaste = jdatos.getBoolean("terminaste");
      nivelesPasados = jdatos.getJSONArray("nivelesPasados");
      tiempoJugado = jdatos.getInt("tiempoJugado");
      cantidadMuertes = jdatos.getInt("cantidadMuertes");
      totalPuntos = jdatos.getInt("totalPuntos");
      volMusic = jdatos.getFloat("volMusic");
      volSound = jdatos.getFloat("volSound");
    } else {
      tiempoJugado = 0;
      cantidadMuertes = 0;
      totalPuntos = 0;
      volMusic = 0.8;
      volSound = 0.8;
      terminaste = false;
      nivelesPasados = new JSONArray();
      jdatos =  new JSONObject();
    }
    guardar();
  }
  void guardar() {
    jdatos.setBoolean("terminaste", terminaste);
    jdatos.setJSONArray("nivelesPasados", nivelesPasados);
    jdatos.setInt("tiempoJugado", tiempoJugado);
    jdatos.setInt("cantidadMuertes", cantidadMuertes);
    jdatos.setInt("totalPuntos", totalPuntos);
    jdatos.setFloat("volMusic", volMusic);
    jdatos.setFloat("volSound", volSound);
    saveJSONObject(jdatos, "datos.json");
  }
}
