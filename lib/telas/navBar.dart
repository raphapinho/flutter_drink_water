import 'package:flutter/material.dart';
import 'historico.dart'; // Importe a tela do Histórico
import 'home.dart'; // Importe a tela da HomePage

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    const HomePage(), // Use a HomePage como a primeira tela
    const Historico(), // Use a tela de Histórico
  ];

  void _onTapTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
    // Navega para a tela correspondente usando o Navigator
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => _telas[_indiceAtual]),
    );
    print('Tela $_indiceAtual selecionada');
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      currentIndex: _indiceAtual,
      onTap: _onTapTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.water_drop),
          label: 'Histórico',
        ),
      ],
    );
  }
}

// Supondo que você tenha um widget para exibir as páginas
class NewPageScreen extends StatelessWidget {
  final String title;
  const NewPageScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tela: $title'),
    );
  }
}
