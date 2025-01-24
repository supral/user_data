import 'package:flutter/material.dart';
import '../models/models.dart';

class PostTile extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  PostTile({required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(post.title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
