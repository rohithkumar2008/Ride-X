import 'package:flutter/material.dart';
import 'dart:io'; // Required for File handling
import 'dart:ui'; // Required for Blur effects
import 'package:image_picker/image_picker.dart'; // Required for Gallery Access
import 'route_selection_page.dart'; // 👉 Imports the next page

class BonafideUploadPage extends StatefulWidget {
  const BonafideUploadPage({super.key});

  @override
  State<BonafideUploadPage> createState() => _BonafideUploadPageState();
}

class _BonafideUploadPageState extends State<BonafideUploadPage> {
  // --- Apple Design Tokens ---
  static const Color black = Color(0xFF0D0D0D);
  static const Color appleBlue = Color(0xFF007AFF);
  static const Color appleRed = Color(0xFFFF3B30);
  static const Color greyText = Color(0xFF8E8E93);
  static const Color appleGrey = Color(0xFFF2F2F7);

  // --- State Variables ---
  bool _isUploading = false;
  bool _hasFile = false;
  File? _selectedFile; // Holds the real file
  int _fileSizeKB = 0; // Holds the calculated size

  // --- Size Logic (Limit: 1 MB = 1000 KB) ---
  bool get _isSizeTooLarge => _fileSizeKB > 1000;

  Future<void> _handleFileSelection() async {
    final ImagePicker picker = ImagePicker();

    try {
      setState(() => _isUploading = true);

      // 1. Pick Image (Simulating Document Scan)
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        File file = File(pickedFile.path);

        // 2. Get Size
        int sizeInBytes = await file.length();
        int sizeInKB = (sizeInBytes / 1024).round();

        // 3. Update State
        if (mounted) {
          setState(() {
            _selectedFile = file;
            _fileSizeKB = sizeInKB;
            _hasFile = true;
            _isUploading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isUploading = false);
      }
    } catch (e) {
      debugPrint("Error: $e");
      if (mounted) setState(() => _isUploading = false);
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
                  "College\nBonafide.",
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
                  "Upload your current year Bonafide.\nEnsure the college seal is visible.",
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: greyText,
                    height: 1.3,
                  ),
                ),

                const Spacer(flex: 2),

                // --- Preview Frame ---
                Center(
                  child: GestureDetector(
                    onTap: _handleFileSelection,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutBack,
                      width: double.infinity,
                      height: 260, // Taller frame for Bonafide certificates
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
                          ),
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

                // --- Warning Text ---
                Center(
                  child: Column(
                    children: [
                      Text(
                        _hasFile
                            ? (_isSizeTooLarge
                                  ? "File too large: $_fileSizeKB KB"
                                  : "Size OK: $_fileSizeKB KB")
                            : "Standard Format: Image / Scan",
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: (_hasFile && _isSizeTooLarge)
                              ? appleRed
                              : greyText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isSizeTooLarge
                            ? "Please compress image below 1 MB"
                            : "Maximum allowed size: 1 MB",
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

                // --- Action Buttons ---
                Column(
                  children: [
                    _buildAppleButton(
                      text: _hasFile ? "Continue to Route" : "Upload Bonafide",
                      // Disable if uploading OR file too large
                      onTap: (_isUploading || (_hasFile && _isSizeTooLarge))
                          ? null
                          : (_hasFile
                                ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RouteSelectionPage(),
                                    ),
                                  )
                                : _handleFileSelection),
                      isPrimary: true,
                    ),
                    if (_hasFile) ...[
                      const SizedBox(height: 12),
                      _buildAppleButton(
                        text: "Change Document",
                        onTap: _handleFileSelection,
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
      return const Center(
        child: CircularProgressIndicator(color: appleBlue, strokeWidth: 3),
      );
    }

    if (_hasFile && _selectedFile != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          // 1. Image Preview
          Image.file(_selectedFile!, fit: BoxFit.cover),

          // 2. Error Overlay
          if (_isSizeTooLarge) Container(color: Colors.white.withOpacity(0.8)),

          // 3. Status Icon
          Center(
            child: _isSizeTooLarge
                ? Icon(Icons.warning_amber_rounded, size: 60, color: appleRed)
                : null,
          ),

          // 4. Corner Badge
          Positioned(
            bottom: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isSizeTooLarge ? appleRed : appleBlue,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isSizeTooLarge ? Icons.close_rounded : Icons.check_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      );
    }

    // Default Empty State
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.note_add_outlined,
          size: 54,
          color: appleBlue.withOpacity(0.8),
        ),
        const SizedBox(height: 12),
        const Text(
          "Select Certificate",
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            color: appleBlue,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildAppleButton({
    required String text,
    required VoidCallback? onTap,
    required bool isPrimary,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: (onTap == null)
              ? Colors.grey.shade300
              : (isPrimary ? black : appleGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            color: (onTap == null)
                ? Colors.grey
                : (isPrimary ? Colors.white : black),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppleAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 110,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 14, color: black),
                    SizedBox(width: 6),
                    Text(
                      "Back",
                      style: TextStyle(
                        color: black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
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
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset("assets/images/map_bg.jpg", fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.white.withOpacity(0.92)),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.8),
                  Colors.white,
                ],
                stops: const [0.0, 0.6, 1.0],
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
