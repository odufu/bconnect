import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/refund_policy_card.dart';
import 'share_deal_screen.dart';

class CreateDealScreen extends StatefulWidget {
  final AppState appState;
  final bool initialIsBuyerAdvert;

  const CreateDealScreen({
    super.key,
    required this.appState,
    this.initialIsBuyerAdvert = false,
  });

  @override
  State<CreateDealScreen> createState() => _CreateDealScreenState();
}

class _CreateDealScreenState extends State<CreateDealScreen> {
  late bool _isBuyerRole;
  late bool _isOpenWantedAdvert;

  final List<String> _productOptions = [
    'iPhone 15 Pro Max 256GB',
    'iPhone 14 Pro Max 128GB/256GB',
    'MacBook Air M2 8GB/256GB',
    'Samsung Galaxy S24 Ultra',
    'Bone Straight Double Drawn Wig 26"',
    'Lutian 3.8kVA Eco Generator',
    'Starlink Standard Satellite Kit',
    'Sony PlayStation 5 Console',
    'Toyota Camry 2012 Headlight (Pair)',
  ];

  String? _selectedProduct;
  final TextEditingController _customProductController = TextEditingController();
  bool _isCustomProduct = false;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(text: '150000');
  final TextEditingController _termsController = TextEditingController(
    text: 'Brand new in original packaging, full accessories, 7-day testing warranty.',
  );
  final TextEditingController _instructionsController = TextEditingController(
    text: 'Please pack securely with bubble wrap and dispatch via priority interstate courier.',
  );

  int _quantity = 1;
  String _deliveryTimeline = '24hrs';
  final List<String> _timelineOptions = ['24hrs', '48hrs', '3 days', '7 days'];

  final List<String> _simulatedProofs = [];
  bool _agreedToTerms = true;

  @override
  void initState() {
    super.initState();
    _isBuyerRole = widget.appState.currentRole == 'buyer';
    _isOpenWantedAdvert = widget.initialIsBuyerAdvert;
    _selectedProduct = _productOptions.first;
  }

