import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../services/database_helper.dart';
import 'post_page.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final ApiService apiService = ApiService();
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<User> users = [];
  bool isNetwork = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      List<User> data;
      if (isNetwork) {
        data = await apiService.fetchUsers();
        for (var user in data) {
          await dbHelper.insertUser(user);
        }
      } else {
        data = await dbHelper.getUsers();
      }
      setState(() {
        users = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name),
            subtitle: Text(user.email),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(userId: user.id),
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
            fetchUsers();
          });
        },
      ),
    );
  }
}
