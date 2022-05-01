import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'package:social_maps/src/models/user.dart';
import 'package:social_maps/src/services/firebase_auth_service.dart';

class AuthWidgetBuilder extends StatelessWidget {
  const AuthWidgetBuilder({
    @required this.builder,
    @required this.userProvidersBuilder,
  })  : assert(builder != null),
        assert(userProvidersBuilder != null);

  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;
  final List<SingleChildWidget> Function(BuildContext, User)
      userProvidersBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Provider.of<FirebaseAuthService>(context, listen: false)
          .onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: userProvidersBuilder(context, snapshot.data),
            child: builder(context, snapshot),
          );
        }
        return builder(context, snapshot);
      },
    );
  }
}
