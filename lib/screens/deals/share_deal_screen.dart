import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../models/deal_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import 'deal_details_screen.dart';

class ShareDealScreen extends StatelessWidget {
  final DealModel deal;
  final AppState appState;
  final bool isCreatedByMe;

  const ShareDealScreen({
    super.key,
    required this.deal,
    required this.appState,
    this.isCreatedByMe = true,
  });

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: deal.dealLink));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Escrow order link copied to clipboard!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareOnWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening WhatsApp with message:\n"Deal: ${deal.title} - Pay securely with BConnect Escrow: ${deal.dealLink}"'),
        backgroundColor: const Color(0xFF25D366),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Escrow Deal Created'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success icon with animated pulse look
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withAlpha(80), width: 2),
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Escrow Deal Link Ready!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share this link with your counterparty on WhatsApp, Instagram, or Twitter. Once funds are deposited, they are locked in escrow.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),

            const SizedBox(height: 24),

            // Deal Snapshot Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deal ID: ${deal.id}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock_rounded, size: 10, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text(
                              'PROTECTED ESCROW',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      deal.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity: ${deal.quantity} unit(s)',
                        style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_rounded, size: 16, color: AppColors.primaryDark),
                          const SizedBox(width: 4),
                          Text(
                            currencyFormatter.format(deal.price),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Lockout Logic Notice (from specification section 5 & vi)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, color: Color(0xFF1D4ED8), size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Lockout Security: Once the other party approves & funds, this link locks to prevent duplicate payments.',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Shareable Link Container
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      deal.dealLink,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18, color: AppColors.primary),
                    onPressed: () => _copyLink(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // WhatsApp Share Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareOnWhatsApp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: const Text('Share Link on WhatsApp'),
              ),
            ),

            const SizedBox(height: 12),

            // Copy Link Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _copyLink(context),
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: const Text('Copy Deal Link'),
              ),
            ),

            const SizedBox(height: 12),

            // View Deal Progress
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (c) => DealDetailsScreen(dealId: deal.id, appState: appState),
                  ),
                );
              },
              child: const Text(
                'Open Deal Details & Escrow Tracker',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
