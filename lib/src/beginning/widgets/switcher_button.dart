import 'package:flutter/material.dart';

/// Credits to appiranian - https://github.com/appiranian/switcher_button
// ignore: must_be_immutable
class SwitcherButton extends StatefulWidget {
  /// width and height of widget.
  /// width = size,height = size / 2.
  double? _width, _height;

  /// size of widget.
  final double size;

  /// onColor is color when widget switched on,
  /// default value is: [Colors.white].
  /// offColor is color when widget switched off,
  /// default value is: [Colors.black].
  final Color onColor, offColor;

  /// status of widget, if value == true widget will switched on else
  /// switched off
  final bool? value;

  /// when change status of widget like switch off or switch on [onChange] will
  /// call and passed new [value]
  final Function(bool value)? onChange;

  SwitcherButton(
      {super.key,
      this.size = 60.0,
      this.onColor = Colors.white,
      this.offColor = Colors.black87,
      this.value = false,
      this.onChange}) {
    _width = size;
    _height = size / 2;
  }

  @override
  State<SwitcherButton> createState() => _SwitcherButtonState();
}

class _SwitcherButtonState extends State<SwitcherButton>
    with TickerProviderStateMixin {
  @override
  void dispose() {
    _rightController.dispose();
    _leftController.dispose();
    super.dispose();
  }

  /// sate of widget that can be switched on or switched off.
  bool? value;

  /// radius of right circle.
  double _rightRadius = 0.0;

  /// radius of left circle.
  double _leftRadius = 0.0;

  /// right radius animation and left radius animation.
  late Animation<double> _rightRadiusAnimation, _leftRadiusAnimation;

  /// animation controllers.
  late AnimationController _rightController, _leftController;

  @override
  void initState() {
    value = widget.value;

    // animation controllers initialize.
    _rightController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    _leftController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    if (value!) {
      // when widget initial with on state.
      _leftRadius = widget._width! * 2;
      _rightRadiusAnimation = Tween(begin: 0.0, end: widget._height! * .18)
          .animate(CurvedAnimation(
              parent: _rightController, curve: Curves.elasticOut))
        ..addListener(() {
          setState(() {
            _rightRadius = _rightRadiusAnimation.value;
          });
        });
      _rightController.forward();
    } else {
      // when widget initial with off state.
      _rightRadius = widget._width! * 2;
      _leftRadiusAnimation = Tween(begin: 0.0, end: widget._height! * .18)
          .animate(CurvedAnimation(
              parent: _leftController, curve: Curves.elasticOut))
        ..addListener(() {
          setState(() {
            _leftRadius = _leftRadiusAnimation.value;
          });
        });
      _leftController.forward();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_rightController.isAnimating && !_leftController.isAnimating) {
          _changeState();
        }
      },
      child: Container(
        width: widget._width,
        height: widget._height,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10000.0))),
        child: CustomPaint(
          size: Size.infinite,
          painter: ProfileCardPainter(
              offColor: widget.offColor,
              onColor: widget.onColor,
              leftRadius: _leftRadius,
              rightRadius: _rightRadius,
              value: value),
        ),
      ),
    );
  }

  // change state of widget when clicked on widget.
  _changeState() {
    _rightController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _leftController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    if (value!) {
      // If value == true right radius will be 18% widget height
      // and left radius will be 2 * widget height
      // switcher is on.

      _rightController.duration = const Duration(milliseconds: 400);

      _rightRadiusAnimation = Tween(
              begin: widget._height! * .18, end: widget._width)
          .animate(_rightController)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            // when widget switched to new state(on state) and complete
            // animation show off circle to user
            setState(() {
              _leftRadius = 0.0;
              value = false;
            });
            _leftController.reset();
            _leftController.duration = const Duration(milliseconds: 800);
            _leftRadiusAnimation = Tween(begin: 0.0, end: widget._height! * .18)
                .animate(CurvedAnimation(
                    parent: _leftController, curve: Curves.elasticOut))
              ..addListener(() {
                setState(() {
                  _leftRadius = _leftRadiusAnimation.value;
                });
              });
            _leftController.forward();
          }
        })
        ..addListener(() {
          setState(() {
            _rightRadius = _rightRadiusAnimation.value;
          });
        });
      _rightController.forward();
    } else {
      // If value == true left radius will be 18% widget height
      // and right radius will be 2 * widget height
      // switcher is off.
      _leftController.duration = const Duration(milliseconds: 400);

      _leftRadiusAnimation =
          Tween(begin: widget._height! * .18, end: widget._width)
              .animate(_leftController)
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                // when widget switched to new state(off state) and complete
                // animation show on circle to user
                setState(() {
                  _rightRadius = 0.0;
                  value = true;
                });
                _rightController.reset();
                _rightController.duration = const Duration(milliseconds: 800);
                _rightRadiusAnimation =
                    Tween(begin: 0.0, end: widget._height! * .18).animate(
                        CurvedAnimation(
                            parent: _rightController, curve: Curves.elasticOut))
                      ..addListener(() {
                        setState(() {
                          _rightRadius = _rightRadiusAnimation.value;
                        });
                      });
                _rightController.forward();
              }
            })
            ..addListener(() {
              setState(() {
                _leftRadius = _leftRadiusAnimation.value;
              });
            });
      _leftController.forward();
    }

    // Call onChange
    if (widget.onChange != null) widget.onChange!(!value!);
  }
}

class ProfileCardPainter extends CustomPainter {
  /// Left circle radius.
  double? rightRadius;

  /// Right circle radius.
  double? leftRadius;

  /// State of widget.
  bool? value;

  /// Color when widget is on
  Color? onColor;

  /// Color when widget is off
  Color? offColor;

  ProfileCardPainter(
      {this.rightRadius,
      this.leftRadius,
      this.value,
      this.onColor,
      this.offColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (value!) {
      var paint = Paint()
        ..color = onColor!
        ..strokeWidth = 18;
      Offset center = Offset((size.width / 2) / 2, size.height / 2);
      canvas.drawCircle(center, leftRadius!, paint);

      paint.color = offColor!;
      center =
          Offset(((size.width / 2) / 2) + (size.width / 2), size.height / 2);
      canvas.drawCircle(center, rightRadius!, paint);
    } else {
      var paint = Paint()..strokeWidth = 18;
      Offset center;

      paint.color = offColor!;
      center =
          Offset(((size.width / 2) / 2) + (size.width / 2), size.height / 2);
      canvas.drawCircle(center, rightRadius!, paint);

      paint.color = onColor!;
      center = Offset((size.width / 2) / 2, size.height / 2);
      canvas.drawCircle(center, leftRadius!, paint);
    }
  }

  @override
  bool shouldRepaint(ProfileCardPainter oldDelegate) {
    return true;
  }
}
