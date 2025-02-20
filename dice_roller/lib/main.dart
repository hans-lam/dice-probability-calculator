import 'package:flutter/material.dart';
import 'widgets/dice_selector.dart';
import 'widgets/roll_type_selector.dart';
import 'widgets/modifier_counter.dart';
import 'widgets/extra_dice_counter.dart';
import 'widgets/target_value_input.dart';
import 'widgets/calculate_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Probability Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dice Probability Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedDice  = 'D20';
  String _selectedRollType = 'Normal';
  int _modifier = 0;
  int _extraDie = 0;
  List<String> _selectedExtraDice = [];
  final TextEditingController _targetValueController = TextEditingController();

  void _updateModifier(int value) {
    setState(() {
      _modifier = value;
    });
  }

  void _updateDieCounter(int value) {
    setState(() {
      _extraDie = value;
    });
  }

  void _updateSelectedExtraDice(List<String> newSelectedExtraDice) {
    setState(() {
      _selectedExtraDice = newSelectedExtraDice;
    });
  }

  void _updateSelectedRollType(String? newRollType) {
    setState(() {
      _selectedRollType = newRollType!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dice Selector part
              DiceSelector(
                selectedDice: _selectedDice,
                onChanged: (String? value) {
                  setState(() {
                    _selectedDice = value!;
                  });
                },
              ),

              // Choosing Roll Type part
              SizedBox(height: 16),
              RollTypeSelector(
                onChanged: _updateSelectedRollType,
              ),
            
              // Modifier part
              SizedBox(height: 16),
              ModifierCounter(
                onModifierChanged: _updateModifier,
              ),

              // Extra dice part
              SizedBox(height: 16),
              ExtraDiceCounter(
                onExtraDieChanged: _updateDieCounter,
                onSelectedExtraDiceChanged: _updateSelectedExtraDice,
              ),
              
              // Target value part
              SizedBox(height: 16),
              TargetValueInput(
                controller: _targetValueController,
                selectedDice: _selectedDice,
                modifier: _modifier,
                selectedExtraDice: _selectedExtraDice,
              ),

              // Calculate button
              SizedBox(height: 16),
              CalculateButton(
                selectedDice: _selectedDice,
                selectedRollType: _selectedRollType,
                modifier: _modifier,
                extraDie: _extraDie,
                selectedExtraDice: _selectedExtraDice,
                targetValueController: _targetValueController,
              ),
            ]
          ),
        )
      )
    );
  }
}
