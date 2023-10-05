// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'main.dart';
// import 'dart:convert';

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   List<Message> _messages = [];
//   final TextEditingController _messageController = TextEditingController();
//   int x = 0;
//   @override
//   void initState() {
//     super.initState();
//     channel.sink.add(json.encode({
//       "event": "pusher:subscribe",
//       "data": {"channel": "user.2"}
//     }));
//     // channel.stream.listen((event) {
//     //   print(event); // Print the raw event data (debugging)

//     //   try {
//     //     // Map<dynamic, dynamic> dataMap = json.decode(event ?? '{"userId":"43"}');
// Map<String, dynamic> dataMap = json.decode(event);

// // Access the 'data' field, which is a JSON string
// Map<String, dynamic> innerDataMap = json.decode(dataMap['data']);

// // Access the 'message' field within the inner data
// Map<String, dynamic> messageData = innerDataMap['message'];

//     //     // Access the 'content' field within the message data
//     //     String content = messageData['content'];
//     //     setState(() {
//     //       final message = Message(content, true);

//     //       _messages.add(message);
//     //     });
//     //     // Now you can use 'content' as needed
//     //     print(content);
//     //     // Now you can access the dataMap as needed
//     //     // For example, to get the 'userId' value:

//     //     // Handle the userId or other data as required
//     //   } catch (e) {
//     //     // Handle JSON parsing error
//     //     print('Error parsing JSON: $e');
//     //   }
//     //   // if (x > 1) {
//     //   //   print(event['data']);
//     //   //   Map<dynamic, dynamic> dataMap = json.decode(event ?? '{"userId":43}');

//     //   //   print(dataMap);
//     //   // final message = Message.fromJson(event);
//     //   // setState(() {
//     //   //   _messages.add(message);
//     //   // });
//     //   // }
//     //   // x++;
//     // });

//     _fetchChatHistory();
//   }

//   void _fetchChatHistory() async {
//     // Replace with actual user and receiver IDs
//     int myId = 1;
//     int receiverId = 2;

//     try {
//       final response = await http.get(
//         Uri.parse('$apiUrl/get-messages?myId=1&receiverId=2'),
//       );

//       if (response.statusCode == 200) {
//         // Parse and store the retrieved messages
//         final messagesJson = json.decode(response.body)['messages'];
//         for (var element in messagesJson) {
//           Message message = Message(element["content"], true);
//           _messages.add(message);
//         }
//         // final List<Message> messagesss = messagesJson.map((message) {
//         //   return Message(message['content'].toString(),
//         //       true); // Assuming 'content' is the message content
//         // }).toList() as List<Message>;
//         setState(() {});
//         // setState(() {
//         //   _messages.addAll(messages);
//         // });
//       } else {
//         // Handle the error response from the server
//         print('Error fetching chat history: ${response.body}');
//       }
//     } catch (e) {
//       // Handle network or other errors
//       print('Error fetching chat history: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Chat with B'),
//         ),
//         body: Column(
//           children: <Widget>[
//             StreamBuilder(
//               stream: channel.stream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   final event = snapshot.data;
//                   try {
//                     Map<String, dynamic> dataMap = json.decode(event);
//                     Map<String, dynamic> innerDataMap =
//                         json.decode(dataMap['data']);
//                     Map<String, dynamic> messageData = innerDataMap['message'];
//                     String content = messageData['content'];
//                     final message = Message(content, true);
//                     _messages.add(message);
//                     return Expanded(
//                       child: ListView.builder(
//                         itemCount: _messages.length,
//                         itemBuilder: (BuildContext context, int index) {
//                           return _buildMessage(_messages[index]);
//                         },
//                       ),
//                     );
//                     // Your message widget here;
//                   } catch (e) {
//                     print('Error parsing JSON: $e');
//                     return SizedBox();
//                     // Handle error UI;
//                   }
//                 } else if (snapshot.hasError) {
//                   print('Error in WebSocket stream: ${snapshot.error}');
//                   return SizedBox(); // Handle error UI;
//                 } else {
//                   return SizedBox(); // Loading or initial UI;
//                 }
//               },
//             ),
//             _buildMessageInput(),
//           ],
//         ),
//       ),
//     );
//   }

// Widget _buildMessage(Message message) {
//   return Align(
//     alignment:
//         message.isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
//     child: Container(
//       padding: EdgeInsets.all(8.0),
//       margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//       decoration: BoxDecoration(
//         color: message.isSentByUser ? Colors.blue : Colors.grey[300],
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Text(
//         message.text,
//         style: TextStyle(fontSize: 16.0),
//       ),
//     ),
//   );
// }

//   Widget _buildMessageInput() {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: TextField(
//               controller: _messageController,
//               decoration: InputDecoration(
//                 hintText: 'Type your message...',
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () {
//               _sendMessage();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void _sendMessage() async {
//     String text = _messageController.text.trim();
//     if (text.isNotEmpty) {
//       // Prepare the request data
//       Map<String, dynamic> requestData = {
//         'myId': 1, // Replace with the actual user ID
//         'receiverId': 2, // Replace with the actual recipient's ID
//         'content': text,
//       };

//       try {
//         final response = await http.get(
//           Uri.parse(
//               '$apiUrl/user/send-message?myId=1&receiverId=2&content=$text'),
//           // body: requestData,
//         );

//         if (response.statusCode == 200) {
//           print('sending message: ${response.body}');
//           setState(() {
//             _messages.add(Message(text, true));
//             _messageController.clear();
//           });
//         } else {
//           // Handle the error response from the server
//           print('Error sending message: ${response.body}');
//         }
//       } catch (e) {
//         // Handle network or other errors
//         print('Error sending message: $e');
//       }
//     }
//   }
// }

class MessageModel {
  final String message;
  final int user_id;
  final int chat_id;
  MessageModel(
      {required this.message, required this.user_id, required this.chat_id});
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user_id': user_id,
      'chat_id': chat_id,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      chat_id: json['chat_id'] as int,
      user_id: json['user_id'] as int,
      message: json['message'] as String,
    );
  }
}
