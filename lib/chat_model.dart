import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {

  final String? question;
   String? response;
   bool isLoading;

   ChatMessage({ required this.isLoading, this.question, this.response});

  ChatMessage copyWith({String? question, String? response, bool? isLoading}){
    return ChatMessage(question: question ?? this.question, response: response ?? this.response, isLoading: isLoading ?? this.isLoading);
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json){
    return ChatMessage(question: json['question'] ?? '',
        response: json['response'] ?? '',
        isLoading: json['isLoading'] ?? false);
  }

  @override
  List<Object?> get props => [question, response, isLoading];

}
