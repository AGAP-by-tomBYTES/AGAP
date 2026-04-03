class Alert {
  final String id;
  final String type;      // safe or danger
  final int timestamp;
  final String senderId;
  final int ttl;

  Alert({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.senderId,
    required this.ttl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'timestamp': timestamp,
        'senderId': senderId,
        'ttl': ttl,
      };

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      type: json['type'],
      timestamp: json['timestamp'],
      senderId: json['senderId'],
      ttl: json['ttl'] ?? 5,
    );
  }
}