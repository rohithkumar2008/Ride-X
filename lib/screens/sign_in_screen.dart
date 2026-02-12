import 'package:flutter/material.dart';
// 👇 Ensure this matches your file name!
import 'get_started_screen.dart'; 

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  static const Color pink = Color(0xFFFF6BCB);
  static const Color black = Color(0xFF0D0D0D);
  static const Color textGrey = Color(0xFF555555);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      extendBodyBehindAppBar: true,
      
      // 👇 The Fixed Custom App Bar is called here
      appBar: const CustomAppBar(),

      // 👇 Reusable Background
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height - padding.top - padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // Title
                    const Text(
                      "Let's sign you in.",
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: black,
                        letterSpacing: -1.5,
                        height: 1.0,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    const Text(
                      "Welcome back.\nYou've been missed!",
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: textGrey,
                        height: 1.2,
                      ),
                    ),

                    const Spacer(flex: 1),

                    // Phone/Email input
                    _buildTextField(
                      label: "Phone, email or username",
                      icon: Icons.person_outline,
                      isPassword: false,
                    ),

                    const SizedBox(height: 16),

                    // Password input
                    _buildTextField(
                      label: "Password", 
                      icon: Icons.lock_outline,
                      isPassword: true,
                    ),

                    const SizedBox(height: 40),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      height: 51,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          // TODO: Auth logic
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontFamily: 'SF Pro Display',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Footer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            color: textGrey, 
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Using pushReplacement here is okay for switching modes
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GetStartedScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              fontFamily: 'SF Pro Display',
                              color: pink,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildTextField({
    required String label,
    required IconData icon,
    required bool isPassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: black,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 20,
          ),
          hintText: label,
          hintStyle: TextStyle(
            fontFamily: 'Segoe UI',
            color: Colors.grey.shade400,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? const Icon(Icons.visibility_off_outlined, color: Colors.grey)
              : null,
        ),
      ),
    );
  }
}

// ============================================================================
// 👇 SMART CUSTOM APP BAR (Handles Navigation automatically)
// ============================================================================

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 120, 
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
        child: GestureDetector(
          onTap: () {
            // 👇 SMART NAVIGATION LOGIC 👇
            if (Navigator.canPop(context)) {
              // If there is history, go back
              Navigator.pop(context);
            } else {
              // If no history (because we replaced the screen), Force Go Back to Start!
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const GetStartedScreen())
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              // Made slightly darker (300) so it's clearly visible against white
              color: Colors.grey.shade300, 
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back_ios_new, 
                  color: Colors.grey.shade700, 
                  size: 14, 
                ),
                const SizedBox(width: 4),
                Text(
                  "back",
                  style: TextStyle(
                    fontFamily: 'SF Pro Display', 
                    color: Colors.grey.shade700, 
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4), 
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ============================================================================
// 👇 REUSABLE BACKGROUND
// ============================================================================

class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            "assets/images/map_bg.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.95),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.85),
                  Colors.white,
                ],
                stops: const [0.0, 0.10, 0.5, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}