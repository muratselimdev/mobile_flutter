import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/country_data.dart';
import '../bloc/app_language_cubit.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../localization/app_localizations.dart';
import 'one_clinic_edit_profile_page.dart';

class OneClinicProfilePage extends StatefulWidget {
  const OneClinicProfilePage({super.key});

  @override
  State<OneClinicProfilePage> createState() => _OneClinicProfilePageState();
}

class _OneClinicProfilePageState extends State<OneClinicProfilePage> {
  bool _notificationsEnabled = true;
  bool _faceIdEnabled = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState.user;

        // Get country name from country code or name
        String getCountryName(String? countryValue) {
          if (countryValue == null || countryValue.isEmpty) {
            return context.loc.t('profile.countryValue');
          }

          // First, try to find by country code (2-letter codes like "TR", "SY")
          if (countryValue.length == 2) {
            final countryByCode = CountryData.countries.firstWhere(
              (c) => c.code.toUpperCase() == countryValue.toUpperCase(),
              orElse: () => CountryData.countries.first,
            );
            if (countryByCode.code.toUpperCase() ==
                countryValue.toUpperCase()) {
              return countryByCode.name;
            }
          }

          // If not a code or not found, try to find by country name
          final countryByName = CountryData.countries.firstWhere(
            (c) => c.name.toLowerCase() == countryValue.toLowerCase(),
            orElse: () => CountryData.countries.first,
          );

          // Check if we found a match by name
          if (countryByName.name.toLowerCase() == countryValue.toLowerCase()) {
            return countryByName.name;
          }

          // If still not found, return the original value
          return countryValue;
        }

        return Center(
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Column(
                children: [
                  Text(
                    context.loc.t('app.brandUpper'),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                  Text(
                    context.loc.t('profile.title'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Header Section
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        // Profile Picture with Badge
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE8B896),
                              ),
                              child: Center(
                                child:
                                    user?.initials != null &&
                                        user!.initials.isNotEmpty
                                    ? Text(
                                        user.initials,
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // User Name
                        Text(
                          user?.fullName ?? context.loc.t('profile.userName'),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (user?.email != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            user!.email!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        // Member Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.loc.t('profile.memberBadge'),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF16A34A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Edit Profile Button
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const OneClinicEditProfilePage(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 18,
                            color: Color(0xFF16A34A),
                          ),
                          label: Text(
                            context.loc.t('profile.editProfileButton'),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF16A34A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Actions Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.t('profile.quickActionsTitle'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Quick Actions Grid
                        Row(
                          children: [
                            Expanded(
                              child: _QuickActionCard(
                                icon: Icons.calendar_today_outlined,
                                iconColor: const Color(0xFF4F46E5),
                                iconBgColor: const Color(0xFFEEF2FF),
                                title: context.loc.t(
                                  'profile.quickActions.treatmentsTitle',
                                ),
                                subtitle: context.loc.t(
                                  'profile.quickActions.treatmentsSubtitle',
                                ),
                                onTap: () {
                                  // TODO: Navigate to appointments
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickActionCard(
                                icon: Icons.description_outlined,
                                iconColor: const Color(0xFFF59E0B),
                                iconBgColor: const Color(0xFFFEF3C7),
                                title: context.loc.t(
                                  'profile.quickActions.reportsTitle',
                                ),
                                subtitle: context.loc.t(
                                  'profile.quickActions.reportsSubtitle',
                                ),
                                onTap: () {
                                  // TODO: Navigate to reports
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _QuickActionCard(
                                icon: Icons.medical_services_outlined,
                                iconColor: const Color(0xFF8B5CF6),
                                iconBgColor: const Color(0xFFF3E8FF),
                                title: context.loc.t(
                                  'profile.quickActions.prescriptionsTitle',
                                ),
                                subtitle: context.loc.t(
                                  'profile.quickActions.prescriptionsSubtitle',
                                ),
                                onTap: () {
                                  // TODO: Navigate to prescriptions
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _QuickActionCard(
                                icon: Icons.chat_bubble_outline,
                                iconColor: const Color(0xFF10B981),
                                iconBgColor: const Color(0xFFD1FAE5),
                                title: context.loc.t(
                                  'profile.quickActions.supportTitle',
                                ),
                                subtitle: context.loc.t(
                                  'profile.quickActions.supportSubtitle',
                                ),
                                onTap: () {
                                  // TODO: Navigate to support
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Personal Information Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.t('profile.personalInfoTitle'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Email
                        _PersonalInfoCard(
                          icon: Icons.email_outlined,
                          iconColor: Colors.grey,
                          title: context.loc.t('profile.emailLabel'),
                          value: user?.email ?? 'No email',
                          isLocked: true,
                        ),
                        const SizedBox(height: 12),
                        // Phone
                        _PersonalInfoCard(
                          icon: Icons.phone_outlined,
                          iconColor: Colors.grey,
                          title: context.loc.t('profile.phoneLabel'),
                          value: user?.phone ?? 'No phone',
                          isLocked: true,
                        ),
                        const SizedBox(height: 12),
                        // Country/Region
                        _SettingItemCard(
                          icon: Icons.public_outlined,
                          iconColor: Colors.grey,
                          title: context.loc.t('profile.countryLabel'),
                          value: getCountryName(user?.country),
                          isArrowShown: true,
                          onTap: () {
                            // TODO: Navigate to country/region selection
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Application Settings Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.t('profile.appSettingsTitle'),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Language Selection
                        _SettingItemCard(
                          icon: Icons.language_outlined,
                          iconColor: Colors.grey,
                          title: context.loc.t('profile.languageOption'),
                          value: context.loc.t('profile.languageValue'),
                          isArrowShown: true,
                          onTap: () {
                            _showLanguageBottomSheet(context);
                          },
                        ),
                        const SizedBox(height: 12),
                        // Notifications Toggle
                        // Notifications Toggle
                        _SettingToggleCard(
                          icon: Icons.notifications_outlined,
                          iconColor: Colors.grey,
                          title: context.loc.t('profile.notifications'),
                          value: _notificationsEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        // FaceID Login Toggle
                        // FaceID Login Toggle
                        _SettingToggleCard(
                          icon: Icons.face_outlined,
                          iconColor: Colors.grey,
                          title: context.loc.t('profile.faceId'),
                          value: _faceIdEnabled,
                          onChanged: (value) {
                            setState(() {
                              _faceIdEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
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
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.english')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('en');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.german')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('de');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.spanish')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('es');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.russian')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('ru');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.polish')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('pl');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.french')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('fr');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.portuguese')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('pt');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.italian')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('it');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(context.loc.t('language.arabic')),
                    onTap: () {
                      context.read<AppLanguageCubit>().setLocaleByCode('ar');
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final bool isLocked;

  const _PersonalInfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          if (isLocked)
            Icon(Icons.lock_outline, color: Colors.grey[400], size: 20),
        ],
      ),
    );
  }
}

class _SettingItemCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final bool isArrowShown;
  final VoidCallback onTap;

  const _SettingItemCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    this.isArrowShown = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            if (isArrowShown)
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }
}

class _SettingToggleCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const _SettingToggleCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF16A34A),
          ),
        ],
      ),
    );
  }
}
