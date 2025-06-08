class Conversation {
  final String conversationId;
  final int customerId;
  final int ownerId;
  final String customerName;
  final String ownerName;
  final String title;

  Conversation({
    required this.conversationId,
    required this.customerId,
    required this.ownerId,
    required this.customerName,
    required this.ownerName,
    this.title = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'customer_id': customerId,
      'owner_id': ownerId,
      'customer_name': customerName,
      'owner_name': ownerName,
      'title': title,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json, [String? externalTitle]) {
    return Conversation(
      conversationId: json['conversation_id'].toString(),
      customerId: int.parse(json['customer_id'].toString()),
      ownerId: int.parse(json['owner_id'].toString()),
      customerName: json['customer_name'] ?? '',
      ownerName: json['owner_name'] ?? '',
      title: externalTitle ?? '',
    );
  }
}
