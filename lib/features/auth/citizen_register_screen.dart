import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/api_service.dart';
import '../../core/router/auth_provider.dart';
import '../../core/theme/app_theme.dart';

class CitizenRegisterScreen extends ConsumerStatefulWidget {
  const CitizenRegisterScreen({super.key});

  @override
  ConsumerState<CitizenRegisterScreen> createState() => _CitizenRegisterState();
}

class _CitizenRegisterState extends ConsumerState<CitizenRegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nidController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passController.text != _confirmPassController.text) {
      setState(() => _errorMessage = 'Nenosiri halilingani na uthibitisho');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final fullName = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final nationalId = _nidController.text.trim();
    final password = _passController.text;

    try {
      final res = await ApiService.registerCitizen(
        fullName: fullName,
        phone: phone,
        password: password,
        email: email,
        nationalId: nationalId,
      );

      final data = res['data']?['registerCitizen'] ?? res;
      final bool success = data['success'] == true;
      final String? message = data['message'] as String?;

      if (success) {
        ref.read(authProvider.notifier).login(phone, password);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: AppTheme.background, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(message ?? 'Akaunti imefunguliwa kikamilifu! Karibu 🎉'),
                  ),
                ],
              ),
              backgroundColor: AppTheme.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
          context.go('/home');
        }
      } else {
        setState(() {
          _errorMessage = message ?? 'Usajili umeshindwa. Tafadhali jaribu tena.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Hitilafu ya mtandao: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nidController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with wave curve
            ClipPath(
              clipper: _HeaderWaveClipper(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 65, left: 24, right: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary,
                      AppTheme.primary,
                      AppTheme.secondary,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/login');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.background.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppTheme.background,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Fungua Akaunti 🚀',
                      style: TextStyle(
                        color: AppTheme.background,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Jiunge na ZeroFoleni ili uokoe muda wako',
                      style: TextStyle(
                        color: AppTheme.background.withValues(alpha: 0.88),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Form container card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.secondary.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section 1: Taarifa za Msingi
                      _buildSectionHeader('Taarifa Binafsi'),
                      const SizedBox(height: 14),

                      // Full Name
                      _buildFieldLabel('Jina Kamili *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Jina linahitajika' : null,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: _inputDecoration(
                          hint: 'Mfano: Juma Ally',
                          icon: Icons.person_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      _buildFieldLabel('Namba ya Simu *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Namba ya simu inahitajika' : null,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: _inputDecoration(
                          hint: 'Mfano: 0712345678',
                          icon: Icons.phone_android_rounded,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Email (optional)
                      _buildFieldLabel('Barua Pepe (Email - Hiari)'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: _inputDecoration(
                          hint: 'mfano@gmail.com',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // National ID (optional)
                      _buildFieldLabel('Namba ya NIDA (Hiari)'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nidController,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: _inputDecoration(
                          hint: '19900101-12345-00001-6',
                          icon: Icons.badge_outlined,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Section 2: Usalama
                      _buildSectionHeader('Usalama wa Akaunti'),
                      const SizedBox(height: 14),

                      // Password
                      _buildFieldLabel('Nenosiri (Password) *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passController,
                        obscureText: _obscurePass,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Nenosiri linahitajika';
                          if (v.length < 6) return 'Nenosiri liwe na angalau herufi 6';
                          return null;
                        },
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: _inputDecoration(
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppTheme.secondary,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscurePass = !_obscurePass),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      _buildFieldLabel('Thibitisha Nenosiri *'),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _confirmPassController,
                        obscureText: _obscureConfirm,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Tafadhali thibitisha nenosiri';
                          return null;
                        },
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        decoration: _inputDecoration(
                          hint: '••••••••',
                          icon: Icons.lock_clock_outlined,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppTheme.secondary,
                              size: 20,
                            ),
                            onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                          ),
                        ),
                      ),

                      // Error Banner
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppTheme.accent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.accent),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline_rounded, color: AppTheme.background, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    color: AppTheme.background,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),

                      // Submit Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.background,
                            elevation: 3,
                            shadowColor: AppTheme.primary.withValues(alpha: 0.35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            disabledBackgroundColor:
                                AppTheme.primary.withValues(alpha: 0.5),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppTheme.background,
                                  ),
                                )
                              : const Text(
                                  'Jiandikishe (Register)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Already have account link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Una akaunti tayari? ',
                  style: TextStyle(color: AppTheme.secondary, fontSize: 14),
                ),
                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: const Text(
                    'Ingia (Login)',
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppTheme.secondary,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.secondary,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppTheme.secondary, fontSize: 14),
      prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppTheme.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.secondary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.secondary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.accent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.accent, width: 1.8),
      ),
    );
  }
}

class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height + 15,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
