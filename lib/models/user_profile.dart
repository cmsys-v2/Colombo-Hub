class UserProfile {
  final String phoneNumber;
  final bool isVerified;
  final int scoutPoints;
  final bool isVendor;
  final double partnerWallet;
  final String partnerId;
  final String partnerName;

  const UserProfile({
    required this.phoneNumber,
    required this.isVerified,
    required this.scoutPoints,
    required this.isVendor,
    required this.partnerWallet,
    required this.partnerId,
    required this.partnerName,
  });

  UserProfile copyWith({
    String? phoneNumber,
    bool? isVerified,
    int? scoutPoints,
    bool? isVendor,
    double? partnerWallet,
    String? partnerId,
    String? partnerName,
  }) {
    return UserProfile(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
      scoutPoints: scoutPoints ?? this.scoutPoints,
      isVendor: isVendor ?? this.isVendor,
      partnerWallet: partnerWallet ?? this.partnerWallet,
      partnerId: partnerId ?? this.partnerId,
      partnerName: partnerName ?? this.partnerName,
    );
  }
}
