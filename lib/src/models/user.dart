import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';

@immutable
class User {
  const User({
    @required this.uid,
    this.email,
    this.displayName,
  }) : assert(uid != null);

  final String uid;
  final String email;
  final String displayName;

  factory User.fromFirebaseUser(FirebaseUser user) {
    if (user == null) return null;
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }
}
