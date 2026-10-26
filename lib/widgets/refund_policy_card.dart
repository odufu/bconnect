import 'package:flutter/material.dart';

class RefundPolicyCard extends StatelessWidget {
  final double returnLogisticsCharge;

  const RefundPolicyCard({
    super.key,
    this.returnLogisticsCharge = 2500.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB), // Soft warm amber alert
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFB45309)),
              SizedBox(width: 8),
              Text(
                'BConnect Refund & Escrow Protection Rules',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF78350F),
                height: 1.4,
              ),
              children: [
                const TextSpan(
                  text: '• Buyer Negligence: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(
                  text:
                      'If refund occurs due to buyer unavailability, refusal without defect, or false claim, buyer is charged return logistics fee (₦${returnLogisticsCharge.toStringAsFixed(0)}).\n',
                ),
                const TextSpan(
                  text: '• Seller Negligence: ',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text:
                      'If product is fake, substandard, or "what I ordered vs what I got", buyer receives 100% full refund immediately, and seller bears all logistics costs to & fro.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
