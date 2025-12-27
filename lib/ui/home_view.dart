import 'dart:async';

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

    final groupValue = useState<PlanetInfo?>(null);
    final textController = useTextEditingController();

    final animController = useAnimationController(
      initialValue: .1,
      duration: const Duration(milliseconds: 500),
    );
    final animation = useCurvedAnimation(animController);

    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: .onDrag,
        child: Column(
          spacing: 25,
          children: <Widget>[
            _Header(index: currentIndex.value),
            Padding(
              padding: const .symmetric(horizontal: 16),
              child: Column(
                spacing: 20,
                children: <Widget>[
                  CustomTextField(
                    controller: textController,
                    label: 'Your weight on earth',
                    hint: 'In $_poundUnit',
                  ),
                  ScaleTransition(
                    scale: animation,
                    child: Text(
                      formattedText.value,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: .w700,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  _PlanetList(
                    planets: planets,
                    groupValue: groupValue.value,
                    onChange: (info, index) {
                      final res = _calculateWeight(
                        textController.text,
                        info.value,
                      );

                      if (animController.status == AnimationStatus.completed) {
                        unawaited(animController.reverse());
                      }

                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (res != 0) {
                          groupValue.value = info;
                          currentIndex.value = index;
                        }
                        formattedText.value = _textResult(res, info.name);
                        unawaited(animController.forward());
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
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return SizedBox(
      height: size.height * .4,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: HeaderClipPath(),
            child: DecoratedBox(
              decoration: BoxDecoration(color: theme.primaryColor),
              child: SizedBox.fromSize(
                size: Size(size.width, size.height * .34),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Align(
                    alignment: .topCenter,
                    child: Padding(
                      padding: const .only(top: 100),
                      child: Text(
                        'Weight Planet Calculator',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: .w700,
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * .24,
            child: SizedBox(
              width: size.width,
              child: RotationListAnimation(
                size: size,
                assetList: planets.map((planet) => planet.asset).toList(),
                currentIndex: index,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

typedef PlanetInfo = ({double value, String name});
typedef OnChangeList = void Function(PlanetInfo, int);

class _PlanetList extends HookWidget {
  const _PlanetList({
    required this.planets,
    required this.groupValue,
    this.onChange,
  });

  final List<Planet> planets;
  final PlanetInfo? groupValue;
  final OnChangeList? onChange;

  @override
  Widget build(BuildContext context) {
    return CustomRadioButtonGroup<PlanetInfo>(
      groupList: [
        for (final item in planets)
          (
            title: item.name,
            value: (value: item.weightGravity, name: item.name),
            color: item.color,
          ),
      ],
      value: groupValue,
      position: .wrap,
      onChanged: (value) {
        if (value == null) return;

        final index = planets.indexWhere((item) {
          return item.weightGravity == value.value && item.name == value.name;
        });
        onChange?.call(value, index);
      },
    );
  }
}
