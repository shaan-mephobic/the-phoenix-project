import 'package:flutter/material.dart';
import 'dart:math' as math;

Duration _kUnconfirmedSplashDuration = const Duration(milliseconds: 250);
Duration _kSplashFadeDuration = const Duration(milliseconds: 180);

const double _kSplashInitialSize = 0.0; // logical pixels
const double _kSplashConfirmedVelocity = 50.0;

class CustomSplashFactory extends InteractiveInkFeatureFactory {
  const CustomSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required TextDirection textDirection,
    ShapeBorder? customBorder,
    required Color color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return CustomRipple(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      radius: radius,
      onRemoved: onRemoved,
    );
  }
}

class CustomRipple extends InteractiveInkFeature {
  /// Used to specify this type of ink splash for an [InkWell], [InkResponse]
  /// or material [Theme].
  static const InteractiveInkFeatureFactory splashFactory =
      CustomSplashFactory();

  /// Begin a splash, centered at position relative to [referenceBox].
  ///
  /// The [controller] argument is typically obtained via
  /// `Material.of(context)`.
  ///
  /// If `containedInkWell` is true, then the splash will be sized to fit
  /// the well rectangle, then clipped to it when drawn. The well
  /// rectangle is the box returned by `rectCallback`, if provided, or
  /// otherwise is the bounds of the [referenceBox].
  ///
  /// If `containedInkWell` is false, then `rectCallback` should be null.
  /// The ink splash is clipped only to the edges of the [Material].
  /// This is the default.
  ///
  /// When the splash is removed, `onRemoved` will be called.
  CustomRipple({
    required MaterialInkController controller,
    required super.referenceBox,
    Offset? position,
    required Color color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    double? radius,
    super.onRemoved,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _targetRadius = radius ??
            _getTargetRadius(
                referenceBox, containedInkWell, rectCallback, position),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _repositionToReferenceBox = !containedInkWell,
        super(
            controller: controller,
            color: color) {
    _radiusController =  AnimationController(
        duration: _kUnconfirmedSplashDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _radius = Tween<double>(begin: _kSplashInitialSize, end: _targetRadius)
        .animate(_radiusController!);
    _alphaController = AnimationController(
        duration: _kSplashFadeDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _alpha =
        IntTween(begin: color.alpha, end: 0).animate(_alphaController!);

    controller.addInkFeature(this);
  }

  final Offset? _position;
  final BorderRadius _borderRadius;
  final double _targetRadius;
  final RectCallback? _clipCallback;
  final bool _repositionToReferenceBox;

  late Animation<double> _radius;
  AnimationController? _radiusController;

  late Animation<int> _alpha;
  AnimationController? _alphaController;

  @override
  void confirm() {
    final int duration = (_targetRadius / _kSplashConfirmedVelocity).floor();
    _radiusController!
      ..duration = Duration(milliseconds: duration)
      ..forward();
    _alphaController!.forward();
  }

  @override
  void cancel() {
    _alphaController?.forward();
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) dispose();
  }

  @override
  void dispose() {
    _radiusController!.dispose();
    _alphaController!.dispose();
    _alphaController = null;
    super.dispose();
  }

  RRect _clipRRectFromRect(Rect rect) {
    return RRect.fromRectAndCorners(
      rect,
      topLeft: _borderRadius.topLeft,
      topRight: _borderRadius.topRight,
      bottomLeft: _borderRadius.bottomLeft,
      bottomRight: _borderRadius.bottomRight,
    );
  }

  void _clipCanvasWithRect(Canvas canvas, Rect rect, {Offset? offset}) {
    Rect clipRect = rect;
    if (offset != null) {
      clipRect = clipRect.shift(offset);
    }
    if (_borderRadius != BorderRadius.zero) {
      canvas.clipRRect(_clipRRectFromRect(clipRect));
    } else {
      canvas.clipRect(clipRect);
    }
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = Paint()..color = color.withAlpha(_alpha.value);
    Offset? center = _position;
    if (_repositionToReferenceBox) {
      center = Offset.lerp(center, referenceBox.size.center(Offset.zero),
          _radiusController!.value);
    }
    final Offset? originOffset = MatrixUtils.getAsTranslation(transform);
    if (originOffset == null) {
      canvas.save();
      canvas.transform(transform.storage);
      if (_clipCallback != null) {
        _clipCanvasWithRect(canvas, _clipCallback!());
      }
      canvas.drawCircle(center!, _radius.value, paint);
      canvas.restore();
    } else {
      if (_clipCallback != null) {
        canvas.save();
        _clipCanvasWithRect(canvas, _clipCallback!(), offset: originOffset);
      }
      canvas.drawCircle(center! + originOffset, _radius.value, paint);
      if (_clipCallback != null) canvas.restore();
    }
  }
}

double _getTargetRadius(RenderBox referenceBox, bool containedInkWell,
    RectCallback? rectCallback, Offset? position) {
  if (containedInkWell) {
    final Size size =
        rectCallback != null ? rectCallback().size : referenceBox.size;
    return _getSplashRadiusForPositionInSize(size, position!);
  }
  return Material.defaultSplashRadius;
}

double _getSplashRadiusForPositionInSize(Size bounds, Offset position) {
  final double d1 = (position - bounds.topLeft(Offset.zero)).distance;
  final double d2 = (position - bounds.topRight(Offset.zero)).distance;
  final double d3 = (position - bounds.bottomLeft(Offset.zero)).distance;
  final double d4 = (position - bounds.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

RectCallback? _getClipCallback(
    RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) return () => Offset.zero & referenceBox.size;
  return null;
}
