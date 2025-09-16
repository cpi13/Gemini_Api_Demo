import 'package:flutter/material.dart';
import 'package:gemini_demo/color.dart';
import 'package:models/models.dart';

class MessageCard extends StatelessWidget {
  final Message msg;
  const MessageCard({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final size = MediaQuery.of(context).size;

    final color = msg.sourceType == MesageSourceType.user ? primary : secondary;

    final alignment = msg.sourceType == MesageSourceType.user
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    final avatar = CircleAvatar(
        backgroundColor: color,
        child: Text(
          msg.sourceType == MesageSourceType.user ? 'U ' : 'M',
          style: textTheme.bodyLarge,
        ));

    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (msg.sourceType == MesageSourceType.model) avatar,
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: size.width * 0.6),
          child: Text(msg.content),
        ),
        if (msg.sourceType == MesageSourceType.user) avatar,
      ],
    );
  }
}
