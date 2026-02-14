import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// 👉 IMPORT THE DESTINATION PAGES HERE:
import 'student_info_page.dart'; 
import 'home_page.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  // --- Apple Design Tokens ---
  static const Color black = Color(0xFF0D0D0D);
  static const Color appleBlue = Color(0xFF007AFF);
  static const Color greyText = Color(0xFF8E8E93);
  static const Color bgGrey = Color(0xFFF2F2F7);

  // --- State ---
  String _selectedRole = ""; // Can be "Student" or "Individual"

  // 👉 FIXED NAVIGATION LOGIC
  void _handleContinue() {
    if (_selectedRole == "Student") {
      print("Navigating to StudentInfoPage...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentInfoPage()),
      );
    } else if (_selectedRole == "Individual") {
      print("Navigating to HomePage...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                  Icon(Icons.arrow_back_ios_new, color: Colors.grey.shade600, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    "back",
                    style: TextStyle(fontFamily: 'SF Pro Display', color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              const Text(
                "Welcome to\nRidex.",
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: black,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "How will you be traveling with us today?",
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
                icon: CupertinoIcons.book,
                roleValue: "Student",
              ),
              
              const SizedBox(height: 20),
              
              _buildSelectionCard(
                title: "Individual Rider",
                subtitle: "Book daily tickets, track buses live, and manage your wallet.",
                icon: CupertinoIcons.person,
                roleValue: "Individual",
              ),

              const Spacer(flex: 2),

              // --- Continue Button ---
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedRole.isEmpty ? bgGrey : black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _selectedRole.isEmpty ? null : _handleContinue,
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      color: _selectedRole.isEmpty ? greyText : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // --- Reusable Apple-Style Card Widget ---
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
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? appleBlue.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? appleBlue : Colors.grey.shade300,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: appleBlue.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))]
              : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? appleBlue : bgGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : black,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'SF Pro Display',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? black : black.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: greyText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            
            // Selection Checkmark
            if (isSelected)
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Icon(CupertinoIcons.checkmark_alt_circle_fill, color: appleBlue, size: 28),
              ),
          ],
        ),
      ),
    );
  }
}