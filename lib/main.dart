// import 'dart:async';
import 'package:drink_water/telas/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(
    
    MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: const HomePage(),
      title: "Water-Animation",
      theme: ThemeData(fontFamily: 'Poppins'),
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

