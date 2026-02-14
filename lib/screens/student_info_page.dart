import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Photo_page.dart'; // Ensure this filename matches exactly

class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({super.key});

  @override
  State<StudentInfoPage> createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  static const Color black = Color(0xFF0D0D0D);
  static const Color customGrey = Color.fromRGBO(117, 117, 117, 1.0);

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _govtIdController = TextEditingController();
  final TextEditingController _collegeIdController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedCollege;
  final List<String> _genders = ["Male", "Female", "Other", "Prefer not to say"];

  final List<String> _tnColleges = [
    "KG College of Arts and Science, Coimbatore",
    "Anna University, Chennai",
    "PSG College of Technology, Coimbatore",
    "Other"
  ];

  bool get _isFormValid {
    return _fullNameController.text.trim().isNotEmpty &&
           _dobController.text.trim().isNotEmpty &&
           _govtIdController.text.trim().length == 14 && 
           _selectedCollege != null && 
           _collegeIdController.text.trim().isNotEmpty;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: black, onPrimary: Colors.white, onSurface: black),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false, // Prevents background slicing
      appBar: _buildAppBar(),
      body: ScreenBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FIXED HEADER ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 10),
                    Text("Student\nDetails.", style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 40, fontWeight: FontWeight.w900, color: black, letterSpacing: -1.5, height: 1.0)),
                    SizedBox(height: 10),
                    Text("Please provide your official details\nfor verification.", style: TextStyle(fontFamily: 'Segoe UI', fontSize: 18, fontWeight: FontWeight.w500, color: Colors.grey, height: 1.2)),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              // --- SCROLLABLE FORM ---
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: bottomInset + 40),
                  child: Column(
                    children: [
                      _buildInputContainer(
                        child: TextField(
                          controller: _fullNameController,
                          onChanged: (_) => setState(() {}),
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')), 
                            UpperCaseTextFormatter(), 
                            LengthLimitingTextInputFormatter(50),
                          ],
                          decoration: _inputDecoration("FULL NAME (AS PER AADHAAR)", Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: AbsorbPointer(
                          child: _buildInputContainer(
                            child: TextField(
                              controller: _dobController,
                              decoration: _inputDecoration("Date of Birth", Icons.calendar_today_outlined),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInputContainer(
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: _inputDecoration("Gender (Optional)", Icons.people_outline).copyWith(contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20)),
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                          items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (v) => setState(() => _selectedGender = v),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInputContainer(
                        child: TextField(
                          controller: _govtIdController,
                          onChanged: (_) => setState(() {}),
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12), AadhaarInputFormatter()],
                          decoration: _inputDecoration("Aadhaar Number (12 Digits)", Icons.credit_card_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInputContainer(
                        child: Autocomplete<String>(
                          optionsBuilder: (val) => val.text.isEmpty ? const Iterable<String>.empty() : _tnColleges.where((c) => c.toLowerCase().contains(val.text.toLowerCase())),
                          onSelected: (s) => setState(() => _selectedCollege = s),
                          fieldViewBuilder: (ctx, ctrl, focus, onSubmitted) {
                            return TextField(
                              controller: ctrl, focusNode: focus,
                              onChanged: (v) { if(v.isEmpty) setState(() => _selectedCollege = null); },
                              decoration: _inputDecoration("Search your College", Icons.school),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInputContainer(
                        child: TextField(
                          controller: _collegeIdController,
                          onChanged: (_) => setState(() {}),
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [UpperCaseTextFormatter(), LengthLimitingTextInputFormatter(20)],
                          decoration: _inputDecoration("College Register Number", Icons.confirmation_number_outlined),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity, height: 51,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid ? black : Colors.grey.shade300,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: _isFormValid ? () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PhotoUploadPage()));
                          } : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Next", style: TextStyle(fontFamily: 'SF Pro Display', fontSize: 18, fontWeight: FontWeight.w600, color: _isFormValid ? Colors.white : Colors.grey.shade500)),
                              const SizedBox(width: 6),
                              Icon(Icons.arrow_forward, size: 20, color: _isFormValid ? Colors.white : Colors.grey.shade500),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- UPDATED APPLE-STYLE APP BAR ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 115, // Gives the pill enough room
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0, top: 10.0, bottom: 10.0),
        child: GestureDetector(
          onTap: () {
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
                fontFamily: 'SF Pro Display',
                color: Color(0xFF8A8A8E), // Classic iOS grey text color
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

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))]),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20), hintText: hint, hintStyle: const TextStyle(color: Colors.grey, fontSize: 16), prefixIcon: Icon(icon, color: Colors.grey), border: InputBorder.none);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldV, TextEditingValue newV) => TextEditingValue(text: newV.text.toUpperCase(), selection: newV.selection);
}

class AadhaarInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldV, TextEditingValue newV) {
    String text = newV.text.replaceAll(RegExp(r'\D'), '');
    if (text.length > 12) text = text.substring(0, 12);
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    return newV.copyWith(text: buffer.toString(), selection: TextSelection.collapsed(offset: buffer.length));
  }
}

class ScreenBackground extends StatelessWidget {
  final Widget child;
  const ScreenBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned.fill(child: Image.asset("assets/images/map_bg.jpg", fit: BoxFit.cover)),
      Positioned.fill(child: Container(color: Colors.white.withOpacity(0.95))),
      Positioned.fill(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white10, Colors.white], stops: [0.0, 1.0])))),
      Positioned.fill(child: child),
    ]);
  }
}