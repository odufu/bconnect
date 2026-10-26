import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../storefront/seller_storefront_screen.dart';
import 'referral_screen.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  void _showWithdrawModal(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

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
              'Withdraw Available Escrow Balance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              'Available: ${currencyFormatter.format(appState.currentUser.availableBalance)} (Locked funds cannot be withdrawn until buyer confirms delivery)',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance_rounded, color: AppColors.primary),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Access Bank • 0123984571', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      Text('Tunde Adebayo (Verified Name Match)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Withdrawal request submitted! Instant transfer initiated to bank account.'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                },
                child: const Text('CONFIRM BANK TRANSFER'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = appState.currentUser;
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Account & Security'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      user.name[0],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.phone,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                user.tierLimitDescription,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Escrow Wallet Balance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LOCKED IN ESCROW',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.lock_rounded, size: 15, color: AppColors.primaryDark),
                              const SizedBox(width: 4),
                              Text(
                                currencyFormatter.format(appState.totalEscrowLocked),
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(width: 1, height: 36, color: AppColors.border),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AVAILABLE PAYOUT',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            currencyFormatter.format(user.availableBalance),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _showWithdrawModal(context),
                      icon: const Icon(Icons.account_balance_rounded, size: 16),
                      label: const Text('Withdraw Available Funds to Bank'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Interactive Role Switcher Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: appState.currentRole == 'buyer' ? AppColors.primarySurface : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: appState.currentRole == 'buyer' ? AppColors.primary.withAlpha(80) : const Color(0xFFF59E0B).withAlpha(80),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    appState.currentRole == 'buyer' ? Icons.shopping_bag_outlined : Icons.storefront_outlined,
                    color: appState.currentRole == 'buyer' ? AppColors.primaryDark : const Color(0xFF92400E),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Active Role: ${appState.currentRole.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: appState.currentRole == 'buyer' ? AppColors.primaryDark : const Color(0xFF92400E),
                          ),
                        ),
                        Text(
                          appState.currentRole == 'buyer'
                              ? 'Switch role to test seller waybill & storefront perspective.'
                              : 'Switch role to test buyer payment & release perspective.',
                          style: TextStyle(
                            fontSize: 11,
                            color: appState.currentRole == 'buyer' ? AppColors.primaryDark : const Color(0xFF78350F),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: appState.currentRole == 'buyer' ? AppColors.primary : const Color(0xFFD97706),
                    ),
                    onPressed: () => appState.toggleRole(),
                    child: const Text('Switch', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Navigation Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.store_rounded, color: AppColors.primary),
                    title: const Text('My Seller Storefront & Reviews', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Manage your adverts and view 90% positive trust stats', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => SellerStorefrontScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.card_giftcard_rounded, color: Color(0xFF2563EB)),
                    title: const Text('Invite & Earn ₦500', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Share your code: BCONNECT-TUNDE24', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => ReferralScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.verified_user_outlined, color: Color(0xFF10B981)),
                    title: const Text('KYC Verification Tiers', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Tier 1 (₦500k) • Tier 2 (₦5m) • Tier 3 (Unlimited)', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tier 2 Verified (N5,000,000 limit active)')),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                    title: const Text('Anti-Scam & Device Security', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                    subtitle: const Text('Auto-flag multiple accounts, VPNs, and risky deals', style: TextStyle(fontSize: 11)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Security Shield Active: Device ID bound, E2E chat encryption enabled.')),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Footer note
            const Center(
              child: Column(
                children: [
                  Text(
                    'Grand Brain Connect Nigeria limited (GBCONNET)',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Powered by GBCONNET • Version 1.0.0',
                    style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
