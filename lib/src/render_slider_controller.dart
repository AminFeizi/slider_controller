import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'slider_decoration.dart';
import 'dart:ui' as ui;

///
/// Class to Render the Slider Widget.
///
class RenderSliderController extends RenderBox {
  RenderSliderController({
    required double value,
    required ValueChanged<double> onChanged,
    required ValueChanged<double>? onChangeEnd,
    required ValueChanged<double>? onChangeStart,
    required double min,
    required double max,
    required SliderDecoration sliderDecoration,
    required bool isDraggable,
  })  : _value = value,
        _onChanged = onChanged,
        _onChangeEnd = onChangeEnd,
        _onChangeStart = onChangeStart,
        _min = min,
        _max = max,
        _sliderDecoration = sliderDecoration,
        _isDraggable = isDraggable {
    if (_isDraggable) {
      /// Setting up the drag gesture for the slider widget
      _drag = HorizontalDragGestureRecognizer()
        ..onStart = (DragStartDetails details) {
          _updateSliderThumbPosition(
            details.localPosition,
            ChangeValueType.changeStart,
          );
        }
        ..onUpdate = (DragUpdateDetails details) {
          _updateSliderThumbPosition(
            details.localPosition,
            ChangeValueType.change,
          );
        }
        ..onEnd = (DragEndDetails details) {
          _onChangeEnd?.call(_value);
        };
    }
  }

  /// Getter and Setter for the slider widget to render

  /// Indicates the default slider thumb value
  /// Value is between the 0.0 to 100.0
  double get value => _value;
  double _value;

  set value(double val) {
    assert(
      val >= _min && val <= _max,
      'value should be between the min or 0.0 to max or 100.0',
    );
    if (_value == val) {
      return;
    }

    /// Setting the value and calling the paint method to render the slider widget
    _value = val;
    markNeedsPaint();
  }

  /// Called during a drag when the user is selecting a new value for the slider
  /// by dragging.
  ValueChanged<double> get onChanged => _onChanged;
  ValueChanged<double> _onChanged;

  set onChanged(ValueChanged<double> changed) {
    if (_onChanged == changed) {
      return;
    }

    /// Setting the onChanged Function and calling the paint method to render the
    /// slider widget
    _onChanged = changed;
    markNeedsPaint();
  }

  /// Called when the user is done selecting a new value for the slider.
  ValueChanged<double>? get onChangeEnd => _onChangeEnd;
  ValueChanged<double>? _onChangeEnd;

  set onChangeEnd(ValueChanged<double>? changed) {
    if (_onChangeEnd == changed) {
      return;
    }

    /// Setting the onChangeEnd Function and calling the paint method to render the
    /// slider widget
    _onChangeEnd = changed;
    markNeedsPaint();
  }

  /// Called when the user starts selecting a new value for the slider.
  ValueChanged<double>? get onChangeStart => _onChangeStart;
  ValueChanged<double>? _onChangeStart;

  set onChangeStart(ValueChanged<double>? changed) {
    if (_onChangeStart == changed) {
      return;
    }

    /// Setting the onChangeStart Function and calling the paint method to render the
    /// slider widget
    _onChangeStart = changed;
    markNeedsPaint();
  }

  /// Indicates the Minimum value for the slider
  /// If min is null then the default value 0.0 is used
  double get min => _min;
  double _min;

  set min(double val) {
    if (_min == val) {
      return;
    }

    /// Setting the value and calling the paint method to render the slider widget
    _min = val;
    markNeedsPaint();
  }

  /// Indicates the Maximum value for the slider
  /// If max is null then the default value 100.0 is used
  double get max => _max;
  double _max;

  set max(double val) {
    if (_max == val) {
      return;
    }

    /// Setting the value and calling the paint method to render the slider widget
    _max = val;
    markNeedsPaint();
  }

  /// Used to Decorate the Slider Widget
  SliderDecoration get sliderDecoration => _sliderDecoration;
  SliderDecoration _sliderDecoration;

  set sliderDecoration(SliderDecoration decoration) {
    if (_sliderDecoration == decoration) {
      return;
    }

    /// Setting the decoration and calling the paint and layout method to render the
    /// slider widget
    _sliderDecoration = decoration;
    markNeedsPaint();
    markNeedsLayout();
  }

