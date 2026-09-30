import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
      ),
      home: const BMIInputPage(),
    );
  }
}

// ======================================================
// CARD DÙNG CHUNG
// ======================================================

class ReusableCard extends StatelessWidget {
  final Color colour;
  final Widget child;
  final VoidCallback? onTap;

  const ReusableCard({
    super.key,
    required this.colour,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(16),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: child,
        ),
      ),
    );
  }
}

// ======================================================
// GENDER
// ======================================================

enum Gender {
  male,
  female,
}

// ======================================================
// TRANG NHẬP BMI
// ======================================================

class BMIInputPage extends StatefulWidget {
  const BMIInputPage({super.key});

  @override
  State<BMIInputPage> createState() => _BMIInputPageState();
}

class _BMIInputPageState extends State<BMIInputPage> {
  Gender? _selectedGender;

  double _height = 170;
  int _weight = 60;
  int _age = 20;

  static const Color _backgroundColor = Color(0xFF0A0E21);
  static const Color _activeCardColor = Color(0xFF1D1E33);
  static const Color _inactiveCardColor = Color(0xFF111328);
  static const Color _accentColor = Color(0xFFEB1555);

  // ====================================================
  // TÍNH BMI
  // ====================================================

  void _calculateBMI() {
    final double heightInM = _height / 100;
    final double bmi = _weight / (heightInM * heightInM);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BMIResultPage(
          bmi: bmi,
          age: _age,
        ),
      ),
    );
  }

  // ====================================================
  // MÀU CARD GIỚI TÍNH
  // ====================================================

  Color _getGenderColor(Gender gender) {
    if (_selectedGender == gender) {
      return _activeCardColor;
    }

    return _inactiveCardColor;
  }

  // ====================================================
  // CARD GIỚI TÍNH
  // ====================================================

  Widget _buildGenderCard(Gender gender) {
    final bool isMale = gender == Gender.male;

    return Expanded(
      child: ReusableCard(
        colour: _getGenderColor(gender),
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isMale ? Icons.male : Icons.female,
              size: 52,
              color: _selectedGender == gender
                  ? _accentColor
                  : Colors.white,
            ),
            const SizedBox(height: 5),
            Text(
              isMale ? 'MALE' : 'FEMALE',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // NÚT + VÀ -
  // ====================================================

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 42,
      height: 42,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: const Color(0xFF4C4F5E),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const CircleBorder(),
        ),
        child: Icon(
          icon,
          size: 24,
        ),
      ),
    );
  }

  // ====================================================
  // CARD WEIGHT / AGE
  // ====================================================

  Widget _buildNumberCard({
    required String title,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Expanded(
      child: ReusableCard(
        colour: _activeCardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _circleButton(
                  icon: Icons.remove,
                  onPressed: onMinus,
                ),

                const SizedBox(width: 12),

                _circleButton(
                  icon: Icons.add,
                  onPressed: onPlus,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ====================================================
  // GIAO DIỆN
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,

      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'BMI CALCULATOR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // ============================================
            // MALE / FEMALE
            // ============================================

            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _buildGenderCard(Gender.male),
                  _buildGenderCard(Gender.female),
                ],
              ),
            ),

            // ============================================
            // HEIGHT
            // ============================================

            Expanded(
              flex: 3,
              child: ReusableCard(
                colour: _activeCardColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'HEIGHT',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${_height.round()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const Text(
                          ' cm',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: _accentColor,
                        inactiveTrackColor: const Color(0xFF8D8E98),
                        thumbColor: _accentColor,
                        overlayColor: _accentColor.withOpacity(0.15),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 10,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 20,
                        ),
                      ),
                      child: Slider(
                        value: _height,
                        min: 100,
                        max: 220,
                        onChanged: (value) {
                          setState(() {
                            _height = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ============================================
            // WEIGHT / AGE
            // ============================================

            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _buildNumberCard(
                    title: 'WEIGHT',
                    value: _weight,
                    onMinus: () {
                      setState(() {
                        if (_weight > 1) {
                          _weight--;
                        }
                      });
                    },
                    onPlus: () {
                      setState(() {
                        _weight++;
                      });
                    },
                  ),

                  _buildNumberCard(
                    title: 'AGE',
                    value: _age,
                    onMinus: () {
                      setState(() {
                        if (_age > 1) {
                          _age--;
                        }
                      });
                    },
                    onPlus: () {
                      setState(() {
                        _age++;
                      });
                    },
                  ),
                ],
              ),
            ),

            // ============================================
            // CALCULATE
            // ============================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                7,
                5,
                7,
                8,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'CALCULATE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// TRANG KẾT QUẢ BMI
// ======================================================

class BMIResultPage extends StatelessWidget {
  final double bmi;
  final int age;

  const BMIResultPage({
    super.key,
    required this.bmi,
    required this.age,
  });

  String get _category {
    if (bmi < 18.5) {
      return 'Underweight';
    } else if (bmi < 25) {
      return 'Normal';
    } else if (bmi < 30) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Color get _categoryColor {
    if (bmi < 18.5) {
      return Colors.blueAccent;
    } else if (bmi < 25) {
      return Colors.greenAccent;
    } else if (bmi < 30) {
      return Colors.orangeAccent;
    } else {
      return Colors.redAccent;
    }
  }

  String get _interpretation {
    if (bmi < 18.5) {
      return 'You have a below normal body weight.';
    } else if (bmi < 25) {
      return 'You have a normal body weight. Good job!';
    } else if (bmi < 30) {
      return 'You have an above normal body weight.';
    } else {
      return 'Your BMI is quite high. Consider maintaining a healthier lifestyle.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'BMI RESULT',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your Result',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1D1E33),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        _category.toUpperCase(),
                        style: TextStyle(
                          color: _categoryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),

                      Text(
                        bmi.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        'Age: $age',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                        ),
                      ),

                      Text(
                        _interpretation,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB1555),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'RE-CALCULATE',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}