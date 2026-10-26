enum DealStatus {
  paymentPending, // Buyer needs to deposit funds
  buyerPaid,       // Funds HELD in escrow trust account
  waybillSent,     // Seller uploaded waybill & dispatched
  inTransit,       // Item in transit, inspection countdown running
  delivered,       // Product received, awaiting code / 2hr auto-release
  completed,       // Funds released to seller wallet
  disputed,        // Disputed, admin arbitration active
  cancelled,
}

class DealModel {
  final String id;
  final String title;
  final String category;
  final double price;
  final double buyerFee;
  final double sellerFee;
  int quantity;
  final String deliveryTimeline;
  final String terms;
  final String instructions;
  final String creatorRole; // 'buyer' or 'seller'
  final String sellerName;
  final String sellerPhone;
  final String buyerName;
  final String buyerPhone;
  DealStatus status;
  String? waybillNumber;
  String? waybillCourier;
  String? waybillReceiptNote;
  String deliveryCode;
  bool isDeliveryCodeVerified;
  final String dealLink;
  bool isLockedOut;
  final bool isBuyerAdvert; // 'Wanted' request on marketplace
  final DateTime createdAt;
  DateTime? autoReleaseTime;
  String? disputeReason;
  String? disputeDetails;
  List<String> proofImages;

  DealModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    this.buyerFee = 500.0,
    this.sellerFee = 500.0,
    this.quantity = 1,
    required this.deliveryTimeline,
    required this.terms,
    this.instructions = '',
    required this.creatorRole,
    required this.sellerName,
    required this.sellerPhone,
    required this.buyerName,
    required this.buyerPhone,
    required this.status,
    this.waybillNumber,
    this.waybillCourier,
    this.waybillReceiptNote,
    this.deliveryCode = '8492',
    this.isDeliveryCodeVerified = false,
    required this.dealLink,
    this.isLockedOut = false,
    this.isBuyerAdvert = false,
    required this.createdAt,
    this.autoReleaseTime,
    this.disputeReason,
    this.disputeDetails,
    this.proofImages = const [],
  });

  double get totalBuyerAmount => price + buyerFee;
  double get netSellerAmount => price - sellerFee;

  String get statusDisplay {
    switch (status) {
      case DealStatus.paymentPending:
        return 'Payment Pending';
      case DealStatus.buyerPaid:
        return 'Funds Held in Escrow';
      case DealStatus.waybillSent:
        return 'Waybill Dispatched';
      case DealStatus.inTransit:
        return 'In Transit';
      case DealStatus.delivered:
        return 'Delivered (Inspection)';
      case DealStatus.completed:
        return 'Completed & Released';
      case DealStatus.disputed:
        return 'Disputed';
      case DealStatus.cancelled:
        return 'Cancelled';
    }
  }

  int get currentStepIndex {
    switch (status) {
      case DealStatus.paymentPending:
        return 0;
      case DealStatus.buyerPaid:
        return 1;
      case DealStatus.waybillSent:
        return 2;
      case DealStatus.inTransit:
        return 2;
      case DealStatus.delivered:
        return 3;
      case DealStatus.completed:
        return 4;
      case DealStatus.disputed:
        return 2;
      case DealStatus.cancelled:
        return 0;
    }
  }
}
