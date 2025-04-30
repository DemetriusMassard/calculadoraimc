import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String labelIMC = "Informe seus dados!";
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();
  String? pesoErrorMessage;
  String? alturaErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHomeAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHomeIcon(),
            _buildPesoInput(),
            _buildAlturaInput(),
            _buildCalculateButton(),
            _buildBMILabel(),
          ],
        ),
      ),
    );
  }

  AppBar _buildHomeAppBar() {
    return AppBar(
      backgroundColor: Colors.grey[900],
      title: Text("Calculadora de IMC"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              pesoController.clear();
              alturaController.clear();
              labelIMC = "Informe seus dados!";
            });
          },
          icon: Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildHomeIcon() {
    return Icon(Icons.person_outlined, size: 128, color: Colors.grey);
  }

  Widget _buildPesoInput() {
    return TextField(
      decoration: InputDecoration(
        label: Text("Peso (kg)"),
        errorText: pesoErrorMessage,
      ),
      controller: pesoController,
      keyboardType: TextInputType.number,
      onChanged: pesoControllerChanged,
    );
  }

  Widget _buildAlturaInput() {
    return TextField(
      decoration: InputDecoration(
        label: Text("Altura (cm)"),
        errorText: alturaErrorMessage,
      ),
      controller: alturaController,
      keyboardType: TextInputType.number,
      onChanged: alturaControllerChanged,
    );
  }

  Widget _buildCalculateButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          labelIMC = calculateBMI();
        });
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
      child: Text("Calcular", style: TextStyle(color: Colors.grey[900])),
    );
  }

  Widget _buildBMILabel() {
    return Text(
      labelIMC,
      style: TextStyle(color: Colors.white, fontSize: 24),
      textAlign: TextAlign.center,
    );
  }

  void pesoControllerChanged(String text) {
    double? peso = parseTextToDouble(text);
    if (peso == null || peso.isNaN) {
      setState(() {
        pesoErrorMessage = "O peso deve ser numérico";
      });
    } else {
      setState(() {
        pesoErrorMessage = null;
      });
    }
  }

  void alturaControllerChanged(String text) {
    double? altura = parseTextToDouble(text);
    if (altura == null || altura.isNaN) {
      setState(() {
        alturaErrorMessage = "O peso deve ser numérico";
      });
    } else {
      setState(() {
        alturaErrorMessage = null;
      });
    }
  }

  double? parseTextToDouble(String text) {
    double? parsedDouble = double.tryParse(text.replaceAll(",", "."));
    return parsedDouble;
  }

  String calculateBMI() {
    double? peso = parseTextToDouble(pesoController.text);
    double? altura = parseTextToDouble(alturaController.text);
    String msg = "";

    if (peso == null || altura == null || peso.isNaN || altura.isNaN) {
      msg = "Valores inválidos!";
      return msg;
    }

    altura = altura / 100;
    double imc = peso / (altura * altura);

    switch (imc) {
      case < 18.5:
        msg = "Abaixo do peso (${imc.toStringAsFixed(2)})";
        break;
      case >= 18.5 && < 25:
        msg = "Peso normal (${imc.toStringAsFixed(2)})";
        break;
      case >= 25 && < 30:
        msg = "Sobrepeso (${imc.toStringAsFixed(2)})";
        break;
      case >= 30 && < 35:
        msg = "Obesidade grau I (${imc.toStringAsFixed(2)})";
        break;
      case >= 35 && < 40:
        msg = "Obesidade grau II (${imc.toStringAsFixed(2)})";
        break;
      case >= 40:
        msg = "Obesidade grau III (${imc.toStringAsFixed(2)})";
        break;
    }

    return msg;
  }
}
