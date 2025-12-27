import 'package:flutter/material.dart';

enum RadioButtonsPosition { row, column, wrap }

class CustomRadioButtonGroup<T> extends StatelessWidget {
  const CustomRadioButtonGroup({
    required this.groupList,
    required this.value,
    required this.position,
    this.onChanged,
    super.key,
  });

  final List<({String title, T value, Color color})> groupList;
  final T? value;
  final RadioButtonsPosition position;
  final ValueSetter<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      for (final item in groupList)
        Row(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Radio(activeColor: item.color, value: item.value),
            InkWell(
              onTap: () => onChanged?.call(item.value),
              child: Text(
                item.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: .w300,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
    ];

    return RadioGroup<T>(
      groupValue: value,
      onChanged: (value) => onChanged?.call(value),
      child: switch (position) {
        RadioButtonsPosition.row => Row(spacing: 10, children: children),
        RadioButtonsPosition.column => Column(
          spacing: 10,
          crossAxisAlignment: .start,
          children: children,
        ),
        RadioButtonsPosition.wrap => Wrap(
          alignment: .center,
          children: children,
        ),
      },
    );
  }
}
