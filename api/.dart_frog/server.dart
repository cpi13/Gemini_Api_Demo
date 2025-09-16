// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, implicit_dynamic_list_literal

import 'dart:io';

import 'package:dart_frog/dart_frog.dart';


import '../routes/ws.dart' as ws;
import '../routes/api/v1/chats/id/[chatId]/index.dart' as api_v1_chats_id_$chat_id_index;

import '../routes/_middleware.dart' as middleware;

void main() async {
  final address = InternetAddress.tryParse('') ?? InternetAddress.anyIPv6;
  final port = int.tryParse(Platform.environment['PORT'] ?? '8082') ?? 8082;
  hotReload(() => createServer(address, port));
}

Future<HttpServer> createServer(InternetAddress address, int port) {
  final handler = Cascade().add(buildRootHandler()).handler;
  return serve(handler, address, port);
}

Handler buildRootHandler() {
  final pipeline = const Pipeline().addMiddleware(middleware.middleware);
  final router = Router()
    ..mount('/api/v1/chats/id/<chatId>', (context,chatId,) => buildApiV1ChatsId$chatIdHandler(chatId,)(context))
    ..mount('/', (context) => buildHandler()(context));
  return pipeline.addHandler(router);
}

Handler buildApiV1ChatsId$chatIdHandler(String chatId,) {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/', (context) => api_v1_chats_id_$chat_id_index.onRequest(context,chatId,));
  return pipeline.addHandler(router);
}

Handler buildHandler() {
  final pipeline = const Pipeline();
  final router = Router()
    ..all('/ws', (context) => ws.onRequest(context,));
  return pipeline.addHandler(router);
}

