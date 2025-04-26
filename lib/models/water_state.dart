class WaterState {
  static final WaterState _instance = WaterState._internal();

  factory WaterState() {
    return _instance;
  }

  WaterState._internal();

  double aguaTotal = 0.0;
  final double totalWater = 80 * 35; // igual no seu código

  double get percentage {
    return (aguaTotal / totalWater * 100).clamp(0.0, 100.0);
  }

  void addWater(double amount) {
    aguaTotal += amount;
  }

  void reset() {
    aguaTotal = 0.0;
  }
}
