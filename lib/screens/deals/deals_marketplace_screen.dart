import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/deal_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import 'create_deal_screen.dart';
import 'deal_details_screen.dart';

class DealsMarketplaceScreen extends StatefulWidget {
  final AppState appState;
  final bool initialTabIsWanted;

  const DealsMarketplaceScreen({
    super.key,
    required this.appState,
    this.initialTabIsWanted = false,
  });

  @override
  State<DealsMarketplaceScreen> createState() => _DealsMarketplaceScreenState();
}

class _DealsMarketplaceScreenState extends State<DealsMarketplaceScreen> {
  late bool _showWantedRequests;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Phones & Gadgets',
    'Fashion & Wigs',
    'Generators & Power',
    'Laptops & Tech',
    'Vehicles & Auto',
    'Gaming & Gadgets',
  ];

  @override
  void initState() {
    super.initState();
    _showWantedRequests = widget.initialTabIsWanted;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _indicateInterest(DealModel deal) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: AppColors.primary),
            SizedBox(width: 8),
            Text('Indicate Interest', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are responding to ${deal.buyerName}\'s request for:',
              style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Text(
              deal.title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'By indicating interest, your verified storefront profile and contact will be submitted to the buyer. You can negotiate and lock escrow immediately.',
                style: TextStyle(fontSize: 12, color: AppColors.primaryDark),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Interest submitted to ${deal.buyerName}! Awaiting buyer response.'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            child: const Text('SUBMIT OFFER'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

    final filteredDeals = widget.appState.deals.where((d) {
      if (_showWantedRequests) {
        if (!d.isBuyerAdvert) return false;
      } else {
        if (d.isBuyerAdvert) return false;
      }

      if (_selectedCategory != 'All' && d.category != _selectedCategory) {
        return false;
      }

      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return d.title.toLowerCase().contains(query) ||
            d.sellerName.toLowerCase().contains(query) ||
            d.buyerName.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Deals & Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => CreateDealScreen(
                    appState: widget.appState,
                    initialIsBuyerAdvert: _showWantedRequests,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Toggle: Buyer Requests / Seller Adverts (from specification section 12 & vii)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _showWantedRequests = false),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_showWantedRequests ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: !_showWantedRequests
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(10),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'Seller Adverts (Deals)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: !_showWantedRequests ? FontWeight.w800 : FontWeight.w500,
                              color: !_showWantedRequests ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _showWantedRequests = true),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _showWantedRequests ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _showWantedRequests
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(10),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Buyer Requests (Wanted)',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: _showWantedRequests ? FontWeight.w800 : FontWeight.w500,
                                  color: _showWantedRequests ? AppColors.textPrimary : AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: _showWantedRequests
                    ? 'Search wanted requests (e.g., PS5, Starlink)...'
                    : 'Search gadgets, wigs, generators...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          // Categories horizontal list
          Container(
            color: Colors.white,
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() => _selectedCategory = category);
                    },
                    selectedColor: AppColors.primaryLight,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Deals Count Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showWantedRequests
                      ? '${filteredDeals.length} Wanted Requests Available'
                      : '${filteredDeals.length} Verified Escrow Deals Available',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                ),
                const Row(
                  children: [
                    Icon(Icons.shield_rounded, size: 12, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      '100% Escrow Protected',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // List of Deals Cards
          Expanded(
            child: filteredDeals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        const Text(
                          'No deals found in this category',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedCategory = 'All';
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                          child: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredDeals.length,
                    itemBuilder: (context, index) {
                      final deal = filteredDeals[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
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
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        deal.category,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryDark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Timeline: ${deal.deliveryTimeline}',
                                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceMuted,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Qty: ${deal.quantity} left',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              deal.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              deal.terms,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('ESCROW PRICE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(Icons.lock_rounded, size: 14, color: AppColors.primaryDark),
                                        const SizedBox(width: 4),
                                        Text(
                                          currencyFormatter.format(deal.price),
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                                if (_showWantedRequests)
                                  Flexible(
                                    child: ElevatedButton(
                                      onPressed: () => _indicateInterest(deal),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      ),
                                      child: const Text('I HAVE IT — INDICATE INTEREST', style: TextStyle(fontSize: 10)),
                                    ),
                                  )
                                else
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) => DealDetailsScreen(dealId: deal.id, appState: widget.appState),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    ),
                                    child: const Text('BUY WITH ESCROW', style: TextStyle(fontSize: 12)),
                                  ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.account_circle_outlined, size: 14, color: AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      _showWantedRequests ? 'Buyer: ${deal.buyerName}' : 'Seller: ${deal.sellerName}',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                                    SizedBox(width: 2),
                                    Text('4.9 (98% Positive)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
