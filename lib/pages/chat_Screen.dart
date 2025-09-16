import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';
import '../color.dart';
import '../main.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  //store message to send to chatroom and also the response of the ai;
  List<Message> messages = [];

  @override
  void initState(){
    _startWebSocket();
    chatRepository.subscribeToMessageUpdates((message) {
      //updated message
      if(message['event'] == 'message.updated'){
        final updatedMessage = Message.fromJson(message['data']);
        setState(() {
          messages = messages.map((message) {
            if(message.id == updatedMessage.id){
              return updatedMessage;
            }
            return message;
          }).toList();
        });
        return;
      }
      
      //new message
      final newMessage = Message.fromJson(message['data']);
      setState(() {
        messages.add(newMessage);
      });
    });
    super.initState();
  }
  _startWebSocket(){
    webSocketClient.connect(
      'ws://10.48.128.1:8082/ws',
      {
        'Authorization': 'Bearer....',
      },
    );
  }
  Future<void> _createMessages(Message msg) async{
    await chatRepository.createMessages(msg);
  }
  @override
  Widget build(BuildContext context) {
    final texttheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
         backgroundColor: Colors.grey.shade200,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            text: "Build with ",
            style: texttheme.titleLarge!.copyWith(color: Colors.black),
            children:[
              TextSpan(
                text: "Gemini",
                style: texttheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primary,
                )
              )
            ]
          ),
        )
          .animate(onComplete: (controller) => controller.repeat()
        )
          .shimmer(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 2000)
        )
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                itemCount: messages.length,
                  itemBuilder: (context,index){
                  final message = messages[index];
                    return MessageCard(msg: message,);
                  }),
            ),
            Padding(
              padding:  const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(14),
                      hintText: 'Type a message',
                      fillColor: Colors.grey,
                      hintStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(100)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(color: Colors.black)
                      )
                    ),
                  )),
                  IconButton(onPressed: (){
                    final message1 = Message(
                        id: const Uuid().v4(),
                        content: controller.text,
                        sourceType: MesageSourceType.user,
                        createdAt: DateTime.now());
                    _createMessages(message1);
                    setState(() {
                      messages.add(message1);
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                    controller.clear();
                  }, icon: const Center(child: Icon(Icons.send)),iconSize: 33,),
                ],
              ),
            ),
          ],
        ),
    );
  }
}
