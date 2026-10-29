import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/carrier_detector.dart';
import '../../state/app_providers.dart';

class PhoneAuthModal extends ConsumerStatefulWidget {
  const PhoneAuthModal({super.key});

  @override
  ConsumerState<PhoneAuthModal> createState() => _PhoneAuthModalState();
}

class _PhoneAuthModalState extends ConsumerState<PhoneAuthModal> {
  int _step = 1;
  final TextEditingController _phoneController = TextEditingController(text: '77 892 4510');
  final TextEditingController _otpController = TextEditingController();
  CarrierInfo _carrierInfo = const CarrierInfo(
    name: 'Dialog Axiata GSM',
    badgeBg: Color(0xFFF0FDFA),
    badgeTextColor: Color(0xFF0F766E),
    borderColor: Color(0xFF99F6E4),
  );

  Timer? _countdownTimer;
  int _secondsLeft = 60;

  @override
  void initState() {
    super.initState();
    _carrierInfo = CarrierDetector.detect(_phoneController.text);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _secondsLeft = 60;
      _step = 2;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTeal,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(LucideIcons.smartphone, color: AppTheme.primaryTeal, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sri Lanka Phone Verification',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            'Firebase Auth with Carrier Detection',
                            style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),

              if (_step == 1) ...[
                const Text(
                  'Enter your 9-digit Sri Lankan mobile number to receive an instant SMS verification code.',
                  style: TextStyle(fontSize: 12, color: AppTheme.slateMuted),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.slateLightBg,
                        border: Border.all(color: AppTheme.slateBorder),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('🇱🇰 +94', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        onChanged: (val) {
                          setState(() {
                            _carrierInfo = CarrierDetector.detect(val);
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: '77 123 4567',
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Detected Telco Network:', style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _carrierInfo.badgeBg,
                        border: Border.all(color: _carrierInfo.borderColor),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _carrierInfo.name,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _carrierInfo.badgeTextColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_phoneController.text.trim().isEmpty) return;
                      _startCountdown();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('6-digit SMS OTP sent to +94 ${_phoneController.text} (Demo: 456789)'),
                          backgroundColor: AppTheme.slateDark,
                        ),
                      );
                    },
                    child: const Text('Send 6-Digit OTP via SMS'),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTeal,
                    border: Border.all(color: AppTheme.tealBorder),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SMS verification code sent to +94 ${_phoneController.text}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.darkTeal),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Expires in $_secondsLeft seconds',
                        style: const TextStyle(fontSize: 11, color: AppTheme.primaryTeal),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Enter 6-Digit Verification Code', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                TextField(
                  controller: _otpController,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 20, letterSpacing: 8, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '456789',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _otpController.text = '456789';
                        },
                        child: const Text('Demo Fill', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.emeraldGreen),
                        onPressed: () {
                          if (_otpController.text.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter 6-digit code')),
                            );
                            return;
                          }
                          final formatted = CarrierDetector.formatSriLankanPhone(_phoneController.text);
                          ref.read(userProfileProvider.notifier).verifyPhone(formatted);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Phone Verified ($formatted)! +50 Scout Points awarded 🎉'),
                              backgroundColor: AppTheme.emeraldGreen,
                            ),
                          );
                        },
                        child: const Text('Verify & Link (+50 Pts)', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
