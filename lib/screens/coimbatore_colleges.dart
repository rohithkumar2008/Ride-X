import 'package:latlong2/latlong.dart';

class CollegeLocation {
  final String name;
  final LatLng coordinates;

  CollegeLocation(this.name, this.coordinates);
}

// Data: Major Colleges in Coimbatore
final List<CollegeLocation> coimbatoreColleges = [
  CollegeLocation("PSG Tech", const LatLng(11.0247, 76.9702)),
  CollegeLocation("CIT (Coimbatore Inst. of Tech)", const LatLng(11.0294, 77.0256)),
  CollegeLocation("GCT (Govt College of Tech)", const LatLng(11.0183, 76.9344)),
  CollegeLocation("Kumaraguru (KCT)", const LatLng(11.0797, 76.9882)),
  CollegeLocation("Sri Krishna (SKCET)", const LatLng(10.9374, 76.9535)),
  CollegeLocation("Hindusthan College", const LatLng(10.9833, 76.9833)),
  CollegeLocation("Amrita Vishwa Vidyapeetham", const LatLng(10.9027, 76.9006)),
  CollegeLocation("KPR Institute", const LatLng(11.0800, 77.0600)),
  CollegeLocation("Bharathiar University", const LatLng(11.0398, 76.9182)),
  CollegeLocation("Karpagam University", const LatLng(10.8801, 77.0224)),
];