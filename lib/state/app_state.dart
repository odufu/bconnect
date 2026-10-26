import 'package:flutter/material.dart';
import '../models/deal_model.dart';
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../models/review_model.dart';

class AppState extends ChangeNotifier {
  // Current active profile
  late UserModel currentUser;
  String currentRole = 'buyer'; // 'buyer' or 'seller'

  List<DealModel> deals = [];
  Map<String, List<ChatMessage>> chatThreads = {};
  List<ReviewModel> reviews = [];

  // Notifications
  List<Map<String, dynamic>> notifications = [
    {
      'id': 'notif-1',
      'title': 'Waybill Dispatched',
      'body': 'Tunde Gadgets has dispatched your iPhone 14 Pro Max via GIG Logistics.',
      'dealId': 'BC-8921',
      'time': '10 mins ago',
      'isRead': false,
    },
    {
      'id': 'notif-2',
      'title': 'Payment Locked in Escrow',
      'body': '₦145,000 for Bone Straight Wig is safely held in trust account.',
      'dealId': 'BC-8922',
      'time': '1 hour ago',
      'isRead': false,
    },
    {
      'id': 'notif-3',
      'title': 'Delivery Confirmed',
      'body': 'Lutian Generator has arrived. 2-hour inspection countdown started.',
      'dealId': 'BC-8923',
      'time': '3 hours ago',
      'isRead': true,
    },
  ];

  AppState() {
    _initInitialData();
  }

