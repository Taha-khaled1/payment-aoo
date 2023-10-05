import 'package:flutter/material.dart';
import 'package:payment_app/users-screen.dart';

int USERID = 0;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                USERID = int.parse(value);
              },
            ),
            TextButton(
                onPressed: () {
                  if (USERID > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserScreen(),
                      ),
                    );
                  }
                },
                child: Text("go ahead"))
          ],
        ),
      ),
    );
  }
}
