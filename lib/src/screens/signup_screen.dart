import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'package:social_maps/src/constants.dart';
import 'package:social_maps/src/services/firebase_auth_service.dart';
import 'package:social_maps/src/widgets/large_button.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _progressIndicatorIsShown = false;
  String _formErrorCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _progressIndicatorIsShown,
        opacity: 0.5,
        color: Colors.white,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Hero(
                  //   tag: 'Logo',
                  //   child: Container(
                  //     height: 200.0,
                  //     child: Image.asset('images/logo.png'),
                  //   ),
                  // ),
                  SizedBox(
                    height: 48.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          textAlign: TextAlign.center,
                          decoration:
                              getInputDecoration(color: Colors.blueAccent)
                                  .copyWith(labelText: 'Email'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email';
                            }
                            switch (_formErrorCode) {
                              case FirebaseAuthErrors.invalidEmail:
                              case FirebaseAuthErrors.emailAlreadyInUse:
                                return FirebaseAuthErrors.getErrorMessage(
                                    _formErrorCode);
                                break;
                              default:
                                return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          decoration:
                              getInputDecoration(color: Colors.blueAccent)
                                  .copyWith(labelText: 'Password'),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter password';
                            }
                            if (_formErrorCode ==
                                FirebaseAuthErrors.weakPassword) {
                              return FirebaseAuthErrors.getErrorMessage(
                                  _formErrorCode);
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Hero(
                    tag: 'Sign Up Button',
                    child: Builder(
                      builder: (context) => LargeButton(
                        color: Colors.blueAccent,
                        onPressed: () {
                          _formErrorCode = null;
                          if (_formKey.currentState.validate())
                            _signUp(context);
                        },
                        text: 'Sign Up',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      setState(() => _progressIndicatorIsShown = true);
      await Provider.of<FirebaseAuthService>(context, listen: false)
          .createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on PlatformException catch (e) {
      _handleAuthException(e, context);
      setState(() => _progressIndicatorIsShown = false);
    }
  }

  void _handleAuthException(PlatformException e, BuildContext context) {
    switch (e.code) {
      case FirebaseAuthErrors.invalidEmail:
      case FirebaseAuthErrors.weakPassword:
      case FirebaseAuthErrors.emailAlreadyInUse:
        Scaffold.of(context).hideCurrentSnackBar();
        _formErrorCode = e.code;
        _formKey.currentState.validate();
        break;
      case FirebaseAuthErrors.networkRequestFailed:
        _showSnackBar(
          FirebaseAuthErrors.getErrorMessage(e.code),
          context,
        );
        break;
      default:
        _showSnackBar('An exception occurred: $e.', context);
        break;
    }
  }

  void _showSnackBar(String message, BuildContext context) {
    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(seconds: 10),
        ),
      );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
