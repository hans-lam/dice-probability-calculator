import 'dart:math';
import 'package:flutter/material.dart';

class CalculateButton extends StatelessWidget {
  final String selectedDice;
  final String selectedRollType;
  final int modifier;
  final int extraDie;
  final List<String> selectedExtraDice;
  final TextEditingController targetValueController;

  const CalculateButton({
    super.key,
    required this.selectedDice,
    required this.selectedRollType,
    required this.modifier,
    required this.extraDie,
    required this.selectedExtraDice,
    required this.targetValueController,
  });

  int _getDiceValue(String dice) {
    RegExp regExp = RegExp(r'\d+');
    final int diceValue = int.parse(regExp.stringMatch(dice)!);
    return diceValue;
  }

  Map<int, double> _getDieProbability(int sides) {
    return {for (int i = 1; i <= sides; i++) i: 1 / sides};
  }

  void _calculateProbability(BuildContext context) {
    // Get target value
    int targetValue = int.parse(targetValueController.text);
    // Grab main dice value
    int mainDiceValue = _getDiceValue(selectedDice);
    // Get additional dice values
    List<int> extraDiceValues = selectedExtraDice.map((e) => _getDiceValue(e)).toList();

    // Compute main dice probabilities (considering roll type)
    Map<int, double> mainDiceProb = _getDieProbability(mainDiceValue);

    if (selectedRollType == 'Advantage') {
      // P(max(X1, X2) = k) = P(at least one roll is k)
      Map<int, double> newProb = {};
      for (int k = 1; k <= mainDiceValue; k++) {
        num probAtLeastK = 1 - pow((k - 1) / mainDiceValue, 2);
        num probAtLeastKPlus1 = (k < mainDiceValue) ? 1 - pow(k / mainDiceValue, 2) : 0;
        newProb[k] = (probAtLeastK - probAtLeastKPlus1).toDouble();
      }
      mainDiceProb = newProb;
    } else if (selectedRollType == 'Disadvantage') {
      // P(min(X1, X2) = k) = 2 * P(X = k) * P(X >= k) - P(X = k)^2
      Map<int, double> newProb = {};
      for (int k = 1; k <= mainDiceValue; k++) {
        num probEqualK = 1 / mainDiceValue;
        num probAtLeastK = (mainDiceValue - k + 1) / mainDiceValue;
        newProb[k] = (2 * probEqualK * probAtLeastK - pow(probEqualK, 2)).toDouble();
      }
      mainDiceProb = newProb;
    }

    // Compute the probability distribution of the sum of extra dice using convolution
    Map<int, double> extraDiceProb = {0: 1.0}; // Start with just 0 sum

    for (int die in extraDiceValues) {
      Map<int, double> newProb = {};
      Map<int, double> dieProb = _getDieProbability(die);

      for (var sum in extraDiceProb.keys) {
        for (var face in dieProb.keys) {
          int newSum = sum + face;
          newProb[newSum] = (newProb[newSum] ?? 0) + extraDiceProb[sum]! * dieProb[face]!;
        }
      }

      extraDiceProb = newProb;
    }

    // Compute final probability distribution by convolving main dice with extra dice
    Map<int, double> finalProb = {};

    for (var mainValue in mainDiceProb.keys) {
      for (var extraSum in extraDiceProb.keys) {
        int total = mainValue + extraSum + modifier; // Apply modifier
        finalProb[total] = (finalProb[total] ?? 0) + mainDiceProb[mainValue]! * extraDiceProb[extraSum]!;
      }
    }

    // Compute P(Z >= targetValue)
    double probability = finalProb.entries
        .where((entry) => entry.key >= targetValue)
        .map((entry) => entry.value)
        .fold(0.0, (sum, prob) => sum + prob);
    String percentage = '${(probability * 100).toStringAsFixed(2)}%.';

    // Show dialog with probability
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Probability Result'),
          content: Text(
            'Your probability of rolling at least $targetValue is $percentage',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  int _rollDice(BuildContext context) {
    // Grab main dice value
    int mainDiceValue = _getDiceValue(selectedDice);
    // Get additional dice values
    List<int> extraDiceValues = selectedExtraDice.map((e) => _getDiceValue(e)).toList();

    int currentRoll = 0;
    currentRoll += Random().nextInt(mainDiceValue) + 1; // Roll main dice
    String rollString = "$selectedDice: $currentRoll";

    for (int die in extraDiceValues) {
      int extraRoll = Random().nextInt(die) + 1; // Roll extra dice
      currentRoll += extraRoll;
      rollString += " + D$die: $extraRoll";
    }

    currentRoll += modifier; // Apply modifier
    rollString += " + $modifier";

    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dice Roll Result'),
          content: Text(
            'You rolled a $currentRoll ($rollString)!',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        );
      },
    );
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 24.0),
          child: ElevatedButton(
            onPressed: () => _calculateProbability(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              foregroundColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            child: const Text('Calculate'),
          ),
        ),
        ElevatedButton(
          onPressed: () => _rollDice(context), 
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              foregroundColor: Colors.black,
              textStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
          ),
          child: const Text('Roll Dice'),
        ),
      ]
    );
  }
}