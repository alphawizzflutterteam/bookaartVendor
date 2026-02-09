import 'package:flutter/material.dart';

import 'auth_screen.dart';

class WaitingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/image/waiting.png"),
              // CircularProgressIndicator(),
              SizedBox(height: 20),
              Text(
                "Your account is not verified yet.\nPlease try again later.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const AuthScreen()),
                      (route) => false);
                },
                child: Text("Login Again"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
