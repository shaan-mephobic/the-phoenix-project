import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/slider_step.dart';
import 'package:another_xlider/models/tooltip/tooltip.dart';
import 'package:another_xlider/models/tooltip/tooltip_box.dart';
import 'package:another_xlider/models/trackbar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/native/go_native.dart';
import 'package:phoenix/src/beginning/utilities/set_ringtone.dart';
import 'package:phoenix/src/beginning/widgets/seek_bar.dart';

final ringtonePlayer = AudioPlayer();

class Ringtone extends StatefulWidget {
  final int? artworkId;
  final String? artist;
  final String title;
  final double songDuration;
  final String filePath;

  const Ringtone(
      {super.key,
      required this.artworkId,
      required this.filePath,
      required this.artist,
      required this.title,
      required this.songDuration});
  @override
  State<Ringtone> createState() => _RingtoneState();
}

class _RingtoneState extends State<Ringtone> with TickerProviderStateMixin {
  late var animatedIcon;
  List<double> ranges = [];
  bool isCompleted = false;
  bool isStartChanged = false;
  List<double> fadeIn = [0];
  bool isProcessing = false;

  @override
  void initState() {
    animatedIcon = AnimationController(
        vsync: this, duration: Duration(milliseconds: crossfadeDuration));
    animatedIcon.forward();
    ranges = [0, widget.songDuration];
    ringtonePlayer.setFilePath(widget.filePath);
    playerState();
    getSettingPermission();
    super.initState();
  }

  @override
  void dispose() {
    animatedIcon.dispose();
    super.dispose();
  }

