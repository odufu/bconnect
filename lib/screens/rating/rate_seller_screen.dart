import 'package:flutter/material.dart';
import '../../models/deal_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';

class RateSellerScreen extends StatefulWidget {
  final DealModel deal;
  final AppState appState;

  const RateSellerScreen({
    super.key,
    required this.deal,
    required this.appState,
  });

  @override
  State<RateSellerScreen> createState() => _RateSellerScreenState();
}

class _RateSellerScreenState extends State<RateSellerScreen> {
  int _rating = 5;
  bool _isPositive = true;
  final TextEditingController _commentController = TextEditingController(
    text: 'Package arrived exactly as described, properly tested and verified. Seamless transaction!',
  );

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    widget.appState.addReview(
      dealId: widget.deal.id,
      productName: widget.deal.title,
      rating: _rating,
      comment: _commentController.text.trim(),
      isPositive: _isPositive,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Review published to Seller\'s Storefront profile!'),
        backgroundColor: AppColors.primary,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rate Escrow Experience'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Rate ${widget.deal.sellerName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              widget.deal.title,
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // 5-Star Rating Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starNum = index + 1;
                return IconButton(
                  iconSize: 36,
                  icon: Icon(
                    starNum <= _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: const Color(0xFFF59E0B),
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = starNum;
                      if (_rating <= 2) {
                        _isPositive = false;
                      } else {
                        _isPositive = true;
                      }
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 20),

            // Positive / Negative Tag Toggle (from specification section 7)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => setState(() => _isPositive = true),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: _isPositive ? AppColors.primaryLight : AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isPositive ? AppColors.primary : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.thumb_up_rounded, color: AppColors.positiveGreen, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Positive Review (90%)',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.positiveGreen),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => setState(() => _isPositive = false),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: !_isPositive ? AppColors.disputeRedLight : AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: !_isPositive ? AppColors.disputeRed : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.thumb_down_rounded, color: AppColors.negativeRed, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Negative (10%)',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.negativeRed),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Feedback Comment',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Share your delivery, packaging, and item quality experience...',
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitReview,
                child: const Text('SUBMIT STOREFRONT REVIEW'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