  void _initInitialData() {
    currentUser = UserModel(
      id: 'USR-001',
      name: 'Tunde Adebayo',
      phone: '+234 803 456 7890',
      email: 'tunde.gadgets@bconnect.ng',
      role: 'seller',
      isVerified: true,
      verificationTier: 2,
      dealsCompleted: 248,
      positivePercent: 90.0,
      negativePercent: 10.0,
      averageRating: 4.8,
      badges: ['Verified ✓', 'Top Seller', 'Fast Shipper'],
      referralCode: 'BCONNECT-TUNDE24',
      referralEarnings: 14500.0,
      lockedEscrowBalance: 325000.0,
      availableBalance: 185000.0,
    );

    deals = [
      DealModel(
        id: 'BC-8921',
        title: 'iPhone 14 Pro Max 256GB Deep Purple',
        category: 'Phones & Gadgets',
        price: 750000.0,
        buyerFee: 500.0,
        sellerFee: 500.0,
        quantity: 1,
        deliveryTimeline: '24hrs',
        terms: 'Factory unlocked, pristine battery health 92%. Original box included.',
        instructions: 'Ship with express door-to-door courier to Ikeja, Lagos.',
        creatorRole: 'seller',
        sellerName: 'Tunde Gadgets',
        sellerPhone: '+234 803 456 7890',
        buyerName: 'Chidi Nnamdi',
        buyerPhone: '+234 812 987 6543',
        status: DealStatus.inTransit,
        waybillCourier: 'GIG Logistics',
        waybillNumber: 'GIGM-LOS-998124',
        waybillReceiptNote: 'Package dispatched at Ikeja Hub, driver Eniola (08023456789)',
        deliveryCode: '7412',
        dealLink: 'https://bconnect.ng/deal/BC-8921',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        autoReleaseTime: DateTime.now().add(const Duration(hours: 1, minutes: 42)),
      ),
      DealModel(
        id: 'BC-8922',
        title: 'Bone Straight Double Drawn Wig 26-inch',
        category: 'Fashion & Wigs',
        price: 145000.0,
        buyerFee: 500.0,
        sellerFee: 500.0,
        quantity: 1,
        deliveryTimeline: '48hrs',
        terms: '100% human virgin hair, tangle-free, HD Swiss lace front.',
        instructions: 'Deliver to Wuse 2, Abuja. Send tracking as soon as dispatched.',
        creatorRole: 'buyer',
        sellerName: 'Glory Hairs Ltd',
        sellerPhone: '+234 809 111 2233',
        buyerName: 'Amina Bello',
        buyerPhone: '+234 802 334 4556',
        status: DealStatus.buyerPaid,
        dealLink: 'https://bconnect.ng/deal/BC-8922',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DealModel(
        id: 'BC-8923',
        title: 'Lutian 3.8kVA Eco Key-Starter Generator',
        category: 'Generators & Power',
        price: 230000.0,
        buyerFee: 500.0,
        sellerFee: 500.0,
        quantity: 1,
        deliveryTimeline: '24hrs',
        terms: '100% copper coil, brand new in carton with battery and wheel kit.',
        instructions: 'Deliver to residential address in Lekki Phase 1.',
        creatorRole: 'seller',
        sellerName: 'Tunde Gadgets',
        sellerPhone: '+234 803 456 7890',
        buyerName: 'David Adeleke',
        buyerPhone: '+234 810 555 6677',
        status: DealStatus.delivered,
        waybillCourier: 'Peace Mass Transit Cargo',
        waybillNumber: 'PMT-BENIN-4401',
        deliveryCode: '9184',
        dealLink: 'https://bconnect.ng/deal/BC-8923',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        autoReleaseTime: DateTime.now().add(const Duration(hours: 1, minutes: 15)),
      ),
      DealModel(
        id: 'BC-8924',
        title: 'MacBook Air M2 16GB RAM / 512GB SSD',
        category: 'Laptops & Tech',
        price: 980000.0,
        buyerFee: 500.0,
        sellerFee: 500.0,
        quantity: 1,
        deliveryTimeline: '3 days',
        terms: 'Midnight blue, cycle count under 25, includes 67W charger.',
        instructions: 'Inspect ports and display thoroughly before release.',
        creatorRole: 'seller',
        sellerName: 'TechHub Marina',
        sellerPhone: '+234 805 777 8899',
        buyerName: 'Tunde Adebayo',
        buyerPhone: '+234 803 456 7890',
        status: DealStatus.disputed,
        waybillCourier: 'DHL Nigeria',
        waybillNumber: 'DHL-NIG-77332',
        deliveryCode: '3109',
        dealLink: 'https://bconnect.ng/deal/BC-8924',
        disputeReason: 'Fake / Substandard item: What I ordered vs What I got',
        disputeDetails: 'Item received has noticeable screen bleeding and MagSafe cable is frayed.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      DealModel(
        id: 'BC-8925',
        title: 'Toyota Camry 2012 Headlight Assembly (Pair)',
        category: 'Vehicles & Auto',
        price: 65000.0,
        buyerFee: 500.0,
        sellerFee: 500.0,
        quantity: 2,
        deliveryTimeline: '24hrs',
        terms: 'Direct replacement OEM spec with projector lens.',
        instructions: 'Deliver to Ladipo market auto mechanics zone.',
        creatorRole: 'buyer',
        sellerName: 'AutoParts Express',
        sellerPhone: '+234 803 999 1122',
        buyerName: 'Emeka Obi',
        buyerPhone: '+234 807 444 3322',
        status: DealStatus.completed,
        waybillCourier: 'Kwik Delivery',
        waybillNumber: 'KWIK-LAG-33219',
        deliveryCode: '6651',
        isDeliveryCodeVerified: true,
        dealLink: 'https://bconnect.ng/deal/BC-8925',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      DealModel(
        id: 'BC-8926',
        title: 'WANTED: PS5 Digital Console with Extra Pad',
        category: 'Gaming & Gadgets',
        price: 480000.0,
        buyerFee: 500.0,
        sellerFee: 500.0,
        quantity: 1,
        deliveryTimeline: '24hrs',
        terms: 'Clean sealed or grade A UK used. Need instant delivery within Lagos.',
        instructions: 'Sellers with verified storefront only.',
        creatorRole: 'buyer',
        sellerName: 'Open to Verified Sellers',
        sellerPhone: '',
        buyerName: 'Kayode Williams',
        buyerPhone: '+234 802 888 9900',
        status: DealStatus.paymentPending,
        dealLink: 'https://bconnect.ng/deal/BC-8926',
        isBuyerAdvert: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      DealModel(
        id: 'BC-8927',
        title: 'WANTED: Starlink Standard Kit Actuated',
        category: 'Laptops & Tech',
        price: 520000.0,
        buyerFee: 500.0,
        sellerFee: 500.0,
        quantity: 1,
        deliveryTimeline: '48hrs',
        terms: 'Must be transferable account ready with complete mounting accessories.',
        instructions: 'Deliver to Port Harcourt GRA.',
        creatorRole: 'buyer',
        sellerName: 'Open to Verified Sellers',
        sellerPhone: '',
        buyerName: 'Tamuno Briggs',
        buyerPhone: '+234 803 765 4321',
        status: DealStatus.paymentPending,
        dealLink: 'https://bconnect.ng/deal/BC-8927',
        isBuyerAdvert: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];

    chatThreads['BC-8921'] = [
      ChatMessage(
        id: 'msg-1',
        dealId: 'BC-8921',
        senderId: 'USR-002',
        senderName: 'Chidi Nnamdi (Buyer)',
        text: 'Hello Tunde, I have inspected the specs. I am depositing the ₦750,000 into BConnect Escrow right away.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 40)),
        isFromMe: false,
      ),
      ChatMessage(
        id: 'msg-2',
        dealId: 'BC-8921',
        senderId: 'SYSTEM',
        senderName: 'BConnect Escrow Bot',
        text: 'PAYMENT LOCKED: ₦750,000 has been received and locked in the BConnect Trust Account. Seller may now proceed with waybill dispatch.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
        isFromMe: false,
        isSystemNotice: true,
      ),
      ChatMessage(
        id: 'msg-3',
        dealId: 'BC-8921',
        senderId: 'USR-001',
        senderName: 'Tunde Gadgets (Seller)',
        text: 'Confirmed! I have packaged the iPhone 14 Pro Max in bubble wrap with all original accessories. Handing over to GIG Logistics now.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 45)),
        isFromMe: true,
      ),
      ChatMessage(
        id: 'msg-4',
        dealId: 'BC-8921',
        senderId: 'USR-001',
        senderName: 'Tunde Gadgets (Seller)',
        text: 'Here is the waybill receipt photo. Tracking number is GIGM-LOS-998124.',
        timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 10)),
        isFromMe: true,
        attachmentUrl: 'waybill_receipt.png',
        isAttachmentPhoto: true,
      ),
      ChatMessage(
        id: 'msg-5',
        dealId: 'BC-8921',
        senderId: 'USR-002',
        senderName: 'Chidi Nnamdi (Buyer)',
        text: 'Received tracking! Waiting for rider to arrive.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
        isFromMe: false,
      ),
    ];

    reviews = [
      ReviewModel(
        id: 'rev-1',
        reviewerName: 'Emeka Nwosu',
        rating: 5,
        comment: 'Fast dispatch! Bought a Samsung S23 Ultra, condition was 100% as advertised. BConnect escrow gave me full peace of mind.',
        isPositive: true,
        productPurchased: 'Samsung Galaxy S23 Ultra',
        date: DateTime.now().subtract(const Duration(days: 3)),
        dealId: 'BC-8910',
      ),
      ReviewModel(
        id: 'rev-2',
        reviewerName: 'Fatima Aliyu',
        rating: 5,
        comment: 'Tunde Gadgets is reliable. Arrived in Abuja within 24hrs via peace mass waybill. Tested battery and released funds immediately.',
        isPositive: true,
        productPurchased: 'iPad Pro 11-inch M1',
        date: DateTime.now().subtract(const Duration(days: 7)),
        dealId: 'BC-8890',
      ),
      ReviewModel(
        id: 'rev-3',
        reviewerName: 'Babatunde Balogun',
        rating: 5,
        comment: 'Legit seller. The delivery code system is great because the courier could only release when I verified the package.',
        isPositive: true,
        productPurchased: 'AirPods Pro 2nd Gen',
        date: DateTime.now().subtract(const Duration(days: 12)),
        dealId: 'BC-8845',
      ),
      ReviewModel(
        id: 'rev-4',
        reviewerName: 'Anonymous Buyer',
        rating: 2,
        comment: 'Packaging box was slightly dented by courier service during transit. Product worked fine but packaging needs improvement.',
        isPositive: false,
        productPurchased: 'JBL Boombox 3',
        date: DateTime.now().subtract(const Duration(days: 20)),
        dealId: 'BC-8799',
      ),
    ];
  }

  // Toggle user test role
  void toggleRole() {
    currentRole = (currentRole == 'buyer') ? 'seller' : 'buyer';
    notifyListeners();
  }

  void setRole(String role) {
    currentRole = role;
    notifyListeners();
  }

  // Escrow Calculations
  double calculateBuyerFee(double amount) => 500.0;
  double calculateSellerFee(double amount) => 500.0;

  // Actions
  DealModel createDeal({
    required String title,
    required String category,
    required double price,
    required int quantity,
    required String deliveryTimeline,
    required String terms,
    required String instructions,
    required String counterpartyPhone,
    required bool isBuyerRole,
    required bool isWantedAdvert,
  }) {
    final newId = 'BC-${8900 + deals.length + 1}';
    final newDeal = DealModel(
      id: newId,
      title: title,
      category: category,
      price: price,
      buyerFee: 500.0,
      sellerFee: 500.0,
      quantity: quantity,
      deliveryTimeline: deliveryTimeline,
      terms: terms,
      instructions: instructions,
      creatorRole: isBuyerRole ? 'buyer' : 'seller',
      sellerName: isBuyerRole ? 'Awaiting Seller' : currentUser.name,
      sellerPhone: isBuyerRole ? counterpartyPhone : currentUser.phone,
      buyerName: isBuyerRole ? currentUser.name : 'Awaiting Buyer',
      buyerPhone: isBuyerRole ? currentUser.phone : counterpartyPhone,
      status: DealStatus.paymentPending,
      dealLink: 'https://bconnect.ng/deal/$newId',
      isBuyerAdvert: isWantedAdvert,
      createdAt: DateTime.now(),
    );

    deals.insert(0, newDeal);

    // Initial system thread
    chatThreads[newId] = [
      ChatMessage(
        id: 'msg-init-$newId',
        dealId: newId,
        senderId: 'SYSTEM',
        senderName: 'BConnect Escrow Guard',
        text: 'ESCROW INITIATED: Deal $newId created. Funds will remain locked until buyer confirms delivery inspection. All messages are encrypted and permanent.',
        timestamp: DateTime.now(),
        isFromMe: false,
        isSystemNotice: true,
      ),
    ];

    notifyListeners();
    return newDeal;
  }

  void markAsPaid(String dealId) {
    final index = deals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      deals[index].status = DealStatus.buyerPaid;

      // Lock out link so duplicate purchases cannot occur
      deals[index].isLockedOut = true;

      _addChatMessage(
        dealId: dealId,
        senderId: 'SYSTEM',
        senderName: 'BConnect Escrow System',
        text: 'FUNDS LOCKED IN ESCROW: ₦${deals[index].price.toStringAsFixed(0)} is secured in trust account. Seller, please dispatch item and upload waybill receipt.',
        isFromMe: false,
        isSystemNotice: true,
      );

      notifications.insert(0, {
        'id': 'notif-${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Payment Secured',
        'body': 'Funds for ${deals[index].title} are now safely held in Escrow.',
        'dealId': dealId,
        'time': 'Just now',
        'isRead': false,
      });

      notifyListeners();
    }
  }

  void sendWaybill({
    required String dealId,
    required String courier,
    required String waybillNumber,
    required String receiptNote,
  }) {
    final index = deals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      deals[index].status = DealStatus.inTransit;
      deals[index].waybillCourier = courier;
      deals[index].waybillNumber = waybillNumber;
      deals[index].waybillReceiptNote = receiptNote;
      deals[index].autoReleaseTime = DateTime.now().add(const Duration(hours: 2));

      _addChatMessage(
        dealId: dealId,
        senderId: currentUser.id,
        senderName: currentUser.name,
        text: 'WAYBILL DISPATCHED: Courier: $courier | Tracking: $waybillNumber. Note: $receiptNote',
        isFromMe: true,
        attachmentUrl: 'receipt_preview.png',
        isAttachmentPhoto: true,
      );

      _addChatMessage(
        dealId: dealId,
        senderId: 'SYSTEM',
        senderName: 'BConnect Escrow Bot',
        text: 'SHIPMENT IN TRANSIT: 2-Hour inspection countdown will begin immediately upon delivery handover.',
        isFromMe: false,
        isSystemNotice: true,
      );

      notifications.insert(0, {
        'id': 'notif-${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Waybill Dispatched',
        'body': '$courier tracking: $waybillNumber has been submitted.',
        'dealId': dealId,
        'time': 'Just now',
        'isRead': false,
      });

      notifyListeners();
    }
  }

