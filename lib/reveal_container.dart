import 'dart:math';

import 'package:flutter/material.dart';

class RevealAnimationView extends StatefulWidget {
  _RevealAnimationView bodyView;
  RevealPositionConfig positionType;
  Widget child;
  Duration duration;

  RevealAnimationView({@required this.child, this.positionType, this.duration});

  @override
  State<StatefulWidget> createState() {
    if (bodyView == null)
      bodyView = _RevealAnimationView(child, positionType, duration);
    return bodyView;
  }
}

class _RevealAnimationView extends State<RevealAnimationView>
    with SingleTickerProviderStateMixin {
  RevealPositionConfig positionType;
  Duration duration;
  Widget child;
  AnimationController _control;

  _RevealAnimationView(this.child, this.positionType, this.duration);

  Animation _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(positionType);
    _control = AnimationController(
        duration: duration == null ? Duration(milliseconds: 500) : duration,
        vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_control)
      ..addListener(() {
        setState(() {});
      });
    _control.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipOval(
        child: child == null ? Container() : child,
        clipper: CircleRevealClipper(_animation.value, positionType),
      ),
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  RevealPositionConfig _positionType;

  CircleRevealClipper(this.revealPercent, this._positionType);

  @override
  Rect getClip(Size size) {
    Offset epicenter;
    double theta;
    double distanceToCenter;
    if (_positionType == null) _positionType = RevealPositionConfig.TOP_CENTER;
    if (_positionType != null) {
      switch (_positionType) {
        case RevealPositionConfig.TOP_LEFT:
          break;
        case RevealPositionConfig.TOP_RIGHT:
          break;
        case RevealPositionConfig.TOP_CENTER:
          epicenter = Offset(size.width / 2, size.height * 0.1);
          theta = atan((size.height - epicenter.dy) / epicenter.dx);
          distanceToCenter = (size.height - epicenter.dy) / sin(theta);
          break;
        case RevealPositionConfig.CENTER:
          epicenter = Offset(size.width / 2, size.height / 2);
          theta = atan(epicenter.dy / epicenter.dx);
          distanceToCenter = epicenter.dy / sin(theta);
          break;
        case RevealPositionConfig.BOTTOM_LEFT:
          break;
        case RevealPositionConfig.BOTTOM_RIGHT:
          break;
        case RevealPositionConfig.BOTTOM_CENTER:
          epicenter = Offset(size.width / 2, size.height * 0.9);
          theta = atan(epicenter.dy / epicenter.dx);
          distanceToCenter = epicenter.dy / sin(theta);
          break;
      }
    }

    final radius = distanceToCenter * revealPercent;
    final diameter = 2 * radius;
    return Rect.fromLTWH(
        epicenter.dx - radius, epicenter.dy - radius, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}

enum RevealPositionConfig {
  TOP_LEFT,
  TOP_RIGHT,
  TOP_CENTER,
  CENTER,
  BOTTOM_LEFT,
  BOTTOM_RIGHT,
  BOTTOM_CENTER,
}
