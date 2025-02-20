import 'package:flutter/material.dart';

class ExtraDiceCounter extends StatefulWidget {
  final ValueChanged<int> onExtraDieChanged;
  final ValueChanged<List<String>> onSelectedExtraDiceChanged;

  const ExtraDiceCounter({
    super.key, 
    required this.onExtraDieChanged, 
    required this.onSelectedExtraDiceChanged
  });

  @override
  // ignore: library_private_types_in_public_api
  _ExtraDiceCounterState createState() => _ExtraDiceCounterState();
}

class _ExtraDiceCounterState extends State<ExtraDiceCounter> {
  int _extraDie = 0;
  final List<String> _selectedDice = [];

  void _incrementExtraDie() {
    setState(() {
      // Set max as 10 dice
      if (_extraDie < 10) {
        _extraDie++;
        _selectedDice.add('D6'); // default to d6 die
        widget.onExtraDieChanged(_extraDie);
        widget.onSelectedExtraDiceChanged(_selectedDice);
      }
    });
  }

  void _decrementExtraDie() {
    setState(() {
      if (_extraDie > 0) {
        _extraDie--;
        _selectedDice.removeLast();
        widget.onExtraDieChanged(_extraDie);
        widget.onSelectedExtraDiceChanged(_selectedDice);
      }
    });
  }

  void _resetExtraDie() {
    setState(() {
      // reset extradie to 0
      _extraDie = 0;
      _selectedDice.clear();
      widget.onExtraDieChanged(_extraDie);
      widget.onSelectedExtraDiceChanged(_selectedDice);
    });
  }

  void _updateSelectedDice(int index, String? newValue) {
    setState(() {
      _selectedDice[index] = newValue!;
      widget.onSelectedExtraDiceChanged(_selectedDice);
    });
  }

  @override 
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                Text(
                  'Extra Dice: ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '$_extraDie',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: _decrementExtraDie,
              icon: const Icon(Icons.remove),
            ),
            IconButton(
              onPressed: _incrementExtraDie,
              icon: const Icon(Icons.add),
            ),
            TextButton(
              onPressed: _resetExtraDie,
              child: Text(
                'Reset',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: List.generate(_extraDie, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0), // Add spacing between selectors
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Extra Die ${index + 1}:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(width: 8.0), // Add spacing between text and dropdown
                  DropdownButton<String>(
                    value: _selectedDice[index],
                    onChanged: (String? newValue) {
                      _updateSelectedDice(index, newValue);
                    },
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
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}