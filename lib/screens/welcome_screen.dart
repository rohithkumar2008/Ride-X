import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Pastel pink from the design
  static const Color pink = Color(0xFFFFA3D7);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // --------------------------------------------------
          // LAYER 1: BACKGROUND (Map)
          // --------------------------------------------------
          Positioned.fill(
            child: Image.asset("assets/images/map_bg.jpg", fit: BoxFit.cover),
          ),

          // --------------------------------------------------
          // LAYER 2: WHITE OVERLAY (Hides the map mostly)
          // --------------------------------------------------
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.96)),
          ),

          // --------------------------------------------------
          // LAYER 3: BOTTOM FADE (Moved BEHIND the graphic)
          // This ensures the white fade doesn't wash out the black graphic
          // --------------------------------------------------
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.0),
                    Colors.white.withOpacity(0.8),
                    Colors.white,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // --------------------------------------------------
          // LAYER 4: TOP GRAPHIC (The Black Swoosh)
          // Now on top of the fade, with NO opacity (Full Black)
          // --------------------------------------------------
          Positioned(
            top: size.height * -0.12, // Moved up slightly to clear text
            left:
                size.width *
                -0.45, // Moved left to center the intersection better
            child: Image.asset(
              "assets/images/logo_black.png",
              width: size.width * 1.9, // Made BIGGER (Thicker lines)
              fit: BoxFit.contain,
              color: Colors.black, // Forces 100% Black
            ),
          ),

          // --------------------------------------------------
          // LAYER 5: CONTENT (Text, Icon, Button)
          // --------------------------------------------------
          SafeArea(
            child: Stack(
              children: [
                // A) TEXT BLOCK
                Positioned(
                  top: size.height * 0.33,
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 48,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2.0,
                          ),
                          children: [
                            TextSpan(
                              text: "Your ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: "pass.",
                              style: TextStyle(
                                color: Color.fromARGB(255, 7, 113, 199),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),

                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 48,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -2.0,
                          ),
                          children: [
                            TextSpan(
                              text: "In your ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: "pocket.",
                              style: TextStyle(
                                color: Color.fromARGB(255, 7, 113, 199),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // B) CENTER APP ICON (Clean, No Black Border)
                Positioned(
                  top: size.height * 0.59,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      "assets/images/app_logo(white).png",
                      width: 84, // Same size as before
                      height: 84,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // C) GET STARTED BUTTON
                Positioned(
                  bottom: size.height * 0.12,
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                  child: Container(
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(34),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/get-started');
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right, size: 28),
                        ],
                      ),
                    ),
                  ),
                ),

                // D) SIGN IN LINK
                Positioned(
                  bottom: size.height * 0.09,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black.withOpacity(0.60),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/sign-in');
                          },
                          child: const Text(
                            "sign in",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 7, 113, 199),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
