import 'package:drink_water/telas/navBar.dart';
import 'package:flutter/material.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  // Dados de exemplo do histórico de consumo de água
  final List<RegistroConsumo> _historicoConsumo = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavBar(),
      appBar: AppBar(
        title: const Text('Histórico de Consumo',style: TextStyle(
          color: Color.fromARGB(255, 253, 253, 253),
          fontSize: 25,
          fontWeight: FontWeight.w600
        ),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      backgroundColor: const Color.fromRGBO(43, 44, 86, 1),
      body:
       _historicoConsumo.isEmpty
          ? const Center(
              child: Text('Nenhum registro de consumo encontrado.'),
            )
          : ListView.builder(
              itemCount: _historicoConsumo.length,
              itemBuilder: (context, index) {
                final registro = _historicoConsumo[index];
                final double percentage =
                    (registro.quantidade / registro.metaDiaria).clamp(0.0, 1.0);

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Stack(
                    children: [
                      // Barra de fundo cinza
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 60, // Altura do card
                      ),
                      // Barra de carregamento azul
                      FractionallySizedBox(
                        widthFactor: percentage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          height: 60, // Mesma altura do card
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${registro.data.day}/${registro.data.month}/${registro.data.year}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.black87),
                            ),
                            Text(
                              '${registro.quantidade} / ${registro.metaDiaria} ml',
                              style: const TextStyle(color: Colors.black87,fontSize: 16),
                              
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// Modelo para representar um registro de consumo
class RegistroConsumo {
  final DateTime data;
  final int quantidade;
  final int metaDiaria; // Adicionamos a meta diária

  RegistroConsumo({
    required this.data,
    required this.quantidade,
    this.metaDiaria = 2000, // Define uma meta padrão
  });
}
