import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colombo_hub/core/utils/carrier_detector.dart';
import 'package:colombo_hub/core/services/payment_service.dart';
import 'package:colombo_hub/state/app_providers.dart';

void main() {
  group('Sri Lankan Telco Carrier Detection Tests', () {
    test('Detects Dialog Axiata GSM correctly', () {
      final info1 = CarrierDetector.detect('0771234567');
      expect(info1.name, 'Dialog Axiata GSM');

      final info2 = CarrierDetector.detect('+94 76 892 4510');
      expect(info2.name, 'Dialog Axiata GSM');

      final info3 = CarrierDetector.detect('741234567');
      expect(info3.name, 'Dialog Axiata GSM');
    });

    test('Detects SLT-Mobitel 4G correctly', () {
      final info = CarrierDetector.detect('0712345678');
      expect(info.name, 'SLT-Mobitel 4G');
    });

    test('Detects Airtel Sri Lanka correctly', () {
      final info = CarrierDetector.detect('0751234567');
      expect(info.name, 'Airtel Sri Lanka');
    });

    test('Detects Hutchison Sri Lanka correctly', () {
      final info = CarrierDetector.detect('0781234567');
      expect(info.name, 'Hutchison Sri Lanka');
    });

    test('Formats Sri Lankan mobile numbers properly', () {
      final formatted = CarrierDetector.formatSriLankanPhone('0778924510');
      expect(formatted, '+94 77 892 4510');
    });
  });

  group('Smart Commuter Budget & Bill Splitter Calculations', () {
    test('Calculates EPF, Tax, and Net Take-Home on 180,000 LKR salary', () {
      const budget = BudgetState(salary: 180000, strategy: 'boarding');
      expect(budget.epf, 14400); // 8% of 180,000
      expect(budget.tax, 1800);  // 6% of (180,000 - 150,000)
      expect(budget.rent, 32000);
      expect(budget.transport, 7500);
      expect(budget.food, 10296);

      const totalDeductions = 32000 + 7500 + 10296 + 14400 + 1800;
      expect(budget.totalDeductions, totalDeductions);
      expect(budget.netTakeHome, 180000 - totalDeductions);
    });

    test('Shared Annex Bill Splitter prorates correctly', () {
      const budget = BudgetState(utilityBill: 16800, roommates: 3);
      expect(budget.splitShare, 5600);
    });

    test('Commuter strategy eliminates Colombo rent', () {
      const budget = BudgetState(salary: 180000, strategy: 'commuter');
      expect(budget.rent, 0);
      expect(budget.transport, 16500);
    });
  });

  group('Payment Service & Platform Commission Tests', () {
    test('Calculates 5% platform fee and 95% net vendor credit', () {
      final order = PaymentService.createOrder(
        title: 'Village Polos Rice & Curry',
        amount: 468.0,
        vendorId: 'V-771',
        serviceType: 'meal_pool',
      );

      expect(order.orderId.startsWith('ORD-'), isTrue);
      expect(order.md5Hash.startsWith('MD5-'), isTrue);
      expect(order.platformFee, closeTo(23.4, 0.01));
      expect(order.netVendorCredit, closeTo(444.6, 0.01));
    });
  });

  group('Riverpod State Management Tests', () {
    test('User profile role toggling and Scout points', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialUser = container.read(userProfileProvider);
      expect(initialUser.isVendor, isFalse);
      expect(initialUser.scoutPoints, 550);

      // Toggle role to Vendor
      container.read(userProfileProvider.notifier).toggleRole();
      expect(container.read(userProfileProvider).isVendor, isTrue);

      // Award scout points (+50)
      container.read(userProfileProvider.notifier).rewardScoutPoints(50);
      expect(container.read(userProfileProvider).scoutPoints, 600);

      // Partner wallet credit
      container.read(userProfileProvider.notifier).creditPartnerWallet(1250);
      expect(container.read(userProfileProvider).partnerWallet, 18450.0 + 1250);
    });
  });
}
