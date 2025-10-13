// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static MyAppState of(BuildContext context) => context.findAncestorStateOfType<MyAppState>()!;

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get currentThemeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _carregarPreferenciaDeTema();
  }

  Future<void> _carregarPreferenciaDeTema() async {
    final prefs = await SharedPreferences.getInstance();
    final temaGuardado = prefs.getString('themeMode') ?? 'system';
    setState(() {
      switch (temaGuardado) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    });
  }

  Future<void> changeTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    switch (themeMode) {
      case ThemeMode.light:
        themeString = 'light';
        break;
      case ThemeMode.dark:
        themeString = 'dark';
        break;
      default:
        themeString = 'system';
    }
    await prefs.setString('themeMode', themeString);
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horóscopo SAPO',
      
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple[700], foregroundColor: Colors.white),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple[800], foregroundColor: Colors.white),
        cardColor: const Color(0xFF1E1E1E),
      ),

      themeMode: _themeMode, 
      
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
