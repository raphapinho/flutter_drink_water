// import 'package:flutter/material.dart';

class ItensModel {
  String name;
  double volume;
  String iconPath;

  ItensModel({
    required this.name,
    required this.volume,
    required this.iconPath,
  });

  static List<ItensModel> getItens() {
    return [
      ItensModel(
        name: 'Xícara',
        volume: 50.0,
        iconPath: 'assets/icons/cup-of-coffee-svgrepo-com.svg',
      ),
      ItensModel(
        name: 'Copo',
        volume: 150.0,
        iconPath: 'assets/icons/glass-of-water-svgrepo-com.svg',
      ),
      ItensModel(
        name: 'Garrafa',
        volume: 350.0,
        iconPath: 'assets/icons/water-plastic-svgrepo-com.svg',
      ),
      // ItensModel(
      //   name: 'Grande',
      //   volume: 500.0,
      //   iconPath: 'assets/icons/soap-bottle-svgrepo-com.svg',
      // ),
    ];
  }
}
