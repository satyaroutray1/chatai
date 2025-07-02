import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'chat_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'chat_widget.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {

  final _chatController = InMemoryChatController();
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  List<ChatMessage> message = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> callAi(TextEditingController textC) async {
    await Gemini.instance.prompt(parts: [
      Part.text(textC.text.trim()),
    ]).then((value) {
      print(value?.output);
      print(ChatMessage(question: textC.text.trim(), response: value!.output.toString()));
      message.add(ChatMessage(question: textC.text.trim(), response: value.output.toString()));
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
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          height: MediaQuery.of(context).size.height,
          child: message.isEmpty ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ask Me Anything....', style: TextStyle(
                      color: Colors.black, fontSize: 25
                  ),)
                ],
              )) : ListView.builder(
              itemCount: message.length,
              itemBuilder: (context , i){
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Bubble(
                          child: Text(message[i].question, style: TextStyle(
                              color: Colors.black
                          ),textAlign: TextAlign.left,),
                        ),],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Bubble(
                            child: Text(message[i].response, style: TextStyle(
                                color: Colors.black
                            ),textAlign: TextAlign.left,),
                          ),
                        ),
                      ],
                    )
                  ],
                );
          }),
        ),
      ),
      bottomSheet: _buildInputBar(),
    ));
  }
}


