class Alert {
  final String id;
  final String type;      // safe or danger
  final int timestamp;
  final String senderId;
  final int ttl;
  final bool uploaded;

  Alert({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.senderId,
    required this.ttl,
    this.uploaded = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'timestamp': timestamp,
        'senderId': senderId,
        'ttl': ttl,
        'uploaded': uploaded ? 1 : 0,
      };

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      type: json['type'],
      timestamp: (json['timestamp'] ?? json['receivedAt'] ?? DateTime.now().millisecondsSinceEpoch) as int,
      senderId: (json['senderId'] ?? json['fromDevice']) as String,
      ttl: json['ttl'] ?? 5,
      uploaded: (json['uploaded'] ?? 0) == 1,
    );
  }

  /// copyWith allows you to create a modified copy of an Alert
  Alert copyWith({
    String? id,
    String? type,
    int? timestamp,
    String? senderId,
    int? ttl,
    bool? uploaded,
  }) {
    return Alert(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      ttl: ttl ?? this.ttl,
      uploaded: uploaded ?? this.uploaded,
    );
  }
}