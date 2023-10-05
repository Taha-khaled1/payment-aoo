import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payment_app/login.dart';
import 'chat-screen.dart';
import 'main.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final int ChatId;

  ChatScreen({required this.ChatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<MessageModel> _messages = [];
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    int chatId = widget.ChatId;
    fetchOldMessages();
    channel.sink.add(json.encode({
      "event": "pusher:subscribe",
      "data": {"channel": "chat.$chatId"}
    }));
    // Add a listener to receive incoming messages from the WebSocket
    channel.stream.listen((message) async {
      print("================================================");
      try {
        Map<String, dynamic> dataMap = json.decode(message);

        // Access the 'data' field, which is a JSON string
        Map<String, dynamic> innerDataMap = json.decode(dataMap['data']);

        // Access the 'message' field within the inner data
        Map<String, dynamic> messageData = innerDataMap['message'];

        setState(() {
          _messages.insert(
            0,
            MessageModel(
              message: messageData['message'],
              user_id: messageData['user_id'],
              chat_id: messageData['chat_id'],
            ),
          );
          // add();
          print("================================================");
          _scrollController.animateTo(
            0,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeOut,
          );
        });
      } catch (e) {
        print("=======================$e=========================");
      }
    });
  }

// https://chat.openai.com/c/dcca46c0-4f61-45de-ab66-ba3c2b00346f
// Function to send a message
  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      try {
        final MessageData = {
          "event":
              "ChatMessageEvent", // Replace with the actual event name your Laravel server expects
          "data": {
            "message": {
              "user_id": 1, // Replace with the sender's user ID
              "chat_id": 1,
              "message": message,
              // Add other message properties as needed
            }
          }
        };
        channel.sink.add(jsonEncode(MessageData));

        final response = await http.get(
          Uri.parse(
            '$apiUrl/chats/send?user_id=$USERID&chatId=${widget.ChatId}&message=$message',
          ),
          // Replace with the actual endpoint
          // body: {
          //   'message': message,
          //   'chat_id': 'YOUR_CHAT_ID'
          // }, // Replace with the chat ID
        );

        if (response.statusCode == 200) {
          print('Message sent successfully.');
        } else {
          print('Failed to send message.');
        }
      } catch (e) {
        print(e);
      }

      // Send the message to your Laravel API

      _messageController.clear();
    }
  }

// Function to fetch old messages
  void fetchOldMessages() async {
    final response = await http.get(
      Uri.parse(
          '$apiUrl/chats/show?user_id=$USERID&chatId=${widget.ChatId}'), // Replace with the actual endpoint and chat ID
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> messages = data['messages'];
      for (var element in messages) {
        final massg = MessageModel(
          message: element['message'],
          user_id: element['user_id'],
          chat_id: element['chat_id'],
        );
        _messages.add(massg);
      }
      setState(() {
        // _messages.addAll(messages.map((message) => message['message']));
      });
    } else {
      print('Failed to fetch old messages.');
    }
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ChatId ${widget.ChatId}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: buildMessage(
                    _messages[index],
                  ), // Text(_messages[index].message),
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            onChanged: (text) {
              // Handle input changes if needed
            },
            // onSubmitted: _sendMessage,
            decoration: InputDecoration.collapsed(
              hintText: 'Send a message',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            // print(_messageController.value);
            _sendMessage(_messageController.text);
            // final fakeMessage = {
            //   "event":
            //       "ChatMessageEvent", // Replace with the actual event name your Laravel server expects
            //   "data": {
            //     "message": {
            //       "user_id": 1, // Replace with the sender's user ID
            //       "chat_id": 1,
            //       "message": "messageText",
            //       // Add other message properties as needed
            //     }
            //   }
            // };
            // try {
            //   channel.sink.add(jsonEncode(fakeMessage));
            // } catch (e) {
            //   print(e);
            // }
          },
        ),
      ],
    );
  }
} // _sendMessage(_messageController.text);

Widget buildMessage(MessageModel message) {
  print("${message.user_id} object $USERID");
  return Align(
    alignment: message.user_id == USERID
        ? Alignment.centerRight
        : Alignment.centerLeft,
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: message.user_id == USERID
            ? Colors.blue
            : const Color.fromARGB(255, 210, 0, 0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        message.message,
        style: TextStyle(fontSize: 16.0),
      ),
    ),
  );
}
