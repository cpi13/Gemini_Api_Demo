import 'package:flutter/material.dart';
import 'package:gemini_demo/pages/chat_Screen.dart';
import 'package:gemini_demo/repos/chat_repository.dart';
import 'package:gemini_demo/web_socket_client.dart';

void main() async {
  runApp(const MyApp());
}

final webSocketClient = WebSocketClient(); //global instance
final chatRepository = ChatRepository(webSocketClient: webSocketClient);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: 'OpenSans',
            primaryColor: Colors.deepPurple.shade300),
        home: const ChatScreen());
  }
}
