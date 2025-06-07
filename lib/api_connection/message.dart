class Message {
  final String text;
  final bool isMe;
  final DateTime sentAt;
  final String senderType;
  final int senderId;

  Message({
    required this.text,
    required this.isMe,
    required this.sentAt,
    required this.senderType,
    required this.senderId,
  });

  factory Message.fromJson(Map<String, dynamic> json, {
    required int currentUserId,
    required String userType,
  }) {
    return Message(
      text: json['message_text'],
      isMe: (json['sender_type'] == userType) &&
          (int.parse(json['sender_id'].toString()) == currentUserId),
      sentAt: DateTime.parse(json['sent_at']),
      senderType: json['sender_type'],
      senderId: int.parse(json['sender_id'].toString()),
    );
  }
}