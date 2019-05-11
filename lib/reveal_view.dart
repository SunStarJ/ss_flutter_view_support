import 'dart:math';

import 'package:flutter/material.dart';

class RevealAnimationView extends StatefulWidget {
  _RevealAnimationView bodyView;
  RevealPositionConfig positionType;
  Widget child;
  Duration duration;
  Offset centerPosition;

  RevealAnimationView(
      {@required this.child,
      this.positionType,
      this.duration,
      this.centerPosition});

  void revers() {
    bodyView.reversAnim();
  }

  @override
  State<StatefulWidget> createState() {
    if (bodyView == null)
      bodyView =
          _RevealAnimationView(child, positionType, duration, centerPosition);
    return bodyView;
  }
}

class _RevealAnimationView extends State<RevealAnimationView>
    with SingleTickerProviderStateMixin {
  RevealPositionConfig positionType;
  Duration duration;
  Widget child;
  AnimationController _control;
  Offset centerPosition;

  _RevealAnimationView(
      this.child, this.positionType, this.duration, this.centerPosition);

  Animation _animation;

  void reversAnim() {
    _control.animateBack(0);
  }

  @override
  void initState() {
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
        clipper: CircleRevealClipper(_animation.value, positionType,centerPosition),
      ),
    );
  }
}

class CircleRevealClipper extends CustomClipper<Rect> {
  final double revealPercent;
  RevealPositionConfig _positionType;
  Offset centerPosition;

  CircleRevealClipper(this.revealPercent, this._positionType,
      this.centerPosition);

  @override
  Rect getClip(Size size) {
    Offset epicenter;
    double theta;
    double distanceToCenter;
    if (centerPosition == null) {
      if (_positionType == null)
        _positionType = RevealPositionConfig.TOP_CENTER;
        switch (_positionType) {
          case RevealPositionConfig.TOP_LEFT:
            epicenter = Offset(size.width * 0.1, size.height * 0.1);
            theta = atan(
                (size.height - epicenter.dy) / (size.width - epicenter.dx));
            distanceToCenter = (size.height - epicenter.dy) / sin(theta);
            break;
          case RevealPositionConfig.TOP_RIGHT:
            epicenter = Offset(size.width * 0.9, size.height * 0.1);
            theta = atan((size.height - epicenter.dy) / (epicenter.dx));
            distanceToCenter = (epicenter.dy) / sin(theta);
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
            epicenter = Offset(size.width * 0.1, size.height * 0.9);
            theta = atan(epicenter.dy / (size.width - epicenter.dx));
            distanceToCenter = epicenter.dy / sin(theta);
            break;
          case RevealPositionConfig.BOTTOM_RIGHT:
            epicenter = Offset(size.width, size.height * 0.9);
            theta = atan(epicenter.dy / epicenter.dx);
            distanceToCenter = epicenter.dy / sin(theta);
            break;
          case RevealPositionConfig.BOTTOM_CENTER:
            epicenter = Offset(size.width / 2, size.height * 0.9);
            theta = atan(epicenter.dy / epicenter.dx);
            distanceToCenter = epicenter.dy / sin(theta);
            break;
        }
    } else {
      epicenter = centerPosition;
      theta = atan(max(epicenter.dy, size.height - epicenter.dy) /
          max(epicenter.dx, size.width - epicenter.dx));
      distanceToCenter =
          max(epicenter.dy, size.height - epicenter.dy) / sin(theta);
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
