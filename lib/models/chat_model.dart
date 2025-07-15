
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {

  final String? question;
   String? response;
   bool isLoading;
  Uint8List? imageBytes;

   ChatMessage({ required this.isLoading, this.question, this.response, this.imageBytes});

  ChatMessage copyWith({String? question, String? response, bool? isLoading,   Uint8List? imageBytes}){
    return ChatMessage(question: question ?? this.question,
        response: response ?? this.response, isLoading: isLoading ?? this.isLoading,
      imageBytes: imageBytes ?? this.imageBytes
    );
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json){
    return ChatMessage(question: json['question'] ?? '',
        response: json['response'] ?? '',
        isLoading: json['isLoading'] ?? false,
    imageBytes: json['imageBytes']);
  }

  @override
  List<Object?> get props => [question, response, isLoading, imageBytes];

}