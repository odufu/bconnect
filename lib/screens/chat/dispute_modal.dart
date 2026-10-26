import 'package:flutter/material.dart';
import '../../models/deal_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';

class DisputeModal extends StatefulWidget {
  final DealModel deal;
  final AppState appState;
  final VoidCallback? onDisputeSubmitted;
  final String? preselectedReason;

  const DisputeModal({
    super.key,
    required this.deal,
    required this.appState,
    this.onDisputeSubmitted,
    this.preselectedReason,
  });

  @override
  State<DisputeModal> createState() => _DisputeModalState();
}

class _DisputeModalState extends State<DisputeModal> {
  late String _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  final List<String> _evidencePhotos = [];

  final List<String> _presetReasons = [
    'I didn\'t get item (Never arrived / wrong location)',
    'Fake item (Counterfeit / non-genuine product)',
    'Not what I ordered (What I ordered vs what I got)',
    'Substandard / Damaged item during transit',
    'Seller unreachable after waybill promised',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedReason != null) {
      final match = _presetReasons.firstWhere(
        (r) => r.toLowerCase().contains(widget.preselectedReason!.toLowerCase()),
        orElse: () => _presetReasons.first,
      );
      _selectedReason = match;
    } else {
      _selectedReason = _presetReasons.first;
    }
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _addEvidence() {
    setState(() {
      _evidencePhotos.add('evidence_${_evidencePhotos.length + 1}.jpg');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo evidence attached for admin inspection'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _submitDispute() {
    if (_detailsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide details for the dispute mediator')),
      );
      return;
    }

    widget.appState.raiseDispute(
      dealId: widget.deal.id,
      reason: _selectedReason,
      details: _detailsController.text.trim(),
      evidenceImages: _evidencePhotos,
    );

    widget.onDisputeSubmitted?.call();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dispute opened! Escrow funds frozen 100%. Admin mediator assigned.'),
        backgroundColor: AppColors.disputeRed,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.disputeRedLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.gavel_rounded, color: AppColors.disputeRed, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Raise Dispute & Admin Intervention',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.disputeRed),
                  ),
                  Text(
                    '100% Escrow Freeze • Immediate Mediation',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Explanation banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.disputeRedLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.disputeRed.withAlpha(50)),
                    ),
                    child: const Text(
                      'When you raise a dispute, the escrow money is immediately locked. The seller cannot withdraw until BConnect admin reviews unboxing evidence and reaches a verdict.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF7F1D1D), height: 1.35),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Select Primary Dispute Reason',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedReason,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: _presetReasons.map((r) {
                      return DropdownMenuItem(
                        value: r,
                        child: Text(r, style: const TextStyle(fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedReason = val);
                    },
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Detailed Statement of Fact *',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _detailsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Describe what arrived, differences from seller advert, or tracking issues...',
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upload Evidence (Photo/Video/Unboxing)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
                      TextButton.icon(
                        onPressed: _addEvidence,
                        icon: const Icon(Icons.add_a_photo_outlined, size: 16),
                        label: const Text('Add Proof', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  if (_evidencePhotos.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: _evidencePhotos.map((e) {
                        return Chip(
                          backgroundColor: AppColors.disputeRedLight,
                          avatar: const Icon(Icons.image, size: 14, color: AppColors.disputeRed),
                          label: Text(e, style: const TextStyle(fontSize: 11, color: AppColors.disputeRed)),
                          deleteIcon: const Icon(Icons.close, size: 14),
                          onDeleted: () => setState(() => _evidencePhotos.remove(e)),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Vote for admin intervention button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.disputeRed,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitDispute,
                      icon: const Icon(Icons.how_to_vote_rounded, size: 18),
                      label: const Text('VOTE FOR ADMIN TO INTERVENE'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
