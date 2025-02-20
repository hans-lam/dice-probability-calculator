import 'package:flutter/material.dart';

class RollTypeSelector extends StatefulWidget {
  final ValueChanged<String?> onChanged;

  const RollTypeSelector({
    super.key,
    required this.onChanged,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RollTypeSelectorState createState() => _RollTypeSelectorState();
}

class _RollTypeSelectorState extends State<RollTypeSelector> {
  String selectedRollType = 'Normal';

  void _onChanged(String? value) {
    setState(() {
      selectedRollType = value!;
      widget.onChanged(value);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How is it being rolled:',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Row(
          children: [
            Radio<String>(
              value: 'Normal',
              groupValue: selectedRollType,
              onChanged: _onChanged,
            ),
            Text(
              'Normal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Radio<String>(
              value: 'Advantage',
              groupValue: selectedRollType,
              onChanged: _onChanged,
            ),
            Text(
              'Advantage',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Radio<String>(
              value: 'Disadvantage',
              groupValue: selectedRollType,
              onChanged: _onChanged,
            ),
            Text(
              'Disadvantage',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}