import 'dart:async';

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
  bool isPaused = false;

  Timer? _hungerTimer;
  Timer? _highMoodTimer;

  final TextEditingController _nameController = TextEditingController(
    text: 'Pip',
  );

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

  void feedPet() {
    setState(() {
      int nextHunger = (hunger - 10).clamp(0, 100);

      hunger = nextHunger;

      if (nextHunger < 30) {
        happiness = (happiness - 20).clamp(0, 100);
      } else {
        happiness = (happiness + 10).clamp(0, 100);
      }

      _updateOutcome();
    });
  }

  void playWithPet() {
    setState(() {
      happiness = (happiness + 10).clamp(0, 100);
      hunger = (hunger + 5).clamp(0, 100);

      _updateOutcome();
    });
  }

  void resetPet() {
    _highMoodTimer?.cancel();
    _highMoodTimer = null;

    setState(() {
      happiness = 50;
      hunger = 50;
      hasWon = false;
      gameOver = false;
      isPaused = false;
    });

    startHungerTimer();
  }

  @override
  void initState() {
    super.initState();
    startHungerTimer();
  }

  void startHungerTimer() {
    _hungerTimer?.cancel();

    _hungerTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        if (hunger + 5 > 100) {
          hunger = 100;
          happiness = (happiness - 20).clamp(0, 100);
        } else {
          hunger += 5;
        }

        _updateOutcome();
      });
    });
  }

  @override
  void dispose() {
    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  void _updateOutcome() {
    if (hunger == 100 && happiness <= 10) {
      gameOver = true;
      hasWon = false;

      _highMoodTimer?.cancel();
      _highMoodTimer = null;
      _hungerTimer?.cancel();
      return;
    }

    if (happiness > 80) {
      if (_highMoodTimer == null) {
        _highMoodTimer = Timer(const Duration(minutes: 3), () {
          if (mounted && happiness > 80 && !gameOver) {
            setState(() {
              hasWon = true;
              _hungerTimer?.cancel();
            });
          }

          _highMoodTimer = null;
        });
      }
    } else {
      _highMoodTimer?.cancel();
      _highMoodTimer = null;
    }
  }

  void updatePetName() {
    if (_nameController.text.trim().isNotEmpty) {
      setState(() {
        petName = _nameController.text.trim();
      });
    }
  }

  void pauseGame() {
    setState(() {
      isPaused = true;
    });

    _hungerTimer?.cancel();
    _highMoodTimer?.cancel();
    _highMoodTimer = null;
  }

  void resumeGame() {
    setState(() {
      isPaused = false;
      _updateOutcome();
    });

    if (!hasWon && !gameOver) {
      startHungerTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digital Pet')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              petName,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Pet name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: updatePetName,
                  child: const Text('Confirm'),
                ),
              ],
            ),

            const SizedBox(height: 20),

            AnimatedScale(
              scale: happiness > 70 ? 1.1 : 1.0,
              duration: MediaQuery.of(context).disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 300),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(moodColor, BlendMode.modulate),
                child: Image.asset('assets/pet.png', height: 200),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Mood: $mood',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            if (hasWon)
              const Text(
                'YOU WIN!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

            if (gameOver)
              const Text(
                'GAME OVER',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

            const SizedBox(height: 30),

            Text('Happiness: $happiness / 100'),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: happiness / 100),
              duration: MediaQuery.of(context).disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return LinearProgressIndicator(value: value);
              },
            ),

            const SizedBox(height: 20),

            Text('Hunger: $hunger / 100'),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: hunger / 100),
              duration: MediaQuery.of(context).disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return LinearProgressIndicator(value: value);
              },
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: hasWon || gameOver || isPaused ? null : feedPet,
                  child: const Text('Feed'),
                ),
                ElevatedButton(
                  onPressed: hasWon || gameOver || isPaused
                      ? null
                      : playWithPet,
                  child: const Text('Play'),
                ),
                ElevatedButton(onPressed: resetPet, child: const Text('Reset')),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: hasWon || gameOver
                      ? null
                      : isPaused
                      ? resumeGame
                      : pauseGame,
                  child: Text(isPaused ? 'Resume' : 'Pause'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
