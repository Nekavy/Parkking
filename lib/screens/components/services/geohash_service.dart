import 'package:dart_geohash/dart_geohash.dart';

class GeohashService {
  // Função para gerar o geohash com precisão padrão (precisão 5)
  String getGeohash(double latitude, double longitude) {
    // Usando o GeoHasher da biblioteca para gerar o geohash
    GeoHasher geoHasher = GeoHasher();
    return geoHasher.encode(latitude, longitude);
  }

  // Função para obter os vizinhos do geohash
  Map<String, String> getNeighbors(String geohash) {
    GeoHasher geoHasher = GeoHasher();
    return geoHasher.neighbors(geohash);
  }
}
