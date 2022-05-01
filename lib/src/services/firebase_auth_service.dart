import 'package:firebase_auth/firebase_auth.dart';

import 'package:social_maps/src/models/user.dart';

class FirebaseAuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((firebaseUser) => User.fromFirebaseUser(firebaseUser));
  }

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return User.fromFirebaseUser(authResult.user);
  }

  Future<User> signInWithEmailAndPassword(
      {String email, String password}) async {
    final authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return User.fromFirebaseUser(authResult.user);
  }

  Future<User> createUserWithEmailAndPassword(
      {String email, String password}) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return User.fromFirebaseUser(authResult.user);
  }

  Future<void> sendPasswordResetEmail({String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return User.fromFirebaseUser(user);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

class FirebaseAuthErrors {
  static const invalidEmail = 'ERROR_INVALID_EMAIL';
  static const weakPassword = 'ERROR_WEAK_PASSWORD';
  static const emailAlreadyInUse = 'ERROR_EMAIL_ALREADY_IN_USE';
  static const networkRequestFailed = 'ERROR_NETWORK_REQUEST_FAILED';
  static const wrongPassword = 'ERROR_WRONG_PASSWORD';
  static const userNotFound = 'ERROR_USER_NOT_FOUND';
  static const userDisabled = 'ERROR_USER_DISABLED';
  static const tooManyRequests = 'ERROR_TOO_MANY_REQUESTS';
  static const operationNotAllowed = 'ERROR_OPERATION_NOT_ALLOWED';

  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case invalidEmail:
        return 'Invalid email';
        break;
      case weakPassword:
        return 'Weak password';
        break;
      case emailAlreadyInUse:
        return 'Email already in use. Try to log in!';
        break;
      case networkRequestFailed:
        return 'Network request failed. Check your Internet connection!';
        break;
      case wrongPassword:
        return 'Wrong password';
        break;
      case userNotFound:
        return 'No account was registered with this email address';
        break;
      case userDisabled:
        return 'This account has been disabled.';
        break;
      case tooManyRequests:
        return 'There was too many attempts to log in. Try again later!';
        break;
      case operationNotAllowed:
        return 'App email-password login function is disabled. Contact us.';
        break;
      default:
        return 'An error occurred: $errorCode';
        break;
    }
  }
}
