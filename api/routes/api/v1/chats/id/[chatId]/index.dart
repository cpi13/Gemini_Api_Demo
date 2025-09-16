import 'dart:io';

import'package:dart_frog/dart_frog.dart';

 Response onRequest(RequestContext context,String chatId){
  if(context.request.method!= HttpMethod.get){
    return Response(
      statusCode: HttpStatus.methodNotAllowed,
      body: 'Only Get request are allowed',
    );
  }
  return _get(context);
 }
 Response _get(context){
   return Response(body: "Welcome to dart Frog");
 }