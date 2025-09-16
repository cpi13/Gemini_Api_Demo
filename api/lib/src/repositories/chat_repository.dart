import 'package:api/env/env.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  //store all the messages in a map with chatroom is as the key
  final Map<String, List<Message>> chatroom = {};

  Future<List<Message>> fetchMessage() async {
    throw UnimplementedError();
  }

  Future<Message> createUserMessage(String chatRoomId, Map<String, dynamic> data) async{
    final message = Message.fromJson(data);
    chatroom.putIfAbsent(chatRoomId, () => []); //will create chatroom means chat
    chatroom[chatRoomId]?.add(message); //will add message to the chat
    return message;
  }

  Stream<(Message, String)> createModelMessage(String chatRoomId, Map<String, dynamic> data) {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: Env.GEMINI_API_KEY);
    final messageId = Uuid().v4();

    List<Content> history = []; //store old messages in list
    for (var message in chatroom[chatRoomId]!) {
      if (message.id == data['id']) {
        //print('message already exits');
        continue;
      }
      if (message.sourceType == MesageSourceType.user) {
        history.add(Content.text(message.content));
      } else {
        history.add(Content.model([TextPart(message.content)]));
      }
    }
    final chat = model.startChat(history: history.isEmpty ? null : history);
    final content = Content.text(data['content'] as String);
    //response as stream
    return chat.sendMessageStream(content).asyncMap((response) {
      final newMessage = Message(
        id: messageId,
        content: response.text ?? '',
        sourceType: MesageSourceType.model,
        createdAt: DateTime.now(),
      );
      return _updateMessage(chatRoomId, newMessage.toJson()).then((value) {
        if (value != null) {
          chatroom[chatRoomId]?.removeWhere((element) => element.id == messageId);
          chatroom[chatRoomId]?.add(value);
          return (value, 'message.updated');
        } else {
          chatroom[chatRoomId]?.add(newMessage);
          return (newMessage, 'message.created');
        }
      });
    });
  }

  Future<Message?> _updateMessage(
      String chatroomId, Map<String, dynamic> data) async {
    if (!chatroom.containsKey(chatroomId)) {
      return null;
    }
    final messages = chatroom[chatroomId];
    final messageIndex = messages?.indexWhere((message) => message.id == data['id']);

    if (messageIndex != null && messageIndex >= 0) {
      final message = messages![messageIndex];
      final dataContent = data['content'] as String;
      final updateMessage = message.copyWith(content: message.content + dataContent);
      return updateMessage;
    } else {
      return null;
    }
  }
}
