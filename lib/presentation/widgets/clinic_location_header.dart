import 'package:flutter/material.dart';

/// A widget that displays the clinic name and location with an icon
class ClinicLocationHeader extends StatelessWidget {
  /// The name of the clinic and its location (e.g., "One Clinic Center · Istanbul")
  final String clinicName;

  /// The location or city name
  final String location;

  /// Icon color, defaults to teal
  final Color iconColor;

  /// Text color, defaults to slate gray
  final Color textColor;

  /// Font size, defaults to 14
  final double fontSize;

  const ClinicLocationHeader({
    super.key,
    required this.clinicName,
    required this.location,
    this.iconColor = const Color(0xFF0EA5A4),
    this.textColor = const Color(0xFF64748B),
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on, size: fontSize + 2, color: iconColor),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            '$clinicName · $location',
            style: TextStyle(
              fontSize: fontSize,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