  void markAsDelivered(String dealId, {String? codeEntered}) {
    final index = deals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      deals[index].status = DealStatus.delivered;
      deals[index].isDeliveryCodeVerified = true;
      deals[index].autoReleaseTime = DateTime.now().add(const Duration(hours: 2));

      _addChatMessage(
        dealId: dealId,
        senderId: 'SYSTEM',
        senderName: 'BConnect Escrow Bot',
        text: 'ITEM DELIVERED: Buyer inspection window has commenced. Funds will auto-release in 2 hours if no dispute is raised.',
        isFromMe: false,
        isSystemNotice: true,
      );

      notifyListeners();
    }
  }

  void releaseFunds(String dealId) {
    final index = deals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      deals[index].status = DealStatus.completed;

      _addChatMessage(
        dealId: dealId,
        senderId: 'SYSTEM',
        senderName: 'BConnect Escrow Bot',
        text: 'DEAL COMPLETED: Buyer has verified and approved release! ₦${deals[index].netSellerAmount.toStringAsFixed(0)} transferred to Seller\'s bank wallet.',
        isFromMe: false,
        isSystemNotice: true,
      );

      notifications.insert(0, {
        'id': 'notif-${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Deal Completed',
        'body': 'Funds released successfully for ${deals[index].title}.',
        'dealId': dealId,
        'time': 'Just now',
        'isRead': false,
      });

      notifyListeners();
    }
  }

  void raiseDispute({
    required String dealId,
    required String reason,
    required String details,
    List<String> evidenceImages = const [],
  }) {
    final index = deals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      deals[index].status = DealStatus.disputed;
      deals[index].disputeReason = reason;
      deals[index].disputeDetails = details;
      deals[index].proofImages = evidenceImages;

      _addChatMessage(
        dealId: dealId,
        senderId: 'SYSTEM',
        senderName: 'BConnect Dispute Arbitration',
        text: 'DISPUTE RAISED: Reason: "$reason". Description: "$details". Funds are frozen 100% in trust escrow. Admin mediator has been assigned.',
        isFromMe: false,
        isSystemNotice: true,
        isDisputeAlert: true,
      );

      notifications.insert(0, {
        'id': 'notif-${DateTime.now().millisecondsSinceEpoch}',
        'title': 'Dispute Opened',
        'body': 'Arbitration started for deal #$dealId. Admin is reviewing evidence.',
        'dealId': dealId,
        'time': 'Just now',
        'isRead': false,
      });

      notifyListeners();
    }
  }

  void sendUserChatMessage({
    required String dealId,
    required String text,
    String? attachmentUrl,
    bool isAttachmentPhoto = false,
  }) {
    _addChatMessage(
      dealId: dealId,
      senderId: currentUser.id,
      senderName: currentRole == 'seller' ? currentUser.name : 'Buyer',
      text: text,
      isFromMe: true,
      attachmentUrl: attachmentUrl,
      isAttachmentPhoto: isAttachmentPhoto,
    );
    notifyListeners();
  }

  void _addChatMessage({
    required String dealId,
    required String senderId,
    required String senderName,
    required String text,
    required bool isFromMe,
    String? attachmentUrl,
    bool isAttachmentPhoto = false,
    bool isSystemNotice = false,
    bool isDisputeAlert = false,
  }) {
    chatThreads.putIfAbsent(dealId, () => []);
    chatThreads[dealId]!.add(
      ChatMessage(
        id: 'msg-${DateTime.now().microsecondsSinceEpoch}',
        dealId: dealId,
        senderId: senderId,
        senderName: senderName,
        text: text,
        timestamp: DateTime.now(),
        isFromMe: isFromMe,
        attachmentUrl: attachmentUrl,
        isAttachmentPhoto: isAttachmentPhoto,
        isSystemNotice: isSystemNotice,
        isDisputeAlert: isDisputeAlert,
      ),
    );
  }

  void addReview({
    required String dealId,
    required String productName,
    required int rating,
    required String comment,
    required bool isPositive,
  }) {
    reviews.insert(
      0,
      ReviewModel(
        id: 'rev-${DateTime.now().millisecondsSinceEpoch}',
        reviewerName: currentUser.name,
        rating: rating,
        comment: comment,
        isPositive: isPositive,
        productPurchased: productName,
        date: DateTime.now(),
        dealId: dealId,
      ),
    );
    notifyListeners();
  }

  double get totalEscrowLocked => deals
      .where((d) => d.status == DealStatus.buyerPaid || d.status == DealStatus.waybillSent || d.status == DealStatus.inTransit || d.status == DealStatus.delivered || d.status == DealStatus.disputed)
      .fold(0.0, (sum, d) => sum + d.price);

  int get activeDealsCount => deals
      .where((d) => d.status != DealStatus.completed && d.status != DealStatus.cancelled)
      .length;
}
