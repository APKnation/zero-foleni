import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final topHeight = (height * 0.75).clamp(440.0, 700.0);

          return SizedBox(
            height: height < 600 ? 600 : height,
            child: Stack(
              children: [
                // 1. White background base
                Container(color: AppTheme.background),

                // 2. Top image section with royal blue overlay + wave clip
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: topHeight,
                  child: ClipPath(
                    clipper: BottomWaveClipper(),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // foleni.jpg background image
                        Image.asset(
                          'lib/images/foleni.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/foleni.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppTheme.primary,
                              ),
                            );
                          },
                        ),

                        // Royal blue gradient overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppTheme.primary.withValues(alpha: 0.88),
                                AppTheme.primary.withValues(alpha: 0.94),
                              ],
                            ),
                          ),
                        ),

                        // Content inside blue section
                        SafeArea(
                          bottom: false,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              children: [
                                const Spacer(flex: 2),

                                // Brand logo row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Zero',
                                      style: TextStyle(
                                        color: AppTheme.background,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: AppTheme.background.withValues(alpha: 0.22),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.all_inclusive_rounded,
                                        color: AppTheme.background,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'Foleni',
                                      style: TextStyle(
                                        color: AppTheme.background,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'SKIP THE QUEUE • SAVE YOUR TIME',
                                  style: TextStyle(
                                    color: AppTheme.background.withValues(alpha: 0.85),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.4,
                                  ),
                                ),

                                const SizedBox(height: 44),

                                const Text(
                                  'Welcome to ZeroFoleni',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.background,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Intelligent queue management to guide you\nsmoothly through hospital, bank &\ngovernment visits!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.background.withValues(alpha: 0.88),
                                    fontSize: 14,
                                    height: 1.55,
                                  ),
                                ),

                                const Spacer(flex: 3),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. GET STARTED button at bottom of screen
                Positioned(
                  bottom: 36,
                  left: 28,
                  right: 28,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () => context.go('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            foregroundColor: AppTheme.background,
                            elevation: 4,
                            shadowColor: AppTheme.primary.withValues(alpha: 0.4),
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            'GET STARTED',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.8,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Wave clipper
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 45);
    final firstControlPoint = Offset(size.width * 0.35, size.height + 28);
    final firstEndPoint = Offset(size.width * 0.70, size.height - 32);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    final secondControlPoint = Offset(size.width * 0.90, size.height - 68);
    final secondEndPoint = Offset(size.width, size.height - 42);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
