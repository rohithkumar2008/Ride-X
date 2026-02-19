import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Core Map
import 'package:latlong2/latlong.dart'; // Coordinates
import 'package:flutter_animate/flutter_animate.dart'; // Smooth Animations
import 'dart:ui'; // For Glassmorphism

// ==============================================================================
// 1. DATA MODELS & MOCK DATA
// ==============================================================================

class LocationItem {
  final String name;
  final LatLng coordinates;
  final String address;
  final String type; // 'house' or 'college'

  LocationItem({
    required this.name,
    required this.coordinates,
    required this.address,
    required this.type,
  });
}

// --- DATA SOURCE 1: Sample_House_Locations__20_.csv ---
final List<LocationItem> _allHouses = [
  LocationItem(name: "Green Garden House", coordinates: LatLng(11.0168, 76.9558), address: "Gandhipuram", type: 'house'),
  LocationItem(name: "Laxmi Nagar Villa", coordinates: LatLng(11.0012, 76.9621), address: "Peelamedu", type: 'house'),
  LocationItem(name: "Skyview Apartments", coordinates: LatLng(10.9985, 76.9920), address: "Avinashi Road", type: 'house'),
  LocationItem(name: "Royal Enclave", coordinates: LatLng(11.0234, 76.9421), address: "RS Puram", type: 'house'),
  LocationItem(name: "Sunny Side Home", coordinates: LatLng(11.0450, 76.9320), address: "Saibaba Colony", type: 'house'),
  LocationItem(name: "The White House", coordinates: LatLng(10.9821, 76.9210), address: "Kuniamuthur", type: 'house'),
  LocationItem(name: "Serene Villa", coordinates: LatLng(11.0820, 76.9810), address: "Saravanampatti", type: 'house'),
  LocationItem(name: "City Center Flat", coordinates: LatLng(11.0120, 76.9820), address: "Pappanaickenpalayam", type: 'house'),
  LocationItem(name: "Blue Hill Residence", coordinates: LatLng(11.0310, 76.9120), address: "Vadavalli", type: 'house'),
  LocationItem(name: "Metro Home", coordinates: LatLng(11.0020, 76.9720), address: "Race Course", type: 'house'),
];

// --- DATA SOURCE 2: Compiled_Colleges_in_near_Coimbatore.csv ---
final List<LocationItem> _allColleges = [
  LocationItem(name: "PSG College of Technology", coordinates: LatLng(11.0247, 77.0028), address: "Peelamedu", type: 'college'),
  LocationItem(name: "Coimbatore Institute of Technology", coordinates: LatLng(11.0285, 77.0224), address: "Avinashi Road", type: 'college'),
  LocationItem(name: "Kumaraguru College of Technology", coordinates: LatLng(11.0772, 76.9882), address: "Saravanampatti", type: 'college'),
  LocationItem(name: "Sri Krishna College of Eng. & Tech", coordinates: LatLng(10.9385, 76.9545), address: "Kuniamuthur", type: 'college'),
  LocationItem(name: "Amrita Vishwa Vidyapeetham", coordinates: LatLng(10.9027, 76.9006), address: "Ettimadai", type: 'college'),
  LocationItem(name: "Hindusthan College", coordinates: LatLng(11.0020, 77.0250), address: "Nava India", type: 'college'),
  LocationItem(name: "Karpagam College", coordinates: LatLng(10.8800, 77.0200), address: "Othakkalmandapam", type: 'college'),
  LocationItem(name: "Dr. N.G.P. Institute", coordinates: LatLng(11.0550, 77.0450), address: "Kalapatti", type: 'college'),
  LocationItem(name: "SNS College of Technology", coordinates: LatLng(11.0950, 77.0150), address: "Saravanampatti", type: 'college'),
  LocationItem(name: "Sri Ramakrishna Eng. College", coordinates: LatLng(11.1050, 76.9450), address: "Vattamalaipalayam", type: 'college'),
  LocationItem(name: "Government College of Technology", coordinates: LatLng(11.0180, 76.9380), address: "Thadagam Road", type: 'college'),
  LocationItem(name: "KG College of Arts and Science", coordinates: LatLng(11.0850, 76.9950), address: "Saravanampatti", type: 'college'),
];

class BusStop {
  final String name;
  final LatLng location;
  final String arrivalTime;
  BusStop(this.name, this.location, this.arrivalTime);
}

// ==============================================================================
// 2. MAIN SCREEN WIDGET
// ==============================================================================

class RouteSelectionPage extends StatefulWidget {
  const RouteSelectionPage({super.key});

  @override
  State<RouteSelectionPage> createState() => _RouteSelectionPageState();
}

class _RouteSelectionPageState extends State<RouteSelectionPage> {
  // --- Constants ---
  final Color _appleBlue = const Color(0xFF007AFF);
  final LatLng _coimbatoreCenter = const LatLng(11.0168, 76.9558);

  // --- Controllers ---
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  // --- State Variables ---
  LocationItem? _selectedHome;
  LocationItem? _selectedCollege;
  
  bool _isSearching = false;       
  String _searchingFor = 'none';   
  List<LocationItem> _searchResults = [];

  bool _isRouteActive = false;
  List<BusStop> _activeRouteStops = [];
  List<LatLng> _polylinePoints = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  // --- Logic: Start Searching ---
  void _startSearch(String field) {
    setState(() {
      _isSearching = true;
      _searchingFor = field;
      _searchController.clear();
      _searchResults = (field == 'from') ? _allHouses : _allColleges;
    });
  }

