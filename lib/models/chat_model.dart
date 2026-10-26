class ChatMessage {
  final String id;
  final String dealId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isFromMe;
  final String? attachmentUrl;
  final bool isAttachmentPhoto;
  final bool isSystemNotice;
  final bool isDisputeAlert;

  ChatMessage({
    required this.id,
    required this.dealId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isFromMe,
    this.attachmentUrl,
    this.isAttachmentPhoto = false,
    this.isSystemNotice = false,
    this.isDisputeAlert = false,
  });
}
