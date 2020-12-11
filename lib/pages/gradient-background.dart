import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

// Create enum that defines the animated properties
enum _BgProps { color1, color2 }

class GradientBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("color1").add(Duration(seconds: 3),
          ColorTween(begin: Colors.purple[300], end: Colors.purple[800])),
      Track("color2").add(Duration(seconds: 3),
          ColorTween(begin: Color(0xffA83279), end: Colors.blue.shade600))
    ]);

    // final tween2 = MultiTween<_BgProps>()
    //   ..add(
    //       _BgProps.color1, Colors.purple[300].tweenTo(Colors.purple[800]))
    //   ..add(_BgProps.color2, Color(0xffA83279).tweenTo(Colors.blue.shade600));

    return MirrorAnimation(
      tween: tween,
      duration: tween.duration,
      builder: (context, widget, animation) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter, 
                   colors: [
               // Colors are easy thanks to Flutter's Colors class.
               Colors.purple[300],
               Colors.purple[500],
               Colors.purple[700],
               Colors.purple[800]]
              )),
        );
      },
    );
  }
}