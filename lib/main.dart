import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payment_app/chat-screen.dart';
import 'package:payment_app/login.dart';
import 'package:payment_app/users-screen.dart';
import 'package:sadad_flutter_sdk/sadad_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

String apiUrl = 'http://10.0.2.2:8000';
late IOWebSocketChannel channel;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  channel = IOWebSocketChannel.connect(
    Uri.parse('ws://10.0.2.2:6001/app/laravelkey'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _sadadResponse = 'did not start yet';

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.post(Uri.parse('http://10.0.2.2:8000/api/user/count'));
      print(response.body);
      // if (response.statusCode == 200) {
      //   final Map<String, dynamic> data = jsonDecode(response.body);
      //   final String encryptedData = data['paymentGateway'];
      //   print(encryptedData);

      //   final key = encrypt.Key.fromUtf8(
      //       '12345678901234567890123456789012'); // Replace with your 32-byte key
      //   final iv = encrypt.IV
      //       .fromUtf8('1234567890123456'); // Replace with your 16-byte IV

      //   final encrypter =
      //       encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
      //   final decryptedData = encrypter
      //       .decrypt(encrypt.Encrypted.fromBase64(encryptedData), iv: iv);

      //   print('Decrypted Data: $decryptedData');
      // } else {
      //   print('Failed to load data');
      // }
    } catch (e) {
      print(e);
    }
  }

  // 'wss://10.0.2.2:6001',
  // Uri.parse('wss://10.0.2.2:8080'),
  // Uri.parse('wss://10.0.2.2:6001'),
  // Uri.parse('wss://10.0.2.2'),
  // Uri.parse('wss://10.0.2.2'),
  // Uri.parse('http://127.0.0.1:8000'),
  // Uri.parse('ws://echo.websocket.events'),

  // Subscribe to the "new-sale-order" channel

  int userCount = 0;

  @override
  void initState() {
    super.initState();
    channel.sink.add(json.encode({
      "event": "pusher:subscribe",
      "data": {"channel": "users"}
    }));

    // Listen for WebSocket messages
    // channel.stream.listen((message) {
    //   setState(() {
    //     print("======${json.decode(message[0])} =========");
    //     userCount++;
    //   });
    // });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  var transaction = SadadTransaction(
    email: "a3bd2llah@gmail.com",
    mobileNumber: "97431487378",
    customerId: "8432581",
    clientToken:
        "aTJROTBpbHByS3pTWDI2WXp5U2I5SnNndDhxODBZUlExWnVJRlh5REQ3cz0=", //  PUT THE OBTAINED TOKEN HERE
    transactionAmount: "10000.0",
    orderItems: [
      const SadadOrderItem(name: "top up", quantity: 1, amount: 10000)
    ],
    orderId: "123456789",
  );
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // StreamBuilder(
            //   stream: channel.stream,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       final data = snapshot.data;
            //       print('Received message: $data');
            //       return Center(
            //         child: Text(userCount.toString()),
            //       );
            //     } else if (snapshot.hasError) {
            //       print('Error occurred: ${snapshot.error}');
            //       return Center(
            //         child: Text('Error occurred: ${snapshot.error}'),
            //       );
            //     } else {
            //       return const Center(
            //         child: Text('Waiting for messages...'),
            //       );
            //     }
            //   },
            // ),

            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = json.decode(snapshot.data);
                  final event = data['event'];
                  final Map<String, dynamic> dataMap =
                      json.decode(data['data'] ?? '{"userId":43}');
                  // if (event == 'NewUserRegistered') {
                  // Handle the "NewUserRegistered" event here
                  var userId = data['data'];
                  print(
                      'New user $userId registered with ID: ${dataMap["userId"]}');
                  return Center(
                    child: Text(
                        'New user registered with ID: ${dataMap["userId"]}'),
                  );
                  // }
                }
                print('Error occurred: ${snapshot.error}');
                return Center(
                  child: Text('Error occurred: ${snapshot.error}'),
                );
              },
            ),

            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$userCount',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: () {
                // Simulate user registration
                // Replace this with your actual registration logic
                channel.sink.add('new_user_registered');
              },
              child: Text('Register New User'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var x = channel.sink.add('NewUserRegistered');
          // var y = channel.sink.add('testEvent');
          // print("object$x");
          // fetchData();

          // String result;

          // final sadadFlutterSdkPlugin = SadadFlutterSdk();

          // try {
          //   result =
          //       await sadadFlutterSdkPlugin.createTransaction(transaction) ??
          //           'null';
          // } on PlatformException {
          //   result = 'Platform Exception';
          // }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class UserCountScreen extends StatefulWidget {
//   @override
//   _UserCountScreenState createState() => _UserCountScreenState();
// }

// class _UserCountScreenState extends State<UserCountScreen> {
//   final channel = IOWebSocketChannel.connect('ws://localhost:6001');
//   int userCount = 0;

//   @override
//   void initState() {
//     super.initState();

//     // Listen for WebSocket messages
//     channel.stream.listen((message) {
//       setState(() {
//         userCount = int.tryParse(message) ?? 0;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     channel.sink.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('User Count App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Number of Users:',
//               style: TextStyle(fontSize: 20),
//             ),
//             Text(
//               '$userCount',
//               style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Simulate user registration
//                 // Replace this with your actual registration logic
//                 channel.sink.add('new_user_registered');
//               },
//               child: Text('Register New User'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
