import 'package:flutter/material.dart';
import 'package:weight_planet_calculator/model/planet.model.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_clippath.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_radio_button.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_text_field.dart';
import 'package:weight_planet_calculator/ui/widgets/rotation_list_animation.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
  static const double _poundValue = 2.20462;
  static const String _poundUnit = 'Kg';

  final TextEditingController _weightController = TextEditingController();

  int _radioValue = 0;
  String _formattedText = '';
  int _currentIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

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
            _Header(index: _currentIndex),
            const SizedBox(height: 25),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    controller: _weightController,
                    label: 'Your weight on earth',
                    hint: 'In $_poundUnit',
                  ),
                  const SizedBox(height: 20),
                  ScaleTransition(
                    scale: _animation,
                    alignment: Alignment.center,
                    child: Text(
                      _formattedText,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < planets.length; i++)
                        CustomRadioButton(
                          title: planets[i].name,
                          value: i,
                          groupValue: _radioValue,
                          weight: planets[i].weightGravity,
                          color: planets[i].color,
                          onChanged: (value) => _onChangeRadioValue(value!,
                              planets[i].name, planets[i].weightGravity),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onChangeRadioValue(int radio, String text, double weight) {
    final result = _calculateWeight(_weightController.text, weight);

    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    }

    Future<void>.delayed(Duration(milliseconds: 500), () {
      if (result != 0) {
        final resultFix = result.toStringAsFixed(1);
        setState(() {
          _currentIndex = radio;
          _radioValue = radio;
          _formattedText = 'Your weight in $text is $resultFix $_poundUnit';
        });
      } else {
        setState(() {
          _formattedText = 'Please enter the value';
        });
      }

      _animationController.forward();
    });
  }

  double _calculateWeight(String weight, double multiplier) {
    final weightValue = double.tryParse(weight);

    return weightValue != null && weightValue > 0
        ? ((double.parse(weight) * _poundValue) * multiplier) / _poundValue
        : 0;
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: HeaderClipPath(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.34,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Text(
                    'Weight Planet Calculator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.24,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: RotationListAnimation(
                size: MediaQuery.of(context).size,
                isReverse: true,
                assetList: planets.map((Planet p) => p.asset).toList(),
                currentIndex: index,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
