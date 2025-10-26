import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_selection_screen.dart';
import 'chat_screen.dart';
import '../services/database_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('language');

    final dbService = DatabaseService();
    await dbService.initializeUser();

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    if (language == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ChatScreen(language: language)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212121),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10A37F), Color(0xFF19C37D)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite,
                  size: 50, color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 20),
            const Text(
              'MoodMate AI',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xFF10A37F)),
            ),
          ],
        ),
      ),
    );
  }
}
