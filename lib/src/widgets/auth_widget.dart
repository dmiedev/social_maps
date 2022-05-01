import 'package:flutter/material.dart';

import 'package:social_maps/src/models/user.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({
    this.userSnapshot,
    this.signedInWidgetBuilder,
    this.notSignedInWidgetBuilder,
  });

  final AsyncSnapshot<User> userSnapshot;
  final WidgetBuilder signedInWidgetBuilder;
  final WidgetBuilder notSignedInWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData
          ? signedInWidgetBuilder(context)
          : notSignedInWidgetBuilder(context);
    } else {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
