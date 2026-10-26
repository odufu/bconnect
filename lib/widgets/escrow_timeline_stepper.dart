import 'package:flutter/material.dart';
import '../models/deal_model.dart';
import '../theme/app_colors.dart';

class EscrowTimelineStepper extends StatelessWidget {
  final DealModel deal;

  const EscrowTimelineStepper({
    super.key,
    required this.deal,
  });

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'title': 'Buyer Paid & Held in Escrow',
        'subtitle': deal.status == DealStatus.paymentPending
            ? 'Awaiting deposit from buyer'
            : 'Funds locked in trust account',
        'icon': Icons.lock_clock_rounded,
        'step': 1,
      },
      {
        'title': 'Waybill Sent',
        'subtitle': deal.waybillNumber != null
            ? '${deal.waybillCourier ?? 'Courier'}: ${deal.waybillNumber}'
            : 'Seller preparing parcel dispatch',
        'icon': Icons.local_shipping_outlined,
        'step': 2,
      },
      {
        'title': 'In Transit & Inspection',
        'subtitle': deal.status == DealStatus.inTransit
            ? 'Active transit • 2hr timer upon arrival'
            : (deal.currentStepIndex > 2 ? 'Inspection completed' : 'En route to destination'),
        'icon': Icons.timer_outlined,
        'step': 3,
      },
      {
        'title': 'Delivered & Released',
        'subtitle': deal.status == DealStatus.completed
            ? 'Delivery code verified • Funds paid'
            : 'Inspection & delivery code handover',
        'icon': Icons.verified_rounded,
        'step': 4,
      },
    ];

    final currentStep = deal.currentStepIndex;

    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Escrow Lifecycle Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: deal.status == DealStatus.disputed
                      ? AppColors.disputeRedLight
                      : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  deal.statusDisplay,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: deal.status == DealStatus.disputed
                        ? AppColors.disputeRed
                        : AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            separatorBuilder: (context, index) {
              final isCompleted = currentStep > index + 1;
              return Padding(
                padding: const EdgeInsets.only(left: 18),
                child: Container(
                  width: 2,
                  height: 24,
                  color: isCompleted ? AppColors.primary : AppColors.border,
                ),
              );
            },
            itemBuilder: (context, index) {
              final stepData = steps[index];
              final stepNum = stepData['step'] as int;

              final isCompleted = currentStep > stepNum;
              final isCurrent = currentStep == stepNum;

              Color indicatorBg;
              Widget statusWidget;

              if (deal.status == DealStatus.disputed && isCurrent) {
                indicatorBg = AppColors.disputeRedLight;
                statusWidget = const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.disputeRed);
              } else if (isCompleted) {
                indicatorBg = AppColors.primary;
                statusWidget = const Icon(Icons.check, size: 14, color: Colors.white);
              } else if (isCurrent) {
                indicatorBg = AppColors.primaryLight;
                statusWidget = Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                );
              } else {
                indicatorBg = AppColors.surfaceMuted;
                statusWidget = Text(
                  '$stepNum',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: indicatorBg,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent
                            ? AppColors.primary
                            : (isCompleted ? AppColors.primary : AppColors.border),
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: Center(child: statusWidget),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stepData['title'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                            color: isCurrent
                                ? AppColors.textPrimary
                                : (isCompleted ? AppColors.textPrimary : AppColors.textMuted),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          stepData['subtitle'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: isCurrent ? AppColors.textSecondary : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCurrent && deal.status == DealStatus.inTransit) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.escrowAmberLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.hourglass_bottom_rounded, size: 12, color: AppColors.escrowAmber),
                          SizedBox(width: 4),
                          Text(
                            '1h 42m',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.escrowAmber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
