import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/mood_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/journal_provider.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await LanguageService.instance.initialize();

  runApp(const MoodMateApp());
}

class MoodMateApp extends StatelessWidget {
  const MoodMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => JournalProvider()),
      ],
      child: MaterialApp(
        title: 'MoodMate AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF212121),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF10A37F),
            secondary: Color(0xFF19C37D),
            surface: Color(0xFF2F2F2F),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
