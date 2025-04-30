import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _labelIMC = "Informe seus dados!";
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _weightErrorMessage;
  String? _heightErrorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildHomeAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 32,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHomeIcon(),
              _buildWeightInput(),
              _buildHeightInput(),
              _buildCalculateButton(),
              _buildBMILabel(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildHomeAppBar() {
    //Builds Homepage's Appbar
    return AppBar(
      backgroundColor: Colors.grey[900],
      title: Text("Calculadora de IMC"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              weightController.clear();
              heightController.clear();
              _labelIMC = "Informe seus dados!";
            });
          },
          icon: Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildHomeIcon() {
    // Builds Homepage icon
    return Icon(Icons.person_outlined, size: 128, color: Colors.grey);
  }

  Widget _buildWeightInput() {
    //Weight Input
    return TextFormField(
      validator: (value) {
        return validateNumericFields(value);
      },
      decoration: InputDecoration(
        label: Text("Peso (kg)"),
        errorText: _weightErrorMessage,
      ),
      controller: weightController,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildHeightInput() {
    // Height input
    return TextFormField(
      validator: (value) {
        return validateNumericFields(value);
      },
      decoration: InputDecoration(
        label: Text("Altura (cm)"),
        errorText: _heightErrorMessage,
      ),
      controller: heightController,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCalculateButton() {
    //Calculate Button
    return SizedBox(
      height: 70,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _labelIMC = calculateBMI();
            });
          }
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
        child: Text(
          "Calcular",
          style: TextStyle(color: Colors.grey[900], fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildBMILabel() {
    //Label with result of the calculation
    return Text(
      _labelIMC,
      style: TextStyle(color: Colors.white, fontSize: 24),
      textAlign: TextAlign.center,
    );
  }

  String calculateBMI() {
    // BMI Calculation
    double? weight = parseTextToDouble(weightController.text);
    double? height = parseTextToDouble(heightController.text);
    String msg = "";

    if (weight == null || height == null || weight.isNaN || height.isNaN) {
      msg = "Valores inválidos!";
      return msg;
    }

    height = height / 100;
    double imc = weight / (height * height);

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

  String? validateNumericFields(String? value) {
    //Form's Validator function
    double? numericValue = parseTextToDouble(value);
    if (numericValue == null || numericValue.isNaN) {
      return "O valor deve ser numérico";
    } else {
      return null;
    }
  }

  double? parseTextToDouble(String? text) {
    //Parse function, so the user can use ',' an '.' as decimal separator
    double? parsedDouble = double.tryParse(text!.replaceAll(",", "."));
    return parsedDouble;
  }
}
