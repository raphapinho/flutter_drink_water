import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drink_water/models/itens_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double percentage = 0.0;
  double tiltX = 0.0;
  double tiltY = 0.0;
  double aguaTotal = 0.0;
  double totalWater = 0.0;



  late final AnimationController _waveController;
  late final Animation<double> _waveAnimation;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;

  bool _primeiroAcesso = false;
  double? _pesoDaPessoa;
  TimeOfDay? _horarioAcordar;
  TimeOfDay? _horarioDormir;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        tiltX = event.x.clamp(-10.0, 10.0) / 10.0;
        tiltY = event.y.clamp(-10.0, 10.0) / 10.0;
      });
    });

    _verificarPrimeiroAcesso();
  }

  Future<void> _verificarPrimeiroAcesso() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _primeiroAcesso = prefs.getBool('primeiro_acesso') ?? false;
    });

    if (!_primeiroAcesso) {
      _mostrarDialogPrimeiroAcesso(context);
    }
  }

  Future<void> _mostrarDialogPrimeiroAcesso(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bem-vindo!"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Por favor, informe seus dados iniciais:"),
                const SizedBox(height: 20),
                const Text("Qual é o seu peso? (em kg): "),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: "Ex: 70.5",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _pesoDaPessoa = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Qual o horário que você acorda?'),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _horarioAcordar ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _horarioAcordar = picked;
                      });
                    }
                  },
                  child: Text(_horarioAcordar?.format(context) ?? 'Selecionar'),
                ),
                const SizedBox(height: 10),
                const Text('Qual o horário que você vai dormir?'),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _horarioDormir ?? TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        _horarioDormir = picked;
                      });
                    }
                  },
                  child: Text(_horarioDormir?.format(context) ?? 'Selecionar'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Confirmar'),
              onPressed: () {
                if (_pesoDaPessoa != null) {
                  totalWater = _pesoDaPessoa! * 30;
                }
                Navigator.of(context).pop();
                _salvarPrimeiroAcesso();
                setState(() {}); // atualiza UI com os novos valores
                print('Peso: $_pesoDaPessoa');
                print('Acordar: $_horarioAcordar');
                print('Dormir: $_horarioDormir');
                print(
                    'Intervalo de consumo: ${_calcularIntervaloDeConsumo()} horas');
              },
            ),

          ],
        );
      },
    );
  }

  Future<void> _salvarPrimeiroAcesso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('primeiro_acesso', true);
  }

  void _howMuchWater(double water) {
    setState(() {
      aguaTotal += water;
      percentage = (aguaTotal / totalWater * 100).clamp(0.0, 100.0);
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final waterItems = ItensModel.getItens();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DrinkWater',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(43, 44, 86, 1),
      body: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              CustomPaint(
                painter: MyPainter(
                  waveOffset: _waveAnimation.value,
                  tiltX: tiltX,
                  tiltY: tiltY,
                  percentage: percentage,
                ),
                child: SizedBox(height: size.height, width: size.width),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${percentage.toInt()} %',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    textScaleFactor: 7,
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.5,
                      children: [
                        ...waterItems
                            .map((item) => _buildWaterItem(item))
                            .toList(),
                        _buildCustomWaterCard(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total de água consumida: ${aguaTotal.toInt()} ml',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Text(
                    (totalWater - aguaTotal) > 0
                        ? 'Faltam: ${(totalWater - aguaTotal).toInt()} ml'
                        : 'Parabéns, você alcançou a meta diária!',
                    style: TextStyle(
                      color: (totalWater - aguaTotal) > 0
                          ? Colors.orangeAccent
                          : Colors.greenAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWaterItem(ItensModel item) {
    return GestureDetector(
      onTap: () => _howMuchWater(item.volume),
      child: Card(
        color: Colors.white.withAlpha(200),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(item.iconPath, height: 40),
              const SizedBox(height: 4),
              Text(
                item.name,
                style: const TextStyle(
                  color: Color.fromARGB(179, 22, 14, 14),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.volume.toInt()} ml',
                style: const TextStyle(
                  color: Color.fromARGB(179, 22, 14, 14),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomWaterCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddWaterDialog(context),
      child: Card(
        color: Colors.white.withAlpha(100),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(height: 40, child: Icon(Icons.add, size: 40)),
              SizedBox(height: 4),
              Text(
                'Adicionar',
                style: TextStyle(
                  color: Color.fromARGB(179, 22, 14, 14),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Manual',
                style: TextStyle(
                  color: Color.fromARGB(179, 22, 14, 14),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddWaterDialog(BuildContext context) async {
    final textController = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Adicionar Água'),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Quantidade em ml'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final water = double.tryParse(textController.text) ?? 0.0;
                _howMuchWater(water);
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  double _calcularIntervaloDeConsumo() {
    if (_horarioAcordar == null || _horarioDormir == null || totalWater == 0) {
      return 0;
    }

    final acordar = _horarioAcordar!;
    final dormir = _horarioDormir!;

    int minutosAcordado = ((dormir.hour * 60 + dormir.minute) -
        (acordar.hour * 60 + acordar.minute));

    // Caso o horário de dormir seja no dia seguinte
    if (minutosAcordado <= 0) {
      minutosAcordado += 24 * 60;
    }

    final horasAcordado = minutosAcordado / 60.0;

    // Dividimos a quantidade de água total pela quantidade de ingestões ideais (200ml por ingestão)
    int ingestoes = (totalWater / 200).ceil();

    if (ingestoes == 0) return horasAcordado;

    return horasAcordado / ingestoes;
  }

}

class MyPainter extends CustomPainter {
  final double waveOffset;
  final double tiltX;
  final double tiltY;
  final double percentage;

  MyPainter({
    required this.waveOffset,
    required this.tiltX,
    required this.tiltY,
    required this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xff3B6ABA).withOpacity(.8)
      ..style = PaintingStyle.fill;

    final waterLevel = size.height * (1 - percentage / 100);

    final path = Path()
      ..moveTo(0, waterLevel + waveOffset + tiltY * 20)
      ..cubicTo(
        size.width * .3,
        waterLevel + waveOffset * 1.5 + tiltX * 20,
        size.width * .7,
        waterLevel - waveOffset * 1.5 + tiltX * -20,
        size.width,
        waterLevel + waveOffset + tiltY * 20,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MyPainter oldDelegate) {
    return waveOffset != oldDelegate.waveOffset ||
        tiltX != oldDelegate.tiltX ||
        tiltY != oldDelegate.tiltY ||
        percentage != oldDelegate.percentage;
  }
}

