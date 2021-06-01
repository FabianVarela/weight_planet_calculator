import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weight_planet_calculator/hooks/curved_animation_hook.dart';
import 'package:weight_planet_calculator/model/planet.model.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_clippath.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_radio_button.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_text_field.dart';
import 'package:weight_planet_calculator/ui/widgets/rotation_list_animation.dart';

class HomeView extends HookWidget {
  static const double _poundValue = 2.20462;
  static const String _poundUnit = 'Kg';

  @override
  Widget build(BuildContext context) {
    final formattedText = useState('');
    final currentIndex = useState(0);

    final textController = useTextEditingController();

    final animController = useAnimationController(
      initialValue: 0.1,
      duration: Duration(milliseconds: 500),
    );
    final animation = useCurvedAnimation(animController);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _Header(index: currentIndex.value),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    controller: textController,
                    label: 'Your weight on earth',
                    hint: 'In $_poundUnit',
                  ),
                  const SizedBox(height: 20),
                  ScaleTransition(
                    scale: animation,
                    alignment: Alignment.center,
                    child: Text(
                      formattedText.value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _PlanetList(
                    planets: planets,
                    onChange: (radio, text, weight) {
                      final res = _calculateWeight(textController.text, weight);

                      if (animController.status == AnimationStatus.completed) {
                        animController.reverse();
                      }

                      Future.delayed(Duration(milliseconds: 500), () {
                        if (res != 0) currentIndex.value = radio;
                        formattedText.value = _textResult(res, text);
                        animController.forward();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _textResult(double result, String text) {
    if (result != 0) {
      final resultFix = result.toStringAsFixed(1);
      return 'Your weight in $text is $resultFix $_poundUnit';
    } else {
      return 'Please enter the value';
    }
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

class _PlanetList extends HookWidget {
  const _PlanetList({Key? key, required this.planets, required this.onChange})
      : super(key: key);

  final List<Planet> planets;
  final Function(int, String, double) onChange;

  @override
  Widget build(BuildContext context) {
    final radioValue = useState(0);

    return Wrap(
      alignment: WrapAlignment.center,
      children: <Widget>[
        for (int i = 0; i < planets.length; i++)
          CustomRadioButton(
            title: planets[i].name,
            value: i,
            groupValue: radioValue.value,
            weight: planets[i].weightGravity,
            color: planets[i].color,
            onChanged: (value) {
              radioValue.value = value!;
              onChange(value, planets[i].name, planets[i].weightGravity);
            },
          ),
      ],
    );
  }
}
