import 'package:flutter/material.dart';

class ConsumoProvider with ChangeNotifier {
  double _aguaTotal = 0.0;
  final double _totalWater = 80 * 35; // Total da meta

  double get aguaTotal => _aguaTotal;
  double get totalWater => _totalWater;
  double get percentage => (_aguaTotal / _totalWater * 100).clamp(0.0, 100.0);

  void adicionarAgua(double quantidade) {
    _aguaTotal += quantidade;
    notifyListeners(); // Atualiza a interface
  }
}
