class Conversation {
  final String conversationId;
  final int customerId;
  final int ownerId;
  final String title;

  Conversation({
    required this.conversationId,
    required this.customerId,
    required this.ownerId,
    this.title = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'customer_id': customerId,
      'owner_id': ownerId,
      'title': title,
    };
  }

  // Modified factory constructor to accept optional external title
  factory Conversation.fromJson(Map<String, dynamic> json, [String? externalTitle]) {
    return Conversation(
      conversationId: json['conversation_id'].toString(),
      customerId: int.parse(json['customer_id'].toString()),
      ownerId: int.parse(json['owner_id'].toString()),
      title: externalTitle ?? json['title'] ?? '',
    );
  }
}
