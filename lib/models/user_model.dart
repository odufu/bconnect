class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role; // 'buyer' or 'seller'
  final bool isVerified;
  final int verificationTier; // 1: N500k max, 2: N5m max, 3: Unlimited
  final int dealsCompleted;
  final double positivePercent;
  final double negativePercent;
  final double averageRating;
  final List<String> badges;
  final String referralCode;
  final double referralEarnings;
  final double lockedEscrowBalance;
  final double availableBalance;
  final String storeDescription;
  final String memberSince;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    this.isVerified = true,
    this.verificationTier = 2,
    this.dealsCompleted = 248,
    this.positivePercent = 90.0,
    this.negativePercent = 10.0,
    this.averageRating = 4.8,
    this.badges = const ['Verified ✓', 'Top Seller', 'Fast Shipper'],
    this.referralCode = 'BCONNECT-TUNDE24',
    this.referralEarnings = 12500.0,
    this.lockedEscrowBalance = 325000.0,
    this.availableBalance = 185000.0,
    this.storeDescription =
        'Direct UK & US used gadgets, pristine iPhones, MacBooks, and accessories with guaranteed warranty.',
    this.memberSince = 'Jan 2024',
  });

  String get tierLimitDescription {
    switch (verificationTier) {
      case 1:
        return 'Tier 1 Limit: ₦500,000 / deal';
      case 2:
        return 'Tier 2 Limit: ₦5,000,000 / deal (Online Verified)';
      case 3:
        return 'Tier 3 Limit: Unlimited (Physical Shop Verified)';
      default:
        return '₦500,000 Limit';
    }
  }
}
