import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/services/payment_service.dart';
import '../../state/app_providers.dart';

class PaymentModal extends ConsumerStatefulWidget {
  final String title;
  final double amount;
  final String vendorId;
  final String serviceType;

  const PaymentModal({
    super.key,
    required this.title,
    required this.amount,
    required this.vendorId,
    required this.serviceType,
  });

  @override
  ConsumerState<PaymentModal> createState() => _PaymentModalState();
}

class _PaymentModalState extends ConsumerState<PaymentModal> {
  late PaymentOrder _order;
  PaymentGatewayType _selectedGateway = PaymentGatewayType.payhere;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _order = PaymentService.createOrder(
      title: widget.title,
      amount: widget.amount,
      vendorId: widget.vendorId,
      serviceType: widget.serviceType,
    );
  }

  void _executePayment() {
    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;

      // Credit Partner Wallet (95% net after 5% platform fee)
      ref.read(userProfileProvider.notifier).creditPartnerWallet(_order.netVendorCredit);
      // Award +10 Scout Points
      ref.read(userProfileProvider.notifier).rewardScoutPoints(10);

      final user = ref.read(userProfileProvider);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment of ${CurrencyFormatter.format(_order.amount)} successful via PayHere Escrow! (+10 Scout Pts). SMS receipt sent to ${user.phoneNumber}',
          ),
          backgroundColor: AppTheme.emeraldGreen,
          duration: const Duration(seconds: 4),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
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
                        child: const Icon(LucideIcons.shieldCheck, color: AppTheme.primaryTeal, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ColomboHub Secure Checkout',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            'PayHere Sri Lanka & FriMi Gateway (LKR)',
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

              // Item Order Breakdown
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.slateLightBg,
                  border: Border.all(color: AppTheme.slateBorder),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _order.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Order ID: ${_order.orderId} • Escrow Protected',
                            style: const TextStyle(fontSize: 11, color: AppTheme.darkTeal, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.format(_order.amount),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.primaryTeal),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.emeraldLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '5% Fee Included',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppTheme.emeraldGreen),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Select Sri Lankan Payment Method:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.slateDark),
              ),
              const SizedBox(height: 10),

              // 1. PayHere Lanka Option
              _buildGatewayOption(
                type: PaymentGatewayType.payhere,
                title: 'PayHere Lanka (Visa, MasterCard, AMEX, FriMi)',
                subtitle: 'Instant Online Payment • Merchant ID: 1220001',
                badgeText: 'MD5 Protected',
                badgeColor: const Color(0xFFEFF6FF),
                badgeTextColor: const Color(0xFF1D4ED8),
                extraContent: _selectedGateway == PaymentGatewayType.payhere
                    ? Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.slateLightBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Security Hash: ${_order.md5Hash}',
                              style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: AppTheme.primaryTeal, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              children: [
                                Expanded(
                                  child: Text('Card: 4111 •••• •••• 1234', style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                                ),
                                Text('Exp: 12/28', style: TextStyle(fontSize: 11, color: AppTheme.slateMuted)),
                              ],
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 8),

              // 2. FriMi LANKAQR Option
              _buildGatewayOption(
                type: PaymentGatewayType.frimi,
                title: 'FriMi LANKAQR (Nations Trust Bank)',
                subtitle: 'Scan & Pay directly via FriMi or any Sri Lankan Bank App',
                badgeText: 'LANKAQR',
                badgeColor: const Color(0xFFFFF7ED),
                badgeTextColor: const Color(0xFFC2410C),
                extraContent: _selectedGateway == PaymentGatewayType.frimi
                    ? Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppTheme.slateBorder),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(LucideIcons.qrCode, size: 64, color: AppTheme.slateDark),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Scan using FriMi or your bank app',
                              style: TextStyle(fontSize: 11, color: AppTheme.slateMuted),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 8),

              // 3. Cash on Delivery / Handover
              _buildGatewayOption(
                type: PaymentGatewayType.cod,
                title: 'Cash on Delivery / Driver Handover',
                subtitle: 'Hold booking with mobile SMS OTP verification',
                badgeText: 'Cash',
                badgeColor: AppTheme.slateLightBg,
                badgeTextColor: AppTheme.slateMuted,
              ),
              const SizedBox(height: 20),

              // Pay Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _executePayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryTeal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isProcessing
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Text('Processing Payment with Sri Lanka Gateway...'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(LucideIcons.lock, size: 16),
                            const SizedBox(width: 8),
                            Text('Pay & Confirm (${CurrencyFormatter.format(_order.amount)})'),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGatewayOption({
    required PaymentGatewayType type,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    Widget? extraContent,
  }) {
    final isSelected = _selectedGateway == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedGateway = type;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.lightTeal : Colors.white,
          border: Border.all(
            color: isSelected ? AppTheme.primaryTeal : AppTheme.slateBorder,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppTheme.primaryTeal : AppTheme.slateMuted,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.slateMuted)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: badgeTextColor),
                  ),
                ),
              ],
            ),
            if (extraContent != null) extraContent,
          ],
        ),
      ),
    );
  }
}
