import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:social_maps/src/models/map.dart';

import 'package:social_maps/src/screens/home_screen.dart';
import 'package:social_maps/src/screens/login_screen.dart';
import 'package:social_maps/src/screens/signup_screen.dart';
import 'package:social_maps/src/screens/welcome_screen.dart';
import 'package:social_maps/src/services/firebase_auth_service.dart';
import 'package:social_maps/src/services/firestore_database.dart';
import 'package:social_maps/src/widgets/auth_widget.dart';
import 'package:social_maps/src/widgets/auth_widget_builder.dart';
import 'package:social_maps/src/models/user.dart';

class SocialMapsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => FirebaseAuthService(),
      child: AuthWidgetBuilder(
        userProvidersBuilder: (context, user) => [
          Provider<User>.value(value: user),
        ],
        builder: (context, userSnapshot) {
          return MaterialApp(
            title: 'SocialMaps',
            home: AuthWidget(
              userSnapshot: userSnapshot,
              signedInWidgetBuilder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider(create: (_) => SocialMap()),
                  Provider(create: (_) => FirestoreDatabase()),
                ],
                child: HomeScreen(),
              ),
              notSignedInWidgetBuilder: (_) => WelcomeScreen(),
            ),
            routes: {
              LogInScreen.routeName: (context) => LogInScreen(),
              SignUpScreen.routeName: (context) => SignUpScreen(),
            },
            theme: ThemeData(
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
              buttonTheme: ButtonThemeData(
                height: 52.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
