import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

//AIzaSyBJjpbnVJxjWDg8maAFhGyeqz-v3P-aaLE

/*
Gemini.instance.prompt(parts: [
    Part.text('Write a story about a magic backpack'),
  ]).then((value) {
    print(value?.output);
  });
 */
class _ChatMainState extends State<ChatMain> {

  final _chatController = InMemoryChatController();
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  List<Message> message = [];

  Future<void> callAi(TextEditingController textC) async {
    await Gemini.instance.prompt(parts: [
      Part.text(textC.text.trim()),
    ]).then((value) {
      print(value?.output);
      print(Message(question: textC.text.trim(), response: value!.output.toString()));
      message.add(Message(question: textC.text.trim(), response: value.output.toString()));
      controller.clear();

      setState(() {

      });
    });
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Ask something...'),
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                //sendMessage(controller.text.trim());
                callAi(controller);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Scaffold(
      appBar: AppBar(title: Text('Chatbot'),),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
              itemCount: message.length,
              itemBuilder: (context , i){
            return Column(
              children: [
                Text(message[i].question, style: TextStyle(
                    color: Colors.black
                ),),
                Text(message[i].response, style: TextStyle(
                  color: Colors.black
                ),),

              ],
            );
          }),
        ),
      )
      // FutureBuilder(
      //     future: callAi(),
      //     builder: (context, snap){
      //   if(snap.hasData){
      //     return Column(
      //       children: [
      //         Text('data'),
      //       ],
      //     );
      //   }
      //   return Text('error');
      // })
        ,
      bottomSheet: _buildInputBar(),
      //bottomNavigationBar: _buildInputBar()
    ));
  }
}


class Message extends Equatable {

  final String question;
  final String response;

  const Message({required this.question, required this.response});

  Message copyWith({String? question, String? response}){
    return Message(question: question ?? this.question, response: response ?? this.response);
  }

  factory Message.fromJson(Map<String, dynamic> json){
    return Message(question: json['question'], response: json['response']);
  }

  @override
  List<Object?> get props => [question, response];


}