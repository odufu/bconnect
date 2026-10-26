import 'package:flutter_test/flutter_test.dart';
import 'package:bconnect/models/deal_model.dart';
import 'package:bconnect/state/app_state.dart';

void main() {
  group('BConnect Escrow Flow Unit & State Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('Initial data loads with realistic Nigerian escrow deals and trust ratings', () {
      expect(appState.deals.isNotEmpty, isTrue);
      expect(appState.currentUser.dealsCompleted, equals(248));
      expect(appState.currentUser.positivePercent, equals(90.0));
      expect(appState.currentUser.negativePercent, equals(10.0));
      expect(appState.currentUser.badges.contains('Verified ✓'), isTrue);
      expect(appState.currentUser.referralCode, equals('BCONNECT-TUNDE24'));
    });

    test('Creating a new deal calculates fees and assigns share link', () {
      final initialCount = appState.deals.length;
      final deal = appState.createDeal(
        title: 'iPhone 15 Pro Max 256GB',
        category: 'Phones & Gadgets',
        price: 850000.0,
        quantity: 1,
        deliveryTimeline: '24hrs',
        terms: 'Original sealed carton, factory unlocked with invoice.',
        instructions: 'Deliver to Ikeja Computer Village.',
        counterpartyPhone: '+234 803 111 2233',
        isBuyerRole: true,
        isWantedAdvert: false,
      );

      expect(appState.deals.length, equals(initialCount + 1));
      expect(deal.price, equals(850000.0));
      expect(deal.buyerFee, equals(500.0));
      expect(deal.sellerFee, equals(500.0));
      expect(deal.totalBuyerAmount, equals(850500.0));
      expect(deal.netSellerAmount, equals(849500.0));
      expect(deal.status, equals(DealStatus.paymentPending));
      expect(deal.dealLink.startsWith('https://bconnect.ng/deal/'), isTrue);
    });

    test('Escrow state transitions: Pay -> Waybill -> Delivered -> Release', () {
      final deal = appState.createDeal(
        title: 'Bone Straight Wig 28"',
        category: 'Fashion & Wigs',
        price: 180000.0,
        quantity: 1,
        deliveryTimeline: '48hrs',
        terms: 'Authentic human virgin hair',
        instructions: 'Ship via GIG Logistics to Abuja',
        counterpartyPhone: '+234 809 999 8888',
        isBuyerRole: false,
        isWantedAdvert: false,
      );

      // 1. Buyer Pays -> Funds Locked in Escrow
      appState.markAsPaid(deal.id);
      expect(deal.status, equals(DealStatus.buyerPaid));
      expect(deal.isLockedOut, isTrue); // link locked out to prevent duplicate purchases

      // 2. Seller Dispatches Waybill
      appState.sendWaybill(
        dealId: deal.id,
        courier: 'GIG Logistics',
        waybillNumber: 'GIGM-ABJ-12345',
        receiptNote: 'Handed over at Yaba Terminal',
      );
      expect(deal.status, equals(DealStatus.inTransit));
      expect(deal.waybillCourier, equals('GIG Logistics'));
      expect(deal.waybillNumber, equals('GIGM-ABJ-12345'));

      // 3. Mark Delivered
      appState.markAsDelivered(deal.id);
      expect(deal.status, equals(DealStatus.delivered));
      expect(deal.isDeliveryCodeVerified, isTrue);

      // 4. Buyer Releases Funds
      appState.releaseFunds(deal.id);
      expect(deal.status, equals(DealStatus.completed));
    });

    test('Dispute flow freezes funds and records evidence', () {
      final deal = appState.deals.first;

      appState.raiseDispute(
        dealId: deal.id,
        reason: 'Fake / Substandard item',
        details: 'Received item did not match description.',
        evidenceImages: ['photo1.jpg', 'unboxing_video.mp4'],
      );

      expect(deal.status, equals(DealStatus.disputed));
      expect(deal.disputeReason, equals('Fake / Substandard item'));
      expect(deal.proofImages.length, equals(2));
      // System message appended to chat
      final chat = appState.chatThreads[deal.id]!;
      expect(chat.any((m) => m.isDisputeAlert), isTrue);
    });

    test('Role toggle switches between buyer and seller perspective', () {
      expect(appState.currentRole, equals('buyer'));
      appState.toggleRole();
      expect(appState.currentRole, equals('seller'));
      appState.toggleRole();
      expect(appState.currentRole, equals('buyer'));
    });

    test('Adding a review updates seller storefront feedback', () {
      final initialReviewCount = appState.reviews.length;
      appState.addReview(
        dealId: 'BC-8921',
        productName: 'iPhone 14 Pro Max',
        rating: 5,
        comment: 'Super fast delivery and pristine condition!',
        isPositive: true,
      );

      expect(appState.reviews.length, equals(initialReviewCount + 1));
      expect(appState.reviews.first.isPositive, isTrue);
      expect(appState.reviews.first.rating, equals(5));
    });
  });
}
