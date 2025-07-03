import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'chat_model.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'chat_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);

class _ChatMainState extends State<ChatMain> {

  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  List<ChatMessage> message = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void callAiText(TextEditingController textC)  {
    setState(() {
      message.add(ChatMessage(question: textC.text.trim(), isLoading: true));

    });

    Gemini.instance.prompt(parts: [
      Part.text(textC.text.trim()),
    ]).then((value) {
      print(value?.output);

      setState(() {
        final i = message.indexWhere((message) => message.question == textC.text && message.isLoading == true);
        if (i != -1) {
          message[i].response = value?.output.toString();
          message[i].isLoading = false;
        }

        controller.clear();
      });
    });
  }

  void callAiTextImage(TextEditingController textC) async{
    setState(() {
      message.add(ChatMessage(question: textC.text.trim(), isLoading: true));

    });
    final bytes1 = await pickedFile?.readAsBytes();

    final result = await Gemini.instance.prompt(parts: [
      Part.text("What is in this image?"),
      Part.inline(
        InlineData.fromUint8List(bytes1!)
      )
    ]);

    setState(() {
      final i = message.indexWhere((message) => message.question == textC.text && message.isLoading == true);
      if (i != -1) {
        message[i].response = result?.output.toString();
        message[i].isLoading = false;
        pickedFile == null;
      }

      controller.clear();
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
              decoration: InputDecoration(hintText: 'Ask anything...'),
              style: TextStyle(color: Colors.black,),
            ),
          ),
          IconButton(onPressed: (){
            _onImageButtonPressed(context: context,ImageSource.gallery, );
          }, icon: Icon(Icons.image_outlined)),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (controller.text.trim().isNotEmpty) {
                
                pickedFile != null ?
                callAiTextImage(controller) : callAiText(controller);
              }
            },
          )
        ],
      ),
    );
  }

  List<XFile>? _mediaFileList;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value == null ? null : <XFile>[value];
  }

  dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();

  Future<void> _onImageButtonPressed(
      ImageSource source, {
        required BuildContext context,
        bool isMultiImage = false,
        bool isMedia = false,
      }) async {

    if(context.mounted){
        _displayPickImageDialog(context,
        );
    }
  }

  XFile? pickedFile;
  Future<void> _displayPickImageDialog(
      BuildContext context
      ) async {
          try {
            pickedFile = await _picker.pickImage(
              source: ImageSource.gallery,
            );
            setState(() {
              _setImageFileListFromFile(pickedFile);
            });
          } catch (e) {
            setState(() {
              _pickImageError = e;
            });
          }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                    colors: [Colors.greenAccent, Colors.white, ],
                    center: Alignment.topCenter,
                    radius: 1
                ),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(title: Text('ChatAI', style: TextStyle(
                color: Colors.white
              ),),
                backgroundColor: Colors.transparent,),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 150),
                  height: MediaQuery.of(context).size.height,

                  child: message.isEmpty ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Hello, How can I help you today?', style: TextStyle(
                              color: Colors.black, fontSize: 25
                          ),)
                        ],
                      )) : ListView.builder(
                      itemCount: message.length,
                      itemBuilder: (context , i){
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  pickedFile != null ?
                                  Image.file(File(pickedFile!.path),height: 100, ) :Container(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Bubble(
                                        child: Text(message[i].question ?? '', style: TextStyle(
                                            color: Colors.black
                                        ),textAlign: TextAlign.left,),
                                      ),],
                                  ),
                                ],
                              ),

                              message[i].isLoading ? Text('Thinking .......',
                                style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.start,):Card(
                                color: Colors.white,
                                child: Container(padding: EdgeInsets.fromLTRB(10, 20, 10 ,0),
                                  child: Row(
                                    children: [Flexible(
                                      child: Text(message[i].response ?? '', style: TextStyle(
                                          color: Colors.black
                                      ),textAlign: TextAlign.left,),
                                    ),],
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
        )

    );
  }
}


