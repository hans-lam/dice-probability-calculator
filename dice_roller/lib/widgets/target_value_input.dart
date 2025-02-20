import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TargetValueInput extends StatelessWidget {
  final TextEditingController controller;
  final String selectedDice;
  final int modifier;
  final List<String> selectedExtraDice;

  const TargetValueInput({
    super.key,
    required this.controller,
    required this.selectedDice,
    required this.modifier,
    required this.selectedExtraDice,
  });

  int _getDiceValue(String dice) {
    RegExp regExp = RegExp(r'\d+');
    final int diceValue = int.parse(regExp.stringMatch(dice)!);
    return diceValue;
  }

  void _incrementController() {
    int currentValue = int.parse(controller.text);
    controller.text = (currentValue + 1).toString();
  }

  void _decrementController() {
    int currentValue = int.parse(controller.text);
    controller.text = (currentValue - 1).toString();
  }

  void _resetController(int min, int max) {
    controller.text = (min + ((max - min) / 2).round()).toString();
  }

  @override
  Widget build(BuildContext context) {
    // Set the default value to 10 if the controller is empty
    if (controller.text.isEmpty) {
      controller.text = '10';
    }

    int mainDiceValue = _getDiceValue(selectedDice);
    List<int> extraDiceValues = selectedExtraDice.map((e) => _getDiceValue(e)).toList();
    int sumExtraDiceValues = extraDiceValues.fold(0, (prev, element) => prev + element);
    int minValue = 1 + modifier + extraDiceValues.length;
    int maxValue = mainDiceValue + modifier + sumExtraDiceValues;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            'Target value:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              onPressed: _decrementController, 
              icon: const Icon(Icons.remove)
            ),
             IconButton(
              onPressed: _incrementController, 
              icon: const Icon(Icons.add)
            ),
            TextButton(
              onPressed: () {
                _resetController(minValue, maxValue);
              },
              child: Text(
                'Reset',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'Current Min: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '$minValue',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              TextButton(
                child: Text(
                  'Set Min',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                onPressed: () {
                  controller.text = minValue.toString();
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'Current Max: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '$maxValue',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
              TextButton(
                child: Text(
                  'Set Max',
                  style: TextStyle(
                    fontSize: 15.0,
                  ),
                ),
                onPressed: () {
                  controller.text = maxValue.toString();
                },
              ),
            ],
          ),
        ),  
      ],
    );
  }
}