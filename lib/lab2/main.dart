import 'package:flutter/material.dart';

void main() {
  runApp(const MiCardApp());
}

class MiCardApp extends StatelessWidget {
  const MiCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiCard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MiCardPage(),
    );
  }
}

class MiCardPage extends StatelessWidget {
  const MiCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
              child: Text(
                '👤',
                style: TextStyle(fontSize: 60),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lê Thị Phát',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pacifico',
                letterSpacing: 2.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'FLUTTER DEVELOPER',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Divider(
              color: Colors.teal.shade100,
              thickness: 1,
              indent: 40,
              endIndent: 40,
            ),
            const SizedBox(height: 20),
            // Phone card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.teal),
                title: const Text(
                  '+84 900 000 000',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            // Email card
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.teal),
                title: const Text(
                  'lethiphat@example.com',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
