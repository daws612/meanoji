import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'animated-wave.dart';
import 'emoji-details.dart';
import 'gradient-background.dart';
import 'signup-dialog.dart';
import 'package:meanoji/services/meanoji-shared-preferences.dart';

class Splash extends StatefulWidget {
  Splash({Key key, this.analytics, this.observer}) : super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<StatefulWidget> createState() => new SplashState();
}

class SplashState extends State<Splash> {
  final formKey = new GlobalKey<FormState>();
  String username, email;

  @override
  void initState() {
    super.initState();
    onLoad(context);
  }

  @override
  Widget build(BuildContext context) {
    double pi = 3.142;

    return new Scaffold(
        appBar: AppBar(
          title: Text("Meanoji"),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(child: GradientBackground()),
            onBottom(AnimatedWave(
              height: 180,
              speed: 1.0,
            )),
            onBottom(AnimatedWave(
              height: 120,
              speed: 0.9,
              offset: pi,
            )),
            onBottom(AnimatedWave(
              height: 220,
              speed: 1.2,
              offset: pi / 2,
            )),
            Positioned.fill(
                child: Container(
                    height: 618,
                    width: 618,
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: <Widget>[
                        new Image(
                          //parte importante, definire gli asset per trovarli più velocemnte
                          //si inseriscono nel pubspec.yaml
                          image: new AssetImage('openmoji618/1F60A.png'),
                        ),
                        Text(
                          'Welcome!',
                          style: TextStyle(fontSize: 40, color: Colors.yellow),
                        ),
                      ],
                    ))),
          ],
        ));
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  void onLoad(BuildContext context) async {
    openEmojiDetailsFuture().then((value) {
      Future<String> username = MeanojiPreferences.getUserName();
      username.then((value) {
        if (value != null)
          Navigator.pushReplacement(context, _createRoute(true));
        else
          showSignupDialog(context, true);
      });

      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => EmojiDetails()));
      // Navigator.of(context).push(_createRoute());
    }, onError: (error) {
      print(error);
    }).timeout(Duration(seconds: 6), onTimeout: () {
      print('6 secs timed out'); //TODO run tests for this
    });
  }

  void enterAppFromDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushReplacement(context, _createRoute(true));
  }

  Future<bool> openEmojiDetailsFuture() async {
    await Future.delayed(Duration(seconds: 5));
    return true;
  }

  Route _createRoute(bool hasUsername) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          hasUsername ? EmojiDetails() : showSignupDialog(context, true),
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

  static Future showSignupDialog(BuildContext context, bool onSplash) {
    return showGeneralDialog(
      context: context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      barrierDismissible: true,
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Align(
          alignment: Alignment.center,
          child: Card(
            child: SignupDialogContent(isOnSplash: onSplash),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return ScaleTransition(
          alignment: Alignment.bottomCenter, // add this
          scale: anim,
          child: child,
        );
      },
    );
    // return showGeneralDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    //   barrierColor: Colors.black.withOpacity(0.2),
    //   transitionDuration: const Duration(milliseconds: 1000),
    //   transitionBuilder: (context, a1, a2, widget) {
    //     return Padding(
    //         padding: EdgeInsets.fromLTRB(50, 250, 50, 310),
    //         child: Card(
    //             shape: RoundedRectangleBorder(
    //               side: BorderSide(color: Colors.white70, width: 1),
    //               borderRadius: BorderRadius.circular(15),
    //             ),
    //             elevation: 3,
    //             child: Center(
    //               child: SignupDialogContent(isOnSplash: onSplash),
    //             )));
    //   },
    //   pageBuilder: (BuildContext context, Animation animation,
    //       Animation secondaryAnimation) {},
    // );
  }
}
