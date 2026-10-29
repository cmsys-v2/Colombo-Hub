import 'package:flutter/material.dart';

class CarrierInfo {
  final String name;
  final Color badgeBg;
  final Color badgeTextColor;
  final Color borderColor;

  const CarrierInfo({
    required this.name,
    required this.badgeBg,
    required this.badgeTextColor,
    required this.borderColor,
  });
}

class CarrierDetector {
  static CarrierInfo detect(String phoneNumber) {
    final clean = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (clean.startsWith('77') || clean.startsWith('76') || clean.startsWith('74') ||
        clean.startsWith('077') || clean.startsWith('076') || clean.startsWith('074') ||
        clean.startsWith('9477') || clean.startsWith('9476') || clean.startsWith('9474')) {
      return const CarrierInfo(
        name: 'Dialog Axiata GSM',
        badgeBg: Color(0xFFF0FDFA),
        badgeTextColor: Color(0xFF0F766E),
        borderColor: Color(0xFF99F6E4),
      );
    } else if (clean.startsWith('71') || clean.startsWith('70') ||
               clean.startsWith('071') || clean.startsWith('070') ||
               clean.startsWith('9471') || clean.startsWith('9470')) {
      return const CarrierInfo(
        name: 'SLT-Mobitel 4G',
        badgeBg: Color(0xFFEFF6FF),
        badgeTextColor: Color(0xFF1D4ED8),
        borderColor: Color(0xFFBFDBFE),
      );
    } else if (clean.startsWith('75') || clean.startsWith('075') || clean.startsWith('9475')) {
      return const CarrierInfo(
        name: 'Airtel Sri Lanka',
        badgeBg: Color(0xFFFEF2F2),
        badgeTextColor: Color(0xFFB91C1C),
        borderColor: Color(0xFFFECACA),
      );
    } else if (clean.startsWith('78') || clean.startsWith('72') ||
               clean.startsWith('078') || clean.startsWith('072') ||
               clean.startsWith('9478') || clean.startsWith('9472')) {
      return const CarrierInfo(
        name: 'Hutchison Sri Lanka',
        badgeBg: Color(0xFFFFF7ED),
        badgeTextColor: Color(0xFFC2410C),
        borderColor: Color(0xFFFED7AA),
      );
    } else {
      return const CarrierInfo(
        name: 'Sri Lankan GSM',
        badgeBg: Color(0xFFF8FAFC),
        badgeTextColor: Color(0xFF334155),
        borderColor: Color(0xFFE2E8F0),
      );
    }
  }

  static String formatSriLankanPhone(String raw) {
    final clean = raw.replaceAll(RegExp(r'\D'), '');
    if (clean.startsWith('94') && clean.length == 11) {
      return '+94 ${clean.substring(2, 4)} ${clean.substring(4, 7)} ${clean.substring(7)}';
    } else if (clean.startsWith('0') && clean.length == 10) {
      return '+94 ${clean.substring(1, 3)} ${clean.substring(3, 6)} ${clean.substring(6)}';
    } else if (clean.length == 9) {
      return '+94 ${clean.substring(0, 2)} ${clean.substring(2, 5)} ${clean.substring(5)}';
    }
    return raw;
  }
}
