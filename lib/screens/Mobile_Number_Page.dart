import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'role_selection_page.dart'; // 👉 UPDATED IMPORT

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  static const Color pink = Color(0xFFFF6BCB);
  static const Color black = Color(0xFF0D0D0D);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isCodeSent = false;
  int _timeLeft = 60;
  Timer? _timer;

  // --- Apple-Style Toast ---
  void _showAppleStyleToast(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade800.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      },
    );
  }

  void _startTimer() {
    _timeLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _resendCode() {
    if (_timeLeft == 0) {
      setState(() {
        _otpController.clear();
      });
      _startTimer();
      _showAppleStyleToast("Code resent");
    }
  }

  // --- Button Logic ---
  void _handleButtonPress() {
    if (!_isCodeSent) {
      // Step 1: Send OTP
      setState(() {
        _isCodeSent = true;
      });
      _startTimer();
      _showAppleStyleToast("Code sent");
    } else {
      // Step 2: Verify & Navigate
      _showAppleStyleToast("OTP Verified!");
      
      // 👉 UPDATED: Navigate to Role Selection using pushReplacement
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonActive = false;
    if (!_isCodeSent) {
      isButtonActive = _phoneController.text.length == 10;
    } else {
      isButtonActive = _otpController.text.replaceAll(' ', '').length == 6;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
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
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.grey.shade600,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "back",
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      color: Colors.grey.shade600,
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
      ),
      body: ScreenBackground(
        child: SafeArea(
          // LayoutBuilder fixes the yellow screen error
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            _isCodeSent ? "Enter your\ncode." : "Enter your\nnumber.",
                            style: const TextStyle(
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
                            "We'll send a quick verification code to\nkeep your account secure.",
                            style: TextStyle(
                              fontFamily: 'Segoe UI',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 120),

                          // --- Mobile Number Input ---
                          Container(
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
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              enabled: !_isCodeSent,
                              onChanged: (value) => setState(() {}),
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: _isCodeSent ? Colors.grey : black,
                                letterSpacing: 2.0,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                  horizontal: 20,
                                ),
                                hintText: "Phone Number",
                                hintStyle: TextStyle(
                                  fontFamily: 'Segoe UI',
                                  color: Colors.grey.shade400,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0,
                                ),
                                prefixIcon: Icon(Icons.phone_outlined,
                                    color: _isCodeSent ? Colors.grey.shade300 : Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          if (_isCodeSent) ...[
                            const SizedBox(height: 54),
                            // --- OTP Input Box ---
                            Container(
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
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  OtpInputFormatter(),
                                  LengthLimitingTextInputFormatter(7),
                                ],
                                onChanged: (value) => setState(() {}),
                                style: const TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: black,
                                  letterSpacing: 6.0,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                    horizontal: 20,
                                  ),
                                  hintText: "000 000",
                                  hintStyle: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    color: Colors.grey.shade300,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 6.0,
                                  ),
                                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // --- Timer / Resend Link ---
                            Center(
                              child: GestureDetector(
                                onTap: _resendCode,
                                child: Text(
                                  _timeLeft > 0
                                      ? "Resend code in 00:${_timeLeft.toString().padLeft(2, '0')}"
                                      : "Didn't receive it? Tap to resend.",
                                  style: TextStyle(
                                    fontFamily: 'Segoe UI',
                                    color: _timeLeft > 0
                                        ? Colors.grey
                                        : const Color.fromARGB(255, 116, 116, 116),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    decoration: _timeLeft == 0
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                    decorationColor: pink,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      // --- BUTTON ---
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0, top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 51,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isButtonActive ? black : Colors.grey.shade300,
                              foregroundColor: isButtonActive ? Colors.white : Colors.grey.shade500,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: isButtonActive ? _handleButtonPress : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _isCodeSent ? "Verify & Continue" : "Send Code",
                                  style: const TextStyle(
                                    fontFamily: 'SF Pro Display',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _isCodeSent ? Icons.check_circle_outline : Icons.arrow_forward,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class OtpInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String numbersOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    String formattedText = numbersOnly;
    if (numbersOnly.length > 3) {
      formattedText = '${numbersOnly.substring(0, 3)} ${numbersOnly.substring(3)}';
    }
    return newValue.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
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
        Positioned.fill(
          child: Image.asset("assets/images/map_bg.jpg", fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.white.withOpacity(0.95)),
        ),
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white10, Colors.white],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}