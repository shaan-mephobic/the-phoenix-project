import 'package:page_transition/page_transition.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/widgets/custom/graviticons.dart';
import 'package:phoenix/src/beginning/widgets/custom/marquee.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/phoenix_visualizer.dart';
import 'package:phoenix/src/beginning/widgets/now_art.dart';
import 'package:phoenix/src/beginning/widgets/seek_bar.dart';
import '../../utilities/constants.dart';
import '../../widgets/dialogues/double_tap.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:flutter/services.dart';
import '../../widgets/dialogues/on_hold.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> with TickerProviderStateMixin {
  ScrollController stupidController = ScrollController();
  swapControllerTimeOut() async {
    await Future.delayed(const Duration(milliseconds: 500));
    swapController = false;
    globalBigNow.rawNotify();
  }

  @override
  void initState() {
    super.initState();
    if (!(musicBox.get("isolation") == null
        ? false
        : musicBox.get('isolation'))) {
      stupidController.addListener(() {
        if (stupidController.offset == stupidController.initialScrollOffset) {
          if (!swapController) {
            swapController = true;
            globalBigNow.rawNotify();
            swapControllerTimeOut();
          }
        } else {
          if (swapController) {
            swapController = false;
            globalBigNow.rawNotify();
          }
        }
      });
    } else {
      swapController = true;
    }

    animatedPlayPause = AnimationController(
        vsync: this, duration: Duration(milliseconds: crossfadeDuration));
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    // Portrait Screen
    return !orientedCar
        ? Consumer<MrMan>(builder: (context, bignow, child) {
            globalBigNow = bignow;
            return AnimatedContainer(
              duration: Duration(milliseconds: crossfadeDuration),
              decoration: BoxDecoration(
                  color: musicBox.get("dynamicArtDB") ?? true
                      ? nowColor
                      : kMaterialBlack,
                  borderRadius: musicBox.get("classix") ?? true
                      ? null
                      : radiusFullscreen),
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return;
                } as bool Function(OverscrollIndicatorNotification)?,
                child: SingleChildScrollView(
                  controller: stupidController,
                  physics: swapController
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: deviceHeight! / 18),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTapDown: (_) {
                                      if (!swapController) {
                                        HapticFeedback.lightImpact();
                                        swapController = true;
                                        globalBigNow.rawNotify();
                                        swapControllerTimeOut();
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: deviceWidth! / 20),
                                      child: Icon(
                                        Ionicons.chevron_down_outline,
                                        size: deviceWidth! / 20,
                                        color: nowContrast,
                                      ),
                                    ),
                                  ),
                                ]),
                            Padding(
                              padding: EdgeInsets.only(top: deviceHeight! / 18),
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: deviceHeight! / 2.32,
                              width: deviceWidth,
                              child: GestureDetector(
                                child: NowArt(orientedCar),
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.size,
                                      alignment: Alignment.center,
                                      duration: dialogueAnimationDuration,
                                      reverseDuration:
                                          dialogueAnimationDuration,
                                      child: OnHoldExtended(
                                        context: context,
                                        car: orientedCar,
                                        heightOfDevice: deviceHeight,
                                        widthOfDevice: deviceWidth,
                                      ),
                                    ),
                                  );
                                },
                                onDoubleTap: () {
                                  onDoubleTap(context);
                                },
                                onLongPress: () {
                                  HapticFeedback.lightImpact();
                                  // await onHoldExtended(context, orientedCar,
                                  //     deviceHeight, deviceWidth);
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.size,
                                      alignment: Alignment.center,
                                      duration: dialogueAnimationDuration,
                                      reverseDuration:
                                          dialogueAnimationDuration,
                                      child: OnHoldExtended(
                                        context: context,
                                        car: orientedCar,
                                        heightOfDevice: deviceHeight,
                                        widthOfDevice: deviceWidth,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: deviceHeight! / 40)),
                            Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    width: deviceWidth! / 1.3,
                                    child: Center(
                                      child: MarqueeText(
                                        text: nowMediaItem.title,
                                        speed: 20,
                                        style: TextStyle(
                                          color: musicBox.get("dynamicArtDB") ??
                                                  true
                                              ? nowContrast
                                              : Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: deviceHeight! / 35,
                                          height: 1.3,
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(1.0, 0.8),
                                              blurRadius: 0.8,
                                              color: Colors.black45,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Opacity(
                              opacity: 0.7,
                              child: Center(
                                child: SizedBox(
                                  width: deviceWidth! / 1.4,
                                  child: Text(
                                    nowMediaItem.album!,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color:
                                          musicBox.get("dynamicArtDB") ?? true
                                              ? nowContrast
                                              : Colors.white,
                                      height: 1,
                                      fontSize: deviceHeight! / 60,
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(0.7, 0.7),
                                          blurRadius: 1,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: 0.7,
                              child: Center(
                                child: SizedBox(
                                  width: deviceWidth! / 1.4,
                                  child: Text(
                                    nowMediaItem.artist!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color:
                                          musicBox.get("dynamicArtDB") ?? true
                                              ? nowContrast
                                              : Colors.white,
                                      fontSize: deviceHeight! / 60,
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(0.7, 0.7),
                                          blurRadius: 1,
                                          color: Colors.black38,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: deviceHeight! / 90),
                            ),
                            Center(
                                child: SizedBox(
                                    width: deviceWidth! / 1.1,
                                    child: const SeekBar())),
                            Padding(
                              padding:
                                  EdgeInsets.only(top: deviceHeight! / 100),
                            ),
                            SizedBox(
                              width: deviceWidth! / 1.2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<Leprovider>(
                                      builder: (context, shuf, _) {
                                    return IconButton(
                                      icon: Icon(Ionicons.shuffle_outline,
                                          color: musicBox.get("dynamicArtDB") ??
                                                  true
                                              ? shuffleSelected
                                                  ? nowContrast
                                                  : nowContrast.withOpacity(0.4)
                                              : shuffleSelected
                                                  ? Colors.white
                                                  : Colors.white38),
                                      iconSize: deviceWidth! / 16,
                                      onPressed: () async {
                                        if (shuffleSelected) {
                                          shuf.changeShuffle(false);
                                        } else {
                                          shuf.changeShuffle(true);
                                        }
                                        await shuffleMode();
                                      },
                                    );
                                  }),
                                  IconButton(
                                      icon: Icon(
                                        MdiIcons.skipPrevious,
                                        color:
                                            musicBox.get("dynamicArtDB") ?? true
                                                ? nowContrast
                                                : Colors.white,
                                      ),
                                      iconSize: deviceWidth! / 12,
                                      onPressed: () async {
                                        audioHandler.skipToPrevious();
                                      }),
                                  IconButton(
                                      icon: AnimatedIcon(
                                        progress: animatedPlayPause,
                                        icon: AnimatedIcons.pause_play,
                                        color:
                                            musicBox.get("dynamicArtDB") ?? true
                                                ? nowContrast
                                                : Colors.white,
                                      ),
                                      iconSize: deviceWidth! / 9,
                                      alignment: Alignment.center,
                                      onPressed: () async {
                                        pauseResume();
                                      }),
                                  IconButton(
                                    icon: Icon(
                                      MdiIcons.skipNext,
                                      color:
                                          musicBox.get("dynamicArtDB") ?? true
                                              ? nowContrast
                                              : Colors.white,
                                    ),
                                    iconSize: deviceWidth! / 12,
                                    onPressed: () async {
                                      audioHandler.skipToNext();
                                    },
                                  ),
                                  Consumer<Leprovider>(
                                      builder: (context, loo, _) {
                                    return IconButton(
                                      icon: Icon(
                                        Ionicons.repeat_outline,
                                        color: musicBox.get("dynamicArtDB") ??
                                                true
                                            ? loopSelected
                                                ? nowContrast
                                                : nowContrast.withOpacity(0.4)
                                            : loopSelected
                                                ? Colors.white
                                                : Colors.white38,
                                      ),
                                      iconSize: deviceWidth! / 15,
                                      onPressed: () async {
                                        if (loopSelected) {
                                          loo.changeLoop(false);
                                        } else {
                                          loo.changeLoop(true);
                                        }
                                        await loopMode();
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: deviceHeight! / 38)),
                            Consumer<Leprovider>(
                              builder: (context, haunt, _) {
                                return Center(
                                  child: SizedBox(
                                    width: deviceWidth! / 1.1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              child: SizedBox(
                                                height: deviceWidth! / 8,
                                                width: deviceWidth! / 8,
                                                child: Icon(
                                                  Graviticons.phoenix,
                                                  color: musicBox.get(
                                                              "dynamicArtDB") ??
                                                          true
                                                      ? isFlashin
                                                          ? nowContrast
                                                          : nowContrast
                                                              .withOpacity(0.4)
                                                      : isFlashin
                                                          ? Colors.white
                                                          : Colors.white38,
                                                  size: deviceWidth! / 13,
                                                ),
                                              ),
                                              onTap: () async {
                                                if (phoenixVisualizerShown) {
                                                  await Navigator.push(
                                                    context,
                                                    PageTransition(
                                                      type: PageTransitionType
                                                          .size,
                                                      alignment:
                                                          Alignment.center,
                                                      duration:
                                                          dialogueAnimationDuration,
                                                      reverseDuration:
                                                          dialogueAnimationDuration,
                                                      child:
                                                          const PhoenixVisualizer(),
                                                    ),
                                                  ).then((value) async {
                                                    if (value) {
                                                      setState(() {});
                                                    }
                                                  });
                                                } else {
                                                  stopPhoenixVisualizer();
                                                  setState(() {});
                                                }
                                              },
                                              onLongPress: () async {
                                                await Navigator.push(
                                                  context,
                                                  PageTransition(
                                                    type:
                                                        PageTransitionType.size,
                                                    alignment: Alignment.center,
                                                    duration:
                                                        dialogueAnimationDuration,
                                                    reverseDuration:
                                                        dialogueAnimationDuration,
                                                    child:
                                                        const PhoenixVisualizerCustomize(),
                                                  ),
                                                ).then((value) async {
                                                  setState(() {});
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            Visibility(
                              visible: musicBox.get("audiophileData") ?? true,
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                      (advanceAudioData == null
                                          ? ""
                                          : "${advanceAudioData!.bitrate}Kbps ${advanceAudioData!.sampleRate}KHz ${advanceAudioData!.format}"),
                                      style: TextStyle(
                                          fontSize: deviceWidth! / 37,
                                          fontFamily: "Futura",
                                          shadows: const [
                                            Shadow(
                                              offset: Offset(0.5, 0.5),
                                              blurRadius: 1,
                                              color: Colors.black26,
                                            ),
                                          ],
                                          color: musicBox.get("dynamicArtDB") ??
                                                  true
                                              ? nowContrast
                                              : Colors.white)),
                                ),
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: deviceHeight! / 38)),
                            Visibility(
                              visible: !(musicBox.get("isolation") == null
                                  ? false
                                  : musicBox.get('isolation')),
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(top: deviceHeight! / 28)),
                            ),
                            Visibility(
                              visible: !(musicBox.get("isolation") == null
                                  ? false
                                  : musicBox.get('isolation')),
                              child: SizedBox(
                                width: deviceWidth! / 1.1,
                                child: AspectRatio(
                                  aspectRatio: 4 / 5,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 700),
                                    decoration: BoxDecoration(
                                      color:
                                          musicBox.get("dynamicArtDB") ?? true
                                              ? nowContrast
                                              : Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(kRounded),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 13.0,
                                          offset: kShadowOffset,
                                          color: musicBox.get("dynamicArtDB") ??
                                                  true
                                              ? Colors.black54
                                              : Colors.white12,
                                        ),
                                      ],
                                    ),
                                    child: lyricsDat ==
                                            "Couldn't find any matching lyrics."
                                        ? Center(
                                            child: Container(
                                              width: deviceWidth! / 1.05,
                                              padding: EdgeInsets.only(
                                                  top: deviceWidth! / 18.5,
                                                  left: deviceWidth! / 20,
                                                  right: deviceWidth! / 20,
                                                  bottom: deviceWidth! / 12),
                                              child: Text(lyricsDat ?? "",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    wordSpacing: 2,
                                                    fontSize: deviceWidth! / 18,
                                                    fontFamily: "Raleway",
                                                    fontWeight: FontWeight.w600,
                                                    color: musicBox.get(
                                                                "dynamicArtDB") ??
                                                            true
                                                        ? nowColor
                                                        : kMaterialBlack,
                                                  )),
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            child: Container(
                                              width: deviceWidth! / 1.05,
                                              padding: EdgeInsets.only(
                                                  top: deviceWidth! / 18.5,
                                                  left: deviceWidth! / 20,
                                                  right: deviceWidth! / 20,
                                                  bottom: deviceWidth! / 12),
                                              child: Text(
                                                lyricsDat ?? "",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  wordSpacing: 2,
                                                  fontSize: deviceWidth! / 18,
                                                  fontFamily: "Raleway",
                                                  fontWeight: FontWeight.w600,
                                                  color: musicBox.get(
                                                              "dynamicArtDB") ??
                                                          true
                                                      ? nowColor
                                                      : kMaterialBlack,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: deviceHeight! / 30)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
//Landscape Screen
        : Consumer<MrMan>(
            builder: (context, bignow, child) {
              globalBigNow = bignow;
              return AnimatedContainer(
                duration: Duration(milliseconds: crossfadeDuration),
                decoration: BoxDecoration(
                    color: musicBox.get("dynamicArtDB") ?? true
                        ? nowColor
                        : kMaterialBlack,
                    borderRadius: musicBox.get("classix") ?? true
                        ? null
                        : radiusFullscreen),
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return;
                  } as bool Function(OverscrollIndicatorNotification)?,
                  child: SingleChildScrollView(
                    controller: stupidController,
                    physics: swapController
                        ? const NeverScrollableScrollPhysics()
                        : const ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: musicBox.get("androidAutoLefty") == null
                                  ? false
                                  : !musicBox.get("androidAutoLefty"),
                              child: SizedBox(
                                width: deviceHeight! / 2,
                                child: GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: NowArtLandScape(orientedCar),
                                  ),
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.size,
                                        alignment: Alignment.center,
                                        duration: dialogueAnimationDuration,
                                        reverseDuration:
                                            dialogueAnimationDuration,
                                        child: OnHoldExtended(
                                          context: context,
                                          car: orientedCar,
                                          heightOfDevice: deviceHeight,
                                          widthOfDevice: deviceWidth,
                                        ),
                                      ),
                                    );
                                  },
                                  onDoubleTap: () {
                                    onDoubleTap(context);
                                  },
                                  onLongPress: () {
                                    HapticFeedback.lightImpact();
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.size,
                                        alignment: Alignment.center,
                                        duration: dialogueAnimationDuration,
                                        reverseDuration:
                                            dialogueAnimationDuration,
                                        child: OnHoldExtended(
                                          context: context,
                                          car: orientedCar,
                                          heightOfDevice: deviceHeight,
                                          widthOfDevice: deviceWidth,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: deviceHeight! / 2,
                              height: deviceWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          width: deviceWidth! / 1.3,
                                          child: Center(
                                            child: MarqueeText(
                                              text: nowMediaItem.title,
                                              speed: 20,
                                              style: TextStyle(
                                                color: musicBox.get(
                                                            "dynamicArtDB") ??
                                                        true
                                                    ? nowContrast
                                                    : Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: deviceHeight! / 35,
                                                height: 1.3,
                                                shadows: const [
                                                  Shadow(
                                                    offset: Offset(1.0, 0.8),
                                                    blurRadius: 0.8,
                                                    color: Colors.black45,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Opacity(
                                    opacity: 0.7,
                                    child: Center(
                                      child: SizedBox(
                                        width: deviceWidth! / 1.4,
                                        child: Text(
                                          nowMediaItem.album!,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color:
                                                musicBox.get("dynamicArtDB") ??
                                                        true
                                                    ? nowContrast
                                                    : Colors.white,
                                            height: 1,
                                            fontSize: deviceHeight! / 60,
                                            shadows: const [
                                              Shadow(
                                                offset: Offset(0.7, 0.7),
                                                blurRadius: 1,
                                                color: Colors.black38,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: 0.7,
                                    child: Center(
                                      child: SizedBox(
                                        width: deviceWidth! / 1.4,
                                        child: Text(
                                          nowMediaItem.artist!,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                musicBox.get("dynamicArtDB") ??
                                                        true
                                                    ? nowContrast
                                                    : Colors.white,
                                            fontSize: deviceHeight! / 60,
                                            shadows: const [
                                              Shadow(
                                                offset: Offset(0.7, 0.7),
                                                blurRadius: 1,
                                                color: Colors.black38,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: deviceHeight! / 90),
                                  ),
                                  Center(
                                      child: SizedBox(
                                          width: deviceHeight! / 2 / 1.1,
                                          child: const SeekBar())),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: deviceHeight! / 100),
                                  ),
                                  SizedBox(
                                    width: deviceHeight! / 2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Consumer<Leprovider>(
                                            builder: (context, shuf, _) {
                                          return IconButton(
                                            icon: Icon(
                                                // MdiIcons.shuffle,
                                                Ionicons.shuffle_outline,
                                                color: musicBox.get(
                                                            "dynamicArtDB") ??
                                                        true
                                                    ? shuffleSelected
                                                        ? nowContrast
                                                        : nowContrast
                                                            .withOpacity(0.4)
                                                    : shuffleSelected
                                                        ? Colors.white
                                                        : Colors.white38),
                                            iconSize: deviceHeight! / 34,
                                            onPressed: () async {
                                              if (shuffleSelected) {
                                                shuf.changeShuffle(false);
                                              } else {
                                                shuf.changeShuffle(true);
                                              }
                                              await shuffleMode();
                                            },
                                          );
                                        }),
                                        IconButton(
                                            icon: Icon(
                                              MdiIcons.skipPrevious,
                                              color: musicBox.get(
                                                          "dynamicArtDB") ??
                                                      true
                                                  ? nowContrast
                                                  : Colors.white,
                                            ),
                                            iconSize: deviceHeight! / 23,
                                            onPressed: () async {
                                              audioHandler.skipToPrevious();
                                            }),
                                        IconButton(
                                            icon: AnimatedIcon(
                                              progress: animatedPlayPause,
                                              icon: AnimatedIcons.pause_play,
                                              color: musicBox.get(
                                                          "dynamicArtDB") ??
                                                      true
                                                  ? nowContrast
                                                  : Colors.white,
                                            ),
                                            iconSize: deviceHeight! / 18,
                                            alignment: Alignment.center,
                                            onPressed: () async {
                                              pauseResume();
                                            }),
                                        IconButton(
                                          icon: Icon(
                                            MdiIcons.skipNext,
                                            color:
                                                musicBox.get("dynamicArtDB") ??
                                                        true
                                                    ? nowContrast
                                                    : Colors.white,
                                          ),
                                          iconSize: deviceHeight! / 23,
                                          onPressed: () async {
                                            audioHandler.skipToNext();
                                          },
                                        ),
                                        Consumer<Leprovider>(
                                            builder: (context, loo, _) {
                                          return IconButton(
                                            icon: Icon(
                                              Ionicons.repeat_outline,
                                              color: musicBox.get(
                                                          "dynamicArtDB") ??
                                                      true
                                                  ? loopSelected
                                                      ? nowContrast
                                                      : nowContrast
                                                          .withOpacity(0.4)
                                                  : loopSelected
                                                      ? Colors.white
                                                      : Colors.white38,
                                            ),
                                            iconSize: deviceHeight! / 29,
                                            onPressed: () async {
                                              if (loopSelected) {
                                                loo.changeLoop(false);
                                              } else {
                                                loo.changeLoop(true);
                                              }
                                              await loopMode();
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: deviceHeight! / 38)),
                                  Consumer<Leprovider>(
                                    builder: (context, haunt, _) {
                                      return Center(
                                        child: SizedBox(
                                          width: deviceWidth! / 1.1,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    child: SizedBox(
                                                      height: deviceWidth! / 8,
                                                      width: deviceWidth! / 8,
                                                      child: Icon(
                                                        Graviticons.phoenix,
                                                        color: musicBox.get(
                                                                    "dynamicArtDB") ??
                                                                true
                                                            ? isFlashin
                                                                ? nowContrast
                                                                : nowContrast
                                                                    .withOpacity(
                                                                        0.4)
                                                            : isFlashin
                                                                ? Colors.white
                                                                : Colors
                                                                    .white38,
                                                        size: deviceWidth! / 13,
                                                      ),
                                                    ),
                                                    onTap: () async {
                                                      if (phoenixVisualizerShown) {
                                                        await Navigator.push(
                                                          context,
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .size,
                                                            alignment: Alignment
                                                                .center,
                                                            duration:
                                                                dialogueAnimationDuration,
                                                            reverseDuration:
                                                                dialogueAnimationDuration,
                                                            child:
                                                                const PhoenixVisualizer(),
                                                          ),
                                                        ).then((value) async {
                                                          setState(() {});
                                                        });
                                                      } else {
                                                        stopPhoenixVisualizer();
                                                        setState(() {});
                                                      }
                                                    },
                                                    onLongPress: () async {
                                                      if (phoenixVisualizerShown) {
                                                        await Navigator.push(
                                                          context,
                                                          PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .size,
                                                            alignment: Alignment
                                                                .center,
                                                            duration:
                                                                dialogueAnimationDuration,
                                                            reverseDuration:
                                                                dialogueAnimationDuration,
                                                            child:
                                                                const PhoenixVisualizer(),
                                                          ),
                                                        ).then((value) async {
                                                          if (value) {
                                                            setState(() {});
                                                          }
                                                        });
                                                      } else {
                                                        stopPhoenixVisualizer();
                                                        setState(() {});
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Visibility(
                                    visible:
                                        musicBox.get("audiophileData") ?? true,
                                    child: Center(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                            (advanceAudioData == null
                                                ? ""
                                                : "${advanceAudioData!.bitrate}Kbps ${advanceAudioData!.sampleRate}KHz ${advanceAudioData!.format}"),
                                            style: TextStyle(
                                                fontSize: deviceWidth! / 37,
                                                fontFamily: "Futura",
                                                shadows: const [
                                                  Shadow(
                                                    offset: Offset(0.5, 0.5),
                                                    blurRadius: 1,
                                                    color: Colors.black26,
                                                  ),
                                                ],
                                                color: musicBox.get(
                                                            "dynamicArtDB") ??
                                                        true
                                                    ? nowContrast
                                                    : Colors.white)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: musicBox.get("androidAutoLefty") ?? true
                                  ? true
                                  : false,
                              child: SizedBox(
                                width: deviceHeight! / 2,
                                child: GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30),
                                    child: NowArtLandScape(orientedCar),
                                  ),
                                  onDoubleTap: () {
                                    onDoubleTap(context);
                                  },
                                  onLongPress: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.size,
                                        alignment: Alignment.center,
                                        duration: dialogueAnimationDuration,
                                        reverseDuration:
                                            dialogueAnimationDuration,
                                        child: OnHoldExtended(
                                          context: context,
                                          car: orientedCar,
                                          heightOfDevice: deviceHeight,
                                          widthOfDevice: deviceWidth,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: deviceHeight! / 38)),
                        Visibility(
                          visible: !(musicBox.get("isolation") == null
                              ? false
                              : musicBox.get('isolation')),
                          child: Padding(
                              padding:
                                  EdgeInsets.only(top: deviceHeight! / 28)),
                        ),
                        Visibility(
                          visible: !(musicBox.get("isolation") == null
                              ? false
                              : musicBox.get('isolation')),
                          child: SizedBox(
                            height: deviceWidth,
                            width: deviceHeight! / 2,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 700),
                              decoration: BoxDecoration(
                                color: musicBox.get("dynamicArtDB") ?? true
                                    ? nowContrast
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(kRounded),
                                boxShadow: [
                                  BoxShadow(
                                    color: musicBox.get("dynamicArtDB") ?? true
                                        ? Colors.black54
                                        : Colors.white12,
                                    offset: kShadowOffset,
                                    blurRadius: 13.0,
                                  ),
                                ],
                              ),
                              child: lyricsDat ==
                                      "Couldn't find any matching lyrics."
                                  ? Center(
                                      child: Container(
                                        width: deviceWidth! / 1.05,
                                        padding: EdgeInsets.only(
                                            top: deviceWidth! / 18.5,
                                            left: deviceWidth! / 20,
                                            right: deviceWidth! / 20,
                                            bottom: deviceWidth! / 12),
                                        child: Text(lyricsDat ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              wordSpacing: 2,
                                              fontSize: deviceWidth! / 18,
                                              fontFamily: "Raleway",
                                              fontWeight: FontWeight.w600,
                                              color: musicBox.get(
                                                          "dynamicArtDB") ??
                                                      true
                                                  ? nowColor
                                                  : kMaterialBlack,
                                            )),
                                      ),
                                    )
                                  : SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        width: deviceWidth! / 1.05,
                                        padding: EdgeInsets.only(
                                            top: deviceWidth! / 18.5,
                                            left: deviceWidth! / 20,
                                            right: deviceWidth! / 20,
                                            bottom: deviceWidth! / 12),
                                        child: Text(lyricsDat ?? "",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              wordSpacing: 2,
                                              fontSize: deviceWidth! / 18,
                                              fontFamily: "Raleway",
                                              fontWeight: FontWeight.w600,
                                              color: musicBox.get(
                                                          "dynamicArtDB") ??
                                                      true
                                                  ? nowColor
                                                  : kMaterialBlack,
                                            )),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !(musicBox.get("isolation") == null
                              ? false
                              : musicBox.get('isolation')),
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: deviceWidth! * 1.03,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
