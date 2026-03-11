import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Replace with your laptop's current Hotspot IP address
  static const String baseUrl = "http://172.20.10.3:5000/api";

  // 1. Submit Application / Register User to MongoDB
  static Future<void> submitApplication({
    required String name,
    required String email,
    required String college,
    required String from,
    required String to,
  }) async {
    final url = Uri.parse('$baseUrl/applications');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullName": name,
          "email": email,
          "collegeName": college,
          "routeFrom": from,
          "routeTo": to,
        }),
      );

      if (response.statusCode == 201) {
        print("✅ Success: Application saved to MongoDB!");
      } else {
        print("❌ Server Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Connection Failed: $e");
    }
  }

  // 2. Request an OTP to be sent to the student's Gmail
  static Future<bool> sendOtp(String email) async {
    final url = Uri.parse('$baseUrl/send-otp');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("❌ OTP Send Error: $e");
      return false;
    }
  }

  // 3. Verify the 6-digit code entered by the student
  static Future<bool> verifyOtp(String email, String otp) async {
    final url = Uri.parse('$baseUrl/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("❌ OTP Verify Error: $e");
      return false;
    }
  }
}