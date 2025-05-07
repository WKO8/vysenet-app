import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vysenet/firebase_options.dart';
import 'package:vysenet/screens/scan_screen.dart';
import 'screens/login_screen.dart';
import 'screens/add_device_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/recovery_password_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { // Chamando initialize
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScanScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/reset': (_) => RecoveryPasswordScreen(),
        '/add': (_) => AddDeviceScreen(),
        '/scan': (_) => ScanScreen(),
        '/profile': (_) => ProfileScreen(),
      },
    );
  }
}