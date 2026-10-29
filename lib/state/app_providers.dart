import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/accommodation_model.dart';
import '../models/transport_model.dart';
import '../models/meal_pool_model.dart';
import '../models/courier_model.dart';
import '../models/service_provider_model.dart';
import '../core/constants/sri_lanka_data.dart';

// ==========================================
// USER STATE
// ==========================================
class UserStateNotifier extends StateNotifier<UserProfile> {
  UserStateNotifier()
      : super(const UserProfile(
          phoneNumber: '+94 77 892 4510',
          isVerified: true,
          scoutPoints: 550,
          isVendor: false,
          partnerWallet: 18450.0,
          partnerId: 'V-771',
          partnerName: 'Kamani Home Caterers & Highway Shuttle Hub',
        ));

  void toggleRole() {
    state = state.copyWith(isVendor: !state.isVendor);
  }

  void rewardScoutPoints(int points) {
    state = state.copyWith(scoutPoints: state.scoutPoints + points);
  }

  void addScoutPoints(int points) => rewardScoutPoints(points);

  void creditPartnerWallet(double amount) {
    state = state.copyWith(partnerWallet: state.partnerWallet + amount);
  }

  void withdrawWallet() {
    state = state.copyWith(partnerWallet: 0.0);
  }

  void verifyPhone(String phone) {
    state = state.copyWith(
      phoneNumber: phone,
      isVerified: true,
      scoutPoints: state.scoutPoints + 50,
    );
  }
}

final userProfileProvider = StateNotifierProvider<UserStateNotifier, UserProfile>((ref) {
  return UserStateNotifier();
});

// ==========================================
// ACTIVE TAB SELECTION
// ==========================================
enum AppTab {
  stay,
  move,
  eat,
  budget,
  courier,
  services,
  chat,
}

extension AppTabControllerExt on StateController<AppTab> {
  void setTab(int index) {
    if (index >= 0 && index < AppTab.values.length) {
      state = AppTab.values[index];
    }
  }
}

final activeTabProvider = StateProvider<AppTab>((ref) => AppTab.stay);

// ==========================================
// MONETIZATION PHASE
// ==========================================
enum MonetizationPhase {
  free, // Phase 1: 0-10k (100% Free Viral)
  ads,  // Phase 2: 10k+ (Light Native Ads)
  subs, // Phase 3: 200k+ (Pro Subscription)
}

extension MonetizationPhaseNameExt on MonetizationPhase {
  String toUpperCase() {
    switch (this) {
      case MonetizationPhase.free:
        return 'FREE BETA';
      case MonetizationPhase.ads:
        return 'AD SUPPORTED';
      case MonetizationPhase.subs:
        return 'PRO SUBSCRIPTION';
    }
  }
}

extension MonetizationPhaseControllerExt on StateController<MonetizationPhase> {
  void cyclePhase() {
    switch (state) {
      case MonetizationPhase.free:
        state = MonetizationPhase.ads;
        break;
      case MonetizationPhase.ads:
        state = MonetizationPhase.subs;
        break;
      case MonetizationPhase.subs:
        state = MonetizationPhase.free;
        break;
    }
  }
}

final monetizationPhaseProvider = StateProvider<MonetizationPhase>((ref) => MonetizationPhase.free);

// ==========================================
// STAY & ACCOMMODATION STATE
// ==========================================
class StayFilterState {
  final String workplace;
  final int maxCommuteMins;
  final String durationCategory;

  const StayFilterState({
    required this.workplace,
    required this.maxCommuteMins,
    required this.durationCategory,
  });

  StayFilterState copyWith({
    String? workplace,
    int? maxCommuteMins,
    String? durationCategory,
  }) {
    return StayFilterState(
      workplace: workplace ?? this.workplace,
      maxCommuteMins: maxCommuteMins ?? this.maxCommuteMins,
      durationCategory: durationCategory ?? this.durationCategory,
    );
  }
}

final stayFilterProvider = StateProvider<StayFilterState>((ref) {
  return const StayFilterState(
    workplace: 'World Trade Center (Fort)',
    maxCommuteMins: 25,
    durationCategory: 'Monthly Boarding / Annex',
  );
});

