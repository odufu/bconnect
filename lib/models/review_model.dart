class ReviewModel {
  final String id;
  final String reviewerName;
  final int rating; // 1 to 5
  final String comment;
  final bool isPositive; // positive vs negative tag
  final String productPurchased;
  final DateTime date;
  final String dealId;

  ReviewModel({
    required this.id,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.isPositive,
    required this.productPurchased,
    required this.date,
    required this.dealId,
  });

  String get productName => productPurchased;
}
