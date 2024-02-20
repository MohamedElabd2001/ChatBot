class ChatMessageModel {
  final String role;
  final List<ChatPartModel> parts;

  ChatMessageModel({
    required this.role,
    required this.parts,
  });

  // Named constructor for creating an object from JSON
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      role: json['role'],
      parts: (json['parts'] as List<dynamic>)
          .map((part) => ChatPartModel.fromJson(part))
          .toList(),
    );
  }

  // Method to convert the object to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'parts': parts.map((part) => part.toJson()).toList(),
    };
  }
}

class ChatPartModel {
  final String text;

  ChatPartModel({
    required this.text,
  });

  // Named constructor for creating an object from JSON
  factory ChatPartModel.fromJson(Map<String, dynamic> json) {
    return ChatPartModel(
      text: json['text'],
    );
  }

  // Method to convert the object to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}