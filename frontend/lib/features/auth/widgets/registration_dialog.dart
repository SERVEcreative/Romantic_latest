import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../../dashboard/screens/dashboard_screen.dart';

class RegistrationDialog extends StatefulWidget {
  final String phoneNumber;
  
  const RegistrationDialog({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<RegistrationDialog> createState() => _RegistrationDialogState();
}

class _RegistrationDialogState extends State<RegistrationDialog>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  
  String _selectedGender = 'male';
  bool _isLoading = false;
  
  // Single animation controller for better performance
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Faster animation
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut, // Simpler curve for better performance
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1), // Smaller slide for smoother feel
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await ApiService.registerUser(
          phoneNumber: widget.phoneNumber,
          fullName: _nameController.text.trim(),
          age: int.parse(_ageController.text),
          gender: _selectedGender,
          bio: '',
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (result['success']) {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const DashboardScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300), // Faster transition
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Registration failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Optimized dynamic sizing
  double _getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) return screenWidth * 0.92;
    if (screenWidth < 600) return 340;
    return 380;
  }

  double _getDialogPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 400 ? 20 : 24;
  }

  double _getFontSize(BuildContext context, {bool isTitle = false}) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 400) {
      return isTitle ? 22 : 15;
    }
    return isTitle ? 26 : 16;
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth = _getDialogWidth(context);
    final dialogPadding = _getDialogPadding(context);
    final titleFontSize = _getFontSize(context, isTitle: true);
    final bodyFontSize = _getFontSize(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: MediaQuery.of(context).size.height * 0.75,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFF6B9D),
                  Color(0xFFFF8E8E),
                  Color(0xFFFFB3BA),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(dialogPadding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(), // Smoother scrolling
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Simplified header icon
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Header Text
                      Text(
                        'Complete Your Profile',
                        style: GoogleFonts.poppins(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tell us a bit about yourself 💕',
                        style: GoogleFonts.poppins(
                          fontSize: bodyFontSize - 1,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      // Name Field
                      _buildOptimizedTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person_outline,
                        fontSize: bodyFontSize,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Age Field
                      _buildOptimizedTextField(
                        controller: _ageController,
                        label: 'Age',
                        icon: Icons.cake_outlined,
                        fontSize: bodyFontSize,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          }
                          final age = int.tryParse(value);
                          if (age == null || age < 18 || age > 100) {
                            return 'Please enter a valid age (18-100)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Gender Selection
                      _buildOptimizedGenderSelector(fontSize: bodyFontSize),
                      const SizedBox(height: 20),

                      // Register Button
                      _buildOptimizedButton(fontSize: bodyFontSize),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptimizedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required double fontSize,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 22),
        labelStyle: GoogleFonts.poppins(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: fontSize - 1,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
    );
  }

  Widget _buildOptimizedGenderSelector({required double fontSize}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.15),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: fontSize,
        ),
        dropdownColor: const Color(0xFFFF6B9D),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white70,
          size: 22,
        ),
        decoration: InputDecoration(
          labelText: 'Gender',
          prefixIcon: const Icon(
            Icons.favorite_outline,
            color: Colors.white70,
            size: 22,
          ),
          labelStyle: GoogleFonts.poppins(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: fontSize - 1,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        items: [
          _buildDropdownItem('male', 'Male', Icons.male, fontSize),
          _buildDropdownItem('female', 'Female', Icons.female, fontSize),
          _buildDropdownItem('other', 'Other', Icons.person, fontSize),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value!;
          });
        },
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, String text, IconData icon, double fontSize) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptimizedButton({required double fontSize}) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FA)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _registerUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6B9D)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Creating Profile...',
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF6B9D),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.rocket_launch,
                    color: Color(0xFFFF6B9D),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Complete Registration',
                    style: GoogleFonts.poppins(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF6B9D),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
