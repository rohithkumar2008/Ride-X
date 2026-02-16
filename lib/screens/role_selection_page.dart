import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui'; // Required for blur effects

// 👉 IMPORT THE DESTINATION PAGES HERE:
import 'student_info_page.dart'; 
import '../Home log/home_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  // --- Apple Design Tokens ---
  static const Color black = Color(0xFF0D0D0D);
  static const Color greyText = Color(0xFF8E8E93);
  static const Color borderGrey = Color(0xFFE5E5EA);
  static const Color surfaceWhite = Colors.white;

  // --- State ---
  String _selectedRole = ""; 

  // 👉 FIXED NAVIGATION LOGIC
  void _handleContinue() {
    if (_selectedRole == "Student") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentInfoPage()),
      );
    } else if (_selectedRole == "Individual") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // 1. Subtle Map Background
          Positioned.fill(
            child: Image.asset(
              "assets/images/map_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // 2. Heavy White Overlay (95% opacity for clean look)
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.95)),
          ),
          // 3. Fade Gradient at bottom
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
          
          // 4. Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // --- Header ---
                  const Text(
                    "Welcome to\nRidex.",
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: black,
                      letterSpacing: -1.5,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "How will you be traveling today?",
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: greyText,
                    ),
                  ),
                  
                  const Spacer(flex: 1),

                  // --- Selection Cards ---
                  _buildSelectionCard(
                    title: "Student Pass",
                    subtitle: "Apply for or renew your college bus pass. Valid for TNSTC & MTC.",
                    icon: CupertinoIcons.book_fill,
                    roleValue: "Student",
                  ),
                  
                  const SizedBox(height: 16),
                  
                  _buildSelectionCard(
                    title: "Individual Rider",
                    subtitle: "Book daily tickets, track buses live, and manage your wallet.",
                    icon: CupertinoIcons.person_fill,
                    roleValue: "Individual",
                  ),

                  const Spacer(flex: 2),

                  // --- Continue Button ---
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedRole.isEmpty ? borderGrey : black,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _selectedRole.isEmpty ? null : _handleContinue,
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          color: _selectedRole.isEmpty ? greyText : Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Apple-Style AppBar ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 100,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F7), // Apple System Grey 6
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back_ios_new, color: black, size: 14),
                SizedBox(width: 4),
                Text(
                  "Back",
                  style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    color: black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Premium Selection Card ---
  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String roleValue,
  }) {
    bool isSelected = _selectedRole == roleValue;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = roleValue;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            // Black border when selected, subtle grey when not
            color: isSelected ? black : borderGrey,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.03),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isSelected ? black : const Color(0xFFF2F2F7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : black,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: greyText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            // Checkmark Indicator
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 12),
                child: Icon(
                  CupertinoIcons.checkmark_circle_fill,
                  color: black,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}