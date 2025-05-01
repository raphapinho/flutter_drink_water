import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrimeiroAcessoDialog extends StatefulWidget {
  final Function(double?) onPesoChanged;
  final Function(TimeOfDay?) onHorarioAcordarChanged;
  final Function(TimeOfDay?) onHorarioDormirChanged;

  const PrimeiroAcessoDialog({
    Key? key,
    required this.onPesoChanged,
    required this.onHorarioAcordarChanged,
    required this.onHorarioDormirChanged,
  }) : super(key: key);

  @override
  _PrimeiroAcessoDialogState createState() => _PrimeiroAcessoDialogState();
}

class _PrimeiroAcessoDialogState extends State<PrimeiroAcessoDialog> {
  final TextEditingController _pesoController = TextEditingController();
  TimeOfDay _horarioAcordar = TimeOfDay.now();
  TimeOfDay _horarioDormir = TimeOfDay.now();

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

  void _atualizarPeso(String valor) {
    final peso = double.tryParse(valor);
    widget.onPesoChanged(peso);
  }

  Future<void> _selecionarHorarioAcordar(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horarioAcordar,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (picked != null && picked != _horarioAcordar) {
      setState(() {
        _horarioAcordar = picked;
        widget.onHorarioAcordarChanged(_horarioAcordar);
      });
    }
  }

  Future<void> _selecionarHorarioDormir(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _horarioDormir,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (picked != null && picked != _horarioDormir) {
      setState(() {
        _horarioDormir = picked;
        widget.onHorarioDormirChanged(_horarioDormir);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Bem-vindo!"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Por favor, informe seus dados iniciais:"),
            const SizedBox(height: 20),
            const Text("Qual é o seu peso? (em kg): "),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _pesoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: "Ex: 70.5",
                  border: OutlineInputBorder(),
                ),
                onChanged: _atualizarPeso,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Qual o horário que você acorda?'),
            ElevatedButton(
              onPressed: () => _selecionarHorarioAcordar(context),
              child: Text(
                '${_horarioAcordar.format(context)}',
              ),
            ),
            const SizedBox(height: 10),
            const Text('Qual o horário que você vai dormir?'),
            ElevatedButton(
              onPressed: () => _selecionarHorarioDormir(context),
              child: Text(
                '${_horarioDormir.format(context)}',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Confirmar'),
          onPressed: () {
            Navigator.of(context).pop();
            _salvarPrimeiroAcesso();
            // Aqui você pode realizar alguma ação após o usuário confirmar os dados
          },
        ),
      ],
    );
  }

  Future<void> _salvarPrimeiroAcesso() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('primeiro_acesso', true);
  }
}

class ExemploUso extends StatefulWidget {
  const ExemploUso({Key? key}) : super(key: key);

  @override
  _ExemploUsoState createState() => _ExemploUsoState();
}

class _ExemploUsoState extends State<ExemploUso> {
  double? _pesoDaPessoa;
  TimeOfDay? _horarioAcordar;
  TimeOfDay? _horarioDormir;
  bool _primeiroAcesso = false;

  @override
  void initState() {
    super.initState();
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
      barrierDismissible:
          false, // Impede que o diálogo seja fechado ao tocar fora
      builder: (BuildContext context) {
        return PrimeiroAcessoDialog(
          onPesoChanged: _handlePesoChanged,
          onHorarioAcordarChanged: _handleHorarioAcordarChanged,
          onHorarioDormirChanged: _handleHorarioDormirChanged,
        );
      },
    );
  }

  void _handlePesoChanged(double? peso) {
    setState(() {
      _pesoDaPessoa = peso;
      print("Peso inserido: $_pesoDaPessoa kg");
    });
  }

  void _handleHorarioAcordarChanged(TimeOfDay? horario) {
    setState(() {
      _horarioAcordar = horario;
      print("Horário de acordar selecionado: $_horarioAcordar");
    });
  }

  void _handleHorarioDormirChanged(TimeOfDay? horario) {
    setState(() {
      _horarioDormir = horario;
      print("Horário de dormir selecionado: $_horarioDormir");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exemplo de Widget de Peso e Horários"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_primeiroAcesso) // Exibe algo após o primeiro acesso (opcional)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_pesoDaPessoa != null)
                    Text("Seu peso é: ${_pesoDaPessoa} kg")
                  else
                    const Text("Nenhum peso foi inserido."),
                  const SizedBox(height: 10),
                  if (_horarioAcordar != null)
                    Text(
                        "Você costuma acordar às: ${_horarioAcordar!.format(context)}")
                  else
                    const Text("Nenhum horário de acordar foi selecionado."),
                  const SizedBox(height: 10),
                  if (_horarioDormir != null)
                    Text(
                        "Você costuma dormir às: ${_horarioDormir!.format(context)}")
                  else
                    const Text("Nenhum horário de dormir foi selecionado."),
                ],
              )
            else
              const Center(
                  child:
                      CircularProgressIndicator()), // Enquanto verifica o primeiro acesso
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ExemploUso(),
  ));
}
