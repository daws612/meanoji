import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:meanoji/pages/emoji-details.dart';
import 'package:meanoji/services/firebase-service.dart';

class SignupDialogContent extends StatefulWidget {
  SignupDialogContent({Key key, this.isOnSplash}) : super(key: key);
  final bool isOnSplash;

  @override
  _SignupDialogContentState createState() => new _SignupDialogContentState();
}

class _SignupDialogContentState extends State<SignupDialogContent> {
  TapGestureRecognizer _skipRecognizer;
  String username, email;

  bool _displayError = false;

  @override
  void initState() {
    super.initState();
    _skipRecognizer = TapGestureRecognizer()
      ..onTap = () {
        enterAppFromDialog(context);
      };
  }

  _getContent() {
    return Container(
      // width: MediaQuery.of(context).size.width - 100,
      // height: MediaQuery.of(context).size.height - 500,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      // color: Colors.white,
      child: Form(
          child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        children: [
          Text(
            'Create your avatar',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 15),
          ),
          showError(),
          showUsernameInput(),
          showEmailInput(),
          showLoginSignupButton(context),
          showSkipPrompt()
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getContent();
  }

  Widget showError() {
    return _displayError
        ? Text(
            'There was an error saving your details. Please try again later.',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          )
        : Text('');
  }

  Widget showUsernameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        color: Color(0xfff5f5f5),
        child: TextField(
          maxLines: 1,
          autofocus: false,
          style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
              prefixIcon: Icon(Icons.person_outline),
              labelStyle: TextStyle(fontSize: 15)),
          onChanged: (value) {
            username = value;
          },
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        color: Color(0xfff5f5f5),
        child: TextField(
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          style: TextStyle(color: Colors.black, fontFamily: 'SFUIDisplay'),
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              prefixIcon: Icon(Icons.mail_outline),
              labelStyle: TextStyle(fontSize: 15)),
          onChanged: (value) {
            email = value;
          },
        ),
      ),
    );
  }

  Widget showLoginSignupButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: MaterialButton(
        onPressed: () {
          _createUser(context);
        },
        child: Text(
          'Start',
          style: TextStyle(
              fontSize: 15,
              fontFamily: 'SFUIDisplay',
              fontWeight: FontWeight.bold),
        ),
        color: Colors.purple,
        elevation: 0,
        minWidth: 400,
        height: 50,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget showSkipPrompt() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Center(
        child: RichText(
          text: TextSpan(
              text: "Skip",
              style: TextStyle(
                  fontFamily: 'SFUIDisplay', color: Colors.black, fontSize: 15),
              recognizer: _skipRecognizer),
        ),
      ),
    );
  }

  void _createUser(BuildContext context) {
    FirebaseService().saveUser(username, email).then((success) {
      if (success)
        enterAppFromDialog(context);
      else //TODO not validating form
        setState(() {
          _displayError = true;
        });
    });
  }

  void enterAppFromDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
    if (widget.isOnSplash)
      Navigator.pushReplacement(context, _createRoute(true));
  }

  Route _createRoute(bool hasUsername) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EmojiDetails(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
