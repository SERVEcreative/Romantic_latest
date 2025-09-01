import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_colors.dart';
import 'core/utils/logger.dart';
import 'core/config/app_config.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/messaging/providers/chat_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize app configuration
  AppConfig.setEnvironment(Environment.development);
  AppConfig.printConfig();
  
  // Initialize AdMob with error handling
  try {
    await MobileAds.instance.initialize();
    Logger.success('AdMob initialized successfully');
  } catch (e) {
    Logger.error('AdMob initialization failed', e);
    // Continue app execution even if AdMob fails
  }
  
  runApp(const RomanticLoginApp());
}

class RomanticLoginApp extends StatelessWidget {
  const RomanticLoginApp({super.key});

  // Global navigation key for accessing navigator from anywhere
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatProvider(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey, // Add global navigation key
        theme: ThemeData(
          primarySwatch: Colors.pink,
          textTheme: GoogleFonts.poppinsTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
