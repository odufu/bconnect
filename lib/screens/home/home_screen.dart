import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/deal_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/locked_amount_card.dart';
import '../deals/create_deal_screen.dart';
import '../deals/deal_details_screen.dart';
import '../deals/deals_marketplace_screen.dart';
import '../storefront/seller_storefront_screen.dart';

class HomeScreen extends StatelessWidget {
  final AppState appState;

  const HomeScreen({super.key, required this.appState});

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _NotificationSheet(appState: appState),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);
    final activeDeals = appState.deals
        .where((d) => d.status != DealStatus.completed && d.status != DealStatus.cancelled)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: AppColors.primary.withAlpha(30)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BCONNECT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Escrow Protection',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Interactive Demo Role Switcher
          InkWell(
            onTap: () => appState.toggleRole(),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: appState.currentRole == 'buyer'
                    ? AppColors.primaryLight
                    : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: appState.currentRole == 'buyer'
                      ? AppColors.primary.withAlpha(80)
                      : const Color(0xFFF59E0B).withAlpha(80),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    appState.currentRole == 'buyer'
                        ? Icons.shopping_bag_outlined
                        : Icons.storefront_outlined,
                    size: 13,
                    color: appState.currentRole == 'buyer'
                        ? AppColors.primaryDark
                        : const Color(0xFFB45309),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    appState.currentRole == 'buyer' ? 'Buyer Mode' : 'Seller Mode',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: appState.currentRole == 'buyer'
                          ? AppColors.primaryDark
                          : const Color(0xFFB45309),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.sync_rounded, size: 12, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _showNotifications(context),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.disputeRed,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Welcome & Role Context
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hello, ${appState.currentUser.name}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.waving_hand_rounded, size: 18, color: Color(0xFFF59E0B)),
                      ],
                    ),
                    Text(
                      appState.currentRole == 'buyer'
                          ? 'Ready to buy securely with escrow hold'
                          : 'Storefront Merchant • ${appState.currentUser.dealsCompleted} Deals Completed',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded, size: 13, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Tier ${appState.currentUser.verificationTier} Verified',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Escrow Trust Holding Card (Rule: Every money must show as LOCKED with padlock icon)
            LockedAmountCard(
              amount: appState.totalEscrowLocked,
              label: 'TOTAL FUNDS LOCKED IN ESCROW',
              subtitle:
                  '${activeDeals.length} deals in active escrow transit. 100% held in trust bank.',
              isLarge: true,
              showFeeBreakdown: true,
            ),

            const SizedBox(height: 18),

            // Quick Actions Bar
            Row(
              children: [
                Expanded(
                  child: _QuickActionButton(
                    title: 'Create Deal',
                    subtitle: 'Escrow Order Link',
                    icon: Icons.add_circle_outline_rounded,
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => CreateDealScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    title: 'Wanted Board',
                    subtitle: 'Buyer Requests',
                    icon: Icons.search_rounded,
                    color: const Color(0xFF2563EB),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => DealsMarketplaceScreen(
                            appState: appState,
                            initialTabIsWanted: true,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _QuickActionButton(
                    title: 'Storefront',
                    subtitle: 'Trust & Reviews',
                    icon: Icons.store_rounded,
                    color: const Color(0xFF7C3AED),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => SellerStorefrontScreen(appState: appState),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Active Escrow Deals Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Active Escrow Deals',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${activeDeals.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => DealsMarketplaceScreen(appState: appState),
                      ),
                    );
                  },
                  child: const Text('View All', style: TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Active Deals Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activeDeals.length,
              itemBuilder: (context, index) {
                final deal = activeDeals[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _DealSummaryCard(
                    deal: deal,
                    currencyFormatter: currencyFormatter,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => DealDetailsScreen(dealId: deal.id, appState: appState),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Trust & Escrow Guarantee Box
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.gavel_rounded, color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'How BConnect Escrow Protects You',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildGuaranteePoint(
                    icon: Icons.lock_outline_rounded,
                    title: 'Funds 100% Locked in Trust',
                    description:
                        'Seller only gets paid after buyer inspects and enters delivery release code.',
                  ),
                  const SizedBox(height: 8),
                  _buildGuaranteePoint(
                    icon: Icons.timer_outlined,
                    title: '2-Hour Delivery Inspection Window',
                    description:
                        'Buyers have a 2-hour window upon waybill arrival to confirm or raise dispute.',
                  ),
                  const SizedBox(height: 8),
                  _buildGuaranteePoint(
                    icon: Icons.security_rounded,
                    title: 'Anti-Scam Intervention',
                    description:
                        'No "What I ordered vs What I got". Admin reviews video evidence and orders full refund if item is substandard.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuaranteePoint({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealSummaryCard extends StatelessWidget {
  final DealModel deal;
  final NumberFormat currencyFormatter;
  final VoidCallback onTap;

  const _DealSummaryCard({
    required this.deal,
    required this.currencyFormatter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusBg;
    Color statusColor;

    switch (deal.status) {
      case DealStatus.buyerPaid:
        statusBg = AppColors.primaryLight;
        statusColor = AppColors.primaryDark;
        break;
      case DealStatus.inTransit:
        statusBg = AppColors.escrowAmberLight;
        statusColor = const Color(0xFFB45309);
        break;
      case DealStatus.delivered:
        statusBg = const Color(0xFFEFF6FF);
        statusColor = const Color(0xFF1D4ED8);
        break;
      case DealStatus.disputed:
        statusBg = AppColors.disputeRedLight;
        statusColor = AppColors.disputeRed;
        break;
      default:
        statusBg = AppColors.surfaceMuted;
        statusColor = AppColors.textSecondary;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      deal.id,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${deal.category}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        deal.status == DealStatus.inTransit
                            ? Icons.local_shipping_rounded
                            : (deal.status == DealStatus.buyerPaid
                                ? Icons.lock_rounded
                                : (deal.status == DealStatus.disputed
                                    ? Icons.warning_amber_rounded
                                    : (deal.status == DealStatus.completed
                                        ? Icons.check_circle_rounded
                                        : Icons.access_time_rounded))),
                        size: 11,
                        color: statusColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        deal.statusDisplay,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              deal.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lock_rounded, size: 13, color: AppColors.primaryDark),
                    const SizedBox(width: 4),
                    Text(
                      currencyFormatter.format(deal.price),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'LOCKED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Seller: ${deal.sellerName}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.textMuted),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationSheet extends StatelessWidget {
  final AppState appState;

  const _NotificationSheet({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Escrow Activity Notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              Icon(Icons.done_all_rounded, size: 18, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: appState.notifications.length,
              separatorBuilder: (c, i) => const Divider(height: 20),
              itemBuilder: (c, i) {
                final notif = appState.notifications[i];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications_active_rounded,
                          color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                notif['title'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                notif['time'] as String,
                                style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif['body'] as String,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
