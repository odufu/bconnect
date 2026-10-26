import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/deal_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/escrow_timeline_stepper.dart';
import '../../widgets/locked_amount_card.dart';
import '../../widgets/refund_policy_card.dart';
import '../chat/chat_conversation_screen.dart';
import '../chat/dispute_modal.dart';
import '../rating/rate_seller_screen.dart';

class DealDetailsScreen extends StatefulWidget {
  final String dealId;
  final AppState appState;

  const DealDetailsScreen({
    super.key,
    required this.dealId,
    required this.appState,
  });

  @override
  State<DealDetailsScreen> createState() => _DealDetailsScreenState();
}

class _DealDetailsScreenState extends State<DealDetailsScreen> {
  // Modal for Seller Sending Waybill
  void _openSendWaybillSheet(DealModel deal) {
    final courierController = TextEditingController(text: 'GIG Logistics');
    final waybillController = TextEditingController(text: 'GIGM-LOS-${DateTime.now().millisecond}99');
    final noteController = TextEditingController(text: 'Handed to driver. Sealed in brown carton.');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Waybill & Dispatch Notice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Upload your parcel receipt so the buyer and BConnect can track transit.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            const Text('Courier Service / Driver Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(
              controller: courierController,
              decoration: const InputDecoration(
                hintText: 'e.g. GIG Logistics, Peace Mass, ABC Transport, Kwik Rider',
              ),
            ),
            const SizedBox(height: 12),
            const Text('Waybill / Tracking / Phone Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(
              controller: waybillController,
              decoration: const InputDecoration(
                hintText: 'e.g. GIGM-991204 or driver phone',
              ),
            ),
            const SizedBox(height: 12),
            const Text('Waybill Dispatch Receipt / Note', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Receipt notes or departure park details...',
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Waybill receipt photo simulated as attached.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.appState.sendWaybill(
                    dealId: deal.id,
                    courier: courierController.text.trim(),
                    waybillNumber: waybillController.text.trim(),
                    receiptNote: noteController.text.trim(),
                  );
                  Navigator.pop(ctx);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Waybill dispatched! Buyer notified.'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('CONFIRM WAYBILL DISPATCH'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Buyer Payment Simulation Sheet
  void _openBuyerPaymentSheet(DealModel deal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Deposit into Escrow Trust Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your funds are protected. The seller will not receive this money until you inspect the item and enter the release code.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            // Dedicated Virtual Bank Account Details (Simulating Paystack/Wema partners)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withAlpha(80)),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dedicated Escrow Account', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('BConnect / Wema Bank', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Account Number:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      Text('0293847162', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount to Transfer:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_rounded, size: 14, color: AppColors.primaryDark),
                            const SizedBox(width: 4),
                            Text(
                              '₦${deal.totalBuyerAmount.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const RefundPolicyCard(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    widget.appState.markAsPaid(deal.id);
                    Navigator.pop(ctx);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Payment verified! Funds locked in Escrow.'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                icon: const Icon(Icons.lock_rounded, size: 18),
                label: const Text('I HAVE PAID (LOCK FUNDS IN ESCROW)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delivery Code Verification & Fund Release Sheet
  void _openReleaseFundsSheet(DealModel deal) {
    final codeController = TextEditingController(text: deal.deliveryCode);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Confirm Inspection & Release Funds',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Only release funds after you have physically inspected the product and confirmed it matches what you ordered.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 16),
            const Text(
              '4-Digit Handover Delivery Code',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: codeController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 4,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 10),
              decoration: const InputDecoration(
                hintText: '8492',
                counterText: '',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.appState.releaseFunds(deal.id);
                  Navigator.pop(ctx);
                  setState(() {});

                  // Open Rating screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => RateSellerScreen(
                        deal: deal,
                        appState: widget.appState,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                label: const Text('I HAVE RECEIVED PRODUCT & RELEASE FUNDS'),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _openDisputeModal(deal);
                },
                icon: const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.disputeRed),
                label: const Text(
                  'Item Defective / Not What I Ordered (Dispute)',
                  style: TextStyle(color: AppColors.disputeRed, fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDisputeModal(DealModel deal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DisputeModal(
        deal: deal,
        appState: widget.appState,
        onDisputeSubmitted: () {
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.appState.deals.firstWhere(
      (d) => d.id == widget.dealId,
      orElse: () => widget.appState.deals.first,
    );

    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);
    final isBuyerPerspective = widget.appState.currentRole == 'buyer';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Deal #${deal.id}'),
        actions: [
          // Toggle perspective button for instant prototype demonstration
          TextButton.icon(
            onPressed: () {
              widget.appState.toggleRole();
              setState(() {});
            },
            icon: const Icon(Icons.swap_horiz_rounded, size: 16),
            label: Text(
              isBuyerPerspective ? 'Buyer View' : 'Seller View',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => ChatConversationScreen(dealId: deal.id, appState: widget.appState),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Card: ₦50,000 LOCKED (Rule: Every money must show as LOCKED with padlock icon)
            LockedAmountCard(
              amount: deal.price,
              label: 'ESCROW HELD FUNDS',
              subtitle: deal.status == DealStatus.completed
                  ? 'Funds released to seller after buyer inspection approval.'
                  : (deal.status == DealStatus.disputed
                      ? 'Funds frozen in trust account under arbitration.'
                      : 'Funds locked in BConnect Trust Account. Safe from fraud.'),
              showFeeBreakdown: true,
              buyerFee: deal.buyerFee,
              sellerFee: deal.sellerFee,
              isLarge: true,
            ),

            const SizedBox(height: 16),

            // 4-Step Interactive Timeline Progress Bar
            EscrowTimelineStepper(deal: deal),

            const SizedBox(height: 16),

            // Auto-Release Notice Card (from specification section 8)
            if (deal.status == DealStatus.inTransit || deal.status == DealStatus.delivered) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.escrowAmberLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Color(0xFFB45309), size: 22),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '2-Hour Auto-Release Guarantee',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'If buyer does not raise dispute in 2hrs after delivery arrival, money automatically transfers to seller.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF78350F),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Dispute Banner if deal is disputed
            if (deal.status == DealStatus.disputed) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.disputeRedLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.disputeRed.withAlpha(80)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.gavel_rounded, color: AppColors.disputeRed, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Dispute Active: ${deal.disputeReason ?? 'Under Arbitration'}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.disputeRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      deal.disputeDetails ?? 'Admin mediator is inspecting chat and media proofs.',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF7F1D1D)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.disputeRed,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => ChatConversationScreen(
                              dealId: deal.id,
                              appState: widget.appState,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_rounded, size: 14),
                      label: const Text('View Arbitration Chat & Evidence', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Deal Details Specification Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Specifications',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    deal.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow('Category', deal.category),
                  _buildDetailRow('Agreed Amount', currencyFormatter.format(deal.price)),
                  _buildDetailRow('Quantity', '${deal.quantity} unit(s)'),
                  _buildDetailRow('Delivery Timeline', deal.deliveryTimeline),
                  _buildDetailRow('Seller', deal.sellerName),
                  _buildDetailRow('Buyer', deal.buyerName),
                  if (deal.waybillCourier != null)
                    _buildDetailRow('Courier Partner', deal.waybillCourier!),
                  if (deal.waybillNumber != null)
                    _buildDetailRow('Waybill Tracking', deal.waybillNumber!),
                  const Divider(height: 20),
                  const Text('Agreed Terms:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(deal.terms, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                  const SizedBox(height: 10),
                  const Text('Instructions:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(deal.instructions, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Delivery Code Handover Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Handover Code',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deal.deliveryCode,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: deal.isDeliveryCodeVerified ? AppColors.primaryLight : AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          deal.isDeliveryCodeVerified ? Icons.check_circle : Icons.lock_clock,
                          size: 14,
                          color: deal.isDeliveryCodeVerified ? AppColors.primary : AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          deal.isDeliveryCodeVerified ? 'Code Verified' : 'Give upon Inspection',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: deal.isDeliveryCodeVerified ? AppColors.primaryDark : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Refund Policy Card
            const RefundPolicyCard(),

            const SizedBox(height: 24),

            // Action Buttons based on User Role & Deal State (from specification section 8)
            // Buyer Sees: I HAVE PAID (auto-detect payment), I HAVE RECEIVED PRODUCT
            // Seller Sees: I HAVE SENT WAYBILL
            if (isBuyerPerspective) ...[
              if (deal.status == DealStatus.paymentPending)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openBuyerPaymentSheet(deal),
                    icon: const Icon(Icons.payment_rounded, size: 18),
                    label: const Text('I HAVE PAID (LOCK FUNDS IN ESCROW)'),
                  ),
                ),
              if (deal.status == DealStatus.inTransit || deal.status == DealStatus.delivered)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openReleaseFundsSheet(deal),
                    icon: const Icon(Icons.verified_rounded, size: 18),
                    label: const Text('I HAVE RECEIVED PRODUCT & RELEASE FUNDS'),
                  ),
                ),
            ] else ...[
              // Seller Perspective
              if (deal.status == DealStatus.paymentPending)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Waiting for buyer to lock funds in Escrow before shipping.',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                  ),
                ),
              if (deal.status == DealStatus.buyerPaid)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openSendWaybillSheet(deal),
                    icon: const Icon(Icons.local_shipping_rounded, size: 18),
                    label: const Text('I HAVE SENT WAYBILL (UPLOAD RECEIPT)'),
                  ),
                ),
              if (deal.status == DealStatus.inTransit || deal.status == DealStatus.delivered)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'Waybill in transit. Funds auto-release 2 hours after delivery if no dispute is raised.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                    ),
                  ),
                ),
            ],

            const SizedBox(height: 12),

            // Dispute & Chat Bottom Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => ChatConversationScreen(dealId: deal.id, appState: widget.appState),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('Open Escrow Chat'),
                  ),
                ),
                const SizedBox(width: 12),
                if (deal.status != DealStatus.completed && deal.status != DealStatus.disputed)
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.disputeRed,
                        side: const BorderSide(color: AppColors.disputeRed, width: 1.5),
                      ),
                      onPressed: () => _openDisputeModal(deal),
                      icon: const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.disputeRed),
                      label: const Text('Raise Dispute'),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
