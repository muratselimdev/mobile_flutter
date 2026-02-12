import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/country_data.dart';
import '../../data/services/language_group_service.dart';
import '../../data/models/country.dart';
import '../../data/models/language_group.dart';
import '../bloc/app_language_cubit.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'main_tab_page.dart';

class OneClinicSignUpPage extends StatefulWidget {
  const OneClinicSignUpPage({
    super.key,
    this.firstName,
    this.lastName,
    this.email,
  });

  final String? firstName;
  final String? lastName;
  final String? email;

  @override
  State<OneClinicSignUpPage> createState() => _OneClinicSignUpPageState();
}

class _OneClinicSignUpPageState extends State<OneClinicSignUpPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Country? _selectedCountry;
  Country? _selectedPhoneCountry;
  LanguageGroup? _selectedLanguageGroup;
  List<LanguageGroup> _languageGroups = [];
  bool _isLoadingLanguages = true;
  final _languageGroupService = LanguageGroupService();

  @override
  void initState() {
    super.initState();
    // Set default country to Turkey
    _selectedCountry = CountryData.getCountryByCode('TR');
    _selectedPhoneCountry = CountryData.getCountryByCode('TR');

    // Pre-fill form with Google account data if provided
    if (widget.firstName != null) {
      _firstNameController.text = widget.firstName!;
    }
    if (widget.lastName != null) {
      _lastNameController.text = widget.lastName!;
    }
    if (widget.email != null) {
      _emailController.text = widget.email!;
    }

    // Fetch language groups from backend
    _loadLanguageGroups();
  }

  Future<void> _loadLanguageGroups() async {
    try {
      final languages = await _languageGroupService.fetchLanguageGroups();
      setState(() {
        _languageGroups = languages;
        _isLoadingLanguages = false;

        // Set default language group based on current app language
        if (mounted) {
          final currentLang = context
              .read<AppLanguageCubit>()
              .state
              .languageCode;
          _selectedLanguageGroup = _languageGroups.firstWhere(
            (lg) => lg.code.toLowerCase() == currentLang.toLowerCase(),
            orElse: () => _languageGroups.isNotEmpty
                ? _languageGroups.first
                : LanguageGroup(
                    id: 0,
                    name: 'English',
                    code: 'en',
                    isActive: true,
                  ),
          );
        }
      });
    } catch (e) {
      setState(() {
        _isLoadingLanguages = false;
      });
      print('Error loading language groups: $e');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AppLanguageCubit>();
    return BlocProvider(
      create: (context) => AuthBloc(authService: AuthService()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration Successful!'),
                backgroundColor: Color(0xFF16A34A),
              ),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainTabPage()),
              (route) => false,
            );
          } else if (state.status == AuthStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Registration Failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sign up to get started',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // First Name
                      _buildTextField(
                        controller: _firstNameController,
                        label: 'First Name',
                        validator: (value) => value?.isEmpty ?? true
                            ? 'First Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Last Name
                      _buildTextField(
                        controller: _lastNameController,
                        label: 'Last Name',
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Last Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!value.contains('@')) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Country
                      _buildCountryDropdown(),
                      const SizedBox(height: 16),

                      // Phone Number with Country Code
                      _buildPhoneField(),
                      const SizedBox(height: 16),

                      // Language Selector
                      _buildLanguageDropdown(),
                      const SizedBox(height: 16),

                      // Password
                      _buildTextField(
                        controller: _passwordController,
                        label: 'Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm Password
                      _buildTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Sign Up Button
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.status == AuthStatus.loading
                              ? null
                              : () => _submitRegistration(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
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
                              : const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: 'Enter your $label',
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF16A34A)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  void _submitRegistration(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final fullPhone = _selectedPhoneCountry != null
          ? '${_selectedPhoneCountry!.dialCode}${_phoneController.text.trim()}'
          : _phoneController.text.trim();

      // Use language group ID from backend
      final languageGroupId = _selectedLanguageGroup?.id ?? 0;

      context.read<AuthBloc>().add(
        RegisterSubmitted(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: fullPhone,
          password: _passwordController.text,
          country: _selectedCountry?.code ?? 'TR',
          languageGroupId: languageGroupId,
        ),
      );
    }
  }

  Widget _buildCountryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Country',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Country>(
          initialValue: _selectedCountry,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF16A34A)),
            ),
          ),
          items: CountryData.countries.map((country) {
            return DropdownMenuItem<Country>(
              value: country,
              child: Row(
                children: [
                  Text(country.flag, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      country.name,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (Country? value) {
            setState(() {
              _selectedCountry = value;
            });
          },
          validator: (value) => value == null ? 'Country is required' : null,
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phone Number',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Country Code Selector
            SizedBox(
              width: 110,
              child: DropdownButtonFormField<Country>(
                initialValue: _selectedPhoneCountry,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF16A34A)),
                  ),
                ),
                selectedItemBuilder: (BuildContext context) {
                  return CountryData.countries.map((country) {
                    return Center(
                      child: Text(
                        country.dialCode,
                        style: const TextStyle(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList();
                },
                items: CountryData.countries.map((country) {
                  return DropdownMenuItem<Country>(
                    value: country,
                    child: SizedBox(
                      width: 240,
                      child: Row(
                        children: [
                          Text(
                            country.flag,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '${country.dialCode} ${country.name}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (Country? value) {
                  setState(() {
                    _selectedPhoneCountry = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 12),
            // Phone Number Input
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF16A34A)),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Language',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        _isLoadingLanguages
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text('Loading languages...'),
                  ],
                ),
              )
            : DropdownButtonFormField<LanguageGroup>(
                value: _selectedLanguageGroup,
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF16A34A)),
                  ),
                ),
                items: _languageGroups.map((languageGroup) {
                  return DropdownMenuItem<LanguageGroup>(
                    value: languageGroup,
                    child: Text(
                      languageGroup.name,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (LanguageGroup? value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguageGroup = value;
                    });
                    // Change app language when user selects different language
                    context.read<AppLanguageCubit>().setLocaleByCode(
                      value.code.toLowerCase(),
                    );
                  }
                },
                validator: (value) =>
                    value == null ? 'Language is required' : null,
              ),
      ],
    );
  }
}
