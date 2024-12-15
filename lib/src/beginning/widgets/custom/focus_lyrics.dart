import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import '../../utilities/global_variables.dart';

// Credits: Focused-Text(author: Dennis Galven)

/// A widget that displays the current text paragraph in a focused manner.
class FocusedTextWidget extends StatefulWidget {
  const FocusedTextWidget._({
    super.key,
    required this.lrc,
    this.maxParagraphLines = 3,
    this.autoPlay = false,
    this.resizeFactor = 0.3,
    this.autoPlayDuration = const Duration(seconds: 5),
    this.textStyle,
  });

  /// Creates a [FocusedTextWidget] from a list of [String]s.
  // factory FocusedTextWidget.fromList({
  //   Key? key,
  //   required List<String> lrc,
  //   int maxParagraphLines = 3,
  //   bool autoPlay = false,
  //   double resizeFactor = 0.4,
  //   Duration autoPlayDuration = const Duration(seconds: 5),
  //   TextStyle? textStyle,
  // }) =>
  //     FocusedTextWidget._(
  //       key: key,
  //       lrc: lrc,
  //       maxParagraphLines: maxParagraphLines,
  //       autoPlay: autoPlay,
  //       resizeFactor: resizeFactor,
  //       autoPlayDuration: autoPlayDuration,
  //       textStyle: textStyle,
  //     );

  /// Creates a [FocusedTextWidget] from a [String].
  ///
  /// The [String] is split into a list of [String]s using the [separator].
  factory FocusedTextWidget.fromString({
    Key? key,
    required String text,
    String separator = '.',
    int maxParagraphLines = 3,
    bool showSeparator = false,
    bool autoPlay = false,
    double resizeFactor = 0.4,
    Duration autoPlayDuration = const Duration(seconds: 5),
    TextStyle? textStyle,
  }) {
    return FocusedTextWidget._(
      key: key,
      lrc: parseLrc(text),
      maxParagraphLines: maxParagraphLines,
      autoPlay: autoPlay,
      resizeFactor: resizeFactor,
      autoPlayDuration: autoPlayDuration,
      textStyle: textStyle,
    );
  }

  // final Map<Duration, String> keyframes;

  /// The list of [String]s to display.
  final Map<Duration, String> lrc;

  /// The maximum number of lines to display in a paragraph.
  /// The default value is 3.
  final int maxParagraphLines;

  /// Should the focused text be auto scrolled.
  /// Combine with [autoPlayDuration] to control the auto scroll speed.
  /// The default value is false.
  final bool autoPlay;

  /// The duration between each auto scroll.
  /// Only used if [autoPlay] is true.
  /// The default value is 5 seconds.
  final Duration autoPlayDuration;

  /// Text style for the focused text.
  /// If null, the default text style is used.
  final TextStyle? textStyle;

  /// The resize factor for the unfocused text.
  /// The default value is 0.4.
  /// Clamped value between 0.2 and 0.8.
  final double resizeFactor;

  @override
  State<FocusedTextWidget> createState() => _FocusedTextWidgetState();
}

class _FocusedTextWidgetState extends State<FocusedTextWidget> {
  late final PageController _controller;
  double _currentOffset = 0;
  final int _rowDimensionDivider = 4;
  late StreamSubscription<Duration> positionStream;
  Timer? _autoPlayTimer;
  late Duration trackPosition;

  @override
  initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1 / 4);
    _controller.addListener(_scrollListener);
    streamOfPosition();
    // _autoScrollIfNeeded();
    // nowLyric();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  void _scrollListener() {
    _currentOffset = _controller.offset;
    setState(() {});
  }

  double _animationFromControllerOffset(int index) {
    final offset = _currentOffset;
    final viewport = _controller.position.viewportDimension;
    final pageHeight = viewport / _rowDimensionDivider;
    final pageOffset = index * pageHeight;
    final pageOffsetDiff = offset - pageOffset;
    final pageOffsetDiffAbs = pageOffsetDiff.abs();
    final pageOffsetDiffAbsClamped = pageOffsetDiffAbs.clamp(0, pageHeight);
    final animation = 1 - (pageOffsetDiffAbsClamped / (pageHeight));
    return max(animation, widget.resizeFactor);
  }

  void _setCurrentPage(int page) {
    // if (!widget.lrc.keys.toList().contains(trackPosition)) {
    //   audioHandler.seek(widget.lrc.keys.toList()[page]);
    // }
    // setState(() {});
  }

  streamOfPosition() {
    positionStream = AudioService.position.listen(
      (Duration position) {
        trackPosition = position;
        // print(position.inMilliseconds);
        for (int i = 0; i < widget.lrc.keys.toList().length; i++) {
          if (position >= widget.lrc.keys.toList()[i]) {
            if (i != widget.lrc.keys.toList().length - 1 &&
                position < widget.lrc.keys.toList()[i + 1]) {
              if (_controller.hasClients) {
                _controller.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              }
            }
          }
        }
      },
    );
  }

  // void _autoScrollIfNeeded() {
  //   if (!widget.autoPlay) return;

  //   _autoPlayTimer = Timer.periodic(
  //     widget.autoPlayDuration,
  //     (timer) {
  //       if (_currentPage == widget.lrc.length - 1) {
  //         _controller.animateToPage(
  //           0,
  //           duration: const Duration(milliseconds: 500),
  //           curve: Curves.easeOut,
  //         );
  //       } else {
  //         _controller.nextPage(
  //           duration: const Duration(milliseconds: 500),
  //           curve: Curves.easeOut,
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      child: PageView.custom(
        physics: const BouncingScrollPhysics(),
        controller: _controller,
        scrollDirection: Axis.vertical,
        onPageChanged: _setCurrentPage,
        childrenDelegate: SliverChildBuilderDelegate(
          (context, index) {
            final text = widget.lrc.values.toList().elementAt(index);
            final animation = _animationFromControllerOffset(index);
            return InkWell(
              onTap: () {
                debugPrint(index.toString());
                audioHandler.seek(widget.lrc.keys.toList()[index]);
              },
              child: Transform.scale(
                scale: animation,
                child: Opacity(
                  opacity: animation,
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        wordSpacing: 2,
                        fontSize: deviceWidth! / 18,
                        fontWeight: FontWeight.w600,
                        color: musicBox.get("dynamicArtDB") ?? true
                            ? isArtworkDark!
                                ? Colors.white
                                : Colors.black
                            : Colors.white,
                      ),
                    ),
                    // ),
                  ),
                ),
              ),
            );
          },
          childCount: widget.lrc.length,
        ),
      ),
    );
  }
}

