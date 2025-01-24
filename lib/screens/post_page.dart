import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import 'post_details_page.dart';

class PostPage extends StatefulWidget {
  final int userId;

  PostPage({required this.userId});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Post> posts = [];
  bool isNetwork = true;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      List<Post> data;
      if (isNetwork) {
        data = await apiService.fetchPosts(widget.userId);
        for (var post in data) {
          await dbHelper.insertPost(post);
        }
      } else {
        data = await dbHelper.getPosts(widget.userId);
      }
      setState(() {
        posts = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return ListTile(
            title: Text(post.title),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailsPage(post: post),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: 'Network'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'Local'),
        ],
        currentIndex: isNetwork ? 0 : 1,
        onTap: (index) {
          setState(() {
            isNetwork = index == 0;
            fetchPosts();
          });
        },
      ),
    );
  }
}
