import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../services/api_service.dart';
import '../widgets/registration_dialog.dart';
import 'dashboard_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  
  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  bool _isResendLoading = false;
  int _resendCountdown = 30;
  bool _canResend = false;
  String _mockOtpCode = ''; // Store mock OTP for testing

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startResendCountdown();
    // TODO: Send OTP to phone number
    _sendOTP();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
    
    _animationController.forward();
  }

  void _startResendCountdown() {
    if (!mounted) return;
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        if (_resendCountdown > 0) {
          _startResendCountdown();
        } else {
          if (mounted) {
            setState(() {
              _canResend = true;
            });
          }
        }
      }
    });
  }

  Future<void> _sendOTP() async {
    try {
      final result = await ApiService.sendOTP(widget.phoneNumber);
      if (result['success']) {
        // Store mock OTP for testing
        if (result['data']?['otpCode'] != null) {
          setState(() {
            _mockOtpCode = result['data']['otpCode'];
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message'] ?? 'Failed to send OTP'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending OTP: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;
    
    setState(() {
      _isResendLoading = true;
      _canResend = false;
      _resendCountdown = 30;
    });
    
    await _sendOTP();
    
    if (mounted) {
      setState(() {
        _isResendLoading = false;
      });
      _startResendCountdown();
    }
  }

  Future<void> _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Verify OTP via API
        final result = await ApiService.verifyOTP(widget.phoneNumber, _otpController.text);
        
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          if (result['success']) {
            final data = result['data'];
            
            if (data['isNewUser'] == true) {
              // Show registration dialog
              _showRegistrationDialog();
            } else {
              // User exists, login successful
              _navigateToDashboard();
            }
          } else {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result['message'] ?? 'Invalid OTP'),
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

  void _showRegistrationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RegistrationDialog(phoneNumber: widget.phoneNumber),
    );
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const DashboardScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel any pending timers
    _resendCountdown = 0;
    _animationController.dispose();
    _otpController.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFF6B9D),
              Color(0xFFFF8E8E),
              Color(0xFFFFB3BA),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 
                              MediaQuery.of(context).padding.top - 
                              MediaQuery.of(context).padding.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildHeader(),
                        SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 15 : 25),
                        _buildOTPForm(),
                        SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 15 : 20),
                        _buildVerifyButton(),
                        const SizedBox(height: 15),
                        _buildResendSection(),
                        const SizedBox(height: 10),
                        // Footer (hide when keyboard is open)
                        if (MediaQuery.of(context).viewInsets.bottom == 0)
                          _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.phone_android,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Verify Your Number',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'We\'ve sent a verification code to',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        Text(
          widget.phoneNumber,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildOTPForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: _otpController,
            onChanged: (value) {},
            onCompleted: (value) {
              _verifyOTP();
            },
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(12),
              fieldHeight: 60,
              fieldWidth: 45,
              activeFillColor: Colors.white.withOpacity(0.2),
              inactiveFillColor: Colors.white.withOpacity(0.1),
              selectedFillColor: Colors.white.withOpacity(0.3),
              activeColor: Colors.white,
              inactiveColor: Colors.white.withOpacity(0.5),
              selectedColor: Colors.white,
            ),
            keyboardType: TextInputType.number,
            enableActiveFill: true,
            textStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the verification code';
              }
              if (value.length != 6) {
                return 'Please enter a 6-digit code';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Enter the 6-digit code sent to your phone',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          // Mock OTP display for testing
          if (_mockOtpCode.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    '🧪 MOCK OTP FOR TESTING',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _mockOtpCode,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Use this code to test the app',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _verifyOTP,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                ),
              )
            : Text(
                'Verify & Continue',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          'Didn\'t receive the code?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 8),
        if (_canResend)
          TextButton(
            onPressed: _isResendLoading ? null : _resendOTP,
            child: _isResendLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Resend Code',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
          )
        else
          Text(
            'Resend code in $_resendCountdown seconds',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'By continuing, you agree to our',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                'Terms of Service',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Text(
              ' and ',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Privacy Policy',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
