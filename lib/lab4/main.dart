import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const Magic8BallApp());
}

class Magic8BallApp extends StatelessWidget {
  const Magic8BallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Magic 8 Ball',
      home: const Magic8BallPage(),
    );
  }
}

class Magic8BallPage extends StatefulWidget {
  const Magic8BallPage({super.key});

  @override
  State<Magic8BallPage> createState() => _Magic8BallPageState();
}

class _Magic8BallPageState extends State<Magic8BallPage> {
  final Random _random = Random();

  final List<String> _answers = [
    'YES',
    'NO',
    'ASK\nAGAIN\nLATER',
    'DEFINITELY',
    'NOT\nSO GOOD',
  ];

  int _answerIndex = 2;

  void _askBall() {
    setState(() {
      _answerIndex = _random.nextInt(_answers.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF63B2EB),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F2F9),
        elevation: 0,
        title: const Text(
          'Magic 8 Ball',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      body: Center(
        child: GestureDetector(
          onTap: _askBall,
          child: SizedBox(
            width: 330,
            height: 330,
            child: Stack(
              alignment: Alignment.center,
              children: [

                // Bóng đổ phía dưới
                Positioned(
                  bottom: 18,
                  child: Container(
                    width: 290,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),

                // Quả Magic 8 Ball
                Positioned(
                  top: 10,
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        center: Alignment(-0.35, -0.4),
                        radius: 0.85,
                        colors: [
                          Color(0xFF666666),
                          Color(0xFF333333),
                          Color(0xFF171717),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Center(
                      child: Container(
                        width: 105,
                        height: 105,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF05080D),
                          border: Border.all(
                            color: Color(0xFF777777),
                            width: 4,
                          ),
                        ),

                        child: Center(
                          child: ClipPath(
                            clipper: TriangleClipper(),
                            child: Container(
                              width: 75,
                              height: 70,
                              color: const Color(0xFF00558A),
                              alignment: Alignment.center,
                              child: Text(
                                _answers[_answerIndex],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF00A7D8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Tạo hình tam giác xanh bên trong quả cầu
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}