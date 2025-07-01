import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

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

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
    Scaffold(
      appBar: AppBar(title: Text('Chatbot'),),
      body: Column(
        children: [
          
        ],
      ),
      bottomNavigationBar: _buildInputBar()
    ));
  }
}

Widget _buildInputBar() {
  TextEditingController controller = TextEditingController();
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Ask something...'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              //sendMessage(controller.text.trim());
              controller.clear();
            }
          },
        )
      ],
    ),
  );
}
