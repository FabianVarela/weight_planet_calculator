import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  final TextEditingController _weightController = TextEditingController();
  int radioValue = 0;
  double _finalResult = 0.0;
  String _formattedText = "";

  void _handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;

      switch (radioValue) {
        case 0:
          _finalResult = calculateWeight(_weightController.text, 0.06);
          _formattedText =
              "Your weight in Pluto is ${_finalResult.toStringAsFixed(1)}";
          break;
        case 1:
          _finalResult = calculateWeight(_weightController.text, 0.38);
          _formattedText =
              "Your weight in Mars is ${_finalResult.toStringAsFixed(1)}";
          break;
        case 2:
          _finalResult = calculateWeight(_weightController.text, 0.91);
          _formattedText =
              "Your weight in Venus is ${_finalResult.toStringAsFixed(1)}";
          break;
      }
    });
  }

  double calculateWeight(String weight, double multiplier) {
    if (weight.isNotEmpty && int.parse(weight).toString().isNotEmpty && int.parse(weight) > 0) {
      return int.parse(weight) * multiplier;
    } else {
      print("THAT'S WRONG!!!");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weight Planet Calculator"),
        centerTitle: true,
        backgroundColor: Colors.black38,
      ),
      backgroundColor: Colors.blueGrey,
      body: Container(
        alignment: Alignment.topCenter,
        child: ListView(
          padding: EdgeInsets.all(3),
          children: <Widget>[
            Image.asset(
              "images/planet.png",
              height: 133,
              width: 200,
            ),
            Container(
              margin: EdgeInsets.all(3),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  TextField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Your weight on earth",
                          hintText: "In pounds",
                          icon: Icon(Icons.person_outline))),
                  Padding(padding: EdgeInsets.all(5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<int>(
                          activeColor: Colors.brown,
                          value: 0,
                          groupValue: radioValue,
                          onChanged: _handleRadioValueChanged),
                      Text("Pluto", style: TextStyle(color: Colors.white30)),
                      Radio<int>(
                          activeColor: Colors.red,
                          value: 1,
                          groupValue: radioValue,
                          onChanged: _handleRadioValueChanged),
                      Text("Mars", style: TextStyle(color: Colors.white30)),
                      Radio<int>(
                          activeColor: Colors.orangeAccent,
                          value: 2,
                          groupValue: radioValue,
                          onChanged: _handleRadioValueChanged),
                      Text("Venus", style: TextStyle(color: Colors.white30))
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(16)),
                  Text(
                    _weightController.text.isEmpty
                        ? "Please enter the value"
                        : "$_formattedText lbs",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
