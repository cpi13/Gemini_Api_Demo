import 'dart:async';
import 'dart:convert';
import 'package:gemini_demo/web_socket_client.dart';
import 'package:models/models.dart';

class ChatRepository {
  // final ApiClient apiClient;
  StreamSubscription? _messageSubscription;
  final WebSocketClient webSocketClient;
  ChatRepository({required this.webSocketClient});

  //create message from the client side
  Future<void> createMessages(Message message) async {
    //send from the client to the backend server
    final payload = {
      'event': 'message.created',
      'data': message.toJson(),
    };
    webSocketClient.send(jsonEncode(payload));
  }

  //here we will start to listen to the stream of data that come from the stream controller in websocket client
  void subscribeToMessageUpdates(
      void Function(Map<String, dynamic> message) onMessageRecived) {
    _messageSubscription = webSocketClient.messageUpdates().listen((message) {
      onMessageRecived(
          message); //this is the abstract function its implementation is in chatscreen that what should do after getting msg
    });
  }

  void unsubscribeFromMessageUpdates() {
    _messageSubscription!.cancel();
    _messageSubscription = null;
  }
}