  // --- Logic: Search Query Changed ---
  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    List<LocationItem> sourceList = (_searchingFor == 'from') ? _allHouses : _allColleges;
    
    setState(() {
      _searchResults = sourceList.where((item) => 
        item.name.toLowerCase().contains(query) || 
        item.address.toLowerCase().contains(query)
      ).toList();
    });
  }

  // --- Logic: Select Item ---
  void _selectItem(LocationItem item) {
    setState(() {
      if (_searchingFor == 'from') {
        _selectedHome = item;
      } else {
        _selectedCollege = item;
      }
      
      _isSearching = false;
      _searchingFor = 'none';
      _searchController.clear();

      if (_selectedHome != null && _selectedCollege != null) {
        _calculateRoute();
      }
    });
  }

  void _calculateRoute() {
    setState(() {
      _isRouteActive = true;
      _activeRouteStops = _generateStops(_selectedHome!.coordinates, _selectedCollege!.coordinates);
      _polylinePoints = [
        _selectedHome!.coordinates,
        ..._activeRouteStops.map((s) => s.location),
        _selectedCollege!.coordinates
      ];
      // When route starts, keep sheet small
      if (_sheetController.isAttached) {
        _sheetController.animateTo(0.25, duration: 300.ms, curve: Curves.easeOut);
      }
    });
    _fitBounds();
  }

  List<BusStop> _generateStops(LatLng start, LatLng end) {
    List<BusStop> stops = [];
    for (int i = 1; i <= 5; i++) {
      double t = i / 6;
      double lat = start.latitude + (end.latitude - start.latitude) * t;
      double lng = start.longitude + (end.longitude - start.longitude) * t;
      stops.add(BusStop("Stop #$i", LatLng(lat, lng), "${7 + i}:00 AM"));
    }
    return stops;
  }

  void _fitBounds() {
    if (_selectedHome == null || _selectedCollege == null) return;
    double lat = (_selectedHome!.coordinates.latitude + _selectedCollege!.coordinates.latitude) / 2;
    double lng = (_selectedHome!.coordinates.longitude + _selectedCollege!.coordinates.longitude) / 2;
    _mapController.move(LatLng(lat, lng), 12.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // -----------------------------------------------------------
          // LAYER 1: MAP
          // -----------------------------------------------------------
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _coimbatoreCenter,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.ridex.app',
              ),
              if (_isRouteActive)
                PolylineLayer(
                  polylines: [
                    Polyline(points: _polylinePoints, strokeWidth: 5.0, color: _appleBlue, isDotted: true),
                  ],
                ),
              MarkerLayer(
                markers: [
                  if (_selectedHome != null)
                    Marker(point: _selectedHome!.coordinates, width: 50, height: 50, child: _buildPin(Icons.home, Colors.blue)),
                  if (_selectedCollege != null)
                    Marker(point: _selectedCollege!.coordinates, width: 50, height: 50, child: _buildPin(Icons.school, Colors.red)),
                  ..._activeRouteStops.map((s) => Marker(point: s.location, width: 30, height: 30, child: _buildDot())),
                ],
              ),
            ],
          ),

          // -----------------------------------------------------------
          // LAYER 2: VIGNETTE FADE
          // -----------------------------------------------------------
          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [Colors.transparent, Colors.white.withOpacity(0.0), Colors.white],
                  stops: const [0.0, 0.8, 1.0],
                ),
              ),
            ),
          ),

          // -----------------------------------------------------------
          // LAYER 3: TOP SEARCH BAR (Floating)
          // -----------------------------------------------------------
          if (!_isSearching)
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  // Back Button
                  _buildGlassBtn(Icons.arrow_back, () => Navigator.pop(context)),
                  
                  const SizedBox(width: 12),
                  
                  // Search Bar
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _startSearch('to'), // Tapping top bar defaults to searching "To"
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.black54),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedCollege?.name ?? "Search for college...",
                                style: const TextStyle(color: Colors.black87, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // -----------------------------------------------------------
          // LAYER 4: SHORT BOTTOM SHEET
          // -----------------------------------------------------------
          if (!_isSearching)
            DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.25, // Starts short
              minChildSize: 0.25,
              maxChildSize: 0.45,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40, height: 5,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
                          ),
                        ),

                        // FROM BUTTON
                        GestureDetector(
                          onTap: () => _startSearch('from'),
                          child: _buildFakeInput(_selectedHome?.name ?? "From (House)", Icons.my_location, Colors.blue),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // TO BUTTON
                        GestureDetector(
                          onTap: () => _startSearch('to'),
                          child: _buildFakeInput(_selectedCollege?.name ?? "To (College)", Icons.location_on, Colors.red),
                        ),
                        
                        if (_isRouteActive) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black, 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                              ),
                              onPressed: () {},
                              child: const Text("Start Route", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),

          // -----------------------------------------------------------
          // LAYER 5: SEARCH OVERLAY (Full Screen)
          // -----------------------------------------------------------
          if (_isSearching)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _isSearching = false)),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: _searchingFor == 'from' ? "Search House Locality..." : "Search College Name...",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          return ListTile(
                            leading: Icon(item.type == 'house' ? Icons.home : Icons.school, color: Colors.grey),
                            title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(item.address),
                            onTap: () => _selectItem(item),
                          );
                        },
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

  // --- Helper Widgets ---

  Widget _buildFakeInput(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: Colors.grey.shade800, fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildGlassBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45, height: 45,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  Widget _buildPin(IconData icon, Color color) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildDot() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: _appleBlue, width: 2)),
      child: const Center(child: Icon(Icons.circle, size: 8, color: Colors.black)),
    );
  }
}