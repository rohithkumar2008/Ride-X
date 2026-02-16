import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- Apple Design Tokens ---
  static const Color black = Color(0xFF0D0D0D);
  static const Color appleBlue = Color(0xFF007AFF);
  static const Color appleGreen = Color(0xFF34C759);
  static const Color greyText = Color(0xFF8E8E93);
  static const Color bgGrey = Color(0xFFF2F2F7);

  final TextEditingController _fromController = TextEditingController(text: "Gandhipuram");
  final TextEditingController _toController = TextEditingController(text: "Thudiyalur");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey, // Light iOS background
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              const Text(
                "Where to?",
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: black,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 20),

              // --- 1. FROM / TO SEARCH BOX ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    // Vertical Timeline Graphic
                    Column(
                      children: [
                        const Icon(CupertinoIcons.circle_fill, size: 12, color: appleBlue),
                        Container(height: 40, width: 2, color: Colors.grey.shade200),
                        const Icon(CupertinoIcons.location_solid, size: 16, color: Color(0xFFFF3B30)), // Apple Red
                      ],
                    ),
                    const SizedBox(width: 16),
                    
                    // Input Fields
                    Expanded(
                      child: Column(
                        children: [
                          TextField(
                            controller: _fromController,
                            style: const TextStyle(fontFamily: 'SF Pro Display', fontSize: 16, fontWeight: FontWeight.w600, color: black),
                            decoration: InputDecoration(
                              hintText: "Current Location",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _toController,
                            style: const TextStyle(fontFamily: 'SF Pro Display', fontSize: 16, fontWeight: FontWeight.w600, color: black),
                            decoration: InputDecoration(
                              hintText: "Destination",
                              hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Swap Button
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: bgGrey, shape: BoxShape.circle),
                      child: const Icon(CupertinoIcons.arrow_up_arrow_down, size: 18, color: black),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              // --- 2. RECOMMENDATIONS HEADER ---
              const Text(
                "Recommended Routes",
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: black,
                ),
              ),
              const SizedBox(height: 16),

              // --- 3. BUS ROUTE CARDS ---
              
              // Route Option 1 (The 111 Bus)
              _buildBusCard(
                busNumber: "111",
                from: "Gandhipuram",
                to: "Thudiyalur",
                stops: "Gandhipuram • Cross Cut Rd • Vadakovai • Saibaba Colony • Thudiyalur",
                eta: "4 mins away",
                isFastest: true,
              ),

              const SizedBox(height: 16),

              // Route Option 2 (Alternative Bus)
              _buildBusCard(
                busNumber: "11A",
                from: "Gandhipuram",
                to: "Thudiyalur",
                stops: "Gandhipuram • North CBE • Goundampalayam • Thudiyalur",
                eta: "12 mins away",
                isFastest: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSABLE BUS CARD WIDGET ---
  Widget _buildBusCard({
    required String busNumber,
    required String from,
    required String to,
    required String stops,
    required String eta,
    required bool isFastest,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isFastest ? appleBlue.withOpacity(0.3) : Colors.transparent, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Bus Number & ETA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: black, borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        const Icon(Icons.directions_bus, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          busNumber,
                          style: const TextStyle(fontFamily: 'SF Pro Display', color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  if (isFastest) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: appleBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: const Text("Fastest", style: TextStyle(fontFamily: 'SF Pro Display', color: appleBlue, fontSize: 12, fontWeight: FontWeight.w700)),
                    )
                  ]
                ],
              ),
              Text(
                eta,
                style: const TextStyle(fontFamily: 'SF Pro Display', color: appleGreen, fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Middle: Route Title
          Text(
            "$from  ➔  $to",
            style: const TextStyle(fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.w700, color: black),
          ),
          const SizedBox(height: 8),
          
          // Bottom: Stop by Stop Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Icon(Icons.alt_route, size: 16, color: greyText),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stops,
                  style: const TextStyle(fontFamily: 'Segoe UI', fontSize: 14, fontWeight: FontWeight.w500, color: greyText, height: 1.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- EXACT APPLE PILL BACK BUTTON ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 115,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 10.0, bottom: 10.0),
        child: GestureDetector(
          onTap: () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // White pill for the grey background
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))
              ],
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