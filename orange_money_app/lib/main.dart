import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.seedSampleData();
  runApp(const OrangeMoneyApp());
}

class OrangeMoneyApp extends StatelessWidget {
  const OrangeMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orange Money',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFFFF7900),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFFFF7900),
          secondary: const Color(0xFFFF7900),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSurface: const Color(0xFF333333),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF7900),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
