import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:provider/provider.dart';
import '../utilities/provider/provider.dart';
import '../pages/ringtone/ringtone.dart';

bool seekInitiated = false;

class SeekBar extends StatefulWidget {
  const SeekBar({super.key});

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  Duration currentPosition = Duration.zero;
  int seekValue = 0;
  var globalTiming;

  @override
  void initState() {
    if (!seekInitiated) {
      seekInitiated = true;
      streamOfPosition();
    }
    super.initState();
  }

  streamOfPosition() {
    AudioService.position.listen(
      (Duration position) {
        currentPosition = position;
        if (globalTiming != null) {
          if (usingSeek == false) {
            globalTiming.incrementTime(currentPosition.inSeconds * 1.0);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<Seek>(builder: (context, timing, child) {
          globalTiming = timing;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: orientedCar
                        ? deviceHeight! / 2 / 25
                        : deviceWidth! / 30),
                child: Text(
                  !usingSeek
                      ? currentPosition
                          .toString()
                          .replaceRange(0, 2, "")
                          .replaceRange(
                              currentPosition
                                  .toString()
                                  .replaceRange(0, 2, "")
                                  .indexOf("."),
                              currentPosition
                                  .toString()
                                  .replaceRange(0, 2, "")
                                  .length,
                              "")
                      : (Duration(seconds: seekValue))
                          .toString()
                          .replaceRange(0, 2, "")
                          .replaceRange(
                              currentPosition
                                  .toString()
                                  .replaceRange(0, 2, "")
                                  .indexOf("."),
                              currentPosition
                                  .toString()
                                  .replaceRange(0, 2, "")
                                  .length,
                              ""),
                  style: TextStyle(
                      fontSize: deviceWidth! / 35,
                      fontFamily: "Futura",
                      shadows: const [
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 2.0,
                          color: Colors.black38,
                        ),
                      ],
                      color: musicBox.get("dynamicArtDB") ?? true
                          ? nowContrast
                          : Colors.white),
                ),
              ),
              SizedBox(
                width:
                    orientedCar ? deviceHeight! / 2 / 1.5 : deviceWidth! / 1.5,
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 2.35),
                    thumbColor: Colors.transparent,
                    inactiveTrackColor: musicBox.get("dynamicArtDB") ?? true
                        ? nowContrast.withOpacity(0.1)
                        : Colors.white10,
                  ),
                  child: Slider(
                      activeColor: musicBox.get("dynamicArtDB") ?? true
                          ? nowContrast
                          : Colors.white,
                      min: 00.0,
                      max: nowMediaItem.duration!.inMilliseconds / 1000,
                      value: timing.time,
                      onChanged: (var valo) async {
                        usingSeek = true;
                        seekValue = double.parse('$valo').toInt();
                        timing.seekIncrementTime(valo);
                      },
                      onChangeEnd: (var valuo) {
                        int seeker = double.parse('$valuo').toInt();

                        audioHandler.seek(Duration(seconds: seeker));
                        usingSeek = false;
                      }),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: orientedCar
                        ? deviceHeight! / 2 / 25
                        : deviceWidth! / 30),
                child: Text(
                  nowMediaItem.duration == null
                      ? Duration(
                              milliseconds:
                                  nowMediaItem.duration!.inMilliseconds)
                          .toString()
                      : Duration(
                              milliseconds:
                                  nowMediaItem.duration!.inMilliseconds)
                          .toString()
                          .replaceRange(0, 2, "")
                          .replaceRange(
                            5,
                            Duration(
                                    milliseconds:
                                        nowMediaItem.duration!.inMilliseconds)
                                .toString()
                                .replaceRange(0, 2, "")
                                .length,
                            "",
                          ),
                  style: TextStyle(
                      fontSize: deviceWidth! / 35,
                      fontFamily: "Futura",
                      shadows: const [
                        Shadow(
                          offset: Offset(0.5, 0.5),
                          blurRadius: 1.5,
                          color: Colors.black38,
                        ),
                      ],
                      color: musicBox.get("dynamicArtDB") ?? true
                          ? nowContrast
                          : Colors.white),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class CyberSkySeekBar extends StatefulWidget {
  const CyberSkySeekBar({super.key});

  @override
  State<CyberSkySeekBar> createState() => _CyberSkySeekBarState();
}

class _CyberSkySeekBarState extends State<CyberSkySeekBar> {
  Duration currentPosition = Duration.zero;
  int seekValue = 0;
  var globalTiming;
  late StreamSubscription<Duration> posStream;

  @override
  void initState() {
    streamOfPosition();
    super.initState();
  }

  @override
  void dispose() {
    posStream.cancel();
    super.dispose();
  }

  streamOfPosition() {
    posStream = AudioService.position.listen(
      (Duration position) {
        currentPosition = position;
        if (globalTiming != null &&
            usingSeek == false &&
            currentPosition.inMilliseconds <=
                nowMediaItem.duration!.inMilliseconds) {
          globalTiming.incrementTime(currentPosition.inMilliseconds / 1000);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<Seek>(builder: (context, timing, child) {
          globalTiming = timing;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: deviceWidth! - 100,
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        trackShape: CustomTrackShape(),
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 1.4),
                        thumbColor: Colors.transparent,
                        inactiveTrackColor: musicBox.get("dynamicArtDB") ?? true
                            ? nowContrast.withOpacity(0.1)
                            : Colors.white10,
                      ),
                      child: Slider(
                          activeColor: musicBox.get("dynamicArtDB") ?? true
                              ? nowContrast
                              : Colors.white,
                          min: 00.0,
                          max: nowMediaItem.duration!.inMilliseconds / 1000,
                          value: timing.time,
                          onChanged: (var valo) async {
                            usingSeek = true;
                            seekValue = double.parse('$valo').toInt();
                            timing.seekIncrementTime(valo);
                          },
                          onChangeEnd: (var valuo) {
                            int seeker = double.parse('$valuo').toInt();
                            audioHandler.seek(Duration(seconds: seeker));
                            usingSeek = false;
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          !usingSeek
                              ? currentPosition
                                  .toString()
                                  .replaceRange(0, 2, "")
                                  .replaceRange(
                                      currentPosition
                                          .toString()
                                          .replaceRange(0, 2, "")
                                          .indexOf("."),
                                      currentPosition
                                          .toString()
                                          .replaceRange(0, 2, "")
                                          .length,
                                      "")
                              : (Duration(seconds: seekValue))
                                  .toString()
                                  .replaceRange(0, 2, "")
                                  .replaceRange(
                                      currentPosition
                                          .toString()
                                          .replaceRange(0, 2, "")
                                          .indexOf("."),
                                      currentPosition
                                          .toString()
                                          .replaceRange(0, 2, "")
                                          .length,
                                      ""),
                          style: TextStyle(
                              fontSize: deviceWidth! / 35,
                              shadows: const [
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 2.0,
                                  color: Colors.black38,
                                ),
                              ],
                              color: musicBox.get("dynamicArtDB") ?? true
                                  ? isArtworkDark!
                                      ? Colors.white
                                      : Colors.black
                                  : Colors.white),
                        ),
                        Text(
                          nowMediaItem.duration == null
                              ? Duration(
                                      milliseconds:
                                          nowMediaItem.duration!.inMilliseconds)
                                  .toString()
                              : Duration(
                                      milliseconds:
                                          nowMediaItem.duration!.inMilliseconds)
                                  .toString()
                                  .replaceRange(0, 2, "")
                                  .replaceRange(
                                    5,
                                    Duration(
                                            milliseconds: nowMediaItem
                                                .duration!.inMilliseconds)
                                        .toString()
                                        .replaceRange(0, 2, "")
                                        .length,
                                    "",
                                  ),
                          style: TextStyle(
                              fontSize: deviceWidth! / 35,
                              shadows: const [
                                Shadow(
                                  offset: Offset(0.5, 0.5),
                                  blurRadius: 1.5,
                                  color: Colors.black38,
                                ),
                              ],
                              color: musicBox.get("dynamicArtDB") ?? true
                                  ? isArtworkDark!
                                      ? Colors.white
                                      : Colors.black
                                  : Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class RingtoneSeekBar extends StatefulWidget {
  final Duration duration;
  const RingtoneSeekBar({super.key, required this.duration});

  @override
  State<RingtoneSeekBar> createState() => _RingtoneSeekBarState();
}

class _RingtoneSeekBarState extends State<RingtoneSeekBar> {
  Duration currentPosition = Duration.zero;
  bool onRingtoneSeek = false;
  int ringtoneSeekValue = 0;
  bool stateChange = true;
  var globalTiming;

  @override
  void initState() {
    streamOfPosition();
    super.initState();
  }

  @override
  void dispose() {
    stateChange = false;
    ringtonePlayer.stop();
    super.dispose();
  }

  void streamOfPosition() {
    ringtonePlayer
        .createPositionStream(
            minPeriod: const Duration(milliseconds: 100),
            maxPeriod: const Duration(milliseconds: 100))
        .listen((event) {
      if (stateChange) {
        if (event > widget.duration) {
          currentPosition = widget.duration;
        } else {
          setState(() {
            currentPosition = event;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: orientedCar ? deviceHeight! / 2 / 25 : deviceWidth! / 30),
          child: Text(
            !onRingtoneSeek
                ? currentPosition
                    .toString()
                    .replaceRange(0, 2, "")
                    .replaceRange(
                        currentPosition
                                .toString()
                                .replaceRange(0, 2, "")
                                .indexOf(".") +
                            2,
                        currentPosition
                            .toString()
                            .replaceRange(0, 2, "")
                            .length,
                        "")
                : (Duration(milliseconds: ringtoneSeekValue))
                    .toString()
                    .replaceRange(0, 2, "")
                    .replaceRange(
                        currentPosition
                                .toString()
                                .replaceRange(0, 2, "")
                                .indexOf(".") +
                            2,
                        currentPosition
                            .toString()
                            .replaceRange(0, 2, "")
                            .length,
                        ""),
            style: TextStyle(
                fontSize: deviceWidth! / 35,
                fontFamily: "Futura",
                shadows: const [
                  Shadow(
                    offset: Offset(0.5, 0.5),
                    blurRadius: 2.0,
                    color: Colors.black38,
                  ),
                ],
                color: Colors.white),
          ),
        ),
        SizedBox(
          width: orientedCar ? deviceHeight! / 1.5 : deviceWidth! / 1.5,
          child: SliderTheme(
            data: const SliderThemeData(
              trackHeight: 3,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.35),
              thumbColor: Colors.transparent,
              inactiveTrackColor: Colors.white10,
            ),
            child: Slider(
                activeColor: Colors.white,
                min: 00.0,
                max: widget.duration.inMilliseconds * 1.0,
                value: onRingtoneSeek
                    ? ringtoneSeekValue * 1.0
                    : currentPosition.inMilliseconds * 1.0,
                onChanged: (var valo) async {
                  onRingtoneSeek = true;
                  setState(() {
                    ringtoneSeekValue = double.parse('$valo').toInt();
                  });
                },
                onChangeEnd: (var valuo) {
                  int seeker = double.parse('$valuo').toInt();
                  ringtonePlayer.seek(Duration(milliseconds: seeker));
                  onRingtoneSeek = false;
                }),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              right: orientedCar ? deviceHeight! / 2 / 25 : deviceWidth! / 30),
          child: Text(
            Duration(milliseconds: widget.duration.inMilliseconds)
                .toString()
                .replaceRange(0, 2, "")
                .replaceRange(
                  7,
                  Duration(milliseconds: widget.duration.inMilliseconds)
                      .toString()
                      .replaceRange(0, 2, "")
                      .length,
                  "",
                ),
            style: TextStyle(
                fontSize: deviceWidth! / 35,
                fontFamily: "Futura",
                shadows: const [
                  Shadow(
                    offset: Offset(0.5, 0.5),
                    blurRadius: 1.5,
                    color: Colors.black38,
                  ),
                ],
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class MiniSeekbar extends StatefulWidget {
  const MiniSeekbar({super.key});

  @override
  State<MiniSeekbar> createState() => _MiniSeekbarState();
}

class _MiniSeekbarState extends State<MiniSeekbar> {
  Duration currentPosition = Duration.zero;
  @override
  void initState() {
    streamPosition();
    super.initState();
  }

  streamPosition() {
    AudioService.position.listen(
      (Duration position) {
        currentPosition =
            position.inMilliseconds <= nowMediaItem.duration!.inMilliseconds
                ? position
                : currentPosition;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // using same consumer used in main seekbar in now playing
    return Consumer<Seek>(builder: (context, timing, child) {
      return SizedBox(
        height: 1,
        width: orientedCar ? deviceHeight : deviceWidth,
        child: SliderTheme(
          data: SliderThemeData(
            trackHeight: 1,
            thumbShape: SliderComponentShape.noThumb,
            trackShape: CustomTrackShape(),
            thumbColor: Colors.transparent,
            inactiveTrackColor: musicBox.get("dynamicArtDB") ?? true
                ? nowContrast.withOpacity(0.1)
                : Colors.white10,
          ),
          child: Slider(
              activeColor: musicBox.get("dynamicArtDB") ?? true
                  ? nowContrast
                  : Colors.white,
              min: 00.0,
              max: nowMediaItem.duration!.inMilliseconds * 1.0,
              value: currentPosition.inMilliseconds * 1.0,
              onChanged: (double value) {}),
        ),
      );
    });
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
