import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/store_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StoreService _service = StoreService();
  List<String> _categories = [];
  bool _isLoading = true;

  final Map<String, IconData> _iconoCategoria = {
    'electronics': Icons.devices,
    'jewelery': Icons.diamond,
    "men's clothing": Icons.man,
    "women's clothing": Icons.woman,
  };

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _service.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  // Verifica si estamos entre 10am y 4pm
  bool get _isExpressHour {
    final now = TimeOfDay.now();
    final hour = now.hour;
    return hour >= 10 && hour < 16;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 204, 0, 1),
        title: SizedBox(
          height: 40,
          width: screenWidth > 600 ? 500 : double.infinity,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Busca en tu app',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(Icons.person),
              ),
            ],
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {},
              ),
              if (cart.totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor: const Color(0xFFD93A2F),
                      child: Text(
                        '${cart.totalItems}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 30,
                  decoration: BoxDecoration(color: Colors.black),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.location_on, color: Colors.amber),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(right: 16),
                        ),
                      ),
                      Text(
                        '¿Cómo quieres recibir tu pedido?',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(left: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: (Icon(Icons.edit, color: Colors.amber)),
                      ),
                    ],
                  ),
                ),
                // Switcher express solo visible entre 10am y 4pm
                if (_isExpressHour)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Activar experiencia express',
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          activeThumbColor: Colors.black,
                          activeTrackColor: Color.fromRGBO(255, 204, 0, 1),
                          focusColor: Colors.red,
                          value: cart.isExpressActive,
                          onChanged: (value) => cart.toggleExpress(value),
                        ),
                      ],
                    ),
                  ),
                // Grilla de categorías
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600
                          ? 4
                          : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return GestureDetector(
                        onTap: () => context.go('/products/$category'),
                        child: Card(
                          elevation: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_iconoCategoria[category] ?? Icons.category),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
