import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/ui/custom_clippath.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController();

  int _radioValue = 0;
  String _formattedText = '';

  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: Duration(milliseconds: 500), vsync: this, value: 0.1);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceInOut,
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _setHeader(),
            SizedBox(height: 25),
            _setContainer(),
          ],
        ),
      ),
    );
  }

  Widget _setHeader() {
    return Container(
      height: 250,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: HeaderClipPath(),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Weight Planet Calculator',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).backgroundColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 110,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/planet.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _setContainer() {
    return Container(
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: _setTextField(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25),
            child: _setRadioButtonList(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: _setAnimationText(),
          )
        ],
      ),
    );
  }

  Widget _setTextField() {
    return TextField(
      controller: _weightController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Your weight on earth',
        hintText: 'In pounds',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.person_outline),
      ),
    );
  }

  Widget _setRadioButtonList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _setRadioButton('Pluto', 0, Colors.brown),
        _setRadioButton('Mars', 1, Colors.redAccent),
        _setRadioButton('Venus', 2, Colors.orangeAccent),
      ],
    );
  }

  Widget _setRadioButton(String title, int radioValue, Color color) {
    return Row(
      children: <Widget>[
        Radio<int>(
          activeColor: color,
          value: radioValue,
          groupValue: _radioValue,
          onChanged: (int value) => _handleRadioValueChanged(value, title),
        ),
        GestureDetector(
          onTap: () => _handleRadioValueChanged(radioValue, title),
          child: Text(
            title,
            style: TextStyle(color: Colors.black38),
          ),
        ),
      ],
    );
  }

  Widget _setAnimationText() {
    return ScaleTransition(
      scale: _animation,
      alignment: Alignment.center,
      child: Text(
        _weightController.text.isEmpty
            ? 'Please enter the value'
            : _formattedText,
        style: TextStyle(
          color: Colors.black38,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleRadioValueChanged(int value, String text) {
    double result = 0;

    switch (value) {
      case 0:
        result = _calculateWeight(_weightController.text, 0.06);
        break;
      case 1:
        result = _calculateWeight(_weightController.text, 0.38);
        break;
      case 2:
        result = _calculateWeight(_weightController.text, 0.91);
        break;
    }

    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    }

    Future<void>.delayed(Duration(milliseconds: 500), () {
      if (result != 0) {
        setState(() {
          _radioValue = value;
          _formattedText = 'Your weight in $text is '
              '${result.toStringAsFixed(1)} lbs';
        });
      }

      _animationController.forward();
    });
  }

  double _calculateWeight(String weight, double multiplier) {
    return weight.isNotEmpty &&
            int.parse(weight).toString().isNotEmpty &&
            int.parse(weight) > 0
        ? int.parse(weight) * multiplier
        : 0;
  }
}
