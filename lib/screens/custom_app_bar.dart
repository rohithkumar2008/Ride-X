import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 115, // Gives the pill enough room
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 10.0, bottom: 10.0),
        child: GestureDetector(
          onTap: () {
            // Safety check so it only pops if there is a previous screen!
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFEF), // Light Apple-style grey background
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: Alignment.center,
            child: const Text(
              "< back",
              style: TextStyle(
                fontFamily: 'SF Pro Display', // Your requested font
                color: Color(0xFF8A8A8E),     // Classic iOS grey text color
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5, // Pulls the characters slightly closer together
              ),
            ),
          ),
        ),
      ),
    );
  }

  // This tells Flutter how tall the AppBar should be
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}