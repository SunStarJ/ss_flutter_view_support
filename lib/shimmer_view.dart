import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Shimmer extends StatefulWidget {
  final Widget child;
  final Duration period;
  final Gradient gradient;

  Shimmer(Key key, this.child, this.period, this.gradient) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: widget.period)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _ShimmerView(
      child: widget.child,
      pintGradient: widget.gradient,
      percent: controller.value,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
}

class _ShimmerView extends SingleChildRenderObjectWidget {
  final Gradient pintGradient;
  final double percent;

  _ShimmerView(
      {@required Widget child,
      @required this.pintGradient,
      @required this.percent})
      : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    // TODO: implement createRenderObject
    return _ShimmerFilter(percent, pintGradient);
  }

  @override
  void updateRenderObject(BuildContext context, _ShimmerFilter shimmer) {
    shimmer.percent = percent;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  final _clearPaint = Paint();
  final Paint _gradientPaint;
  final Gradient _gradient;
  double _percent;

  _ShimmerFilter(this._percent, this._gradient)
      : _gradientPaint = Paint()..blendMode = BlendMode.srcIn;

  set percent(double newValue) {
    if (newValue != _percent) {
      _percent = newValue;
      markNeedsPaint();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);
      final width = child.size.width;
      final height = child.size.height;
      Rect rect;
      double dx, dy;

      dx = _offset(-width, width, _percent);
      dy = 0.0;
      rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);

      _gradientPaint.shader = _gradient.createShader(rect);

      context.canvas.saveLayer(offset & child.size, _clearPaint);
      context.paintChild(child, offset);
      context.canvas.translate(dx, dy);
      context.canvas.drawRect(rect, _gradientPaint);
      context.canvas.restore();
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
