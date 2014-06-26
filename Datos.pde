class Datos {  
  JSONObject jdatos;
  int tiempoJugado, cantidadMuertes, totalPuntos;
  Datos() {
    cargarDatos();
  }
  void act() {
  }
  void cargarDatos() {
    File file = new File(sketchPath("datos.json"));
    if (file.exists()) {
      jdatos = loadJSONObject("datos.json");
      tiempoJugado = jdatos.getInt("tiempoJugado");
      cantidadMuertes = jdatos.getInt("cantidadMuertes");
      totalPuntos = jdatos.getInt("totalPuntos");
    } else {
      tiempoJugado = 0;
      cantidadMuertes = 0;
      totalPuntos = 0;
      jdatos =  new JSONObject();
    }
    guardar();
  }
  void guardar() {
    jdatos.setInt("tiempoJugado", tiempoJugado);
    jdatos.setInt("cantidadMuertes", cantidadMuertes);
    jdatos.setInt("totalPuntos", totalPuntos);
    saveJSONObject(jdatos, "datos.json");
  }
}
