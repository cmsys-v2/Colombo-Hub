class AppConstants {
  static const String appName = 'ColomboHub';
  static const String appTagline = 'Super-App for Corporate & Daily Commuters';

  // Workplace locations in Western Province
  static const List<String> workplaces = [
    'World Trade Center (Fort)',
    'Bambalapitiya / Kollupitiya',
    'Sethsiripaya (Battaramulla)',
    'Orion City (Dematagoda)',
    'Malabe IT Corridor (SLIIT/MillenniumIT)',
  ];

  // Stay duration types
  static const List<String> stayDurations = [
    'Monthly Boarding / Annex',
    'Morning 2-Hr Fresh-Up Pod (Rs. 850)',
    'Daily / Short Exam Stay',
    'Student Shared Room',
  ];

  // Scout verification max distance
  static const double maxScoutGpsDistanceMeters = 45.0;

  // Scout point rewards
  static const int pointsPhoneVerification = 50;
  static const int pointsGpsScoutPhoto = 50;
  static const int pointsPaymentEscrow = 10;
  static const int pointsGasStockReport = 15;
  static const int pointsFeedbackSubmission = 25;

  // Platform fee (5%)
  static const double platformFeePercentage = 0.05;

  // WhatsApp Contact
  static const String supportWhatsAppNumber = '94778924510';
}