  @override
  void dispose() {
    _customProductController.dispose();
    _phoneController.dispose();
    _priceController.dispose();
    _termsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  double get _enteredPrice {
    final clean = _priceController.text.replaceAll(',', '').trim();
    return double.tryParse(clean) ?? 0.0;
  }

  double get _buyerFee => 500.0;
  double get _sellerFee => 500.0;
  double get _totalPrice => (_enteredPrice * _quantity) + (_isBuyerRole ? _buyerFee : 0.0);

  void _addProof() {
    setState(() {
      _simulatedProofs.add('proof_${_simulatedProofs.length + 1}.jpg');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulated proof image attached'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _submitCreateDeal() {
    final title = _isCustomProduct ? _customProductController.text.trim() : _selectedProduct!;
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please specify product or service name')),
      );
      return;
    }

    if (_enteredPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to the Escrow Terms & Conditions')),
      );
      return;
    }

    final newDeal = widget.appState.createDeal(
      title: title,
      category: 'Gadgets & Services',
      price: _enteredPrice * _quantity,
      quantity: _quantity,
      deliveryTimeline: _deliveryTimeline,
      terms: _termsController.text.trim(),
      instructions: _instructionsController.text.trim(),
      counterpartyPhone: _phoneController.text.trim().isEmpty
          ? '+234 812 345 6789'
          : _phoneController.text.trim(),
      isBuyerRole: _isBuyerRole,
      isWantedAdvert: _isOpenWantedAdvert,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (c) => ShareDealScreen(
          deal: newDeal,
          appState: widget.appState,
          isCreatedByMe: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_isBuyerRole ? 'Create Escrow Purchase' : 'Create Seller Order Link'),
        actions: [
          // Role switch on creation
          TextButton(
            onPressed: () {
              setState(() {
                _isBuyerRole = !_isBuyerRole;
              });
            },
            child: Text(
              _isBuyerRole ? 'Switch to Seller' : 'Switch to Buyer',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mode Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isBuyerRole ? AppColors.primarySurface : const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isBuyerRole
                      ? AppColors.primary.withAlpha(50)
                      : const Color(0xFFF59E0B).withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isBuyerRole ? Icons.shopping_bag_outlined : Icons.storefront_outlined,
                    color: _isBuyerRole ? AppColors.primaryDark : const Color(0xFF92400E),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _isBuyerRole
                          ? 'Buyer Flow: Set what you are buying, lock funds, and send link to the seller.'
                          : 'Seller Flow: Create an order link, share to customer on WhatsApp or DM to receive guaranteed payment.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _isBuyerRole ? AppColors.primaryDark : const Color(0xFF92400E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Open Advert / Wanted toggle (from specification section 4)
            if (_isBuyerRole) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Post to Wanted Board',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Let any verified seller see this request & indicate interest',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isOpenWantedAdvert,
                      activeThumbColor: AppColors.primary,
                      onChanged: (val) => setState(() => _isOpenWantedAdvert = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // 1. Product/Service Name: Dropdown with list + Button "Add New Product Name"
            const Text(
              'Product or Service Name *',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            if (!_isCustomProduct) ...[
              DropdownButtonFormField<String>(
                initialValue: _selectedProduct,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                ),
                items: _productOptions.map((prod) {
                  return DropdownMenuItem(
                    value: prod,
                    child: Text(prod, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedProduct = val);
                },
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isCustomProduct = true;
                      _customProductController.text = _selectedProduct ?? '';
                    });
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text(
                    'Add New Product / Custom Name',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ] else ...[
              TextField(
                controller: _customProductController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.edit_note_rounded, color: AppColors.primary),
                  hintText: 'Enter custom product or service name',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () => setState(() => _isCustomProduct = false),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Counterparty Phone (Optional if open advert)
            Text(
              _isBuyerRole
                  ? 'Seller Phone Number (Optional for open request)'
                  : 'Buyer Phone Number (Optional for open link)',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                hintText: 'e.g. 0803 123 4567 or leave blank for open link',
              ),
            ),

            const SizedBox(height: 16),

            // Quantity selector (+ / -) & Price Input
            Row(
              children: [
                // Quantity Selector
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quantity',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 18),
                            onPressed: () {
                              if (_quantity > 1) setState(() => _quantity--);
                            },
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 18),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Price Input (Creator sets price)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Agreed Price per Unit (₦) *',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => setState(() {}),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.money_rounded, color: AppColors.primary),
                          hintText: '150,000',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Delivery Timeline: [24hrs, 48hrs, 3 days, 7 days]
            const Text(
              'Delivery Timeline *',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Row(
              children: _timelineOptions.map((time) {
                final isSelected = _deliveryTimeline == time;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      onTap: () => setState(() => _deliveryTimeline = time),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Terms & Conditions box + Free Instructions box (multiline)
            const Text(
              'Agreed Deal Terms & Specifications',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _termsController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Condition, serial number, included accessories, or return warranty...',
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Free Instructions & Waybill Address',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _instructionsController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Destination address, courier preference, inspection instructions...',
              ),
            ),

            const SizedBox(height: 16),

            // Upload Proofs: Photos/Videos/Receipts (multiple)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Upload Proofs (Photos / Videos)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
                TextButton.icon(
                  onPressed: _addProof,
                  icon: const Icon(Icons.attach_file_rounded, size: 16),
                  label: const Text('Add Media', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            if (_simulatedProofs.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: _simulatedProofs.map((p) {
                  return Chip(
                    avatar: const Icon(Icons.image_rounded, size: 14, color: AppColors.primary),
                    label: Text(p, style: const TextStyle(fontSize: 11)),
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () {
                      setState(() => _simulatedProofs.remove(p));
                    },
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 20),

            // System Auto-Calculates: "Buyer Fee: ₦500 | Seller Fee: ₦500" — show total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withAlpha(60)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Item Subtotal:',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Text(
                        currencyFormatter.format(_enteredPrice * _quantity),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Buyer Escrow Protection Fee:',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Text(
                        currencyFormatter.format(_buyerFee),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Seller Escrow Protection Fee:',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      Text(
                        currencyFormatter.format(_sellerFee),
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(color: AppColors.border, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          'Total Payable (Escrow Locked):',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_rounded, size: 15, color: AppColors.primaryDark),
                          const SizedBox(width: 4),
                          Text(
                            currencyFormatter.format(_totalPrice),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Refund Policy Card (Specification requirement 9)
            const RefundPolicyCard(),

            const SizedBox(height: 16),

            // Checkbox for the Escrow T&C before payment (Specification requirement xiii)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      'I agree to the BConnect Escrow Terms & Conditions, 2-hour inspection window, and automated dispute arbitration policy.',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Button: CREATE & SHARE LINK
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submitCreateDeal,
                icon: const Icon(Icons.share_rounded, size: 18),
                label: Text(
                  _isOpenWantedAdvert ? 'POST TO WANTED BOARD' : 'CREATE & SHARE ESCROW LINK',
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
