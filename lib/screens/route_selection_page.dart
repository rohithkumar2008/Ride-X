import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:ui'; // Required for Glass effect
import 'coimbatore_colleges.dart'; // Imports your college data

class RouteSelectionPage extends StatefulWidget {
  const RouteSelectionPage({super.key});

  @override
  State<RouteSelectionPage> createState() => _RouteSelectionPageState();
}

class _RouteSelectionPageState extends State<RouteSelectionPage> {
  // --- Design Constants ---
  static const Color appleBlue = Color(0xFF007AFF);
  static const Color black = Color(0xFF0D0D0D);
  static const Color glassWhite = Color(0xCCFFFFFF); // Translucent white

  // --- Map State ---
  final MapController _mapController = MapController();
  final LatLng _coimbatoreCenter = const LatLng(11.0168, 76.9558);
  double _currentZoom = 11.5;

  // --- Selection State ---
  LatLng? _homeLocation;
  LatLng? _collegeLocation;
  String _homeName = "Select Home";
  String _collegeName = "Select College";
  double _routeDistance = 0.0;
  bool _showInfo = false; // Toggles the instruction bubble

  // --- Logic: Map Taps ---
  void _onMapTap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _homeLocation = point;
      _homeName = "Dropped Pin";
      _calculateDistance();
    });
  }

  void _selectCollege(CollegeLocation college) {
    setState(() {
      _collegeLocation = college.coordinates;
      _collegeName = college.name;
      _calculateDistance();
    });
  }

  void _calculateDistance() {
    if (_homeLocation != null && _collegeLocation != null) {
      final Distance distance = const Distance();
      setState(() {
        _routeDistance = distance.as(LengthUnit.Kilometer, _homeLocation!, _collegeLocation!);
      });
    }
  }

  // --- Logic: Zoom Control ---
  void _zoom(bool zoomIn) {
    setState(() {
      _currentZoom = zoomIn ? _currentZoom + 1 : _currentZoom - 1;
      _mapController.move(_mapController.camera.center, _currentZoom);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ----------------------------------------
          // 1. FULL SCREEN MAP
          // ----------------------------------------
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _coimbatoreCenter,
              initialZoom: _currentZoom,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ridex.app',
              ),
              if (_homeLocation != null && _collegeLocation != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [_homeLocation!, _collegeLocation!],
                      strokeWidth: 4.0,
                      color: appleBlue,
                      isDotted: true,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  ...coimbatoreColleges.map((college) => Marker(
                    point: college.coordinates,
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => _selectCollege(college),
                      child: _buildCollegeIcon(),
                    ),
                  )),
                  if (_homeLocation != null)
                    Marker(
                      point: _homeLocation!,
                      width: 50,
                      height: 50,
                      child: const Icon(Icons.location_on, color: appleBlue, size: 45),
                    ),
                ],
              ),
            ],
          ),

          // ----------------------------------------
          // 2. HEADER: BACK & INFO BUTTONS
          // ----------------------------------------
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGlassButton(Icons.arrow_back, () => Navigator.pop(context)),
                  _buildGlassButton(
                    _showInfo ? Icons.close : Icons.info_outline, 
                    () => setState(() => _showInfo = !_showInfo)
                  ),
                ],
              ),
            ),
          ),

          // ----------------------------------------
          // 3. INSTRUCTION BUBBLE (Hidden by default)
          // ----------------------------------------
          if (_showInfo)
            Positioned(
              top: 100,
              right: 20,
              child: _buildGlassCard(
                child: const Text(
                  "1. Tap anywhere to set Home.\n2. Tap a Red Hat to set College.",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),

          // ----------------------------------------
          // 4. RIGHT SIDE: ZOOM CONTROLS
          // ----------------------------------------
          Positioned(
            right: 20,
            bottom: 300,
            child: Column(
              children: [
                _buildGlassButton(Icons.add, () => _zoom(true)),
                const SizedBox(height: 12),
                _buildGlassButton(Icons.remove, () => _zoom(false)),
              ],
            ),
          ),

          // ----------------------------------------
          // 5. BOTTOM ROUTE CARD (Apple Maps Style)
          // ----------------------------------------
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Locations
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(Icons.circle, size: 12, color: appleBlue),
                          Container(height: 25, width: 2, color: Colors.grey.shade300),
                          Icon(Icons.circle, size: 12, color: Colors.red),
                        ],
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCompactRow("From", _homeName),
                            const Divider(height: 25),
                            _buildCompactRow("To", _collegeName),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: (_homeLocation != null && _collegeLocation != null) 
                          ? () { print("Route Confirmed: $_routeDistance km"); } 
                          : null,
                      child: Text(
                        _routeDistance > 0 ? "Go (${_routeDistance.toStringAsFixed(1)} km)" : "Select Route",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets for Apple Design ---

  Widget _buildGlassButton(IconData icon, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: glassWhite,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Icon(icon, color: black, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: glassWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildCollegeIcon() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.school, color: Colors.red.shade700, size: 22),
      ),
    );
  }

  Widget _buildCompactRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(
          value.length > 25 ? "${value.substring(0, 22)}..." : value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: black),
        ),
      ],
    );
  }
}