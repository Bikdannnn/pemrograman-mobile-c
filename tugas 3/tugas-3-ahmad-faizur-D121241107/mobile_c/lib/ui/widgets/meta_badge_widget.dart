import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MetaBadgeWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const MetaBadgeWidget({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: const Color(0xFF6B584C)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.lora(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3E312B),
            ),
          ),
        ),
      ],
    );
  }
}
