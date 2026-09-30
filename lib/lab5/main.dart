import 'package:flutter/material.dart';

// Lab 5: Xylophone
// NOTE: This lab uses the audioplayers package.
// Add to pubspec.yaml:
//   audioplayers: ^6.0.0
// Place note audio files in assets/note1.wav ... note7.wav
// Then run: flutter pub get

void main() {
  runApp(const XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xylophone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const XylophonePage(),
    );
  }
}

class XylophonePage extends StatelessWidget {
  const XylophonePage({super.key});

  // 7 notes with their colors (Do Re Mi Fa Sol La Si)
  static const List<Color> _noteColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.purple,
  ];

  static const List<String> _noteNames = [
    'Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Si',
  ];

  void _playNote(int noteNumber) {
    // To enable audio: import 'package:audioplayers/audioplayers.dart';
    // AudioPlayer player = AudioPlayer();
    // player.play(AssetSource('note$noteNumber.wav'));
    debugPrint('Playing note $noteNumber: ${_noteNames[noteNumber - 1]}');
  }

  Widget _buildKey(int noteNumber) {
    final color = _noteColors[noteNumber - 1];
    final name = _noteNames[noteNumber - 1];
    return Expanded(
      child: GestureDetector(
        onTap: () => _playNote(noteNumber),
        child: Container(
          color: color,
          child: Center(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xylophone 🎵'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: List.generate(7, (index) => _buildKey(index + 1)),
        ),
      ),
    );
  }
}
