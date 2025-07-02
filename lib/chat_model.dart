import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {

  final String question;
  final String response;

  const ChatMessage({required this.question, required this.response});

  ChatMessage copyWith({String? question, String? response}){
    return ChatMessage(question: question ?? this.question, response: response ?? this.response);
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json){
    return ChatMessage(question: json['question'], response: json['response']);
  }

  @override
  List<Object?> get props => [question, response];

}
