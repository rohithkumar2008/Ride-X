import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io'; // Needed for File access
import 'package:image_picker/image_picker.dart'; // REQUIRED: flutter pub add image_picker
import 'aadhaar_page.dart';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  // --- Apple Design Tokens ---
  static const Color black = Color(0xFF0D0D0D);
  static const Color appleBlue = Color(0xFF007AFF);
  static const Color appleRed = Color(0xFFFF3B30); // Apple Error Red
  static const Color greyText = Color(0xFF8E8E93);
  static const Color appleGrey = Color(0xFFF2F2F7);

  // --- State ---
  bool _isUploading = false;
  bool _hasPhoto = false;
  File? _selectedImage; // Holds the real file
  int _currentFileSizeKB = 0; // Holds real size

  // --- Size Logic ---
  // The specific size limit you gave: 100 KB
  bool get _isSizeTooLarge => _currentFileSizeKB > 100;

  // --- File Selection Logic ---
  Future<void> _handleFileSelection() async {
    final ImagePicker picker = ImagePicker();
    
    try {
      setState(() => _isUploading = true);
      
      // 1. Pick the image from gallery
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        
        // 2. Get actual file size
        int sizeInBytes = await file.length();
        int sizeInKB = (sizeInBytes / 1024).round();

        // 3. Update State
        if (mounted) {
          setState(() {
            _selectedImage = file;
            _currentFileSizeKB = sizeInKB;
            _hasPhoto = true;
            _isUploading = false;
          });
        }
      } else {
        // User canceled selection
        if (mounted) setState(() => _isUploading = false);
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
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
                  "Passport\nPhoto.",
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
                  "Upload a clear photo for your digital pass.",
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
                    onTap: _handleFileSelection, // Allow tapping to change even if photo exists
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutBack,
                      width: 260,
                      height: 320,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: _hasPhoto 
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
                        borderRadius: BorderRadius.circular(37),
                        child: _buildPreviewContent(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                
                // --- DYNAMIC WARNING TEXT ---
                Center(
                  child: Column(
                    children: [
                      Text(
                        _hasPhoto 
                            ? (_isSizeTooLarge ? "File too large: $_currentFileSizeKB KB" : "Size OK: $_currentFileSizeKB KB")
                            : "Standard size: 20 KB to 100 KB",
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: (_hasPhoto && _isSizeTooLarge) ? appleRed : (_hasPhoto ? Colors.green : greyText),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isSizeTooLarge 
                            ? "Please compress image below 100 KB" 
                            : "Guideline: Max 100 KB allowed",
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

                // --- Buttons ---
                Column(
                  children: [
                    _buildAppleButton(
                      text: _hasPhoto ? "Confirm & Continue" : "Choose from Gallery",
                      // Disable if uploading OR (has photo AND is too large)
                      onTap: (_isUploading || (_hasPhoto && _isSizeTooLarge)) 
                          ? null 
                          : (_hasPhoto 
                              ? () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AadhaarUploadPage())) 
                              : _handleFileSelection),
                      isPrimary: true,
                    ),
                    if (_hasPhoto) ...[
                      const SizedBox(height: 12),
                      _buildAppleButton(
                        text: "Change Photo",
                        onTap: _handleFileSelection, // Directly open gallery
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
    if (_hasPhoto && _selectedImage != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          // 1. The Actual Image
          Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
          ),
          
          // 2. Overlay if Error (Optional, helps readability of error icon)
          if (_isSizeTooLarge)
            Container(color: Colors.white.withOpacity(0.7)),

          // 3. Status Icon
          Center(
            child: _isSizeTooLarge 
                ? Icon(Icons.warning_amber_rounded, size: 80, color: appleRed.withOpacity(0.8))
                : null, // Don't show icon if image is good, show the photo!
          ),

          // 4. Checkmark / X Badge
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isSizeTooLarge ? appleRed : appleBlue, 
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0,4))]
              ),
              child: Icon(
                _isSizeTooLarge ? Icons.close_rounded : Icons.check_rounded, 
                color: Colors.white, 
                size: 24
              ),
            ),
          ),
        ],
      );
    }
    // Default State
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.photo_library_outlined, size: 64, color: appleBlue.withOpacity(0.8)),
        const SizedBox(height: 16),
        const Text("Browse Files", style: TextStyle(fontFamily: 'SF Pro Display', color: appleBlue, fontWeight: FontWeight.w600, fontSize: 18)),
      ],
    );
  }

  Widget _buildAppleButton({required String text, required VoidCallback? onTap, required bool isPrimary}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: (onTap == null) ? Colors.grey.shade300 : (isPrimary ? black : appleGrey),
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
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), border: Border.all(color: Colors.white.withOpacity(0.3)), borderRadius: BorderRadius.circular(12)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.arrow_back_ios_new, size: 14, color: black), SizedBox(width: 6), Text("Back", style: TextStyle(color: black, fontWeight: FontWeight.w600, fontSize: 15))]),
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