import 'package:covid19/display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main()=>runApp(Home());
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Display(),
    );
  }
}