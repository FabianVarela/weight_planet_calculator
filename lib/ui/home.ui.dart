import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/model/planet.model.dart';
import 'package:weight_planet_calculator/ui/custom_clippath.dart';
import 'package:weight_planet_calculator/ui/rotation_list_animation.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final TextEditingController _weightController = TextEditingController();

  int _radioValue = 0;
  String _formattedText = '';

  AnimationController _animationController;
  Animation<double> _animation;

  int _currentIndex = 0;

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
      height: MediaQuery.of(context).size.height * 0.34,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: HeaderClipPath(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
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
            top: MediaQuery.of(context).size.height * 0.19,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RotationListAnimation(
                size: MediaQuery.of(context).size,
                isReverse: true,
                assetList: planets.map((Planet p) => p.asset).toList(),
                currentIndex: _currentIndex,
              ),
            ),
          ),
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
            padding: EdgeInsets.only(bottom: 20),
            child: _setTextField(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _setAnimationText(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Wrap(
              children: <Widget>[
                for (int i = 0; i < planets.length; i++)
                  _setRadioButton(planets[i].name, i, planets[i].weightGravity,
                      planets[i].color)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _setTextField() {
    return TextField(
      controller: _weightController,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
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

  Widget _setRadioButton(
      String title, int radioValue, double weightValue, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Radio<int>(
          activeColor: color,
          value: radioValue,
          groupValue: _radioValue,
          onChanged: (int value) =>
              _handleRadioValueChanged(radioValue, title, weightValue),
        ),
        GestureDetector(
          onTap: () => _handleRadioValueChanged(radioValue, title, weightValue),
          child: Padding(
            padding: EdgeInsets.only(right: 5),
            child: Text(
              title,
              style: TextStyle(color: Colors.black38),
            ),
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

  void _handleRadioValueChanged(
      int radioValue, String text, double weightValue) {
    final double result = _calculateWeight(_weightController.text, weightValue);

    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    }

    Future<void>.delayed(Duration(milliseconds: 500), () {
      if (result != 0) {
        setState(() {
          _currentIndex = radioValue;
          _radioValue = radioValue;
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