import 'package:flutter/material.dart';
import 'package:prueba_tecnica_exito/models/product_model.dart';

class CartProvider extends ChangeNotifier{
  // Carrito normal: mapa de producto -> cantidad
  final Map<int, int> _normalCart = {};
  // Carrito normal: mapa de producto -> cantidad
  final Map<int, int> _expressCart = {};
  //  Guarda los productos agregados al carrito 
  final Map<int, Product> _products = {};

  // Estado del swhitch express
  bool _isExpressActive = false;

  bool get isExpressActive => _isExpressActive;

  //Cambia el modo express
  void toggleExpress(bool value){
    _isExpressActive = value;
    notifyListeners();
  }

  // Carrito activo segun el modo
  Map<int, int> get _activeCart => _isExpressActive ? _expressCart : _normalCart;

  // Obtener cantidad carrito activo
  int getQuantity(int productId) { 
    return _activeCart[productId] ?? 0;
  }

  void addProduct(Product product){
    _products[product.id] = product;
    _activeCart[product.id] = (_activeCart[product.id] ?? 0) + 1;
    notifyListeners();
  }

  void removeProduct(int productId) {
    if(_activeCart.containsKey(productId)){
      if(_activeCart[productId]! <= 1) {
        _activeCart.remove(productId);
      }else {
        _activeCart[productId] = _activeCart[productId]! - 1;
      }
      notifyListeners();
    }
  }
// Total de items en el carrito activo
int get totalItems {
  return _activeCart.values.fold(0, (sum, qty) => sum + qty);
}

}