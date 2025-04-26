import 'dart:async';
import 'package:drink_water/models/itens_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'navBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  double percentage = 0.0;
  double tiltX = 0.0;
  double tiltY = 0.0;
  double aguaTotal = 0.0;
  final double totalWater = 80 * 35;

  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  StreamSubscription? _accelerometerSubscription;

  void _howMuchWater(double water) {
    setState(() {
      aguaTotal += water;
      percentage = (aguaTotal / totalWater * 100).clamp(0.0, 100.0);
    });
  }

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
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final List<ItensModel> waterItems = ItensModel.getItens();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DrinkWater',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: const Color.fromRGBO(43, 44, 86, 1),
      bottomNavigationBar: BottomNavBar(),
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
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${percentage.toInt()} %',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      wordSpacing: 3,
                      color: Colors.white.withOpacity(.7),
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
                            .map((item) => _buildWaterItem(item, _howMuchWater))
                            .toList(),
                        _buildCustomWaterCard(context), // Add the new card here
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total de água consumida: ${aguaTotal.toInt()} ml',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Faltam: ${(totalWater - aguaTotal).toInt()} ml',
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

  Widget _buildWaterItem(ItensModel item, Function(double) onWaterAdded) {
    return GestureDetector(
      onTap: () {
        onWaterAdded(item.volume);
      },
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
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
      onTap: () {
        _showAddWaterDialog(context);

      },
      child: Card(
        color: Colors.white.withAlpha(100),
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/plus.svg',
                height: 40,
                width: 40,
              ),
              const SizedBox(height: 4),
              const Text(
                'Adicionar',
                style: TextStyle(
                  color: Color.fromARGB(179, 22, 14, 14),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              const Text(
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
    final TextEditingController _textController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Água'),
          content: TextField(
            controller: _textController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Quantidade em ml',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Adicionar'),
              onPressed: () {
                final water = double.tryParse(_textController.text) ?? 0.0;
                _howMuchWater(water);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
