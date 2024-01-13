import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:weight_planet_calculator/hooks/curved_animation_hook.dart';
import 'package:weight_planet_calculator/model/planet_model.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_clippath.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_radio_button.dart';
import 'package:weight_planet_calculator/ui/widgets/custom_text_field.dart';
import 'package:weight_planet_calculator/ui/widgets/rotation_list_animation.dart';

class HomeView extends HookWidget {
  const HomeView({super.key});

  static const double _poundValue = 2.20462;
  static const String _poundUnit = 'Kg';

  @override
  Widget build(BuildContext context) {
    final formattedText = useState('');
    final currentIndex = useState(0);
    final groupValue = useState(0);

    final textController = useTextEditingController();

    final animController = useAnimationController(
      initialValue: 0.1,
      duration: const Duration(milliseconds: 500),
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
                    groupValue: groupValue.value,
                    onChange: (radio, text, weight) {
                      final res = _calculateWeight(textController.text, weight);

                      if (animController.status == AnimationStatus.completed) {
                        animController.reverse();
                      }

                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (res != 0) {
                          groupValue.value = radio;
                          currentIndex.value = radio;
                        }
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
  const _Header({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: HeaderClipPath(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.34,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Text(
                    'Weight Planet Calculator',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.24,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: RotationListAnimation(
                size: MediaQuery.of(context).size,
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

typedef OnChangeList = void Function(int, String, double);

class _PlanetList extends HookWidget {
  const _PlanetList({
    required this.planets,
    this.groupValue = 0,
    this.onChange,
  });

  final List<Planet> planets;
  final int groupValue;
  final OnChangeList? onChange;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: planets.mapIndexed((index, item) {
        final name = item.name;
        final weightGravity = item.weightGravity;

        return CustomRadioButton(
          title: name,
          value: index,
          groupValue: groupValue,
          weight: weightGravity,
          color: item.color,
          onChanged: (value) => onChange?.call(value!, name, weightGravity),
        );
      }).toList(),
    );
  }
}