  /// Used to Enable or Disable Drag Gesture of Slider
  bool get isDraggable => _isDraggable;
  bool _isDraggable;

  set isDraggable(bool isDrag) {
    if (_isDraggable == isDrag) {
      return;
    }

    /// Setting the Enable or Disable Behaviour of the Drag Gesture
    _isDraggable = isDrag;
    markNeedsPaint();
    markNeedsLayout();
  }

  /// Default stroke width for the painters
  final double _strokeWidth = 4.0;

  /// Left side padding for the slider thumb
  final double _thumbLeftPadding = 10.0;

  @override
  void performLayout() {
    /// Setting up the size for the slider widget
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = _sliderDecoration.height;
    final desiredSize = Size(desiredWidth, desiredHeight);
    size = constraints.constrain(desiredSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    /// Setting up the canvas to draw the slider widget
    final canvas = context.canvas;
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    /// Painter for the inactive part of slider
    final inactiveSliderPainter = Paint()
      ..color = _sliderDecoration.inactiveColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    /// Painter for the active part of slider
    final activeSliderPainter = Paint()
      ..color = _sliderDecoration.activeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    /// Painter for the slider thumb
    final thumbPainter = Paint()..color = Color(0xffDDE1E7);
    final thumbPainter2 = Paint()..color = _sliderDecoration.outerColor;

    /// Drawing the inactive part of slider
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Offset.zero & Size(constraints.maxWidth, _sliderDecoration.height),
        topRight: Radius.circular(_sliderDecoration.borderRadius),
        topLeft: Radius.circular(_sliderDecoration.borderRadius),
        bottomRight: Radius.circular(_sliderDecoration.borderRadius),
        bottomLeft: Radius.circular(_sliderDecoration.borderRadius),
      ),
      inactiveSliderPainter,
    );

