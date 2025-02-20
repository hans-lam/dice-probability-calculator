import 'package:flutter/material.dart';

class DiceSelector extends StatelessWidget {
  final String selectedDice;
  final ValueChanged<String?> onChanged;

  const DiceSelector({
    super.key,
    required this.selectedDice,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose your main die:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0),
          child: DropdownButton<String>(
            value: selectedDice,
            onChanged: onChanged,
            items: <String>['D4', 'D6', 'D8', 'D10', 'D12', 'D20', 'D100']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}