class StayListingsNotifier extends StateNotifier<List<StayListing>> {
  StayListingsNotifier() : super(SriLankaData.initialStayListings);

  void addScoutPhoto(String listingId) {
    state = [
      for (final item in state)
        if (item.id == listingId)
          item.copyWith(scoutPhotosCount: item.scoutPhotosCount + 1)
        else
          item
    ];
  }

  void addListing(StayListing listing) {
    state = [listing, ...state];
  }
}

final stayListingsProvider = StateNotifierProvider<StayListingsNotifier, List<StayListing>>((ref) {
  return StayListingsNotifier();
});

final filteredStayListingsProvider = Provider<List<StayListing>>((ref) {
  final listings = ref.watch(stayListingsProvider);
  final filter = ref.watch(stayFilterProvider);

  return listings.where((item) {
    final matchesCommute = item.commuteMins <= filter.maxCommuteMins;
    final matchesWorkplace = filter.workplace.isEmpty ||
        item.workplace.toLowerCase().contains(filter.workplace.toLowerCase()) ||
        filter.workplace.toLowerCase().contains(item.workplace.toLowerCase());
    return matchesCommute && matchesWorkplace;
  }).toList();
});

// ==========================================
// BUS ROUTES & TRANSPORT STATE
// ==========================================
class BusRoutesNotifier extends StateNotifier<List<BusRoute>> {
  BusRoutesNotifier() : super(SriLankaData.initialBusRoutes);

  void bookDailySeat(String routeId) {
    state = [
      for (final r in state)
        if (r.id == routeId && r.seatsLeft > 0)
          r.copyWith(seatsLeft: r.seatsLeft - 1)
        else
          r
    ];
  }

  void bookSeat(String routeId) => bookDailySeat(routeId);
}

final busRoutesProvider = StateNotifierProvider<BusRoutesNotifier, List<BusRoute>>((ref) {
  return BusRoutesNotifier();
});

// ==========================================
// LUNCH POOL STATE
// ==========================================
final lunchItemsProvider = Provider<List<LunchItem>>((ref) {
  return SriLankaData.initialLunchItems;
});

// ==========================================
// BUDGET & BILL SPLITTER STATE
// ==========================================
class BudgetState {
  final double salary;
  final String strategy; // 'boarding', 'commuter', 'shared', 'board_near', 'expressway_bus'
  final double utilityBill;
  final int roommates;
  final double? customRent;
  final double? customTransport;
  final double? customFood;

  const BudgetState({
    this.salary = 180000,
    this.strategy = 'boarding',
    this.utilityBill = 16800,
    this.roommates = 3,
    this.customRent,
    this.customTransport,
    this.customFood,
  });

  double get rent {
    if (customRent != null) return customRent!;
    if (strategy == 'commuter' || strategy == 'expressway_bus') return 0;
    if (strategy == 'shared') return 16000;
    return 32000;
  }

  double get transport {
    if (customTransport != null) return customTransport!;
    if (strategy == 'commuter' || strategy == 'expressway_bus') return 16500;
    return 7500;
  }

  double get food => customFood ?? 10296; // 22 days of office lunch pool

  double get epf => salary * 0.08;

  double get tax => salary > 150000 ? (salary - 150000) * 0.06 : 0;

  double get totalDeductions => rent + transport + food + epf + tax;

  double get netTakeHome => salary - totalDeductions;

  double get splitShare => roommates > 0 ? (utilityBill / roommates) : utilityBill;

  // Aliases for BudgetPlannerScreen
  double get rentCost => rent;
  double get transportCost => transport;
  double get foodCost => food;
  double get utilityCost => utilityBill;
  double get epfEmployee => epf;
  double get apitTax => tax;
  double get totalExpenses => totalDeductions;
  double get netSavings => netTakeHome;
  double get totalUtilityBill => utilityBill;
  int get roommatesCount => roommates;
  double get perPersonShare => splitShare;

