import 'package:flutter/foundation.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// ColomboHub Remote Configuration Service
/// Wraps [FirebaseRemoteConfig] with local fallbacks for monetization phases,
/// Sri Lankan business constants, fee tiers, and operational feature flags.
class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  FirebaseRemoteConfig? _remoteConfig;

  // Default Fallback Values
  static const Map<String, dynamic> _defaults = {
    'monetization_phase': 'free_beta', // 'free_beta', 'ad_supported', 'subscription'
    'lunch_pool_cutoff_time': '10:30 AM',
    'lunch_pool_delivery_fee': 18.0,
    'partner_commission_rate': 0.10,
    'form_c_verification_required': true,
    'geofence_scout_radius_meters': 45.0,
    'whatsapp_dispatch_webhook_url':
        'https://us-central1-cmsys-hr.cloudfunctions.net/whatsappWebhook',
    'payhere_merchant_id': '1220001',
    'banner_announcement':
        '🇱🇰 ColomboHub: Form-C Stays, Expressway Buses & Pooled Meals',
    'expressway_pass_discount_pct': 0.25,
    'scout_reward_points_per_photo': 50,
  };

  /// Initialize and fetch remote parameters
  Future<void> initialize() async {
    try {
      _remoteConfig = FirebaseRemoteConfig.instance;
      await _remoteConfig!.setDefaults(_defaults);
      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode
              ? const Duration(minutes: 1)
              : const Duration(hours: 1),
        ),
      );
      await _remoteConfig!.fetchAndActivate();
      debugPrint('[RemoteConfig] Successfully initialized and activated.');
    } catch (e) {
      debugPrint('[RemoteConfig] Initialized with local defaults due to: $e');
    }
  }

  // Getters with fallback to defaults
  String get monetizationPhase =>
      _remoteConfig?.getString('monetization_phase') ??
      _defaults['monetization_phase'] as String;

  String get lunchPoolCutoffTime =>
      _remoteConfig?.getString('lunch_pool_cutoff_time') ??
      _defaults['lunch_pool_cutoff_time'] as String;

  double get lunchPoolDeliveryFee =>
      _remoteConfig?.getDouble('lunch_pool_delivery_fee') ??
      _defaults['lunch_pool_delivery_fee'] as double;

  double get partnerCommissionRate =>
      _remoteConfig?.getDouble('partner_commission_rate') ??
      _defaults['partner_commission_rate'] as double;

  bool get isFormCVerificationRequired =>
      _remoteConfig?.getBool('form_c_verification_required') ??
      _defaults['form_c_verification_required'] as bool;

  double get geofenceScoutRadiusMeters =>
      _remoteConfig?.getDouble('geofence_scout_radius_meters') ??
      _defaults['geofence_scout_radius_meters'] as double;

  String get whatsappDispatchWebhookUrl =>
      _remoteConfig?.getString('whatsapp_dispatch_webhook_url') ??
      _defaults['whatsapp_dispatch_webhook_url'] as String;

  String get payHereMerchantId =>
      _remoteConfig?.getString('payhere_merchant_id') ??
      _defaults['payhere_merchant_id'] as String;

  String get bannerAnnouncement =>
      _remoteConfig?.getString('banner_announcement') ??
      _defaults['banner_announcement'] as String;

  double get expresswayPassDiscountPct =>
      _remoteConfig?.getDouble('expressway_pass_discount_pct') ??
      _defaults['expressway_pass_discount_pct'] as double;

  int get scoutRewardPointsPerPhoto =>
      _remoteConfig?.getInt('scout_reward_points_per_photo') ??
      _defaults['scout_reward_points_per_photo'] as int;
}
