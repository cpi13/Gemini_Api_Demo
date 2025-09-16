import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class Message extends Equatable{
  final String id;
  final String content;
  final MesageSourceType sourceType;
  final DateTime createdAt;

  const Message({required this.id,
    required this.content,
    required this.sourceType,
    required this.createdAt});

  Message copyWith({
  String? id,
  String? content,
  MesageSourceType? sourceType,
  DateTime? createdAt,
  }){
    return Message(
        id: id?? this.id,
        content: content?? this.content,
        sourceType: sourceType?? this.sourceType,
        createdAt: createdAt?? this.createdAt);
  }
  //singleton patter or when we want to have one instance only
  factory Message.fromJson(Map<String,dynamic> json,{String? id} ){
    return Message(
        id: id ?? json['id'] ?? " ",
        content: json['content'],
        sourceType: MesageSourceType.values[json['sourceType']],
        createdAt: DateTime.parse(json['createdAt']));

  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'content': content,
      'sourceType':sourceType.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  //this getter is used for object equality and hash code generation.
  List<Object?> get props => [id,content,sourceType,createdAt];

}