import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';
import 'package:payment_app/massgeScreen.dart';

import 'login.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: fetchUsersData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> data = json.decode(snapshot.data!.body);
            return ListView.builder(
              itemCount: data['chats'].length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          ChatId: int.parse(
                            data['chats'][index]['id'].toString(),
                          ),
                        ),
                      ),
                    );
                  },
                  child: ChatWidget(
                    name: "${data['chats'][index]['name']}",
                    lastMessage:
                        "${data['chats'][index]['last_message']['message']}",
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Future<Response> fetchUsersData() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/chats?user_id=$USERID'));
  return response;
}

class ChatWidget extends StatelessWidget {
  final String name;
  final String lastMessage;

  const ChatWidget({
    required this.name,
    required this.lastMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            lastMessage,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
