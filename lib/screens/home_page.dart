import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'components/utils/calculator.dart'; // Caminho para a classe
import 'components/home/slide_menu.dart'; // SlideMenu importado

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
  List<Map<String, dynamic>> nearbyPlacesData = [];

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = Set();
  final LatLng _center = LatLng(37.7749, -122.4194); // Posição inicial do mapa
  
  String _errorMessage = '';
  List<dynamic> _searchResults = [];
  final String _apiKey = 'AIzaSyDdwdpjWLdkfnFwZnhtAG3z64cseSqcycc'; // Substituir pela tua chave da API
  bool _isMenuVisible = false; // Controla a visibilidade do SlideMenu
  
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

  void _selectPlace(dynamic place) async{
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    final placeName = place['name'];
    //testes envio de cordenadas para a calculadora
    print("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWLatitude: $lat");  
    print("EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEELongitude: $lng");
    //calculator.calculate(lat, lng);
    Calculator calculator = Calculator();
    List<Map<String, dynamic>> nearbyPlaces = await calculator.calculate(lat, lng);
    nearbyPlacesData = nearbyPlaces;
    print(nearbyPlaces); // Ver a lista no terminal

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

    // Limpar resultados de pesquisa e mostrar o SlideMenu
    setState(() {
      _searchResults.clear();
      _isMenuVisible = true; // Mostrar SlideMenu após mover o mapa
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // O conteúdo principal, como o mapa
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10,
            ),
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: _markers,
          ),
          // O menu de pesquisa sobre o mapa
          Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquise por um local',
                    suffixIcon: Icon(Icons.search),
                    errorText: _errorMessage.isEmpty ? null : _errorMessage,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      height: 200,
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
                  ),
              ],
            ),
          ),
          // O SlideMenu que ficará sobre o mapa, visível após a pesquisa
          if (_isMenuVisible)
            SlideMenu(menuItems: nearbyPlacesData),  // Exibe o SlideMenu quando a pesquisa for realizada
        ],
      ),
    );
  }
}
