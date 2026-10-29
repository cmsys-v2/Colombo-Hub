class LunchItem {
  final String id;
  final String catererName;
  final String title;
  final String description;
  final double price;
  final double courierFee;
  final bool isEcoTiffin;
  final String vendorId;

  const LunchItem({
    required this.id,
    required this.catererName,
    required this.title,
    required this.description,
    required this.price,
    required this.courierFee,
    this.isEcoTiffin = false,
    required this.vendorId,
  });

  double get totalPrice => price + courierFee;
}

class CourierOption {
  final String id;
  final String tierTag;
  final String title;
  final String description;
  final double price;
  final String priceLabel;
  final String vendorId;

  const CourierOption({
    required this.id,
    required this.tierTag,
    required this.title,
    required this.description,
    required this.price,
    required this.priceLabel,
    required this.vendorId,
  });
}

class HouseholdService {
  final String id;
  final String title;
  final String description;
  final double price;
  final String priceUnit;
  final String iconCode;
  final String vendorId;
  final bool isColSpan2;

  const HouseholdService({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.priceUnit,
    required this.iconCode,
    required this.vendorId,
    this.isColSpan2 = false,
  });
}

class ChatMessage {
  final String id;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isAssistant;

  const ChatMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isAssistant,
  });
}

class ActiveDispatch {
  final String id;
  final String title;
  final String locationTag;
  final String description;
  final double payoutAmount;

  const ActiveDispatch({
    required this.id,
    required this.title,
    required this.locationTag,
    required this.description,
    required this.payoutAmount,
  });
}
