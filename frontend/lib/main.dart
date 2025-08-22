import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize AdMob with error handling
  try {
    await MobileAds.instance.initialize();
    print('AdMob initialized successfully');
  } catch (e) {
    print('AdMob initialization failed: $e');
    // Continue app execution even if AdMob fails
  }
  
  runApp(const RomanticLoginApp());
}

class RomanticLoginApp extends StatelessWidget {
  const RomanticLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Romantic Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
