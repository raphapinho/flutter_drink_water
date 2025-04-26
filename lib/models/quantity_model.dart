class RegistroConsumo {
  final DateTime data;
  final int quantidade;
  final int metaDiaria; // Adicionamos a meta diária

  RegistroConsumo({
    required this.data,
    required this.quantidade,
    this.metaDiaria = 2000, // Define uma meta padrão
  });

   final List<RegistroConsumo> historicoConsumo = [
    RegistroConsumo(
        data: DateTime(2025, 4, 20), quantidade: 1500, metaDiaria: 2000),
    RegistroConsumo(
        data: DateTime(2025, 4, 21), quantidade: 2000, metaDiaria: 2000),
    RegistroConsumo(
        data: DateTime(2025, 4, 22), quantidade: 1200, metaDiaria: 2000),
    RegistroConsumo(
        data: DateTime(2025, 4, 23), quantidade: 1800, metaDiaria: 2000),
    RegistroConsumo(
        data: DateTime(2025, 4, 24), quantidade: 2500, metaDiaria: 2000),
    RegistroConsumo(
        data: DateTime(2025, 4, 25), quantidade: 1000, metaDiaria: 2000),
    RegistroConsumo(
        data: DateTime(2025, 4, 26), quantidade: 800, metaDiaria: 2000),
  ];

}
