import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart'; // Required for Apple Loading
import 'dart:async';
import 'dart:math'; 
import 'role_selection_page.dart'; 

class MobileNumberScreen extends StatefulWidget {
  final String email; 
  
  const MobileNumberScreen({
    super.key, 
    required this.email 
  });

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> with SingleTickerProviderStateMixin {
  // --- Design Tokens ---
  static const Color black = Color(0xFF0D0D0D);
  static const Color appleBlue = Color(0xFF007AFF);
  static const Color appleRed = Color(0xFFFF3B30);
  static const Color bgGrey = Color(0xFFF2F2F7);
  static const Color lockedGrey = Color(0xFFE5E5EA); // Darker grey for locked state

  // --- Controllers ---
  late TextEditingController _emailController;
  final TextEditingController _otpController = TextEditingController();
  
  // --- State ---
  bool _isCodeSent = false;
  bool _isLoading = false;
  bool _isError = false; 
  int _timeLeft = 60;
  Timer? _timer;

  // --- Animation ---
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Auto-fill email
    _emailController = TextEditingController(text: widget.email);

    // Setup Shake Animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
    
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _shakeController.reset(); 
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  // --- Logic 1: Confirm Email ---
  void _attemptSendCode() {
    // Basic validation
    if (!_emailController.text.contains("@") || !_emailController.text.contains(".")) {
       _triggerErrorShake();
       return;
    }

    showDialog(
      context: context,
      builder: (context) => CupertinoStyleDialog(
        title: "Is this correct?",
        content: "We will send a verification code to:\n\n${_emailController.text}\n\nWould you like to continue?",
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context); 
          _sendCode(); 
        },
      ),
    );
  }

  // --- Logic 2: Simulate Sending ---
  void _sendCode() async {
    setState(() => _isLoading = true);
    
    // Simulate Network Delay (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isCodeSent = true;
        _startTimer();
      });
    }
  }

  // --- Logic 3: Verify OTP ---
  void _verifyOtp() {
    String enteredCode = _otpController.text.replaceAll(" ", "");
    
    // 🔒 MOCK VALIDATION: Code is always "123456"
    if (enteredCode == "123456") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
      );
    } else {
      _triggerErrorShake();
      _otpController.clear();
    }
  }

  void _triggerErrorShake() {
    setState(() => _isError = true);
    _shakeController.forward();
    HapticFeedback.mediumImpact(); 
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isError = false);
    });
  }

  void _startTimer() {
    _timeLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) _timeLeft--;
        else _timer?.cancel();
      });
    });
  }

  void _resetEmailEdit() {
    setState(() {
      _isCodeSent = false;
      _isError = false;
      _otpController.clear();
      _timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonActive = !_isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: bgGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios_new, color: Colors.grey.shade600, size: 14),
                  const SizedBox(width: 4),
                  Text("back", style: TextStyle(fontFamily: 'SF Pro Display', color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // --- Title ---
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _isCodeSent ? "Check your\nemail." : "Confirm your\nemail.",
                  key: ValueKey(_isCodeSent),
                  style: const TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: black,
                    letterSpacing: -1.5,
                    height: 1.0,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // --- Subtitle ---
              Text(
                _isCodeSent 
                    ? "We've sent a 6-digit code to your email.\nenter the code below."
                    : "We'll send a verification code to your\ninbox. No passwords needed.",
                style: const TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 40),

              // --- 1. EMAIL INPUT (Locks when code sent) ---
              Container(
                decoration: BoxDecoration(
                  color: _isCodeSent ? lockedGrey : bgGrey, // Grey out if locked
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (_isError && !_isCodeSent) ? appleRed : Colors.transparent, 
                    width: 1.5
                  ),
                ),
                child: TextField(
                  controller: _emailController,
                  enabled: !_isCodeSent, // Disable typing when code is sent
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    // Grey text when locked to look like "Lock Mode"
                    color: _isCodeSent ? Colors.grey.shade500 : black,
                  ),
                  inputFormatters: [
                    LowerCaseTextFormatter(), // Force small letters
                  ],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    hintText: "name@example.com",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                    prefixIcon: Icon(Icons.email_outlined, color: _isCodeSent ? Colors.grey : black),
                    suffixIcon: _isCodeSent ? const Icon(Icons.lock, color: Colors.grey, size: 18) : null,
                    border: InputBorder.none,
                  ),
                ),
              ),

              // --- 2. OTP INPUT (Appears below email) ---
              if (_isCodeSent) ...[
                const SizedBox(height: 16),
                
                // Animated Shake for OTP Error
                AnimatedBuilder(
                  animation: _shakeAnimation,
                  builder: (context, child) {
                    final double offset = sin(_shakeController.value * pi * 4) * 10;
                    return Transform.translate(offset: Offset(offset, 0), child: child);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isError ? appleRed : Colors.black12, // Red border on error
                        width: 1.5
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      style: const TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: black,
                        letterSpacing: 4.0,
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        hintText: "000 000",
                        hintStyle: TextStyle(color: Colors.grey, letterSpacing: 1.0, fontSize: 22),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Resend Timer
                Center(
                  child: GestureDetector(
                    onTap: _timeLeft == 0 ? () => setState(() { _timeLeft = 60; _startTimer(); }) : null,
                    child: Text(
                      _timeLeft > 0 ? "Resend code in 00:${_timeLeft.toString().padLeft(2, '0')}" : "Resend Code",
                      style: TextStyle(
                        color: _timeLeft > 0 ? Colors.grey : appleBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              const Spacer(),

              // --- MAIN BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                  onPressed: isButtonActive 
                      ? (_isCodeSent ? _verifyOtp : _attemptSendCode) 
                      : null,
                  child: _isLoading
                      // Apple-style Loading Spinner (White)
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isCodeSent ? "Verify & Login" : "Send Code",
                              style: const TextStyle(fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                          ],
                        ),
                ),
              ),
              
              // --- EDIT EMAIL LINK (Bottom) ---
              if (_isCodeSent) 
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: _resetEmailEdit,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 14, color: Colors.grey),
                          children: [
                            TextSpan(text: "Entered wrong email? "),
                            TextSpan(
                              text: "Edit Email",
                              style: TextStyle(color: appleBlue, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Lowercase Formatter ---
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}

// --- Custom IOS Style Confirmation Dialog ---
class CupertinoStyleDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const CupertinoStyleDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        width: 270,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9).withOpacity(0.95),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black)),
                  const SizedBox(height: 6),
                  Text(content, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
                ],
              ),
            ),
            const Divider(height: 0.5, thickness: 0.5, color: Colors.grey),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      child: const Text("Edit", style: TextStyle(fontSize: 17, color: Colors.blue, fontWeight: FontWeight.w400)),
                    ),
                  ),
                ),
                Container(width: 0.5, height: 44, color: Colors.grey),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: 44,
                      alignment: Alignment.center,
                      child: const Text("Yes", style: TextStyle(fontSize: 17, color: Colors.blue, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}