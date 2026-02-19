import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  // Variables to store the selected images
  File? _profilePhoto;
  File? _aadhaarCard;
  File? _bonafideCert;

  final ImagePicker _picker = ImagePicker();

  // Function to pick an image
  Future<void> _pickImage(String docType) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        if (docType == 'photo') _profilePhoto = File(image.path);
        if (docType == 'aadhaar') _aadhaarCard = File(image.path);
        if (docType == 'bonafide') _bonafideCert = File(image.path);
      });
    }
  }

  // Check if all documents are uploaded
  bool _isReadyToSubmit() {
    return _profilePhoto != null && _aadhaarCard != null && _bonafideCert != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7), // Apple System Grey Background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Upload Documents",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              const Text(
                "Step 3 of 3",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              const Text(
                "Verify your identity",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: -0.5),
              ),
              const SizedBox(height: 8),
              Text(
                "Please upload clear photos of the following documents to process your student pass.",
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              
              const SizedBox(height: 32),

              // Upload Cards
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildUploadCard(
                      title: "Profile Photo",
                      subtitle: "Clear face picture for the ID card",
                      icon: Icons.person_outline,
                      file: _profilePhoto,
                      onTap: () => _pickImage('photo'),
                    ),
                    const SizedBox(height: 16),
                    _buildUploadCard(
                      title: "Aadhaar Card",
                      subtitle: "Front side of your Aadhaar",
                      icon: Icons.credit_card,
                      file: _aadhaarCard,
                      onTap: () => _pickImage('aadhaar'),
                    ),
                    const SizedBox(height: 16),
                    _buildUploadCard(
                      title: "Bonafide Certificate",
                      subtitle: "Issued by your college this year",
                      icon: Icons.school_outlined,
                      file: _bonafideCert,
                      onTap: () => _pickImage('bonafide'),
                    ),
                  ],
                ),
              ),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isReadyToSubmit() ? Colors.black : Colors.grey.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: _isReadyToSubmit() 
                    ? () {
                        // TODO: Upload to Firebase Storage
                        print("Ready to send to Firebase!");
                      } 
                    : null,
                  child: const Text(
                    "Submit Application",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for the upload boxes
  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required File? file,
    required VoidCallback onTap,
  }) {
    bool isUploaded = file != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded ? Colors.green : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // Icon or Image Preview
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: isUploaded ? Colors.green.shade50 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                image: isUploaded
                    ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
                    : null,
              ),
              child: isUploaded 
                  ? null 
                  : Icon(icon, color: Colors.blue, size: 28),
            ),
            
            const SizedBox(width: 16),
            
            // Text Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUploaded ? "Document attached" : subtitle,
                    style: TextStyle(
                      fontSize: 13, 
                      color: isUploaded ? Colors.green : Colors.grey.shade600,
                      fontWeight: isUploaded ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),

            // Trailing Checkmark or Add Button
            Icon(
              isUploaded ? Icons.check_circle : Icons.add_circle_outline,
              color: isUploaded ? Colors.green : Colors.grey.shade400,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}