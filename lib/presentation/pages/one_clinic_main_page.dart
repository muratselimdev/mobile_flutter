import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/onboarding/onboarding_bloc.dart';
import 'one_clinic_sign_in_page.dart';

class OneClinicMainPage extends StatelessWidget {
  const OneClinicMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state is NavigateToSignInState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigating to Sign In...')),
          );
        } else if (state is NavigateToCreateAccountState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Navigating to Create Account...')),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header with logo and language selector
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'One Clinic',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Language selector
                        GestureDetector(
                          onTap: () {
                            _showLanguageBottomSheet(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.language,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  state is OnboardingLanguageChanged
                                      ? state.language
                                      : 'TR',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Doctor image with professional background
                  Stack(
                    children: [
                      // Background with gradient and pattern
                      Container(
                        height: 520,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.95),
                              const Color(0xFFF0F7F3),
                            ],
                          ),
                        ),
                      ),
                      // Decorative circles background
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF16A34A,
                            ).withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: -30,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(
                              0xFF16A34A,
                            ).withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      // Doctor image - enlarged with transparency
                      Positioned.fill(
                        child: Center(
                          child: Transform.scale(
                            scale: 1.2,
                            child: Opacity(
                              opacity: 0.95,
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuDQV_0EMZkapQNURrO0YiAxwDwlwfpCekSDjMvSomFqJ0vkcIPurZ0qrzL3nK62n4x4fn8SoJFG1lU6mZjvfIXEa5LSiozkUyDPYneXjpq34ca5W0OMQ1wkK_ZDbt9qeQk_MbLJa-ROQLRczoI8h0TwfHIbuYwbVDfDHw2mwQtRM5emNcn4JN_ZjnhX4761ikt_uKVDF0K89jimS30v_yAbkmSyDIEeyYuTlc4LMQmO9V-MqBzAvnV8VmPGS1G0RsiF-A7iIbOKdS9G',
                                fit: BoxFit.cover,
                                height: 1300,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 1080,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                    ),
                                    child: const Icon(
                                      Icons.person,
                                      size: 150,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Content section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      children: [
                        // Shield icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF16A34A,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.shield,
                            color: Color(0xFF16A34A),
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Main heading
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Sağlığınız İçin\n',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'One Clinic Yanınızda',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Description text
                        const Text(
                          'En iyi uzmanlar ve modern tedavi yöntemleri ile sağlık voluluğunuzu güvenle planlayın.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Sign In button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 4,
                              shadowColor: const Color(
                                0xFF16A34A,
                              ).withValues(alpha: 0.4),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const OneClinicSignInPage(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;

                                        var tween = Tween(
                                          begin: begin,
                                          end: end,
                                        ).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                  transitionDuration: const Duration(
                                    milliseconds: 400,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Giriş Yap',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Create Account button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.black26,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            onPressed: () {
                              context.read<OnboardingBloc>().add(
                                const NavigateToCreateAccountEvent(),
                              );
                            },
                            child: const Text(
                              'Hesap Oluştur',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                letterSpacing: 0.5,
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
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Dil Seçin',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Türkçe'),
                onTap: () {
                  context.read<OnboardingBloc>().add(
                    const ChangeLanguageEvent(language: 'TR'),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  context.read<OnboardingBloc>().add(
                    const ChangeLanguageEvent(language: 'EN'),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Deutsch'),
                onTap: () {
                  context.read<OnboardingBloc>().add(
                    const ChangeLanguageEvent(language: 'DE'),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
