import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DigitalPetPage(),
    );
  }
}

class DigitalPetPage extends StatefulWidget {
  const DigitalPetPage({super.key});

  @override
  State<DigitalPetPage> createState() => _DigitalPetPageState();
}

class _DigitalPetPageState extends State<DigitalPetPage> {
  String petName = 'Pip';

  int happiness = 50;
  int hunger = 50;

  bool hasWon = false;
  bool gameOver = false;

  String get mood {
    if (happiness > 70) {
      return 'Happy';
    } else if (happiness >= 30) {
      return 'Okay';
    } else {
      return 'Sad';
    }
  }

  Color get moodColor {
    if (happiness > 70) {
      return Colors.green;
    } else if (happiness >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              petName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ColorFiltered(
              colorFilter: ColorFilter.mode(
                moodColor,
                BlendMode.modulate,
              ),
              child: Image.asset(
                'assets/pet.png',
                height: 200,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Mood: $mood',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Text('Happiness: $happiness / 100'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: happiness / 100,
            ),

            const SizedBox(height: 20),

            Text('Hunger: $hunger / 100'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: hunger / 100,
            ),
          ],
        ),
      ),
    );
  }
}