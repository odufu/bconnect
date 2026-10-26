import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';

class ReferralScreen extends StatelessWidget {
  final AppState appState;

  const ReferralScreen({super.key, required this.appState});

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: appState.currentUser.referralCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral code copied to clipboard!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareReferral(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: "Use my code ${appState.currentUser.referralCode} to get ₦500 off your first BConnect Escrow transaction!"'),
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
        title: const Text('Invite & Earn Rewards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary, size: 48),
            ),
            const SizedBox(height: 16),
            const Text(
              'Earn ₦500 for Every Referral',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Share your personal referral code with friends, buyers, and sellers. When they complete their first escrow deal, both of you earn ₦500.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),

            const SizedBox(height: 24),

            // Earnings Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withAlpha(50)),
              ),
              child: Column(
                children: [
                  const Text(
                    'TOTAL REFERRAL EARNINGS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryDark),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currencyFormatter.format(appState.currentUser.referralEarnings),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '29 Successful Friends Invited',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Customized Referral Code (from specification section xv)
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Your Customized Referral Code',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    appState.currentUser.referralCode,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _copyCode(context),
                    icon: const Icon(Icons.copy_rounded, size: 16),
                    label: const Text('Copy'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _shareReferral(context),
                icon: const Icon(Icons.share_rounded, size: 18),
                label: const Text('Share Code on WhatsApp'),
              ),
            ),

            const SizedBox(height: 24),

            // How referral works steps
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How It Works:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  SizedBox(height: 10),
                  Text('1. Send your code or link to any buyer or seller on WhatsApp.', style: TextStyle(fontSize: 12, height: 1.4)),
                  SizedBox(height: 6),
                  Text('2. They enter your code when signing up or creating an escrow deal.', style: TextStyle(fontSize: 12, height: 1.4)),
                  SizedBox(height: 6),
                  Text('3. Once their first order is safely completed and funds released, ₦500 is credited straight into your wallet.', style: TextStyle(fontSize: 12, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
