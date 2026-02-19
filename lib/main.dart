import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Import Core
import 'firebase_options.dart'; // 2. Import generated options

// Import your screens
import 'screens/welcome_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/get_started_screen.dart';

void main() async {
  // 3. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Ridex",
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'SF Pro Display', // Added this to ensure your Apple look is consistent
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/sign-in': (context) => const SignInScreen(),
        '/get-started': (context) => const GetStartedScreen(),
      },
    );
  }
}