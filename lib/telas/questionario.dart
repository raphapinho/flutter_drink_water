import 'package:flutter/material.dart';

class PesoHorarioWidget extends StatefulWidget {
  final Function(double?) onPesoChanged;
  final Function(TimeOfDay?) onHorarioAcordarChanged;
  final Function(TimeOfDay?) onHorarioDormirChanged;

  const PesoHorarioWidget({
    Key? key,
    required this.onPesoChanged,
    required this.onHorarioAcordarChanged,
    required this.onHorarioDormirChanged,
  }) : super(key: key);

  @override
  _PesoHorarioWidgetState createState() => _PesoHorarioWidgetState();
}

class _PesoHorarioWidgetState extends State<PesoHorarioWidget> {
  final TextEditingController _pesoController = TextEditingController();
  double? _peso;
  TimeOfDay _horarioAcordar = TimeOfDay.now();
  TimeOfDay _horarioDormir = TimeOfDay.now();

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

  void _atualizarPeso(String valor) {
    setState(() {
      _peso = double.tryParse(valor);
      widget.onPesoChanged(_peso);
    });
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Qual é o seu peso? (em kg): "),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: TextField(
              controller: _pesoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                hintText: "Ex: 70.5",
              ),
              onChanged: _atualizarPeso,
            ),
          ),
          const Text(" kg"),
          const SizedBox(height: 20),
          const Text('Qual o horário que você acorda?'),
          ElevatedButton(
            onPressed: () => _selecionarHorarioAcordar(context),
            child: Text(
              '${_horarioAcordar.format(context)}',
            ),
          ),
          const SizedBox(height: 20),
          const Text('Qual o horário que você vai dormir?'),
          ElevatedButton(
            onPressed: () => _selecionarHorarioDormir(context),
            child: Text(
              '${_horarioDormir.format(context)}',
            ),
          ),
        ],
      ),
    );
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

  void _handlePesoChanged(double? peso) {
    setState(() {
      _pesoDaPessoa = peso;
      print("Peso inserido: $_pesoDaPessoa kg");
      // Aqui você pode usar o valor do peso como precisar
    });
  }

  void _handleHorarioAcordarChanged(TimeOfDay? horario) {
    setState(() {
      _horarioAcordar = horario;
      print("Horário de acordar selecionado: $_horarioAcordar");
      // Aqui você pode usar o horário de acordar como precisar
    });
  }

  void _handleHorarioDormirChanged(TimeOfDay? horario) {
    setState(() {
      _horarioDormir = horario;
      print("Horário de dormir selecionado: $_horarioDormir");
      // Aqui você pode usar o horário de dormir como precisar
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
            PesoHorarioWidget(
              onPesoChanged: _handlePesoChanged,
              onHorarioAcordarChanged: _handleHorarioAcordarChanged,
              onHorarioDormirChanged: _handleHorarioDormirChanged,
            ),
            const SizedBox(height: 20),
            if (_pesoDaPessoa != null)
              Text("O peso inserido é: ${_pesoDaPessoa} kg")
            else
              const Text("Nenhum peso foi inserido ainda."),
            const SizedBox(height: 10),
            if (_horarioAcordar != null)
              Text(
                  "O horário de acordar selecionado é: ${_horarioAcordar!.format(context)}")
            else
              const Text("Nenhum horário de acordar foi selecionado ainda."),
            const SizedBox(height: 10),
            if (_horarioDormir != null)
              Text(
                  "O horário de dormir selecionado é: ${_horarioDormir!.format(context)}")
            else
              const Text("Nenhum horário de dormir foi selecionado ainda."),
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
