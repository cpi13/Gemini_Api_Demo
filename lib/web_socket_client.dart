import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

//when we recieve messages from the server that will be processed by this class & that msg will be added to the streamController
class WebSocketClient {
  IOWebSocketChannel? channel; //represent connection between client and server
  late StreamController<Map<String, dynamic>>
      messageController; //emit data event and represents messages

  WebSocketClient() {
    initializeController();
  }
  initializeController() {
    messageController = StreamController<Map<String, dynamic>>.broadcast();
  }

  void connect(String url, Map<String, String> headers) {
    if (channel != null && channel!.closeCode == null) {
      debugPrint("Already Connected");
      return;
    }
    try {
      channel = IOWebSocketChannel.connect(Uri.parse(url), headers: headers);
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      return;
    }

    channel!.stream.listen((event) {
      Map<String, dynamic> message =
          jsonDecode(event); // listen msgs coming from the server
      //this is for the first time when gemini start to answer the question
      // but whole answer will not come at a time so
      // it will provide in chunks so this for the first chunks and
      //for the incoming chunks of the naswer there is message update event
      if (message['event'] == 'message.created') {
        messageController.add(message);
      }
      if (message['event'] == 'message.updated') {
        messageController.add(message);
      }
    }, onDone: () {
      debugPrint('Disconnected');
    }, onError: (e) {
      debugPrint('Error:$e');
    });
  }

  void send(String data) {
    //send the payload to the server
    if (channel == null && channel!.closeCode != null) {
      debugPrint('Not connected');
      return;
    }
    //send data to the ws /endpoint
    print(data.runtimeType);
    channel!.sink.add(data);
  }

  //expose data steam coming from the messageController
  Stream<Map<String, dynamic>> messageUpdates() {
    return messageController.stream;
  }

  void disconnect() {
    if (channel == null && channel!.closeCode != null) {
      debugPrint('Not connected');
      return;
    }
    channel!.sink.close();
    messageController.close();
    initializeController();
  }
}
