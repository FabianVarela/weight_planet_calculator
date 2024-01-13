import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.weight,
    required this.color,
    this.onChanged,
    super.key,
  });

  final String title;
  final int value;
  final int groupValue;
  final double weight;
  final Color color;
  final ValueSetter<int?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Radio(
          activeColor: color,
          value: value,
          groupValue: groupValue,
          onChanged: (_) => onChanged?.call(value),
        ),
        GestureDetector(
          onTap: () => onChanged?.call(value),
          child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
