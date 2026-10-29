/// ColomboHub User Model
/// Represents commuter profiles, verified scouts, and partner/vendor credentials.
class UserModel {
  final String uid;
  final String phoneNumber;
  final String carrier;
  final bool isVerified;
  final int scoutPoints;
  final bool isVendor;
  final double partnerWallet;
  final String partnerId;
  final String partnerName;
  final String officeZone;
  final double monthlyBudget;

  const UserModel({
    this.uid = '',
    required this.phoneNumber,
    this.carrier = 'Dialog',
    this.isVerified = false,
    this.scoutPoints = 0,
    this.isVendor = false,
    this.partnerWallet = 0.0,
    this.partnerId = '',
    this.partnerName = '',
    this.officeZone = 'World Trade Center (Fort)',
    this.monthlyBudget = 75000.0,
  });

  UserModel copyWith({
    String? uid,
    String? phoneNumber,
    String? carrier,
    bool? isVerified,
    int? scoutPoints,
    bool? isVendor,
    double? partnerWallet,
    String? partnerId,
    String? partnerName,
    String? officeZone,
    double? monthlyBudget,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      carrier: carrier ?? this.carrier,
      isVerified: isVerified ?? this.isVerified,
      scoutPoints: scoutPoints ?? this.scoutPoints,
      isVendor: isVendor ?? this.isVendor,
      partnerWallet: partnerWallet ?? this.partnerWallet,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
      officeZone: officeZone ?? this.officeZone,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'carrier': carrier,
      'isVerified': isVerified,
      'scoutPoints': scoutPoints,
      'isVendor': isVendor,
      'partnerWallet': partnerWallet,
      'partnerId': partnerId,
      'partnerName': partnerName,
      'officeZone': officeZone,
      'monthlyBudget': monthlyBudget,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      carrier: map['carrier'] as String? ?? 'Dialog',
      isVerified: map['isVerified'] as bool? ?? false,
      scoutPoints: (map['scoutPoints'] as num?)?.toInt() ?? 0,
      isVendor: map['isVendor'] as bool? ?? false,
      partnerWallet: (map['partnerWallet'] as num?)?.toDouble() ?? 0.0,
      partnerId: map['partnerId'] as String? ?? '',
      partnerName: map['partnerName'] as String? ?? '',
      officeZone: map['officeZone'] as String? ?? 'World Trade Center (Fort)',
      monthlyBudget: (map['monthlyBudget'] as num?)?.toDouble() ?? 75000.0,
    );
  }
}

/// Backwards compatibility alias for UserProfile
typedef UserProfile = UserModel;
