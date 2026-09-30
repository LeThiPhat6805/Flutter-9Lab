import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Lab 9: Clima
// Sử dụng wttr.in - hoàn toàn miễn phí, không cần API key
// pubspec.yaml cần có: http: ^1.2.0

void main() {
  runApp(const ClimaApp());
}

class ClimaApp extends StatelessWidget {
  const ClimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const WeatherScreen(),
    );
  }
}

// ───── Model ─────────────────────────────────────────────────────
class WeatherData {
  final String cityName;
  final int temperature;
  final int weatherCode;

  const WeatherData({
    required this.cityName,
    required this.temperature,
    required this.weatherCode,
  });

  /// Weather emoji hiện cạnh nhiệt độ
  String get weatherIcon {
    if (weatherCode == 113) return '☀️';
    if (weatherCode == 116) return '🌤️';
    if (weatherCode == 119 || weatherCode == 122) return '☁️';
    if (weatherCode == 143 || weatherCode == 248 || weatherCode == 260) return '🌫️';
    if ([200, 386, 389, 392, 395].contains(weatherCode)) return '⛈️';
    if ([227, 230, 329, 332, 335, 338].contains(weatherCode)) return '❄️';
    if (weatherCode >= 293 && weatherCode <= 321) return '🌧️';
    if (weatherCode >= 176 && weatherCode <= 284) return '🌦️';
    return '🌡️';
  }

  /// Emoji vui trong câu "It's [X] time in [City]!"
  String get conditionEmoji {
    if (weatherCode == 113) return '🍦';
    if (weatherCode == 116) return '😎';
    if (weatherCode == 119 || weatherCode == 122) return '☕';
    if ([227, 230, 329, 332, 335, 338].contains(weatherCode)) return '🧤';
    if ([200, 386, 389].contains(weatherCode)) return '⚡';
    if (weatherCode >= 293 && weatherCode <= 321) return '☂️';
    return '🌡️';
  }

  factory WeatherData.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current_condition'][0];
    return WeatherData(
      cityName: city,
      temperature: int.parse(current['temp_C'] as String),
      weatherCode: int.parse(current['weatherCode'] as String),
    );
  }
}

// ───── Service (wttr.in - không cần API key) ─────────────────────
class WeatherService {
  // wttr.in: free, no API key, query by city name
  static const _base = 'https://wttr.in';

  Future<WeatherData?> fetchByCity(String city) async {
    try {
      final res = await http.get(
        Uri.parse('$_base/$city?format=j1'),
        headers: {'User-Agent': 'Flutter-Clima-Lab9'},
      );
      if (res.statusCode == 200) {
        return WeatherData.fromJson(jsonDecode(res.body), city);
      }
    } catch (e) {
      debugPrint('Weather error: $e');
    }
    return null;
  }
}

// ───── Screen 1: Weather ─────────────────────────────────────────
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  WeatherData? _weather;
  bool _isLoading = false;
  String? _error;

  Future<void> _loadWeather(String city) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final data = await WeatherService().fetchByCity(city);
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (data != null) {
          _weather = data;
        } else {
          _error = 'Không tìm thấy thành phố!';
        }
      });
    }
  }

  void _openCityScreen() async {
    final city = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const CityScreen()),
    );
    if (city != null && city.trim().isNotEmpty) {
      _loadWeather(city.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = _weather;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF2d4a6e), Color(0xFF1a3050)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.navigation,
                      color: Color(0xFF9b59b6),
                      size: 32,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.location_city,
                        color: Color(0xFF9b59b6),
                        size: 32,
                      ),
                      onPressed: _openCityScreen,
                    ),
                  ],
                ),

                const Spacer(),

                // ── Loading / Error / Weather ──
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                else if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.white70, fontSize: 20),
                    ),
                  )
                else ...[
                  // ── Nhiệt độ + icon thời tiết ──
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          w != null ? '${w.temperature}°' : '--°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          w?.weatherIcon ?? '☀️',
                          style: const TextStyle(fontSize: 80),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── "It's [emoji] time in [City]!" ──
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      w != null
                          ? "It's ${w.conditionEmoji}\ntime in\n${w.cityName}!"
                          : "Nhấn 🏢\nđể xem\nthời tiết!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ───── Screen 2: City Search ─────────────────────────────────────
class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0d2b1e), Color(0xFF1a4a30), Color(0xFF0a2018)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF9b59b6),
                        size: 28,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Icon(
                      Icons.location_city,
                      color: Color(0xFF9b59b6),
                      size: 28,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── TextField ──
                TextField(
                  controller: _controller,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Enter City Name',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (v) => Navigator.pop(context, v),
                ),

                const SizedBox(height: 20),

                // ── Get Weather button ──
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, _controller.text),
                    child: const Text(
                      'Get Weather',
                      style: TextStyle(
                        color: Color(0xFF9b59b6),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
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
