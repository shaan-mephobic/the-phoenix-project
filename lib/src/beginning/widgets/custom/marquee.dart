import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Credits to zhcode-fun https://github.com/zhcode-fun/flutter-marquee-text

class MarqueeText extends StatelessWidget {
  final String? text;
  final TextStyle? style;

  /// default 50
  /// Must be greater than 0.
  final double speed;

  /// Always scroll and ignore text length.
  final bool alwaysScroll;

  final TextDirection textDirection;

  /// default rtl
  final MarqueeDirection marqueeDirection;

  const MarqueeText({
    super.key,
    this.text,
    this.style,
    this.speed = 50,
    this.alwaysScroll = false,
    this.textDirection = TextDirection.ltr,
    this.marqueeDirection = MarqueeDirection.rtl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) => ClipPath(
          child: MarqueeContainer(
            text: text,
            textStyle: style,
            constraints: constraints,
            speed: speed,
            alwaysScroll: alwaysScroll,
            textDirection: textDirection,
            marqueeDirection: marqueeDirection,
          ),
        ),
      ),
    );
  }
}

class MarqueeContainer extends StatefulWidget {
  final String? text;
  final TextStyle? textStyle;
  final double? speed;
  final BoxConstraints? constraints;
  final bool? alwaysScroll;
  final TextDirection? textDirection;
  final MarqueeDirection? marqueeDirection;

  const MarqueeContainer({
    super.key,
    this.text,
    this.textStyle,
    this.constraints,
    this.speed,
    this.alwaysScroll,
    this.textDirection,
    this.marqueeDirection,
  });
  @override
  MarqueeContainerState createState() => MarqueeContainerState();
}

class MarqueeContainerState extends State<MarqueeContainer>
    with SingleTickerProviderStateMixin {
  bool isListening = false;
  late AnimationController marqueeController;
  bool isMarqueeDead = false;
  late Animation<double> _animation;
  bool _showMarquee = false;

  @override
  void initState() {
    marqueeController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    marqueeController.dispose();
    super.dispose();
  }

  void shouldResume() {
    if (isMarqueeDead) {
      marqueeController.repeat();
      isMarqueeDead = false;
    }
  }

  void shouldPause() {
    if (!isMarqueeDead) {
      marqueeController.reset();
      isMarqueeDead = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var renderParagraph = RenderParagraph(
      TextSpan(
        text: widget.text,
        style: widget.textStyle,
      ),
      softWrap: false,
      maxLines: 1,
      textDirection: widget.textDirection!,
      overflow: TextOverflow.visible,
    );
    renderParagraph.layout(widget.constraints!);
    var textWidth = renderParagraph.textSize.width;
    var constraintsWidth = renderParagraph.constraints.maxWidth;
    _showMarquee = textWidth > constraintsWidth || widget.alwaysScroll!;
    if (marqueeController.isAnimating && !_showMarquee) {
      marqueeController.stop();
      marqueeController.reset();
    }
    var tweenList = [constraintsWidth, -textWidth];
    if (_showMarquee && !isMarqueeDead) {
      if (widget.speed! <= 0) {
        throw Exception('marquee_text speed value must be greater than 0');
      }
      var duration = ((textWidth / (widget.speed! * 1.72)) * 1000).floor();
      _showMarquee = true;
      marqueeController.duration = Duration(milliseconds: duration);
      _animation = Tween(
        begin: tweenList[widget.marqueeDirection!.index],
        end: tweenList[1 - widget.marqueeDirection!.index],
      ).animate(marqueeController)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            marqueeController.repeat();
          }
        });
      marqueeController.forward();
    }

    final textWidget = Text(
      widget.text!,
      style: widget.textStyle,
      overflow: TextOverflow.visible,
      softWrap: false,
      textDirection: widget.textDirection,
    );
    return _showMarquee
        ? AnimatedBuilder(
            builder: (context, myWidget) => Container(
              width: double.infinity,
              transform: Matrix4.translationValues(
                _animation.value,
                0.0,
                0.0,
              ),
              child: myWidget,
            ),
            animation: _animation,
            child: textWidget,
          )
        : textWidget;
  }
}

enum MarqueeDirection {
  rtl,
  ltr,
}
