import 'package:flutter/material.dart';

class Splash extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new SplashState();
  }
    
}

class SplashState extends State<Splash>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Meanoji"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.purple[800],
            Colors.purple[700],
            Colors.purple[600],
            Colors.purple[400],
          ],
          )
        ),
      ),
    );
  }
  
}