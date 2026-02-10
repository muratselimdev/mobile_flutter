import 'package:flutter/material.dart';

/// A widget that displays a rating with star icon and verified reviews count
class RatingLabel extends StatelessWidget {
  /// The rating value (e.g., 4.8)
  final double rating;

  /// The number of verified reviews
  final int reviewCount;

  /// Whether to show the full label with "Verified Reviews" text
  final bool showFullLabel;

  /// Background color of the rating badge
  final Color backgroundColor;

  /// Star icon color
  final Color starColor;

  /// Text color for the review count
  final Color textColor;

  const RatingLabel({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.showFullLabel = true,
    this.backgroundColor = const Color(0xFFFFF7ED),
    this.starColor = const Color(0xFFF59E0B),
    this.textColor = const Color(0xFF64748B),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 14, color: starColor),
              const SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        if (showFullLabel) ...[
          const SizedBox(width: 12),
          Text(
            '$reviewCount Verified Reviews',
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ],
      ],
    );
  }
}
