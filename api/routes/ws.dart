import 'dart:convert';
import 'package:api/src/repositories/chat_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final chatRepository = context.read<ChatRepository>();
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
     if(message is! String){
       channel.sink.add('Invalid Message');
       return ;
     }
     try{
       Map<String,dynamic> messageJson =json.decode(message) as Map<String,dynamic>;
       final event = messageJson['event'];
       final data = messageJson['data'] as Map<String,dynamic>;


       switch(event){
         case 'message.created':
           final chatroomId = '1';
           chatRepository.createUserMessage(chatroomId,data).then((value) {
             final responseStream = chatRepository.createModelMessage(chatroomId, data);

             responseStream.listen((data) {
               final modelMessage = data.$1;
               final eventType = data.$2;

                //From server to Client
               channel.sink.add(
                 json.encode(
                   {
                    'event' : eventType,
                    'data':modelMessage.toJson(),
                   }
                 ),
               );
             });
              return;
           });
           break;
         default:
       }
     }
     catch(err){
      print(err.toString());
     }
    });

  });
  return handler(context);
}
Middleware? chatProvider(){return null;}
