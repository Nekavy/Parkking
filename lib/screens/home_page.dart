import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = Set();
  final LatLng _center = LatLng(37.7749, -122.4194); // Default center
  String _errorMessage = '';
  List<dynamic> _searchResults = [];
  final String _apiKey = 'AIzaSyDdwdpjWLdkfnFwZnhtAG3z64cseSqcycc'; // Substituir pela tua chave da API

  // Função para buscar locais utilizando a Google Places API
  Future<void> _searchPlaces(String query) async {
    final Uri url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$_apiKey');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _searchResults = data['results'] ?? [];
          _errorMessage = _searchResults.isEmpty ? 'Nenhum local encontrado' : '';
        });
      } else {
        setState(() {
          _errorMessage =
              'Erro ao buscar locais. Código de status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao buscar locais: $e';
      });
    }
  }

  void _selectPlace(dynamic place) {
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    final placeName = place['name'];

    // Adicionar marcador e mover a câmara para a localização escolhida
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(place['place_id']),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: placeName),
      ));
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 14),
      ),
    );

    // Limpar resultados de pesquisa
    setState(() {
      _searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps - Pesquisa de Locais'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquise por um local',
                    suffixIcon: Icon(Icons.search),
                    errorText: _errorMessage.isEmpty ? null : _errorMessage,
                  ),
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      _searchPlaces(query);
                    } else {
                      setState(() {
                        _searchResults.clear();
                      });
                    }
                  },
                ),
                if (_searchResults.isNotEmpty)
                  Container(
                    height: 200, // Limitar altura da lista
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return ListTile(
                          title: Text(place['name']),
                          subtitle: Text(place['formatted_address'] ?? ''),
                          onTap: () {
                            _selectPlace(place);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              markers: _markers,
            ),
          ),
        ],
      ),
    );
  }
}
