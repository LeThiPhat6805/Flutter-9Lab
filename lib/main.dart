import 'package:flutter/material.dart';

// Import all labs
import 'lab1/main.dart' as lab1;
import 'lab2/main.dart' as lab2;
import 'lab3/main.dart' as lab3;
import 'lab4/main.dart' as lab4;
import 'lab5/main.dart' as lab5;
import 'lab6/main.dart' as lab6;
import 'lab7/main.dart' as lab7;
import 'lab8/main.dart' as lab8;
import 'lab9/main.dart' as lab9;

void main() {
  runApp(const NineLabApp());
}

class NineLabApp extends StatelessWidget {
  const NineLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '9Lab – Flutter Labs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LabMenuPage(),
    );
  }
}

// ───── Lab entry model ───────────────────────────────────────────
class _LabEntry {
  final String title;
  final String subtitle;
  final String emoji;
  final Widget Function() builder;

  const _LabEntry({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.builder,
  });
}

final List<_LabEntry> _labs = [
  _LabEntry(
    title: 'Lab 1 – I Am Rich',
    subtitle: 'Hiển thị tiêu đề và viên kim cương ở giữa',
    emoji: '💎',
    builder: () => const lab1.IAmRichPage(),
  ),
  _LabEntry(
    title: 'Lab 2 – MiCard',
    subtitle: 'Profile cá nhân với avatar và thông tin cơ bản',
    emoji: '👤',
    builder: () => const lab2.MiCardPage(),
  ),
  _LabEntry(
    title: 'Lab 3 – Dicee',
    subtitle: 'Ứng dụng gieo xúc sắc – StatefulWidget',
    emoji: '🎲',
    builder: () => const lab3.DiceePage(),
  ),
  _LabEntry(
    title: 'Lab 4 – Magic 8 Ball',
    subtitle: 'Quả bóng ma thuật trả lời câu hỏi ngẫu nhiên',
    emoji: '🎱',
    builder: () => const lab4.Magic8BallPage(),
  ),
  _LabEntry(
    title: 'Lab 5 – Xylophone',
    subtitle: 'Đàn Xylophone 7 notes (audioplayers)',
    emoji: '🎵',
    builder: () => const lab5.XylophonePage(),
  ),
  _LabEntry(
    title: 'Lab 6 – Quizzler',
    subtitle: 'Ứng dụng đố vui Đúng / Sai với bảng điểm',
    emoji: '❓',
    builder: () => const lab6.QuizzlerPage(),
  ),
  _LabEntry(
    title: 'Lab 7 – Destini',
    subtitle: 'Câu chuyện phiêu lưu với nhiều kết thúc',
    emoji: '🗺️',
    builder: () => const lab7.DestiniPage(),
  ),
  _LabEntry(
    title: 'Lab 8 – BMI Calculator',
    subtitle: 'Máy tính BMI với Slider, FAB, Navigator',
    emoji: '⚖️',
    builder: () => const lab8.BMIInputPage(),
  ),
  _LabEntry(
    title: 'Lab 9 – Clima',
    subtitle: 'Thời tiết theo vị trí & thành phố (OpenWeatherAPI)',
    emoji: '🌤️',
    builder: () => const lab9.WeatherScreen(),
  ),
];

// ───── Lab Menu Page ─────────────────────────────────────────────
class LabMenuPage extends StatelessWidget {
  const LabMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '9 Lab – Flutter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _labs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 4),
        itemBuilder: (context, index) {
          final lab = _labs[index];
          return Card(
            elevation: 2,
            child: ListTile(
              leading: Text(lab.emoji, style: const TextStyle(fontSize: 32)),
              title: Text(
                lab.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(lab.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => lab.builder()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}