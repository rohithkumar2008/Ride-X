import 'package:flutter/material.dart';
import '../api_service.dart'; // Ensure this points to your api_service.dart
import 'get_started_screen.dart'; 

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // --- Colors ---
  static const Color pink = Color(0xFFFF6BCB);
  static const Color black = Color(0xFF0D0D0D);
  static const Color textGrey = Color(0xFF555555);

  // --- Controllers & State ---
  final TextEditingController _identifierController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- REAL-TIME SIGN IN LOGIC ---
  Future<void> _handleSignIn() async {
    if (_identifierController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Sending login attempt to your Node.js server at 172.20.10.3
      await ApiService.submitApplication(
        name: "Login Attempt",
        email: _identifierController.text.trim(),
        college: "N/A",
        from: "Login Screen",
        to: "Authorizing",
      );

      setState(() => _isLoading = false);
      
      // If success, you would normally navigate to a home screen here
      print("✅ Sign-in request sent to MongoDB!");
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Login request successful!")),
      );

    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Connection Failed. Check Server/VPN")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
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

                    // Identifier Input
                    _buildTextField(
                      controller: _identifierController,
                      label: "Phone, email or username",
                      icon: Icons.person_outline,
                      isPassword: false,
                    ),

                    const SizedBox(height: 16),

                    // Password Input
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password", 
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isVisible: _isPasswordVisible,
                      onToggleVisibility: () {
                        setState(() => _isPasswordVisible = !_isPasswordVisible);
                      }
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
                        onPressed: _isLoading ? null : _handleSignIn,
                        child: _isLoading 
                          ? const SizedBox(
                              height: 20, 
                              width: 20, 
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                            )
                          : const Text(
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isPassword,
    bool isVisible = false,
    VoidCallback? onToggleVisibility,
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
        controller: controller,
        obscureText: isPassword && !isVisible,
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: black,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
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
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: Colors.grey,
                ),
                onPressed: onToggleVisibility,
              )
            : null,
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM APP BAR
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
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const GetStartedScreen())
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300, 
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new, color: Colors.grey.shade700, size: 14),
                const SizedBox(width: 4),
                Text("back", style: TextStyle(fontFamily: 'SF Pro Display', color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.w600)),
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
// REUSABLE BACKGROUND
// ============================================================================
class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset("assets/images/map_bg.jpg", fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.white.withOpacity(0.95))),
        Positioned.fill(child: child),
      ],
    );
  }
}