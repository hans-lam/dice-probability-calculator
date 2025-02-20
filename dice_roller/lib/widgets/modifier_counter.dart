import 'package:flutter/material.dart';

class ModifierCounter extends StatefulWidget {
  final ValueChanged<int> onModifierChanged;

  const ModifierCounter({super.key, required this.onModifierChanged});

  @override
  // ignore: library_private_types_in_public_api
  _ModifierCounterState createState() => _ModifierCounterState();
}

class _ModifierCounterState extends State<ModifierCounter> {
  int _modifier = 0;

  void _incrementModifier() {
    setState(() {
      // set +20 as max
      if (_modifier < 20) _modifier++;
      widget.onModifierChanged(_modifier);
    });
  }

  void _decrementModifier() {
    setState(() {
      // set -20 as max
      if (_modifier > -20) _modifier--;
      widget.onModifierChanged(_modifier);
    });
  }

  void _resetModifier() {
    setState(() {
      // reset modifier to 0
      _modifier = 0;
      widget.onModifierChanged(_modifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Text(
              'Modifier: ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '$_modifier',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: _decrementModifier,
          icon: const Icon(Icons.remove),
        ),
        IconButton(
          onPressed: _incrementModifier,
          icon: const Icon(Icons.add),
        ),
        TextButton(
          onPressed: _resetModifier,
          child: Text(
            'Reset',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}