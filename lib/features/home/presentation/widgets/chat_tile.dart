import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  final String name;
  const ChatTile({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 30, child: Text(name[0].toUpperCase())),
              SizedBox(width: 10),
              Text(name, style: TextStyle(fontSize: 25)),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
