import 'package:flutter/material.dart';
// Note: Removed Firebase imports

// Import your screens
import 'screens/welcome_screen.dart';
import 'screens/sign_in_screen.dart';
import 'screens/get_started_screen.dart';

void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

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
        fontFamily: 'SF Pro Display', 
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