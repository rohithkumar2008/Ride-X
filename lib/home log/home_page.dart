import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color kBlack    = Color(0xFF1C1C1E);
  static const Color kBlue     = Color(0xFF0771C7);
  static const Color kBgGrey   = Color(0xFFF2F2F7);
  static const Color kTextGrey = Color(0xFF8E8E93);

  int _currentIndex = 0;

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgGrey,
      bottomNavigationBar: _buildBottomNav(),
      body: Column(
        children: [
          // ── Top area: map bg + fade + header ──────────────────────────────
          _buildTopSection(),

          // ── Scrollable body ───────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // White rounded card: Explore More
                  _buildExploreCard(),

                  // Activity
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
                    child: Text(
                      "Activity",
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: kBlack,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "No recent activity.",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: kTextGrey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TOP SECTION (map bg + gradient fade + header) ───────────────────────
  Widget _buildTopSection() {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          // Map image fills the top block
          Positioned.fill(
            child: Image.asset(
              "assets/images/map_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Gradient: transparent at top → kBgGrey at bottom (the fade effect)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.55),
                    Colors.white.withOpacity(0.75),
                    kBgGrey,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
          // Header content on top
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Welcome",
                    style: GoogleFonts.inter(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: kBlack,
                      letterSpacing: -1.2,
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── WHITE EXPLORE CARD ───────────────────────────────────────────────────
  Widget _buildExploreCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Explore More",
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: kTextGrey,
            ),
          ),
          const SizedBox(height: 14),
          _buildSplitCard(
            title: "Bus\nPass",
            subtitle: "About the Pass",
            imageAsset: "assets/home page/bus graphics.png",
            onTap: () {},
          ),
          const SizedBox(height: 14),
          _buildSplitCard(
            title: "Live\nTicket",
            subtitle: "About the ticket",
            imageAsset: "assets/home page/ticket.png",
            onTap: () {},
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ─── SPLIT CARD ───────────────────────────────────────────────────────────
  Widget _buildSplitCard({
    required String title,
    required String subtitle,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 165,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.13),
              blurRadius: 8,
              offset: Offset.zero,
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            // ── Left: black panel ─────────────────────────────────────────
            Expanded(
              flex: 42,
              child: Container(
                color: kBlack,
                alignment: Alignment.center, // vertically + horizontally centered
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.15,
                    ),
                  ),
                ),
              ),
            ),

            // ── Right: blue panel ─────────────────────────────────────────
            Expanded(
              flex: 58,
              child: Container(
                color: kBlue,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Subtitle top-left
                    Positioned(
                      top: 16,
                      left: 14,
                      child: Text(
                        subtitle,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                          decorationThickness: 1.5,
                        ),
                      ),
                    ),
                    // Illustration — white tinted to show on blue
                    Positioned(
                      bottom: -8,
                      right: -4,
                      left: 8,
                      child: Image.asset(
                        imageAsset,
                        height: 118,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomRight,
                        // Makes dark line-art visible as white outlines on blue
                        color: Colors.white.withOpacity(0.90),
                        colorBlendMode: BlendMode.srcIn,
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

  // ─── BOTTOM NAV ───────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(0, "assets/App Icon/house-chimney.png"),
            _navItem(1, "assets/App Icon/wallet (2).png"),
            _navItem(2, "assets/App Icon/qr.png", isDarkCircle: true),
            _navItem(3, "assets/App Icon/time-past.png"),
            _navItem(4, "assets/App Icon/circle-user.png"),
          ],
        ),
      ),
    );
  }

  Widget _navItem(int index, String assetPath, {bool isDarkCircle = false}) {
    final bool isActive = _currentIndex == index;

    if (isDarkCircle) {
      return GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          width: 54,
          height: 54,
          decoration: const BoxDecoration(
            color: kBlack,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              assetPath,
              width: 26,
              height: 26,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: isActive ? kBgGrey : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            width: 26,
            height: 26,
            // Active: full black. Inactive: grey
            color: isActive ? kBlack : const Color(0xFFAAAAAA),
          ),
        ),
      ),
    );
  }
}