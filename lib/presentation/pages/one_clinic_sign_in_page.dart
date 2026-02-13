import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../data/services/google_signin_config.dart';
import '../bloc/app_language_cubit.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../localization/app_localizations.dart';
import 'main_tab_page.dart';
import 'one_clinic_sign_up_page.dart';

class OneClinicSignInPage extends StatefulWidget {
  const OneClinicSignInPage({super.key});

  @override
  State<OneClinicSignInPage> createState() => _OneClinicSignInPageState();
}

class _OneClinicSignInPageState extends State<OneClinicSignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize Google Sign-In with Web Client ID
    if (GoogleSignInConfig.isConfigured) {
      GoogleSignIn.instance.initialize(
        clientId: GoogleSignInConfig.webClientId,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppLanguageCubit>();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.loc.t('signIn.loginSuccess')),
              backgroundColor: const Color(0xFF16A34A),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainTabPage()),
          );
        } else if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? context.loc.t('signIn.loginFailed'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                                    context
                                        .watch<AppLanguageCubit>()
                                        .state
                                        .languageCode
                                        .toUpperCase(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Shield icon
                          Align(
                            alignment: Alignment.center,
                            child: Container(
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
                          ),
                          const SizedBox(height: 24),
                          // Main heading
                          Align(
                            alignment: Alignment.center,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        '${context.loc.t('main.heroTitleLine1')}\n',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: context.loc.t('main.heroTitleLine2'),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Description text
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              context.loc.t('main.heroDescription'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Email label and input
                          Text(
                            context.loc.t('signIn.emailLabel'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.loc.t('signIn.emailRequired');
                              }
                              if (!value.contains('@')) {
                                return context.loc.t('signIn.emailInvalid');
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: context.loc.t('signIn.emailHint'),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Password label and input
                          Text(
                            context.loc.t('signIn.passwordLabel'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.loc.t('signIn.passwordRequired');
                              }
                              if (value.length < 6) {
                                return context.loc.t('signIn.passwordMin');
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: context.loc.t('signIn.passwordHint'),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.black12,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.red),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: state.status == AuthStatus.loading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                          LoginSubmitted(
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text,
                                          ),
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF16A34A),
                                disabledBackgroundColor: const Color(
                                  0xFF16A34A,
                                ).withValues(alpha: 0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: state.status == AuthStatus.loading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      context.loc.t('signIn.loginButton'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'Or continue with',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );

                                    // Check if Web Client ID is configured
                                    if (!GoogleSignInConfig.isConfigured) {
                                      messenger.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Google Sign-In is not configured. Please add your Web Client ID in google_signin_config.dart',
                                          ),
                                          backgroundColor: Colors.orange,
                                          duration: Duration(seconds: 4),
                                        ),
                                      );
                                      return;
                                    }

                                    try {
                                      // Try to sign in with Google
                                      final account = await GoogleSignIn
                                          .instance
                                          .authenticate(
                                            scopeHint:
                                                GoogleSignInConfig.scopes,
                                          );

                                      // Parse display name into first and last name
                                      String? firstName;
                                      String? lastName;
                                      if (account.displayName != null) {
                                        final nameParts = account.displayName!
                                            .split(' ');
                                        firstName = nameParts.isNotEmpty
                                            ? nameParts.first
                                            : null;
                                        lastName = nameParts.length > 1
                                            ? nameParts.sublist(1).join(' ')
                                            : null;
                                      }

                                      // Navigate to sign-up page with Google account info
                                      if (!context.mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => OneClinicSignUpPage(
                                            firstName: firstName,
                                            lastName: lastName,
                                            email: account.email,
                                          ),
                                        ),
                                      );
                                    } catch (error) {
                                      // Show user-friendly error message
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Google Sign-In failed: ${error.toString()}',
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 4),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.google,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  label: const Text('Google'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    final messenger = ScaffoldMessenger.of(
                                      context,
                                    );
                                    try {
                                      await SignInWithApple.getAppleIDCredential(
                                        scopes: [
                                          AppleIDAuthorizationScopes.email,
                                          AppleIDAuthorizationScopes.fullName,
                                        ],
                                      );
                                      // Use credential here to authenticate with backend
                                      messenger.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Apple Sign In Success (Demo)',
                                          ),
                                          backgroundColor: Color(0xFF16A34A),
                                        ),
                                      );
                                    } catch (error) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Apple Sign In Failed: $error',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.apple,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                  label: const Text('Apple'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Sign up link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const OneClinicSignUpPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Color(0xFF16A34A),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
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
      isScrollControlled: true,
      useRootNavigator: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(20),
                color: Theme.of(context).colorScheme.surface,
                child: ListView(
                  controller: scrollController,
                  children: [
                    Text(
                      context.loc.t('language.selectTitle'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      title: Text(context.loc.t('language.turkish')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('tr');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.english')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('en');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.german')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('de');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.spanish')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('es');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.russian')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('ru');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.polish')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('pl');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.french')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('fr');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.portuguese')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('pt');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.italian')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('it');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                    ListTile(
                      title: Text(context.loc.t('language.arabic')),
                      onTap: () {
                        context.read<AppLanguageCubit>().setLocaleByCode('ar');
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
