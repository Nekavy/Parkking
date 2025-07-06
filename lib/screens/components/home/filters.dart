import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  bool _isFilterVisible = false;
  double _kmRange = 10.0; // Range de km
  double _priceRange = 100.0; // Range de preço
  String _selectedCategory = 'Todos'; // Categoria selecionada
  double _rating = 0.0; // Rating selecionado

  void _toggleFilter() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Botão de filtro mais para baixo
       Positioned(
        top: MediaQuery.of(context).size.height * 0.20, // 75% de altura da tela
        right: 16.0,
        child: FloatingActionButton(
          onPressed: _toggleFilter,
          child: Icon(Icons.filter_list),
          mini: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),

        // Página de filtros em tela cheia
        if (_isFilterVisible)
          Positioned.fill(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false, // Remove o botão de voltar padrão
                title: Text('Filtros'),
                leading: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: _toggleFilter, // Fecha a página de filtros
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Aplicar filtros
                      print('Filtros aplicados:');
                      print('Km: $_kmRange');
                      print('Preço: $_priceRange');
                      print('Categoria: $_selectedCategory');
                      print('Rating: $_rating');
                      _toggleFilter(); // Fecha a página após aplicar
                    },
                    child: Text(
                      'Aplicar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filtro de Range de Km
                    Text(
                      'Distância (km)',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _kmRange,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: _kmRange.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _kmRange = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Filtro de Range de Preço
                    Text(
                      'Preço Máximo',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _priceRange,
                      min: 0,
                      max: 1000,
                      divisions: 10,
                      label: _priceRange.toStringAsFixed(0),
                      onChanged: (value) {
                        setState(() {
                          _priceRange = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),

                    // Filtro de Categoria
                    Text(
                      'Categoria',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: _selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      items: ['Todos', 'Restaurantes', 'Hotéis', 'Lojas', 'Parques']
                          .map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20),

                    // Filtro de Rating
                    Text(
                      'Avaliação Mínima',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Slider(
                      value: _rating,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _rating.toStringAsFixed(1),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}