    /// Drawing the active part of slider or bar from left to thumb position
    final thumbDx = ((_value - _min) / (_max - _min)) * size.width;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Offset.zero & Size(thumbDx, _sliderDecoration.height),
        topRight: Radius.circular(_sliderDecoration.borderRadius),
        topLeft: Radius.circular(_sliderDecoration.borderRadius),
        bottomRight: Radius.circular(_sliderDecoration.borderRadius),
        bottomLeft: Radius.circular(_sliderDecoration.borderRadius),
      ),
      activeSliderPainter,
    );

    if (_sliderDecoration.isThumbVisible) {
      /// Drawing the slider thumb
      final thumbDesiredDx =
          thumbDx - ((thumbDx == 0.0) ? 0 : _thumbLeftPadding * 4.2);
      final thumbDesiredDy =
          (size.height / 2.0) - (_sliderDecoration.thumbHeight / 2.0);
      final thumbCenter = Offset(thumbDesiredDx, thumbDesiredDy);
      final thumbCenter2 = Offset(
          thumbDx - ((thumbDx == 0.0) ? -25 : _thumbLeftPadding * 1.7), 25);
      canvas.drawRRect(
          RRect.fromRectAndCorners(
            thumbCenter &
                Size(_sliderDecoration.thumbWidth,
                    _sliderDecoration.thumbHeight),
            topRight: Radius.circular(_sliderDecoration.borderRadius),
            topLeft: Radius.circular(_sliderDecoration.borderRadius),
            bottomRight: Radius.circular(_sliderDecoration.borderRadius),
            bottomLeft: Radius.circular(_sliderDecoration.borderRadius),
          ),
          thumbPainter
          // ..colorFilter =ColorFilter.mode(Colors.red,BlendMode.color)
          //   ..filterQuality = FilterQuality.none
          );
      Paint paint_0_stroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.005000000;
      paint_0_stroke.shader = ui.Gradient.linear(
          thumbCenter2,
          Offset(size.width * 0.7500000, size.height * 0.9227271),
          [Colors.white.withOpacity(1), Color(0xffC0C5CD).withOpacity(1)],
          [0, 1]);
      canvas.drawCircle(thumbCenter2,
          19, paint_0_stroke);

      Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
      paint_0_fill.shader = ui.Gradient.linear(
          thumbCenter2,
          Offset(size.width * 0.7272729, size.height * 0.9500000),
          [Color(0xffF5F5F9).withOpacity(1), Color(0xffE4E8EE).withOpacity(1)],
          [0, 1]);
      canvas.drawCircle(thumbCenter2,
          19, paint_0_fill);

      Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
      paint_1_fill.shader = ui.Gradient.linear(
          thumbCenter2,
          Offset(size.width * 0.7224937, size.height * 0.8549979),
          [Color(0xffDDE1E7).withOpacity(1), Color(0xffFAFBFC).withOpacity(1)],
          [0, 1]);
      canvas.drawCircle(thumbCenter2,
         19, paint_1_fill);

    /*  canvas.drawCircle(
          thumbCenter2,
          19,
          thumbPainter2
            ..shader =
            ui.Gradient.linear(
                Offset(size.width * 0.2272729, size.height * 0.1590908),
                Offset(size.width * 0.7500000, size.height * 0.9227271),
                [Colors.white.withOpacity(1), Color(0xffC0C5CD).withOpacity(1)],
                [0, 1])
            // ui.Gradient.linear(
            //     Offset(size.width * 0.2818188, size.height * 0.05000000),
            //     Offset(size.width * 0.7272729, size.height * 0.9500000),
            //     [Color(0xffF5F5F9).withOpacity(1), Color(0xffE4E8EE).withOpacity(1)],
            //     [0, 1])
            // ui.Gradient.linear(
            //     Offset(size.width * 0.2899937, size.height * 0.1374981),
            //     Offset(size.width * 0.7224937, size.height * 0.8549979),
            //     [Color(0xffDDE1E7).withOpacity(1), Color(0xffFAFBFC).withOpacity(1)],
            //     [0, 1])
            ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 3));*/

    }

    /// Restoring the saved canvas
    canvas.restore();
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  /// Helped to Use the horizontal drag gesture for the slider
  HorizontalDragGestureRecognizer _drag = HorizontalDragGestureRecognizer();

  /// Indicates that our widget handles the gestures
  @override
  bool hitTestSelf(Offset position) => true;

  /// Handles the events
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(
      debugHandleEvent(event, entry),
      'renderer should handle the events',
    );
    if (event is PointerDownEvent) {
      _drag.addPointer(event);
    }
  }

  /// Used to update the slider thumb position
  void _updateSliderThumbPosition(
    Offset localPosition,
    ChangeValueType changeValueType,
  ) {
    /// Clamp the position between the full width of the render object
    var dx = localPosition.dx.clamp(0.0, size.width);

    /// Make the size between 0 and 1 with only 1 decimal and multiply it.
    var desiredDx = double.parse((dx / size.width).toStringAsFixed(1));
    _value = desiredDx * (_max - _min) + _min;

    switch (changeValueType) {
      case ChangeValueType.changeStart:
        _onChangeStart?.call(_value);
        break;
      case ChangeValueType.change:
        _onChanged(_value);
        break;
      case ChangeValueType.changeEnd:
        _onChangeEnd?.call(_value);
        break;
    }

    /// Calling the paint and layout method to render the slider widget
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  @override
  void detach() {
    /// Disposing the horizontal drag gesture
    _drag.dispose();
    super.detach();
  }
}

enum ChangeValueType {
  changeStart,
  change,
  changeEnd,
}

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.005000000;
    paint_0_stroke.shader = ui.Gradient.linear(
        Offset(size.width * 0.2272729, size.height * 0.1590908),
        Offset(size.width * 0.7500000, size.height * 0.9227271),
        [Colors.white.withOpacity(1), Color(0xffC0C5CD).withOpacity(1)],
        [0, 1]);
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000),
        size.width * 0.4975000, paint_0_stroke);

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.2818188, size.height * 0.05000000),
        Offset(size.width * 0.7272729, size.height * 0.9500000),
        [Color(0xffF5F5F9).withOpacity(1), Color(0xffE4E8EE).withOpacity(1)],
        [0, 1]);
    canvas.drawCircle(Offset(size.width * 0.5000000, size.height * 0.5000000),
        size.width * 0.4975000, paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.2899937, size.height * 0.1374981),
        Offset(size.width * 0.7224937, size.height * 0.8549979),
        [Color(0xffDDE1E7).withOpacity(1), Color(0xffFAFBFC).withOpacity(1)],
        [0, 1]);
    canvas.drawCircle(Offset(size.width * 0.4999938, size.height * 0.4999979),
        size.width * 0.4300000, paint_1_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
