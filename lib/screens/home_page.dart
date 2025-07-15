import 'dart:convert';
import 'chat_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'components/utils/calculator.dart';
import 'components/utils/menubar.dart';
import 'components/home/slide_menu.dart';
import 'components/home/filters.dart';
import 'components/services/geohash_service.dart';
import 'components/services/searchPontosByGeohash.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;
  Set<Marker> _markers = Set();
  final LatLng _center = LatLng(37.7749, -122.4194);

  String _errorMessage = '';
  List<dynamic> _searchResults = [];
  final String _apiKey = 'AIzaSyDdwdpjWLdkfnFwZnhtAG3z64cseSqcycc';

  List<Map<String, dynamic>> nearbyPlacesData = [];
  List<Map<String, dynamic>> filteredPlaces = [];

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

  void _selectPlace(dynamic place) async {
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    String geohash = GeohashService().getGeohash(lat, lng);
    print('Geohash gerado: $geohash');
    print('latelngfeed:$lat ,$lng');

    List<Map<String, dynamic>> pontos = await FirestoreService().searchPontosByGeohash(geohash);
    print('pontos:$pontos');

    Calculator calculator = Calculator();
    List<Map<String, dynamic>> nearbyPlaces = await calculator.calculate(lat, lng, pontos);
    print('nearplaces:$nearbyPlaces');

    setState(() {
      nearbyPlacesData = nearbyPlaces;
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(place['place_id']),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: place['name']),
      ));
      _searchResults.clear();
    });

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
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 10,
            ),
            onMapCreated: (controller) => mapController = controller,
            markers: _markers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
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
          SlideMenu(menuItems: nearbyPlacesData),
          FilterWidget(),
        ],
      ),
    );
  }
}
