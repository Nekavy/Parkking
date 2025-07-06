import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/services/geohash_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdCreationPage extends StatefulWidget {
  @override
  _AdCreationPageState createState() => _AdCreationPageState();
}

class _AdCreationPageState extends State<AdCreationPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  LatLng _parkingLocation = LatLng(0, 0);
  GoogleMapController? _mapController;
  List<XFile> _images = [];
  final List<String> _priceOptions = ["€1/h", "€2/h", "€3/h"];
  String? _selectedPrice;

  final ImagePicker _picker = ImagePicker();
  final FBColRegInfoPark _fbColRegInfoPark = FBColRegInfoPark();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Novo Anúncio'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputField(_addressController, 'Morada do Parque', Icons.location_on, onChanged: _searchAddress),
            SizedBox(height: 16),
            _buildButton('Pesquisar Morada', Icons.map, _searchAddressFromField),

            SizedBox(height: 16),
            _buildInputField(_nameController, 'Nome do Parque', Icons.drive_eta),
            SizedBox(height: 16),
            _buildInputField(_descriptionController, 'Descrição', Icons.description, maxLines: 3),
            SizedBox(height: 16),

            _buildDropdown(),

            SizedBox(height: 16),
            _buildButton('Adicionar Fotos', Icons.camera_alt, _pickImages),
            _buildImageGrid(),

            SizedBox(height: 16),
            _buildMap(),

            SizedBox(height: 20),
            _buildCreateAdButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon, {int maxLines = 1, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPrice,
      decoration: InputDecoration(
        labelText: 'Preço por Hora (€)',
        prefixIcon: Icon(Icons.euro, color: Colors.grey[600]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
      items: _priceOptions.map((price) {
        return DropdownMenuItem<String>(
          value: price,
          child: Text(price),
        );
      }).toList(),
      onChanged: (value) => setState(() => _selectedPrice = value),
    );
  }

  Widget _buildButton(String text, IconData icon, Function() onPressed) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.blue),
        label: Text(text, style: TextStyle(fontSize: 16, color: Colors.blue)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.blue),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    if (_images.isEmpty) return SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _images.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(File(_images[index].path), fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: _parkingLocation, zoom: 15),
        onMapCreated: (controller) => _mapController = controller,
        markers: {
          Marker(markerId: MarkerId('parking_location'), position: _parkingLocation),
        },
      ),
    );
  }

  Widget _buildCreateAdButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _createAd,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text('Criar Anúncio', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() => _images = selectedImages);
    }
  }

  Future<void> _searchAddress(String value) async {
    if (value.isNotEmpty) {
      List<Location> locations = await locationFromAddress(value);
      if (locations.isNotEmpty) {
        setState(() {
          _parkingLocation = LatLng(locations.first.latitude, locations.first.longitude);
        });
        _mapController?.animateCamera(CameraUpdate.newLatLng(_parkingLocation));
      }
    }
  }

  Future<void> _searchAddressFromField() async {
    if (_addressController.text.isNotEmpty) {
      List<Location> locations = await locationFromAddress(_addressController.text);
      if (locations.isNotEmpty) {
        setState(() {
          _parkingLocation = LatLng(locations.first.latitude, locations.first.longitude);
        });
        _mapController?.animateCamera(CameraUpdate.newLatLng(_parkingLocation));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Morada não encontrada.')));
      }
    }
  }

  Future<void> _createAd() async {
    if (_addressController.text.isNotEmpty && _nameController.text.isNotEmpty && _selectedPrice != null) {
      try {
        // Convert XFile to File
        //List<File> imageFiles = _images.map((xfile) => File(xfile.path)).toList();

        // Generate a unique parkId
        String parkId = DateTime.now().millisecondsSinceEpoch.toString();

        // Call the registerPark method
        await _fbColRegInfoPark.registerPark(
          name: _nameController.text,
          address: _addressController.text,
          country: 'Portugal', // You can change this to a dynamic value if needed
          geohash: 'geohash', // You need to generate a geohash based on the coordinates
          lat: _parkingLocation.latitude,
          lng: _parkingLocation.longitude,
          parkId: parkId,
          price: _selectedPrice!,
          //images: imageFiles,
        );

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Anúncio criado com sucesso!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao criar anúncio: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preencha todos os campos.')));
    }
  }
}

class FBColRegInfoPark {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerPark({
    required String name,
    required String address,
    required String country,
    required String geohash,
    required double lat,
    required double lng,
    required String parkId,
    required String price,
    //required List<File> images,
  }) async {
    try {
      String userId = _auth.currentUser?.uid ?? "unknown_user";

      // Upload das imagens para Firebase Storage
      /*List<String> imageUrls = [];
      for (File image in images) {
        String filePath = 'parks/$parkId/${DateTime.now().millisecondsSinceEpoch}.jpg';
        TaskSnapshot snapshot = await _storage.ref(filePath).putFile(image);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }*/

      // Guardar os dados no Firestore
      await _firestore.collection('parks').doc(parkId).set({
        'name': name,
        'address': address,
        'country': country,
        'geohash': GeohashService().getGeohash(lat, lng),
        'coordinates': GeoPoint(lat, lng),
        'parkId': parkId,
        'price': price,
        'userid': userId,
        //'images': imageUrls, // URLs das imagens
      });
    } catch (e) {
      print('Erro ao registar parque: $e');
      rethrow;
    }
  }
}