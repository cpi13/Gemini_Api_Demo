
import 'package:api/src/middleware/chat_reository_provider.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler){
  return handler.use(requestLogger()).use(chatRepositoryProvider());
}