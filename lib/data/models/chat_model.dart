// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatModel {
  ChatModel({
    this.question,
    this.id,
  });
  final String? question;
  final int? id;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'id': id,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      question: map['question'] != null ? map['question'] as String : null,
      id: map['id'] != null ? map['id'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UserChats {
  UserChats({this.chats});
  final List<ChatModel>? chats;
}
