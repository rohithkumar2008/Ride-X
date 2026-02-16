import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'Mobile_Number_Page.dart'; 
import 'sign_in_screen.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  // --- Colors ---
  static const Color pink = Color(0xFFFF6BCB);
  static const Color black = Color(0xFF0D0D0D);
  static const Color customGrey = Color.fromRGBO(117, 117, 117, 1.0);
  static const Color errorRed = Color(0xFFFF3B30);

  // --- Controllers & Focus Nodes ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  String? _passwordError; 

  // --- Password Strength Logic ---
  int get _strengthScore {
    String p = _passwordController.text;
    if (p.isEmpty) return 0;
    int count = 0;
    if (p.contains(RegExp(r'[a-zA-Z]'))) count++; 
    if (p.contains(RegExp(r'[0-9]'))) count++;    
    if (p.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) count++; 
    return count; 
  }

  Color get _strengthColor {
    if (_strengthScore == 1) return Colors.redAccent;
    if (_strengthScore == 2) return Colors.orangeAccent;
    if (_strengthScore == 3) return Colors.greenAccent;
    return Colors.grey.shade200; 
  }

  String get _strengthText {
    if (_strengthScore == 1) return "Weak";
    if (_strengthScore == 2) return "Medium";
    if (_strengthScore == 3) return "Strong";
    return "Enter Password";
  }

  // --- Validation Logic ---
  bool get _isFormValid {
    final passLen = _passwordController.text.length;
    // Simple Email Regex check
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    
    return _nameController.text.trim().isNotEmpty &&
           emailRegex.hasMatch(_emailController.text.trim()) &&
           passLen >= 6 && 
           passLen <= 12; 
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isNotEmpty) {
        if (value.length < 6) {
          _passwordError = "Password is too short (Min 6)";
        } else if (value.length > 12) {
          _passwordError = "Password is too long (Max 12)";
        } else {
          _passwordError = null; 
        }
      } else {
        _passwordError = null; 
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {}); 
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height - padding.top - padding.bottom),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text("Start your\njourney.", style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 40, fontWeight: FontWeight.w900, color: black, letterSpacing: -1.5, height: 1.0)),
                    const SizedBox(height: 10),
                    const Text("Create your account to start\nriding with Ridex.", style: TextStyle(fontFamily: 'Segoe UI', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey, height: 1.2)),
                    const Spacer(),
                    
                    // --- 1. Name Input ---
                    _buildInputContainer(
                      child: TextField(
                        controller: _nameController,
                        onChanged: (_) => setState(() {}),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), LengthLimitingTextInputFormatter(30)],
                        decoration: _inputDecoration("Full Name", Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- 2. Mail ID Input (Clean, No Dropdown) ---
                    _buildInputContainer(
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (_) => setState(() {}),
                        decoration: _inputDecoration("Mail ID", Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // --- 3. Password Input ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputContainer(
                          borderColor: _passwordError != null ? errorRed : Colors.transparent,
                          child: TextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode, 
                            onChanged: (value) {
                              _validatePassword(value);
                            },
                            obscureText: !_isPasswordVisible,
                            inputFormatters: [LengthLimitingTextInputFormatter(12)], 
                            decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(
                              suffixIcon: GestureDetector(
                                onLongPressStart: (_) => setState(() => _isPasswordVisible = true),
                                onLongPressEnd: (_) => setState(() => _isPasswordVisible = false),
                                child: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        
                        if (_passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 10.0),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: errorRed, size: 14),
                                const SizedBox(width: 5),
                                Text(
                                  _passwordError!,
                                  style: const TextStyle(fontFamily: 'SF Pro Display', color: errorRed, fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    
                    // Strength Bars
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: (_passwordFocusNode.hasFocus || _passwordController.text.isNotEmpty) ? 1.0 : 0.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 4.0, right: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: List.generate(3, (index) => Expanded(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  height: 6, 
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: index < _strengthScore ? _strengthColor : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20), 
                                  ),
                                ),
                              )),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_strengthText, style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 13, fontWeight: FontWeight.bold, color: _strengthColor)),
                                Text("${_passwordController.text.length}/12", style: TextStyle(fontFamily: 'Segoe UI', fontSize: 12, color: _passwordController.text.length > 12 ? errorRed : Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),

                    // --- Create Account Button ---
                    SizedBox(
                      width: double.infinity,
                      height: 51,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid ? black : Colors.grey.shade300,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: _isFormValid ? () {
                          // 👉 PASSING EMAIL TO NEXT SCREEN
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => MobileNumberScreen(email: _emailController.text)
                            )
                          );
                        } : null,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Create Account", style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.w600, color: _isFormValid ? Colors.white : Colors.grey.shade500)),
                            const SizedBox(width: 6),
                            Icon(Icons.arrow_forward, size: 20, color: _isFormValid ? Colors.white : Colors.grey.shade500),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFooter(context),
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

  // --- UI Helpers ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 120, 
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent, 
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: customGrey, width: 1.5), 
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new, color: customGrey, size: 14),
                SizedBox(width: 4),
                Text("back", style: TextStyle(fontFamily: 'SF Pro Display', color: customGrey, fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child, Color borderColor = Colors.transparent}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'Segoe UI', color: Colors.grey, fontSize: 16),
      prefixIcon: Icon(icon, color: Colors.grey),
      border: InputBorder.none,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an account? ", style: TextStyle(fontFamily: 'Segoe UI', color: Colors.grey, fontSize: 14)),
        GestureDetector(
          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInScreen())),
          child: const Text("Sign In", style: TextStyle(fontFamily: 'SF Pro Display', color: pink, fontWeight: FontWeight.w700, fontSize: 14)),
        ),
      ],
    );
  }
}

class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset("assets/images/map_bg.jpg", fit: BoxFit.cover)),
        Positioned.fill(child: Container(color: Colors.white.withOpacity(0.95))),
        Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white10, Colors.white], stops: [0.0, 1.0])))),
        Positioned.fill(child: child),
      ],
    );
  }
}