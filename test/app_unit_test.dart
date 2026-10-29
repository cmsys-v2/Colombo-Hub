import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colombo_hub/core/utils/carrier_detector.dart';
import 'package:colombo_hub/core/services/payment_service.dart';
import 'package:colombo_hub/models/user_model.dart';
import 'package:colombo_hub/models/accommodation_model.dart';
import 'package:colombo_hub/models/transport_model.dart';
import 'package:colombo_hub/models/meal_pool_model.dart';
import 'package:colombo_hub/models/courier_model.dart';
import 'package:colombo_hub/models/service_provider_model.dart';
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

  group('New Feature Models & Serialization Tests', () {
    test('UserModel serializes and deserializes cleanly', () {
      final user = UserModel.fromMap({
        'uid': 'usr-999',
        'phoneNumber': '+94778924510',
        'carrier': 'Dialog Axiata GSM',
        'isVerified': true,
        'scoutPoints': 650,
        'isVendor': true,
        'partnerWallet': 25000.0,
      });

      expect(user.uid, 'usr-999');
      expect(user.phoneNumber, '+94778924510');
      expect(user.scoutPoints, 650);
      expect(user.isVendor, isTrue);

      final map = user.toMap();
      expect(map['carrier'], 'Dialog Axiata GSM');
      expect(map['partnerWallet'], 25000.0);
    });

    test('AccommodationModel Form-C & CEB separate meter verification', () {
      const stay = AccommodationModel(
        id: 'stay-test',
        title: 'Executive Annex',
        neighborhood: 'Rajagiriya',
        workplace: 'World Trade Center (Fort)',
        commuteMins: 16,
        price: 32000,
        durationCategory: 'Monthly Boarding',
        description: 'Form-C Ready',
        ownerPhotosCount: 4,
        scoutPhotosCount: 8,
        rating: 4.8,
        depositAmount: 15000,
        features: ['Separate CEB Meter', 'Form-C Ready'],
        latitude: 6.9103,
        longitude: 79.8966,
        vendorId: 'V-771',
      );

      expect(stay.isFormCReady, isTrue);
      expect(stay.isSeparateMeter, isTrue);
      expect(stay.features.length, 2);

      final updated = stay.copyWith(scoutPhotosCount: 9);
      expect(updated.scoutPhotosCount, 9);
    });

    test('TransportModel expressway pass discount calculation', () {
      const bus = TransportModel(
        id: 'bus-test',
        corridorName: 'E04 Kandy-Colombo',
        expresswayTag: 'E04 Central Express',
        title: 'Super Luxury Coach',
        busType: 'AC Express',
        departureTime: '05:45 AM',
        arrivalTime: '07:30 AM',
        dailyPrice: 950,
        monthlyPassPrice: 15800,
        seatsLeft: 14,
        waypoints: 'Peradeniya -> Mirigama -> Peliyagoda -> Fort',
        vendorId: 'V-Bus-01',
      );

      expect(bus.dailyPrice, 950);
      expect(bus.monthlyPassPrice, 15800);
      expect(bus.seatsLeft, 14);

      final updated = bus.copyWith(seatsLeft: 13);
      expect(updated.seatsLeft, 13);
    });

    test('MealPoolModel order cutoff and pooled fee calculation', () {
      const meal = MealPoolModel(
        id: 'lunch-test',
        catererName: 'Kamani Home Caterers',
        title: 'Village Polos & Red Rice',
        description: 'Traditional Sri Lankan Curry',
        price: 450,
        courierFee: 18,
        isEcoTiffin: true,
        vendorId: 'V-771',
      );

      expect(meal.price, 450);
      expect(meal.courierFee, 18);
      expect(meal.totalPrice, 468);
      expect(meal.isEcoTiffin, isTrue);
      expect(meal.orderCutoffTime, '10:30 AM');
    });

    test('CourierModel backhaul discount percent verification', () {
      const courier = CourierModel(
        id: 'courier-test',
        tierTag: 'OUTSTATION BACKHAUL',
        title: 'Weekend Trunk Bin Cargo',
        description: 'Carried in return commuter bus luggage bay',
        price: 650,
        priceLabel: 'flat per trunk',
        vendorId: 'V-Bus-01',
        backhaulDiscountPercent: 0.40,
      );

      expect(courier.price, 650);
      expect(courier.backhaulDiscountPercent, 0.40);
    });

    test('ServiceProviderModel gas stock and water delivery items', () {
      const service = ServiceProviderModel(
        id: 'srv-gas',
        title: 'Litro Gas 12.5kg Cylinder Depot',
        description: 'Current verified Colombo Fort dealer depot stock',
        price: 3690,
        priceUnit: 'per cylinder',
        iconCode: 'flame',
        vendorId: 'V-Gas-01',
        stockCount: 120,
      );

      expect(service.price, 3690);
      expect(service.stockCount, 120);
      expect(service.iconCode, 'flame');
    });
  });
}
