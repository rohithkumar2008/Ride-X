import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'bonafide_page.dart';

class AadhaarUploadPage extends StatefulWidget {
  const AadhaarUploadPage({super.key});

  @override
  State<AadhaarUploadPage> createState() => _AadhaarUploadPageState();
}

class _AadhaarUploadPageState extends State<AadhaarUploadPage> {
  // --- Apple Design Tokens ---
  static const Color black = Color(0xFF0D0D0D);
  static const Color appleBlue = Color(0xFF007AFF);
  static const Color appleRed = Color(0xFFFF3B30); 
  static const Color greyText = Color(0xFF8E8E93);
  static const Color appleGrey = Color(0xFFF2F2F7);

  // --- State Variables ---
  bool _isUploading = false;
  bool _hasFile = false;
  
  // Simulation for PDF/Scanned File logic
  int _mockFileSizeKB = 450; // Mocking a 450 KB file
  bool get _isSizeTooLarge => _mockFileSizeKB > 1000; // 1 MB Cap

  Future<void> _handleFileSelection() async {
    setState(() => _isUploading = true);
    
    // Simulate picking a PDF or Scanned Document
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isUploading = false;
        _hasFile = true;
        // Logic: Change this to 1200 to test the RED error state
        _mockFileSizeKB = 450; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppleAppBar(context),
      body: ScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Upload\nyour ID.",
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: black,
                    letterSpacing: -2.0,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Aadhaar / Govt ID (PDF or Scan)\nUsed only for identity verification.",
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: greyText,
                    height: 1.3,
                  ),
                ),
                
                const Spacer(flex: 2),

                // --- Aadhaar Preview Frame ---
                Center(
                  child: GestureDetector(
                    onTap: _hasFile ? null : _handleFileSelection,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutBack,
                      width: double.infinity, 
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _hasFile 
                              ? (_isSizeTooLarge ? appleRed : appleBlue) 
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(27),
                        child: _buildPreviewContent(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // --- DYNAMIC WARNING AREA ---
                Center(
                  child: Column(
                    children: [
                      Text(
                        _isSizeTooLarge 
                            ? "Document exceeds limit: ${_mockFileSizeKB} KB" 
                            : "Standard Format: PDF / Scanned Image",
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _isSizeTooLarge ? appleRed : greyText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isSizeTooLarge 
                            ? "Please reduce file size below 1 MB" 
                            : "Maximum allowed size: 1 MB (1000 KB)",
                        style: const TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 12,
                          color: greyText,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 3),

                // --- Action Area ---
                Column(
                  children: [
                    _buildAppleButton(
                      text: _hasFile ? "Confirm & Continue" : "Upload Document",
                      onTap: (_isUploading || (_hasFile && _isSizeTooLarge)) 
                          ? null 
                          : (_hasFile ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BonafideUploadPage()),
                              );
                            } : _handleFileSelection),
                      isPrimary: true,
                    ),
                    if (_hasFile) ...[
                      const SizedBox(height: 12),
                      _buildAppleButton(
                        text: "Change Document",
                        onTap: () => setState(() => _hasFile = false),
                        isPrimary: false,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_isUploading) {
      return const Center(child: CircularProgressIndicator(color: appleBlue, strokeWidth: 3));
    }
    if (_hasFile) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Container(color: appleGrey),
          Center(
            child: Icon(
              _isSizeTooLarge ? Icons.error_outline_rounded : Icons.picture_as_pdf_rounded, 
              size: 80, 
              color: _isSizeTooLarge ? appleRed.withOpacity(0.5) : appleBlue.withOpacity(0.7)
            )
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isSizeTooLarge ? appleRed : appleBlue, 
                shape: BoxShape.circle
              ),
              child: Icon(
                _isSizeTooLarge ? Icons.close_rounded : Icons.check_rounded, 
                color: Colors.white, 
                size: 20
              ),
            ),
          ),
        ],
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.file_upload_outlined, size: 54, color: appleBlue.withOpacity(0.8)),
        const SizedBox(height: 12),
        const Text("Choose PDF or Scan", style: TextStyle(fontFamily: 'SF Pro Display', color: appleBlue, fontWeight: FontWeight.w600, fontSize: 18)),
      ],
    );
  }

  Widget _buildAppleButton({required String text, required VoidCallback? onTap, required bool isPrimary}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: (onTap == null) ? Colors.grey.shade200 : (isPrimary ? black : appleGrey),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            color: (onTap == null) ? Colors.grey : (isPrimary ? Colors.white : black),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // 👉 UPDATED EXACT APPLE PILL BACK BUTTON
  PreferredSizeWidget _buildAppleAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 115,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 10.0, bottom: 10.0),
        child: GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF),
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: const Text(
              "< back",
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                color: Color(0xFF8A8A8E),
                fontSize: 17,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: Image.asset("assets/images/map_bg.jpg", fit: BoxFit.cover)),
      Positioned.fill(child: Container(color: Colors.white.withOpacity(0.92))),
      Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withOpacity(0.0), Colors.white.withOpacity(0.8), Colors.white], stops: const [0.0, 0.6, 1.0])))),
      Positioned.fill(child: child),
    ]);
  }
}