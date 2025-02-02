// Importações necessárias para o funcionamento do app
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'components/utils/calculator.dart';
import 'components/utils/menubar.dart';
import 'components/home/slide_menu.dart';

// [CLASSE EXTERNA: HomePageLogic] - Toda a lógica de estado poderia ser movida para uma classe controller
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// [CLASSE EXTERNA: MapService] - Gestão do mapa e marcadores
// [CLASSE EXTERNA: PlacesRepository] - Lógica de chamadas à API
class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = Set();
  final LatLng _center = LatLng(37.7749, -122.4194);
  
  // [CLASSE EXTERNA: SearchService] - Gestão de estado da pesquisa
  String _errorMessage = '';
  List<dynamic> _searchResults = [];
  final String _apiKey = 'AIzaSyDdwdpjWLdkfnFwZnhtAG3z64cseSqcycc';
  
  // [CLASSE EXTERNA: MenuController] - Controle de visibilidade do menu
  bool _isMenuVisible = false;
  List<Map<String, dynamic>> nearbyPlacesData = [];

  // [CLASSE EXTERNA: PlacesRepository] - Método deveria estar em um serviço de API
  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _errorMessage = '';
      });
      return;
    }

    final Uri url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$_apiKey'
    );

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
          _errorMessage = 'Erro: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro de conexão: $e';
      });
    }
  }

  // [CLASSE EXTERNA: LocationService] - Lógica de processamento de localização
  void _selectPlace(dynamic place) async {
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    
    Calculator calculator = Calculator();
    List<Map<String, dynamic>> nearbyPlaces = await calculator.calculate(lat, lng);
    
    setState(() {
      nearbyPlacesData = nearbyPlaces;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(place['place_id']),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: place['name']),
      ));
      _searchResults.clear();
      _isMenuVisible = true;
    });

    // [CLASSE EXTERNA: MapAnimations] - Animação deveria ser gerenciada separadamente
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // [CLASSE EXTERNA: CustomMapWidget] - Widget de mapa personalizado
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10,
            ),
            onMapCreated: (controller) => mapController = controller,
            markers: _markers,
          ),

          // [CLASSE EXTERNA: SearchComponent] - Componente de pesquisa reutilizável
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
                  ),
                  onChanged: (query) => _searchPlaces(query),
                ),

                // [CLASSE EXTERNA: ResultsList] - Lista de resultados modularizada
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
                            onTap: () => _selectPlace(place),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // [CLASSE EXTERNA: SlideMenuController] - Gestão do estado do menu
          if (_isMenuVisible)
            SlideMenu(menuItems: nearbyPlacesData),
        ],
      ),
      bottomNavigationBar: BottomMenuBar("Mapa"),
    );
  }
}