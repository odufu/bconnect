import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/deal_model.dart';
import '../../state/app_state.dart';
import '../../theme/app_colors.dart';
import 'dispute_modal.dart';

class ChatConversationScreen extends StatefulWidget {
  final String dealId;
  final AppState appState;

  const ChatConversationScreen({
    super.key,
    required this.dealId,
    required this.appState,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    widget.appState.sendUserChatMessage(
      dealId: widget.dealId,
      text: text,
    );

    _messageController.clear();
    setState(() {});

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _attachProof() {
    widget.appState.sendUserChatMessage(
      dealId: widget.dealId,
      text: 'Sent proof attachment: item_inspection_photo.jpg',
      attachmentUrl: 'sample_proof.jpg',
      isAttachmentPhoto: true,
    );
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulated proof attachment added to chat'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _callCounterparty(DealModel deal) {
    final phone = widget.appState.currentRole == 'buyer' ? deal.sellerPhone : deal.buyerPhone;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Simulating phone call to: ${phone.isNotEmpty ? phone : "+234 803 456 7890"}'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _openDispute(DealModel deal, [String? preselected]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DisputeModal(
        deal: deal,
        appState: widget.appState,
        preselectedReason: preselected,
        onDisputeSubmitted: () {
          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.appState.deals.firstWhere(
      (d) => d.id == widget.dealId,
      orElse: () => widget.appState.deals.first,
    );

    final messages = widget.appState.chatThreads[deal.id] ?? [];
    final currencyFormatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.appState.currentRole == 'buyer' ? deal.sellerName : deal.buyerName,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.lock_rounded, size: 12, color: AppColors.primary),
              ],
            ),
            Text(
              '${deal.title} • ${currencyFormatter.format(deal.price)} (Escrow Held)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined, color: AppColors.primary),
            onPressed: () => _callCounterparty(deal),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Security Banner (from specification: "Security UI Notes: Chat End-to-End Encryption")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: const Color(0xFFEFF6FF),
            child: const Row(
              children: [
                Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF1D4ED8)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'End-to-End Encrypted • Messages cannot be deleted or edited (Preserved as dispute evidence)',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF1E40AF)),
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final timeStr = DateFormat('hh:mm a').format(msg.timestamp);

                if (msg.isSystemNotice) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isDisputeAlert ? AppColors.disputeRedLight : AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: msg.isDisputeAlert ? AppColors.disputeRed.withAlpha(60) : AppColors.primary.withAlpha(60),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          msg.isDisputeAlert ? Icons.warning_amber_rounded : Icons.shield_rounded,
                          size: 16,
                          color: msg.isDisputeAlert ? AppColors.disputeRed : AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg.senderName,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: msg.isDisputeAlert ? AppColors.disputeRed : AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                msg.text,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: msg.isDisputeAlert ? const Color(0xFF7F1D1D) : AppColors.textPrimary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Align(
                  alignment: msg.isFromMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: msg.isFromMe ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(16).copyWith(
                        bottomRight: msg.isFromMe ? const Radius.circular(2) : const Radius.circular(16),
                        bottomLeft: !msg.isFromMe ? const Radius.circular(2) : const Radius.circular(16),
                      ),
                      border: msg.isFromMe ? null : Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          msg.isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!msg.isFromMe) ...[
                          Text(
                            msg.senderName,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 13,
                            color: msg.isFromMe ? Colors.white : AppColors.textPrimary,
                            height: 1.35,
                          ),
                        ),
                        if (msg.isAttachmentPhoto) ...[
                          const SizedBox(height: 8),
                          Container(
                            height: 110,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: msg.isFromMe ? Colors.white.withAlpha(40) : AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.image_outlined, size: 28, color: AppColors.primary),
                                  SizedBox(height: 4),
                                  Text(
                                    'Proof Attached',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          timeStr,
                          style: TextStyle(
                            fontSize: 10,
                            color: msg.isFromMe ? Colors.white.withAlpha(180) : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Fixed Dispute Quick Action Bar (from specification section 10)
          // "Bottom Fixed Bar: Dispute Button | I didn't get item | Fake item | Not what I ordered"
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => _openDispute(deal),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.disputeRedLight,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.disputeRed.withAlpha(80)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.disputeRed),
                          SizedBox(width: 4),
                          Text(
                            'Dispute Deal',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.disputeRed),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildDisputeChip('I didn\'t get item', () => _openDispute(deal, 'didn\'t get item')),
                  const SizedBox(width: 8),
                  _buildDisputeChip('Fake item', () => _openDispute(deal, 'Fake item')),
                  const SizedBox(width: 8),
                  _buildDisputeChip('Not what I ordered', () => _openDispute(deal, 'Not what I ordered')),
                ],
              ),
            ),
          ),

          // Message Input Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded, color: AppColors.primary),
                  onPressed: _attachProof,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message (encrypted)...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onSubmitted: (v) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  radius: 22,
                  child: IconButton(
                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeChip(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