Map<Duration, String> parseLrc(String lrc) {
  Map<Duration, String> result = {};

  // Split the lyrics by lines
  List<String> lines = lrc.split('\n');
  result[Duration.zero] = "...";

  // Iterate through each line of lyrics
  for (var line in lines) {
    // Extract time and lyrics using RegExp
    RegExpMatch? match =
        RegExp(r"\[(\d{2}):(\d{2}).(\d{2})\]([^\[\]]*)").firstMatch(line);
    if (match != null) {
      // Extract time parts
      int minutes = int.parse(match.group(1)!);
      int seconds = int.parse(match.group(2)!);
      int milliseconds =
          int.parse(match.group(3)!) * 10; // Convert hundredths to milliseconds
      Duration duration = Duration(
          minutes: minutes, seconds: seconds, milliseconds: milliseconds);

      // Extract lyrics
      String lyrics = match.group(4)!.trim();

      // Append duration and lyrics to the result map
      result[duration] = lyrics;
    } else {
      // result[duration] = line;
    }
  }
  print(result);
  return result;
}
// // spotify format parsing
// Map<Duration, String> parseLrc(String lrc) {
//   Map<Duration, String> result = {};
//   result[Duration.zero] = "...";
//   // print(lrc);
//   Map lyricObj = jsonDecode(lrc);
//   // print(lrc);
//   // iteration through each Lines of Lyric
//   for (int i = 0; i < lyricObj["lines"].length; i++) {
//     //Duration extraction
//     List<String> timeParts = lyricObj["lines"][i]["timeTag"].split(':');
//     int minutes = int.parse(timeParts[0]);
//     List<String> secondsAndMilliseconds = timeParts[1].split('.');
//     int seconds = int.parse(secondsAndMilliseconds[0]);
//     int milliseconds = int.parse(secondsAndMilliseconds[1]);
//     Duration duration = Duration(
//         minutes: minutes, seconds: seconds, milliseconds: milliseconds);

//     // appending duration and words
//     result[duration] = lyricObj["lines"][i]["words"];
//   }
//   return result;
// }

// Old format 

// Map<Duration, String> parseLrc(String lrc) {
//   Map<Duration, String> result = {};
//   result[Duration.zero] = "...";
//   lrc = lrc.replaceRange(0, lrc.indexOf("[00:"), "");
//   print("HITTTT");
//   print(lrc);
//   lrc = lrc.replaceAll("\\r\\n", "\n");
//   print(lrc.replaceAll("\\r\\n", "\n"));
//   print("iiohi");
//   List<String> lines = lrc.split('\n');

//   for (String line in lines) {
//     int endIndex = line.indexOf(']');
//     if (endIndex != -1) {
//       String timeString = line.substring(line.indexOf('[') + 1, endIndex);
//       List<String> timeParts = timeString.split(':');
//       if (timeParts.length == 2) {
//         int minutes = int.parse(timeParts[0]);
//         List<String> secondsAndMilliseconds = timeParts[1].split('.');
//         int seconds = int.parse(secondsAndMilliseconds[0]);
//         int milliseconds = int.parse(secondsAndMilliseconds[1]);
//         Duration duration = Duration(
//             minutes: minutes, seconds: seconds, milliseconds: milliseconds);
//         String text = line.substring(endIndex + 1).trim();
//         result[duration] = text;
//       }
//     }
//   }

//   return result;
// }

// extension _SeperatedList on String {
//   List<String> seperatedList(String separator, bool showSeparator) =>
//       split(separator)
//           .map(
//             (e) => _formattedString(e, showSeparator, separator),
//           )
//           .toList();

//   static String _formattedString(
//       String rawString, bool showSeparator, String separator) {
//     String processedString = rawString;
//     if (rawString.startsWith('\n')) {
//       processedString = rawString.replaceFirst('\n', '');
//       return _formattedString(
//         processedString,
//         showSeparator,
//         separator,
//       );
//     }
//     processedString = rawString.trim();
//     if (!showSeparator) {
//       processedString = rawString.replaceAll(separator, '');
//     }
//     return processedString;
//   }
// }