  BudgetState copyWith({
    double? salary,
    String? strategy,
    double? utilityBill,
    int? roommates,
    double? customRent,
    double? customTransport,
    double? customFood,
  }) {
    return BudgetState(
      salary: salary ?? this.salary,
      strategy: strategy ?? this.strategy,
      utilityBill: utilityBill ?? this.utilityBill,
      roommates: roommates ?? this.roommates,
      customRent: customRent ?? this.customRent,
      customTransport: customTransport ?? this.customTransport,
      customFood: customFood ?? this.customFood,
    );
  }
}

class BudgetNotifier extends StateNotifier<BudgetState> {
  BudgetNotifier() : super(const BudgetState());

  void setSalary(double val) => state = state.copyWith(salary: val);
  void setStrategy(String val) => state = state.copyWith(strategy: val);
  void setUtilityBill(double val) => state = state.copyWith(utilityBill: val);
  void setRoommates(int val) => state = state.copyWith(roommates: val);

  void setRentCost(double val) => state = state.copyWith(customRent: val);
  void setTransportCost(double val) => state = state.copyWith(customTransport: val);
  void setFoodCost(double val) => state = state.copyWith(customFood: val);
  void setUtilityCost(double val) => state = state.copyWith(utilityBill: val);
  void setTotalUtilityBill(double val) => state = state.copyWith(utilityBill: val);
  void setRoommatesCount(int val) => state = state.copyWith(roommates: val);
}

final budgetProvider = StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
  return BudgetNotifier();
});

// ==========================================
// COURIER & SERVICES STATE
// ==========================================
final courierOptionsProvider = Provider<List<CourierOption>>((ref) {
  return SriLankaData.initialCourierOptions;
});

final householdServicesProvider = Provider<List<HouseholdService>>((ref) {
  return SriLankaData.initialServices;
});

// Active Dispatches
class DispatchesNotifier extends StateNotifier<List<ActiveDispatch>> {
  DispatchesNotifier() : super(SriLankaData.initialDispatches);

  void removeDispatch(String id) {
    state = state.where((d) => d.id != id).toList();
  }
}

final dispatchesProvider = StateNotifierProvider<DispatchesNotifier, List<ActiveDispatch>>((ref) {
  return DispatchesNotifier();
});

// ==========================================
// CHAT & MESSAGES STATE
// ==========================================
class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super(SriLankaData.initialChatMessages);

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      senderName: 'You',
      text: text.trim(),
      timestamp: DateTime.now(),
      isAssistant: false,
    );

    state = [...state, userMsg];

    // Simulated Smart Response from ColomboHub AI
    Future.delayed(const Duration(milliseconds: 800), () {
      final reply = _generateReply(text.trim());
      final assistantMsg = ChatMessage(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch + 1}',
        senderName: 'ColomboHub Assistant',
        text: reply,
        timestamp: DateTime.now(),
        isAssistant: true,
      );
      state = [...state, assistantMsg];
    });
  }

  String _generateReply(String input) {
    final lower = input.toLowerCase();
    if (lower.contains('bus') || lower.contains('seat') || lower.contains('highway')) {
      return 'The Kurunegala and Galle highway coaches have live seat tracking. You can reserve directly from the Move tab!';
    } else if (lower.contains('lunch') || lower.contains('curry') || lower.contains('food') || lower.contains('polos')) {
      return 'Today\'s WTC lunch pool orders lock at 10:30 AM! Delivery arrives at the lobby at 12:15 PM sharp (courier fee only Rs. 18).';
    } else if (lower.contains('room') || lower.contains('annex') || lower.contains('stay')) {
      return 'We have 6 verified annexes and exam pods near WTC, Malabe IT corridor, and Bambalapitiya. You can inspect scout photos in the Stay tab.';
    } else if (lower.contains('budget') || lower.contains('salary')) {
      return 'Try our Smart Budget Advisor in the Budget tab to see how taking the Highway Bus from Kurunegala saves ~Rs. 22,200/mo vs Colombo boarding!';
    } else {
      return 'Ayubowan! I am synced with our Meta WhatsApp Business webhook. Feel free to ask about bus schedules, lunch pools, annex scout photos, or courier bin backhauls.';
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});
