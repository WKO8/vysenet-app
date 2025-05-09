import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vysenet/firebase_options.dart';
import 'package:vysenet/screens/scan_screen.dart';
import 'package:vysenet/services/auth_shared_preference_service.dart';
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
      home: FutureBuilder<bool>(
        future: AuthSharedPreferences.loadLoggedInState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while waiting
          } else if (snapshot.hasData && snapshot.data == true) {
            return ScanScreen(); // Navigate to ProfileScreen if logged in
          } else {
            return LoginScreen(); // Navigate to LoginScreen if not logged in
          }
        },
      ),
      routes: {
        '/login': (_) => LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/recovery': (_) => RecoveryPasswordScreen(),
        '/add': (_) => AddDeviceScreen(),
        '/scan': (_) => ScanScreen(),
        '/profile': (_) => ProfileScreen(),
      },
    );
  }
}