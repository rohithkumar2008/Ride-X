import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Your exact color tokens
  static const Color black = Color(0xFF1C1C1E);
  static const Color ridexBlue = Color(0xFF0771C7);
  static const Color bgGrey = Color(0xFFF2F2F7);
  static const Color textGrey = Color(0xFF8E8E93);

  int _currentIndex = 0; // For bottom navigation state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. Map Background 
          Positioned.fill(
            child: Opacity(
              opacity: 0.15, // Lightened to match your design background
              child: Image.asset(
                "assets/images/map_bg.jpg", 
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // 2. Main Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Explore More",
                          style: TextStyle(
                            fontFamily: 'SF Pro Display', 
                            fontSize: 22, 
                            fontWeight: FontWeight.w700, 
                            color: Colors.grey
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Bus Pass Card
                        _buildSplitCard(
                          title: "Bus\nPass",
                          subtitle: "About the Pass",
                          imageAsset: "assets/home page/bus graphics.png",
                          onTap: () {
                            // TODO: Navigate to Bus Pass page
                          },
                        ),
                        
                        const SizedBox(height: 16),

                        // Live Ticket Card
                        _buildSplitCard(
                          title: "Live\nTicket",
                          subtitle: "About the ticket",
                          imageAsset: "assets/home page/ticket.png",
                          onTap: () {
                            // TODO: Navigate to Ticket details
                          },
                        ),

                        const SizedBox(height: 35),
                        
                        // Activity Section
                        const Text(
                          "Activity",
                          style: TextStyle(
                            fontFamily: 'SF Pro Display', 
                            fontSize: 26, 
                            fontWeight: FontWeight.w800, 
                            color: Colors.black, 
                            letterSpacing: -0.5
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Placeholder for activity
                        Center(
                          child: Text(
                            "No recent activity.", 
                            style: TextStyle(fontFamily: 'SF Pro Display', color: Colors.grey.shade500)
                          ),
                        ),
                        
                        const SizedBox(height: 120), // Extra space so bottom nav doesn't cover content
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Custom Bottom Navigation Dash
          Positioned(
            bottom: 30, // Hovering slightly above the bottom edge
            left: 20,
            right: 20,
            child: _buildBottomNav(),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Welcome",
            style: TextStyle(
              fontFamily: 'SF Pro Display', 
              fontSize: 36, 
              fontWeight: FontWeight.w900, 
              color: Colors.black, 
              letterSpacing: -1.0
            ),
          ),
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade400,
            // Replace this with your actual grey profile image if you have one specifically
          ),
        ],
      ),
    );
  }

  Widget _buildSplitCard({
    required String title, 
    required String subtitle, 
    required String imageAsset, 
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // Your specific 3D radius settings: 8px blur, 0px offset
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15), 
              blurRadius: 8.0, 
              offset: const Offset(0, 0)
            )
          ],
        ),
        clipBehavior: Clip.antiAlias, 
        child: Row(
          children: [
            // Left Black Section
            Expanded(
              flex: 4,
              child: Container(
                color: black, // #1C1C1E
                padding: const EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Sitka', 
                    fontSize: 34, 
                    color: Colors.white, 
                    height: 1.2
                  ),
                ),
              ),
            ),
            // Right Blue Section
            Expanded(
              flex: 5,
              child: Container(
                color: ridexBlue, // #0771C7
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 16),
                      child: Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: 'Sitka', 
                          fontSize: 16, 
                          color: Colors.white,
                          decoration: TextDecoration.underline, // Adds the thin line under text
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      left: 10,
                      child: Image.asset(
                        imageAsset, 
                        fit: BoxFit.contain,
                        height: 110, // Adjust this size to fit the line-art exactly
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50), // Fully rounded pill shape
        // Your specific 3D radius settings for the nav dash: 8px blur, 0px offset
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), 
            blurRadius: 8.0, 
            offset: const Offset(0, 0)
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navItem(0, "assets/App Icon/house-chimney.png"),
          _navItem(1, "assets/App Icon/wallet (2).png"),
          _navItem(2, "assets/App Icon/qr.png", isDarkCircle: true),
          _navItem(3, "assets/App Icon/apps.png"), // Used 'apps.png' based on your screenshot
          _navItem(4, "assets/App Icon/circle-user.png"),
        ],
      ),
    );
  }

  Widget _navItem(int index, String assetPath, {bool isDarkCircle = false}) {
    bool isActive = _currentIndex == index;

    if (isDarkCircle) {
      return GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: black, // #1C1C1E
            shape: BoxShape.circle
          ),
          child: Image.asset(assetPath, width: 28, height: 28, color: Colors.white),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Image.asset(
          assetPath, 
          width: 26, 
          height: 26, 
          // Applies a slight transparency to unselected items for visual hierarchy
          color: isActive ? black : Colors.grey.shade500, 
        ),
      ),
    );
  }
}