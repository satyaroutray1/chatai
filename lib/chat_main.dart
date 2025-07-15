
import 'package:all_ui_projects/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/chat_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  TextEditingController controller = TextEditingController();
  List<ChatMessage> message = [];

  XFile? pickedFile;
  final ImagePicker _picker = ImagePicker();
  dynamic _pickImageError;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void callAiText(TextEditingController textC1) {
    final newMessage = ChatMessage(
      question: textC1.text.trim(),
      isLoading: true,
    );

    setState(() {
      message.add(newMessage);
    });

    Gemini.instance.prompt(parts: [
      Part.text(textC1.text.trim()),
    ]).then((value) {
      setState(() {
        final i = message.indexWhere((msg) => msg == newMessage);
        if (i != -1) {
          message[i].response = value?.output.toString();
          message[i].isLoading = false;
        }
        controller.clear();
      });
    });
  }

  void callAiTextImage(TextEditingController textC2) async {
    final bytes1 = await pickedFile?.readAsBytes();
    if (bytes1 == null) return;

    final newMessage = ChatMessage(
      question: textC2.text.trim(),
      isLoading: true,
      imageBytes: bytes1,
    );

    setState(() {
      message.add(newMessage);
    });

    final result = await Gemini.instance.prompt(parts: [
      Part.text(textC2.text.trim()),
      Part.inline(InlineData.fromUint8List(bytes1)),
    ]);

    setState(() {
      final i = message.indexWhere((msg) => msg == newMessage);
      if (i != -1) {
        message[i].response = result?.output.toString();
        message[i].isLoading = false;
      }
      pickedFile = null; // Reset after use
      controller.clear();
    });
  }

  Future<void> _displayPickImageDialog(BuildContext context) async {
    try {
      pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {});
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Ask anything...'),
              style: TextStyle(color: Colors.black),
            ),
          ),
          IconButton(
            onPressed: () => _displayPickImageDialog(context),
            icon: Icon(Icons.image_outlined),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (controller.text.trim().isNotEmpty) {
                pickedFile != null
                    ? callAiTextImage(controller)
                    : callAiText(controller);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.greenAccent, Colors.white],
                center: Alignment.topCenter,
                radius: 1,
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('ChatAI', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.transparent,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 150),
                height: MediaQuery.of(context).size.height,
                child: message.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hello, How can I help you today?',
                        style:
                        TextStyle(color: Colors.black, fontSize: 25),
                      )
                    ],
                  ),
                )
                    : ListView.builder(
                    itemCount: message.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (message[i].imageBytes != null)
                              Image.memory(message[i].imageBytes!,
                                  height: 100),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Bubble(
                                  child: Text(
                                    message[i].question ?? '',
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            message[i].isLoading
                                ? Text(
                              'Thinking .......',
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.start,
                            )
                                : Card(
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    10, 20, 10, 0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        message[i].response ?? '',
                                        style: TextStyle(
                                            color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ),
            bottomSheet: _buildInputBar(),
          )
        ],
      ),
    );
  }
}