  playerState() {
    ringtonePlayer.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        animatedIcon.forward();
        isCompleted = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        splashColor: Colors.transparent,
        icon: isProcessing
            ? null
            : const Icon(Icons.check_rounded, color: Colors.black),
        label: isProcessing
            ? Center(
                child: SizedBox(
                  height: deviceWidth! / 25,
                  width: deviceWidth! / 25,
                  child: const CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Colors.black,
                  ),
                ),
              )
            : Text("Set Ringtone",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: deviceWidth! / 25,
                    fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFF1DB954),
        elevation: 8.0,
        onPressed: () async {
          setState(() {
            isProcessing = true;
          });
          try {
            await ringtoneTrim(
                pathOfFile: widget.filePath,
                ranges: ranges,
                fade: fadeIn[0].toInt(),
                title: widget.title);
            ringtoneSuccess(context);
          } catch (e) {
            ringtoneFailed(context);
            throw Exception(e);
          }
          setState(() {
            isProcessing = false;
          });
        },
      ),
      appBar: AppBar(
        elevation: 0,
        //TODO make all elevations as 0. many pages are broken
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "RINGTONE",
          style: TextStyle(
            color: Colors.white,
            fontSize: deviceWidth! / 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Theme(
        data: themeOfApp,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: QueryArtworkWidget(
                id: widget.artworkId!,
                type: ArtworkType.AUDIO,
                format: ArtworkFormat.JPEG,
                size: 400,
                artworkQuality: FilterQuality.high,
                keepOldArtwork: true,
                nullArtworkWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kRounded),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(defaultNone!),
                    ),
                  ),
                ),
                artworkBorder: BorderRadius.circular(kRounded),
                artworkFit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: artworkBlurConst, sigmaY: artworkBlurConst),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    child: SizedBox(
                      height: orientedCar ? deviceWidth : deviceHeight,
                      width: orientedCar ? deviceHeight : deviceWidth,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: kToolbarHeight +
                                MediaQuery.of(context).padding.top),
                        child: CustomScrollView(
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: orientedCar
                                              ? deviceWidth! / 12
                                              : deviceHeight! / 12,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 50, bottom: 15),
                                        child: Text(
                                          widget.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: deviceWidth! / 18,
                                          ),
                                        ),
                                      ),
                                      RingtoneSeekBar(
                                          duration: Duration(
                                              milliseconds:
                                                  widget.songDuration ~/ 1)),
                                      IconButton(
                                        icon: AnimatedIcon(
                                          progress: animatedIcon,
                                          icon: AnimatedIcons.pause_play,
                                          color: Colors.white,
                                        ),
                                        iconSize: deviceWidth! / 9,
                                        alignment: Alignment.center,
                                        onPressed: () async {
                                          if (isCompleted) {
                                            ringtonePlayer
                                                .setFilePath(widget.filePath);
                                            ringtonePlayer.play();
                                            isCompleted = false;
                                            animatedIcon.reverse();
                                          } else if (ringtonePlayer.playing) {
                                            ringtonePlayer.pause();
                                            animatedIcon.forward();
                                          } else {
                                            ringtonePlayer.play();
                                            animatedIcon.reverse();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: orientedCar
                                          ? deviceWidth! / 9
                                          : deviceHeight! / 9,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Select range",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: deviceWidth! / 18,
                                        ),
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.only(top: 30)),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  ringtoneRange(
                                                      context: context,
                                                      ms: ranges[0],
                                                      startend: 'Start point');
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    Duration(
                                                            milliseconds:
                                                                ranges[0] ~/ 1)
                                                        .toString()
                                                        .replaceRange(0, 2, "")
                                                        .replaceRange(
                                                          7,
                                                          Duration(
                                                                  milliseconds:
                                                                      nowMediaItem
                                                                          .duration!
                                                                          .inMilliseconds)
                                                              .toString()
                                                              .replaceRange(
                                                                  0, 2, "")
                                                              .length,
                                                          "",
                                                        ),
                                                    style: const TextStyle(
                                                      fontFamily: "Futura",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  ringtoneRange(
                                                      context: context,
                                                      ms: ranges[1],
                                                      startend: 'End point');
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Text(
                                                    Duration(
                                                            milliseconds:
                                                                ranges[1] ~/ 1)
                                                        .toString()
                                                        .replaceRange(0, 2, "")
                                                        .replaceRange(
                                                          7,
                                                          Duration(
                                                                  milliseconds:
                                                                      nowMediaItem
                                                                          .duration!
                                                                          .inMilliseconds)
                                                              .toString()
                                                              .replaceRange(
                                                                  0, 2, "")
                                                              .length,
                                                          "",
                                                        ),
                                                    style: const TextStyle(
                                                      fontFamily: "Futura",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 20)),
                                          SizedBox(
                                            width: orientedCar
                                                ? deviceHeight! / 1.1
                                                : deviceWidth! / 1.1,
                                            height: 50,
                                            child: FlutterSlider(
                                              trackBar: FlutterSliderTrackBar(
                                                inactiveTrackBar: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.black12,
                                                  border: Border.all(
                                                      width: 3,
                                                      color: Colors.white24),
                                                ),
                                                activeTrackBar: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    color: Colors.white),
                                              ),
                                              axis: Axis.horizontal,
                                              values: ranges,
                                              tooltip: FlutterSliderTooltip(
                                                  disabled: true),
                                              rangeSlider: true,
                                              min: 0,
                                              max: widget.songDuration,
                                              onDragging:
                                                  (int index, start, end) {
                                                if (start != ranges[0]) {
                                                  isStartChanged = true;
                                                }
                                                setState(() {
                                                  ranges = [start, end];
                                                });
                                              },
                                              onDragCompleted:
                                                  (index, start, end) {
                                                if (start == ranges[0]) {
                                                  if (isStartChanged) {
                                                    setState(() {
                                                      ringtonePlayer.seek(
                                                          Duration(
                                                              milliseconds:
                                                                  start ~/ 1));
                                                    });
                                                    isStartChanged = false;
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              bottom: orientedCar
                                                  ? deviceWidth! / 9
                                                  : deviceHeight! / 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "Fade in",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: deviceWidth! / 18,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 50,
                                            ),
                                            child: SizedBox(
                                              width: orientedCar
                                                  ? deviceHeight! / 1.1
                                                  : deviceWidth! / 1.1,
                                              height: 50,
                                              child: FlutterSlider(
                                                tooltip: FlutterSliderTooltip(
                                                  format: (String value) {
                                                    return "${value}s";
                                                  },
                                                  textStyle: const TextStyle(
                                                      color: Colors.white),
                                                  boxStyle:
                                                      const FlutterSliderTooltipBox(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black26),
                                                  ),
                                                ),
                                                step: const FlutterSliderStep(
                                                  step: 0.5,
                                                ),
                                                trackBar: FlutterSliderTrackBar(
                                                  inactiveTrackBar:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.black12,
                                                    border: Border.all(
                                                        width: 3,
                                                        color: Colors.white24),
                                                  ),
                                                  activeTrackBar: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      color: Colors.white),
                                                ),
                                                values: fadeIn,
                                                max: 10,
                                                min: 0,
                                                onDragging: (handlerIndex,
                                                    lowerValue, upperValue) {
                                                  setState(() {
                                                    fadeIn = [lowerValue];
                                                  });
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          bottom: orientedCar
                                              ? deviceWidth! / 9
                                              : deviceHeight! / 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ringtoneSuccess(BuildContext context) async {
    Flushbar(
      messageText: const Text("Ringtone updated!",
          style: TextStyle(fontFamily: "Futura", color: Colors.white)),
      icon: Icon(
        Icons.music_note,
        size: 28.0,
        color: kCorrect,
      ),
      shouldIconPulse: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 3),
      borderColor: Colors.white.withOpacity(0.04),
      borderWidth: 1,
      backgroundColor: glassOpacity!,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      barBlur: musicBox.get("glassBlur") ?? 18,
      margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
      borderRadius: BorderRadius.circular(15),
    ).show(context);
  }

  ringtoneFailed(BuildContext context) async {
    Flushbar(
      messageText: const Text("Failed to set ringtone",
          style: TextStyle(fontFamily: "Futura", color: Colors.white)),
      icon: const Icon(
        Icons.error_outline,
        size: 28.0,
        color: Color(0xFFCB0447),
      ),
      shouldIconPulse: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(seconds: 3),
      borderColor: Colors.white.withOpacity(0.04),
      borderWidth: 1,
      backgroundColor: glassOpacity!,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      barBlur: musicBox.get("glassBlur") ?? 18,
      margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
      borderRadius: BorderRadius.circular(15),
    ).show(context);
  }

  Future<Widget?> ringtoneRange(
      {required BuildContext context,
      required String startend,
      required double ms}) async {
    String duration = Duration(milliseconds: ms ~/ 1)
        .toString()
        .replaceRange(0, 2, "")
        .replaceRange(
          7,
          Duration(milliseconds: nowMediaItem.duration!.inMilliseconds)
              .toString()
              .replaceRange(0, 2, "")
              .length,
          "",
        );
    String minutes = duration.replaceRange(2, duration.length, "");
    String seconds = "${duration[3]}${duration[4]}";
    String milliseconds = duration[duration.length - 1];
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return Material(
              color: Colors.transparent,
              child: Theme(
                data: themeOfApp,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kRounded),
                  ),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kRounded),
                    child: BackdropFilter(
                      filter: glassBlur,
                      child: Container(
                        height: 250,
                        width: 400,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kRounded),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.04)),
                          color: glassOpacity,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 30),
                                  child: Text(
                                    startend,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Material(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 70,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      controller: TextEditingController()
                                        ..text = minutes
                                        ..selection = TextSelection.collapsed(
                                            offset: minutes.length),
                                      cursorColor: kPhoenixColor,
                                      decoration: const InputDecoration(
                                        labelText: "min",
                                        labelStyle: TextStyle(
                                          color: Colors.white38,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        counterText: "",
                                      ),
                                      onChanged: (changes) {
                                        setState(() {
                                          minutes = changes.length > 2
                                              ? changes.replaceRange(
                                                  2, changes.length, '')
                                              : changes;
                                        });
                                      },
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  SizedBox(
                                    width: 40,
                                    height: 70,
                                    child: TextField(
                                      cursorColor: kPhoenixColor,
                                      textAlign: TextAlign.center,
                                      controller: TextEditingController()
                                        ..text = seconds
                                        ..selection = TextSelection.collapsed(
                                            offset: seconds.length),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: "sec",
                                        labelStyle: TextStyle(
                                          color: Colors.white38,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                        ),
                                        counterText: "",
                                      ),
                                      onChanged: (changes) {
                                        setState(() {
                                          seconds = changes.length > 2
                                              ? changes.replaceRange(
                                                  2, changes.length, "")
                                              : changes;
                                        });
                                      },
                                      maxLength: 2,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  SizedBox(
                                    width: 40,
                                    height: 70,
                                    child: TextField(
                                        cursorColor: kPhoenixColor,
                                        textAlign: TextAlign.center,
                                        controller: TextEditingController()
                                          ..text = milliseconds
                                          ..selection = TextSelection.collapsed(
                                              offset: milliseconds.length),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: const InputDecoration(
                                          labelText: "ms",
                                          labelStyle: TextStyle(
                                            color: Colors.white38,
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.black),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          counterText: "",
                                        ),
                                        onChanged: (changes) {
                                          setState(() {
                                            milliseconds = changes.length > 1
                                                ? changes.replaceRange(
                                                    1, changes.length, "")
                                                : changes;
                                          });
                                        },
                                        maxLength: 1,
                                        keyboardType: TextInputType.number),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.white30)),
                                    child: const Text(
                                      "CANCEL",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (minutes != "" &&
                                          seconds != "" &&
                                          milliseconds != "") {
                                        Duration seekTo = Duration(
                                                minutes: int.parse(minutes)) +
                                            Duration(
                                                seconds: int.parse(seconds)) +
                                            Duration(
                                                milliseconds:
                                                    int.parse(milliseconds) *
                                                        100);
                                        if (seekTo.inMilliseconds <
                                                widget.songDuration &&
                                            seekTo.inMilliseconds >= 0) {
                                          if (startend == "Start point") {
                                            ranges[0] =
                                                seekTo.inMilliseconds * 1.0;
                                            ringtonePlayer.seek(Duration(
                                                milliseconds:
                                                    seekTo.inMilliseconds));
                                          } else {
                                            ranges[1] =
                                                seekTo.inMilliseconds * 1.0;
                                          }
                                          Navigator.pop(context);
                                        } else {
                                          Flushbar(
                                            messageText: const Text(
                                                "Values out of range.",
                                                style: TextStyle(
                                                    fontFamily: "Futura",
                                                    color: Colors.white)),
                                            icon: const Icon(
                                              Icons.error_outline,
                                              size: 28.0,
                                              color: Color(0xFFCB0447),
                                            ),
                                            shouldIconPulse: true,
                                            dismissDirection:
                                                FlushbarDismissDirection
                                                    .HORIZONTAL,
                                            duration:
                                                const Duration(seconds: 3),
                                            borderColor:
                                                Colors.white.withOpacity(0.04),
                                            borderWidth: 1,
                                            backgroundColor: glassOpacity!,
                                            flushbarStyle:
                                                FlushbarStyle.FLOATING,
                                            isDismissible: true,
                                            barBlur:
                                                musicBox.get("glassBlur") ?? 18,
                                            margin: const EdgeInsets.only(
                                                bottom: 20, left: 8, right: 8),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ).show(context);
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(kCorrect),
                                      overlayColor: MaterialStateProperty.all(
                                        Colors.white30,
                                      ),
                                    ),
                                    child: const Text(
                                      "APPLY",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
