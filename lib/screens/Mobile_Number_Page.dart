import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart'; 
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
  // Design Tokens
  static const Color black = Color(0xFF0D0D0D);
  static const Color appleRed = Color(0xFFFF3B30);
  static const Color bgGrey = Color(0xFFF2F2F7);
  static const Color lockedGrey = Color(0xFFE5E5EA);

  late TextEditingController _emailController;
  final TextEditingController _otpController = TextEditingController();
  
  bool _isLoading = false;
  bool _isError = false; 

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);

    // Shake animation setup for incorrect code
    _shakeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
    
    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) _shakeController.reset(); 
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  // --- RESTORED MOCK LOGIC: Verification is hardcoded to 123456 ---
  Future<void> _verifyOtp() async {
    String enteredCode = _otpController.text.trim();
    
    if (enteredCode.length < 6) return;

    setState(() => _isLoading = true);

    // Artificial delay to make the app feel "real"
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _isLoading = false);

    // Check against the fixed code
    if (enteredCode == "123456") {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
        );
      }
    } else {
      _triggerErrorShake();
      _otpController.clear(); // Clear the wrong code
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Incorrect code. Please use 123456")),
        );
      }
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

  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(color: bgGrey, borderRadius: BorderRadius.circular(30)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back_ios_new, color: Colors.grey, size: 14),
                  SizedBox(width: 4),
                  Text("back", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600)),
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
              const Text(
                "Verify Code",
                style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 40, fontWeight: FontWeight.w900, color: black, letterSpacing: -1.5, height: 1.0),
              ),
              const SizedBox(height: 12),
              const Text(
                "For testing, please enter 123456 below.",
                style: TextStyle(fontSize: 17, color: Colors.grey, height: 1.3),
              ),

              const SizedBox(height: 40),

              // Locked Email display (cannot be edited here)
              Container(
                decoration: BoxDecoration(color: lockedGrey, borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _emailController,
                  enabled: false, 
                  style: const TextStyle(color: Colors.black54),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              
              // OTP Input with Animation
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
                    border: Border.all(color: _isError ? appleRed : Colors.black12, width: 1.5),
                  ),
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 4.0),
                    inputFormatters: [LengthLimitingTextInputFormatter(6), FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    onChanged: (val) {
                      if (val.length == 6) _verifyOtp();
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      hintText: "000 000",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),

              // Verify Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  onPressed: !_isLoading ? _verifyOtp : null,
                  child: _isLoading
                      ? const CupertinoActivityIndicator(color: Colors.white)
                      : const Text("Verify & Continue", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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