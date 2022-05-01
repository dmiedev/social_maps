import 'package:flutter/material.dart';

import 'package:social_maps/src/screens/login_screen.dart';
import 'package:social_maps/src/screens/signup_screen.dart';
import 'package:social_maps/src/widgets/large_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                // Hero(
                //   tag: 'Logo',
                //   child: Container(
                //     child: Image.asset('images/logo.png'),
                //     height: 60.0,
                //   ),
                // ),
                Text(
                  'SocialMaps',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Hero(
              tag: 'Log In Button',
              child: LargeButton(
                color: Colors.lightBlueAccent,
                onPressed: () =>
                    Navigator.pushNamed(context, LogInScreen.routeName),
                text: 'Log In',
              ),
            ),
            Hero(
              tag: 'Sign Up Button',
              child: LargeButton(
                color: Colors.blueAccent,
                onPressed: () =>
                    Navigator.pushNamed(context, SignUpScreen.routeName),
                text: 'Sign Up',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
