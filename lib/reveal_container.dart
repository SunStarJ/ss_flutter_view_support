import 'dart:math';

import 'package:flutter/material.dart';

class RevealAnimationView extends StatefulWidget {
  _RevealAnimationView bodyView;
  int positionType = RevealPositionConfig.BOTTOM_CENTER;
  Widget child;

  RevealAnimationView({@required this.child, this.positionType});

  @override
  State<StatefulWidget> createState() {
    if (bodyView == null) bodyView = _RevealAnimationView(child, positionType);
    return bodyView;
  }
}

class _RevealAnimationView extends State<RevealAnimationView>  with SingleTickerProviderStateMixin{
  int positionType;

  Widget child;
  AnimationController _control;
  _RevealAnimationView(this.child, this.positionType);
  Animation _animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(positionType);
    _control = AnimationController(duration:Duration(milliseconds: 500),vsync: this);
    _animation = Tween(begin: 0.0,end: 1.0).animate(_control)..addListener((){
      setState(() {

      });
    });
    _control.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipOval(
        child: child == null ? Container() : child,
        clipper:CircleRevealClipper(_animation.value, positionType),
      ),
    );
  }
}


class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  int _positionType;

  CircleRevealClipper(this.revealPercent, this._positionType);

  @override
  Rect getClip(Size size) {
    if(_positionType == null) _positionType = RevealPositionConfig.BOTTOM_CENTER;
    if (_positionType == RevealPositionConfig.BOTTOM_CENTER) {
      final epicenter = Offset(size.width / 2, size.height * 0.9);
      double theta = atan(epicenter.dy / epicenter.dx);
      final distanceToCenter = epicenter.dy / sin(theta);
      final radius = distanceToCenter * revealPercent;
      final diameter = 2 * radius;
      return Rect.fromLTRB(
          epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
    }
    return null;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}


class RevealPositionConfig {
  static final int TOP_LEFT = 0;
  static final int TOP_RIGHT = 1;
  static final int TOP_CENTER = 2;
  static final int CENTER = 3;
  static final int BOTTOM_LEFT = 4;
  static final int BOTTOM_RIGHT = 5;
  static final int BOTTOM_CENTER = 6;
}
