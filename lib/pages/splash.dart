import 'package:flutter/material.dart';
import 'package:meanoji/pages/animated-wave.dart';
import 'package:meanoji/pages/gradient-background.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SplashState();
}

class SplashState extends State<Splash> {
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
            Positioned.fill(child: Text("")),
          ],
        ));
  }

  onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}
