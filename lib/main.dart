// lib/main.dart - CONNECTIVITY WRAPPER BILAN
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/app_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/vehicle_provider.dart';
import 'constants/app_constants.dart';
import 'screens/splash_screen.dart';
import 'widgets/connectivity_wrapper.dart'; // 🔧 QO'SHILDI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Supabase
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
    debugPrint('✅ Supabase initialized successfully');
  } catch (e) {
    debugPrint('❌ Supabase initialization error: $e');
    // App will continue to work without Supabase for demo purposes
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        // 🔧 TUZATILDI: ConnectivityWrapper bilan o'rab olish
        home: ConnectivityWrapper(
          showNoInternetScreen: true, // 🔧 YOQILDI
          child: const SplashScreen(),
        ),
      ),
    );
  }
}
