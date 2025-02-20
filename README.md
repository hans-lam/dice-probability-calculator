# Dice Probability Calculator

A dice probability calculator that can be used to calculate the probabilty of hitting certain roles in tabletop games like Dungeons and Dragons.<br>
This application was built using Flutter and is primarily targeted towards Android devices.

## Getting Started

To run the appication, clone the repository and make sure you have a target device setup. Once that is done, navigate to the dice_roller folder and you can run the application through the command:
```sh
dart run
```

## Building Application

To build the application (into an apk), run the following command in the dice_roller folder:
```sh
flutter build apk
```

## Features
The flow of using the app is as follows.
1. First, you must enter all of this information:
- You can set a main die that you want to roll (from d4 to d100)
- You can then choose whether you're rolling that main die normally, at advantage (max of two rolls), or at disadvantage (min of two rolls)
- If you have any flat/constant modifiers, you can add those as well
- If you have any extra dice that should be considered within the roll, you can add up to 10 extra dice
- You can enter the target value you are trying to hit
2. Once the information has been entered, you have the option to:
- Determine the probability of hitting the target value based off of all the entered information
- Perform a dice roll based off of the entered information
