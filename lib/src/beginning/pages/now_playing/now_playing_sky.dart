// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remixicon/flutter_remixicon.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/equalizer.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/custom/focus_lyrics.dart';
import 'package:phoenix/src/beginning/widgets/custom/graviticons.dart';
import 'package:phoenix/src/beginning/widgets/custom/marquee.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/on_hold.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/phoenix_visualizer.dart';
import 'package:phoenix/src/beginning/widgets/now_art.dart';
import 'package:phoenix/src/beginning/widgets/seek_bar.dart';
import 'package:provider/provider.dart';

class NowPlayingSky extends StatefulWidget {
  const NowPlayingSky({super.key});

  @override
  State<NowPlayingSky> createState() => _NowPlayingSkyState();
}

class _NowPlayingSkyState extends State<NowPlayingSky>
    with TickerProviderStateMixin {
  ScrollController lyricscrollController = ScrollController();
  double skyBlur = 30;
  Color skyOverlayColor = Colors.black.withOpacity(0.15);
  int skyFadeDuration = 600;

  @override
  void initState() {
    try {
      animatedPlayPause.isAnimating;
    } catch (e) {
      animatedPlayPause = AnimationController(
          vsync: this, duration: Duration(milliseconds: crossfadeDuration));
    }
    super.initState();
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
    return !orientedCar
        ? Consumer<MrMan>(builder: (context, bignow, child) {
            globalBigNow = bignow;
            return Container(
              color: kMaterialBlack,
              child: Stack(
                children: [
                  Visibility(
                    visible: musicBox.get("dynamicArtDB") ?? true,
                    child: AnimatedCrossFade(
                      duration: Duration(milliseconds: skyFadeDuration),
                      firstChild: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(art!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              tileMode: TileMode.mirror,
                              sigmaX: skyBlur,
                              sigmaY: skyBlur),
                          child: Container(
                            alignment: Alignment.center,
                            color: skyOverlayColor,
                            child: Center(
                              child: SizedBox(
                                height:
                                    orientedCar ? deviceWidth : deviceHeight,
                                width: orientedCar ? deviceHeight : deviceWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                      secondChild: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(art2!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              tileMode: TileMode.mirror,
                              sigmaX: skyBlur,
                              sigmaY: skyBlur),
                          child: Container(
                            alignment: Alignment.center,
                            color: skyOverlayColor,
                            child: Center(
                              child: SizedBox(
                                height:
                                    orientedCar ? deviceWidth : deviceHeight,
                                width: orientedCar ? deviceHeight : deviceWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                      crossFadeState: first
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.only(top: deviceHeight! / 30),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: deviceHeight! / 1.7,
                        child: InkWell(
                          enableFeedback: false,
                          onTap: () {
                            if (!onLyrics) {
                              HapticFeedback.lightImpact();
                              setState(() {
                                onLyrics = !onLyrics;
                              });
                              if (onLyrics) lyricsFoo();
                            }
                            // print(lyricsDat);
                            // print("What the cuk");
                            // print("YOOOOOOOOOOOOO${lyricsDat!.isValidLrc}");
                          },
                          onDoubleTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              onLyrics = !onLyrics;
                            });
                            if (onLyrics) lyricsFoo();
                          },
                          onLongPress: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.size,
                                alignment: Alignment.center,
                                duration: dialogueAnimationDuration,
                                reverseDuration: dialogueAnimationDuration,
                                child: OnHoldExtended(
                                  context: context,
                                  car: orientedCar,
                                  heightOfDevice: deviceHeight,
                                  widthOfDevice: deviceWidth,
                                ),
                              ),
                            );
                          },
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: Stack(
                                children: [
                                  Visibility(
                                      maintainState: true,
                                      visible: !onLyrics,
                                      child: NowArt(false)),
                                  Visibility(
                                    visible: onLyrics,
                                    child: ShaderMask(
                                      shaderCallback: (bounds) =>
                                          LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: const [
                                            0.0,
                                            0.1,
                                            0.9,
                                            1.0
                                          ],
                                              colors: [
                                            Colors.transparent,
                                            musicBox.get("dynamicArtDB") ?? true
                                                ? isArtworkDark!
                                                    ? Colors.white
                                                    : Colors.black
                                                : Colors.white,
                                            musicBox.get("dynamicArtDB") ?? true
                                                ? isArtworkDark!
                                                    ? Colors.white
                                                    : Colors.black
                                                : Colors.white,
                                            Colors.transparent
                                          ]).createShader(Rect.fromLTRB(0, 0,
                                              bounds.width, bounds.height)),

                                      //TODO unfucker

                                      child: lyricsDat!.contains("[00:")
                                          ? FocusedTextWidget.fromString(
                                              text: lyricsDat!,
                                              // showSeparator: true,
                                              resizeFactor: 0.5,
                                              maxParagraphLines: 3,

                                              // autoPlay: true,
                                              // autoPlayDuration:
                                              //     const Duration(seconds: 3),
                                            )
                                          : SingleChildScrollView(
                                              controller: lyricscrollController,
                                              padding: EdgeInsets.only(
                                                  bottom: deviceHeight! / 18,
                                                  top: deviceHeight! / 18),
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Text(
                                                lyricsDat ?? "",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  wordSpacing: 2,
                                                  fontSize: deviceWidth! / 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: musicBox.get(
                                                              "dynamicArtDB") ??
                                                          true
                                                      ? isArtworkDark!
                                                          ? Colors.white
                                                          : Colors.black
                                                      : Colors.white,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(bottom: deviceHeight! / 50)),
                      Column(
                        children: [
                          Row(children: [
                            SizedBox(
                              width: orientedCar ? deviceHeight : deviceWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 50, right: 50, bottom: 7),
                                child: MarqueeText(
                                  text: nowMediaItem.title,
                                  style: TextStyle(
                                    color: musicBox.get("dynamicArtDB") ?? true
                                        ? isArtworkDark!
                                            ? Colors.white
                                            : Colors.black
                                        : Colors.white,
                                    fontSize: deviceHeight! / 32,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  speed: 20,
                                ),
                              ),
                            ),
                          ]),
                          Row(
                            children: [
                              SizedBox(
                                width: orientedCar ? deviceHeight : deviceWidth,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50, right: 50),
                                  child: Text(
                                    "${nowMediaItem.artist} - ${nowMediaItem.album}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: deviceHeight! / 65,
                                        color:
                                            musicBox.get("dynamicArtDB") ?? true
                                                ? isArtworkDark!
                                                    ? Colors.white
                                                    : Colors.black
                                                : Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const CyberSkySeekBar(),
                      SizedBox(
                        width: deviceWidth! - 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Consumer<Leprovider>(builder: (context, shuf, _) {
                                return IconButton(
                                  icon: Icon(Ionicons.shuffle_outline,
                                      color:
                                          musicBox.get("dynamicArtDB") ?? true
                                              ? shuffleSelected
                                                  ? isArtworkDark!
                                                      ? Colors.white
                                                      : Colors.black
                                                  : isArtworkDark!
                                                      ? Colors.white
                                                          .withOpacity(0.4)
                                                      : Colors.black
                                                          .withOpacity(0.4)
                                              : shuffleSelected
                                                  ? Colors.white
                                                  : Colors.white38),
                                  iconSize: deviceWidth! / 18,
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
                                    color: musicBox.get("dynamicArtDB") ?? true
                                        ? isArtworkDark!
                                            ? Colors.white
                                            : Colors.black
                                        : Colors.white,
                                  ),
                                  iconSize: deviceWidth! / 14,
                                  onPressed: () async {
                                    audioHandler.skipToPrevious();
                                  }),
                              Container(
                                width: deviceWidth! / 8,
                                height: deviceWidth! / 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2)),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(deviceWidth! / 16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: skyBlur, sigmaY: skyBlur),
                                    child: AnimatedContainer(
                                      duration: Duration(
                                          milliseconds: skyFadeDuration),
                                      color: nowColor.withOpacity(0.3),
                                      child: Center(
                                        child: IconButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            padding: EdgeInsets.zero,
                                            icon: AnimatedIcon(
                                              progress: animatedPlayPause,
                                              icon: AnimatedIcons.pause_play,
                                              color: musicBox.get(
                                                          "dynamicArtDB") ??
                                                      true
                                                  ? isArtworkDark!
                                                      ? Colors.white
                                                      : Colors.black
                                                  : Colors.white,
                                            ),
                                            iconSize: deviceWidth! / 11,
                                            alignment: Alignment.center,
                                            onPressed: () async {
                                              pauseResume();
                                            }),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  MdiIcons.skipNext,
                                  color: musicBox.get("dynamicArtDB") ?? true
                                      ? isArtworkDark!
                                          ? Colors.white
                                          : Colors.black
                                      : Colors.white,
                                ),
                                iconSize: deviceWidth! / 14,
                                onPressed: () async {
                                  audioHandler.skipToNext();
                                },
                              ),
                              Consumer<Leprovider>(builder: (context, loo, _) {
                                return IconButton(
                                  icon: Icon(
                                    Ionicons.repeat_outline,
                                    color: musicBox.get("dynamicArtDB") ?? true
                                        ? loopSelected
                                            ? isArtworkDark!
                                                ? Colors.white
                                                : Colors.black
                                            : isArtworkDark!
                                                ? Colors.white.withOpacity(0.4)
                                                : Colors.black.withOpacity(0.4)
                                        : loopSelected
                                            ? Colors.white
                                            : Colors.white38,
                                  ),
                                  iconSize: deviceWidth! / 17,
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
                            ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(kRounded),
                              onTap: () async {
                                // setState(() {
                                //   onLyrics = !onLyrics;
                                // });
                                // if (onLyrics) lyricsFoo();
                                await Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.size,
                                    alignment: Alignment.center,
                                    duration: dialogueAnimationDuration,
                                    reverseDuration: dialogueAnimationDuration,
                                    child: const EqualizerPage(),
                                  ),
                                ).then((value) async {
                                  setState(() {});
                                });

                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => EqualizerPage()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(17.0),
                                child: Icon(
                                  MIcon.riDiscLine,
                                  // Graviticons.lyricsAwesome,
                                  color: musicBox.get("dynamicArtDB") ?? true
                                      ? equalizer.enabled
                                          ? isArtworkDark!
                                              ? Colors.white
                                              : Colors.black
                                          : isArtworkDark!
                                              ? Colors.white.withOpacity(0.4)
                                              : Colors.black.withOpacity(0.4)
                                      : equalizer.enabled
                                          ? Colors.white
                                          : Colors.white38,
                                  size: deviceWidth! / 15,
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: musicBox.get("audiophileData") ?? true,
                            child: Expanded(
                              child: AnimatedSwitcher(
                                // transitionBuilder: (Widget child,
                                // Animation<double> animation) {
                                //   return SlideTransition(
                                //     position: Tween<Offset>(
                                //       begin: Offset(0, 5),
                                //       end: Offset(0, 0.0),
                                //     ).animate(animation),
                                //     child: child,
                                //   );
                                // },
                                duration:
                                    Duration(milliseconds: crossfadeDuration),
                                child: Text(
                                    (advanceAudioData == null
                                        ? ""
                                        : "${advanceAudioData!.bitrate}Kbps ${advanceAudioData!.sampleRate}KHz ${advanceAudioData!.format}"),
                                    key: ValueKey<String>(
                                      (advanceAudioData == null
                                          ? ""
                                          : "${advanceAudioData!.bitrate}Kbps ${advanceAudioData!.sampleRate}KHz ${advanceAudioData!.format}"),
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: deviceWidth! / 37,
                                        shadows: const [
                                          Shadow(
                                            offset: Offset(0.5, 0.5),
                                            blurRadius: 1,
                                            color: Colors.black26,
                                          ),
                                        ],
                                        color:
                                            musicBox.get("dynamicArtDB") ?? true
                                                ? isArtworkDark!
                                                    ? Colors.white
                                                    : Colors.black
                                                : Colors.white)),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(kRounded),
                              onTap: () async {
                                if (phoenixVisualizerShown) {
                                  await Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.size,
                                      alignment: Alignment.center,
                                      duration: dialogueAnimationDuration,
                                      reverseDuration:
                                          dialogueAnimationDuration,
                                      child: const PhoenixVisualizer(),
                                    ),
                                  ).then((value) async {
                                    setState(() {});
                                  });
                                } else {
                                  stopPhoenixVisualizer();
                                  setState(() {});
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => EqualizerPage()));
                              },
                              onLongPress: () async {
                                await Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.size,
                                    alignment: Alignment.center,
                                    duration: dialogueAnimationDuration,
                                    reverseDuration: dialogueAnimationDuration,
                                    child: const PhoenixVisualizerCustomize(),
                                  ),
                                ).then((value) async {
                                  setState(() {});
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(17.0),
                                child: Icon(
                                  Graviticons.phoenix,
                                  color: musicBox.get("dynamicArtDB") ?? true
                                      ? isFlashin
                                          ? isArtworkDark!
                                              ? Colors.white
                                              : Colors.black
                                          : isArtworkDark!
                                              ? Colors.white.withOpacity(0.4)
                                              : Colors.black.withOpacity(0.4)
                                      : isFlashin
                                          ? Colors.white
                                          : Colors.white38,
                                  size: deviceWidth! / 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          })

        /// Landscape screen
        : Consumer<MrMan>(
            builder: (context, bignow, child) {
              globalBigNow = bignow;
              return Container(
                color: kMaterialBlack,
                child: Stack(
                  children: [
                    Visibility(
                      visible: musicBox.get("dynamicArtDB") ?? true,
                      child: AnimatedCrossFade(
                        duration: Duration(milliseconds: skyFadeDuration),
                        firstChild: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(art!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                tileMode: TileMode.mirror,
                                sigmaX: skyBlur,
                                sigmaY: skyBlur),
                            child: Container(
                              alignment: Alignment.center,
                              color: skyOverlayColor,
                              child: Center(
                                child: SizedBox(
                                  height:
                                      orientedCar ? deviceHeight : deviceWidth,
                                  width:
                                      orientedCar ? deviceWidth : deviceHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        secondChild: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(art2!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                tileMode: TileMode.mirror,
                                sigmaX: skyBlur,
                                sigmaY: skyBlur),
                            child: Container(
                              alignment: Alignment.center,
                              color: skyOverlayColor,
                              child: Center(
                                child: SizedBox(
                                  height:
                                      orientedCar ? deviceHeight : deviceWidth,
                                  width:
                                      orientedCar ? deviceWidth : deviceHeight,
                                ),
                              ),
                            ),
                          ),
                        ),
                        crossFadeState: first
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: musicBox.get("androidAutoLefty") == null
                              ? false
                              : !musicBox.get("androidAutoLefty"),
                          child: SizedBox(
                            height: deviceWidth,
                            width: deviceHeight! / 2,
                            child: InkWell(
                              enableFeedback: false,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Stack(
                                  children: [
                                    Visibility(
                                      maintainState: true,
                                      visible: !onLyrics,
                                      child: NowArtLandScape(orientedCar),
                                    ),
                                    Center(
                                      child: Visibility(
                                        visible: onLyrics,
                                        child: ShaderMask(
                                          shaderCallback: (bounds) =>
                                              LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  stops: const [
                                                0.0,
                                                0.1,
                                                0.9,
                                                1.0
                                              ],
                                                  colors: [
                                                Colors.transparent,
                                                musicBox.get("dynamicArtDB") ??
                                                        true
                                                    ? isArtworkDark!
                                                        ? Colors.white
                                                        : Colors.black
                                                    : Colors.white,
                                                musicBox.get("dynamicArtDB") ??
                                                        true
                                                    ? isArtworkDark!
                                                        ? Colors.white
                                                        : Colors.black
                                                    : Colors.white,
                                                Colors.transparent
                                              ]).createShader(Rect.fromLTRB(
                                                  0,
                                                  0,
                                                  bounds.width,
                                                  bounds.height)),
                                          child: SingleChildScrollView(
                                            controller: lyricscrollController,
                                            padding: EdgeInsets.only(
                                                bottom: deviceHeight! / 18,
                                                top: deviceHeight! / 18),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Text(
                                              lyricsDat ?? "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                wordSpacing: 2,
                                                fontSize: deviceWidth! / 18,
                                                fontWeight: FontWeight.w600,
                                                color: musicBox.get(
                                                            "dynamicArtDB") ??
                                                        true
                                                    ? isArtworkDark!
                                                        ? Colors.white
                                                        : Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  onLyrics = !onLyrics;
                                });
                                if (onLyrics) lyricsFoo();
                              },
                              onLongPress: () {
                                HapticFeedback.lightImpact();
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.size,
                                    alignment: Alignment.center,
                                    duration: dialogueAnimationDuration,
                                    reverseDuration: dialogueAnimationDuration,
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
                              Row(
                                children: [
                                  SizedBox(
                                    width: deviceHeight! / 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, right: 50),
                                      child: MarqueeText(
                                        text: nowMediaItem.title,
                                        speed: 20,
                                        style: TextStyle(
                                          color: musicBox.get("dynamicArtDB") ??
                                                  true
                                              ? isArtworkDark!
                                                  ? Colors.white
                                                  : Colors.black
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
                                ],
                              ),
                              Opacity(
                                opacity: 0.7,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: deviceHeight! / 2,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50, right: 50),
                                        child: Text(
                                          "${nowMediaItem.artist} - ${nowMediaItem.album}",
                                          maxLines: 1,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color:
                                                musicBox.get("dynamicArtDB") ??
                                                        true
                                                    ? isArtworkDark!
                                                        ? Colors.white
                                                        : Colors.black
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
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: deviceHeight! / 90),
                              ),
                              Center(
                                child: SizedBox(
                                  width: deviceHeight! / 2,
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 50.0, right: 50),
                                    child: CyberSkySeekBar(),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: deviceHeight! / 100),
                              ),
                              SizedBox(
                                width: deviceHeight! / 2 - 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Consumer<Leprovider>(
                                        builder: (context, shuf, _) {
                                      return IconButton(
                                        icon: Icon(Ionicons.shuffle_outline,
                                            color: musicBox
                                                        .get("dynamicArtDB") ??
                                                    true
                                                ? shuffleSelected
                                                    ? isArtworkDark!
                                                        ? Colors.white
                                                        : Colors.black
                                                    : isArtworkDark!
                                                        ? Colors.white
                                                            .withOpacity(0.4)
                                                        : Colors.black
                                                            .withOpacity(0.4)
                                                : shuffleSelected
                                                    ? Colors.white
                                                    : Colors.white38),
                                        iconSize: deviceHeight! / 36,
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
                                          color: musicBox.get("dynamicArtDB") ??
                                                  true
                                              ? isArtworkDark!
                                                  ? Colors.white
                                                  : Colors.black
                                              : Colors.white,
                                        ),
                                        iconSize: deviceHeight! / 25,
                                        onPressed: () async {
                                          audioHandler.skipToPrevious();
                                        }),
                                    Container(
                                      width: deviceHeight! / 16,
                                      height: deviceHeight! / 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2)),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            deviceHeight! / 32),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: skyBlur, sigmaY: skyBlur),
                                          child: AnimatedContainer(
                                            duration: Duration(
                                                milliseconds: skyFadeDuration),
                                            color: nowColor.withOpacity(0.3),
                                            child: Center(
                                              child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  icon: AnimatedIcon(
                                                    progress: animatedPlayPause,
                                                    icon: AnimatedIcons
                                                        .pause_play,
                                                    color: musicBox.get(
                                                                "dynamicArtDB") ??
                                                            true
                                                        ? isArtworkDark!
                                                            ? Colors.white
                                                            : Colors.black
                                                        : Colors.white,
                                                  ),
                                                  iconSize: deviceHeight! / 20,
                                                  alignment: Alignment.center,
                                                  onPressed: () async {
                                                    pauseResume();
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        MdiIcons.skipNext,
                                        color:
                                            musicBox.get("dynamicArtDB") ?? true
                                                ? isArtworkDark!
                                                    ? Colors.white
                                                    : Colors.black
                                                : Colors.white,
                                      ),
                                      iconSize: deviceHeight! / 25,
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
                                                  ? isArtworkDark!
                                                      ? Colors.white
                                                      : Colors.black
                                                  : isArtworkDark!
                                                      ? Colors.white
                                                          .withOpacity(0.4)
                                                      : Colors.black
                                                          .withOpacity(0.4)
                                              : loopSelected
                                                  ? Colors.white
                                                  : Colors.white38,
                                        ),
                                        iconSize: deviceHeight! / 31,
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
                                  return SizedBox(
                                    width: deviceHeight! / 2 - 100,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(kRounded),
                                            onTap: () {
                                              setState(() {
                                                onLyrics = !onLyrics;
                                              });
                                              if (onLyrics) lyricsFoo();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(17.0),
                                              child: Icon(
                                                Graviticons.lyricsAwesome,
                                                color: musicBox.get(
                                                            "dynamicArtDB") ??
                                                        true
                                                    ? onLyrics
                                                        ? isArtworkDark!
                                                            ? Colors.white
                                                            : Colors.black
                                                        : isArtworkDark!
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.4)
                                                            : Colors.black
                                                                .withOpacity(
                                                                    0.4)
                                                    : onLyrics
                                                        ? Colors.white
                                                        : Colors.white38,
                                                size: deviceWidth! / 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              musicBox.get("audiophileData") ??
                                                  true,
                                          child: Expanded(
                                            child: AnimatedSwitcher(
                                              duration: Duration(
                                                  milliseconds:
                                                      crossfadeDuration),
                                              child: Text(
                                                  (advanceAudioData == null
                                                      ? ""
                                                      : "${advanceAudioData!.bitrate}Kbps ${advanceAudioData!.sampleRate}KHz ${advanceAudioData!.format}"),
                                                  textAlign: TextAlign.center,
                                                  key: ValueKey<String>(
                                                    (advanceAudioData == null
                                                        ? ""
                                                        : "${advanceAudioData!.bitrate}Kbps ${advanceAudioData!.sampleRate}KHz ${advanceAudioData!.format}"),
                                                  ),
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontSize:
                                                          deviceWidth! / 37,
                                                      shadows: const [
                                                        Shadow(
                                                          offset:
                                                              Offset(0.5, 0.5),
                                                          blurRadius: 1,
                                                          color: Colors.black26,
                                                        ),
                                                      ],
                                                      color: musicBox.get(
                                                                  "dynamicArtDB") ??
                                                              true
                                                          ? isArtworkDark!
                                                              ? Colors.white
                                                              : Colors.black
                                                          : Colors.white)),
                                            ),
                                          ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(kRounded),
                                            onTap: () async {
                                              // if (phoenixVisualizerShown) {
                                              //   await Navigator.push(
                                              //     context,
                                              //     PageTransition(
                                              //       type:
                                              //           PageTransitionType.size,
                                              //       alignment: Alignment.center,
                                              //       duration: const Duration(
                                              //           milliseconds: 200),
                                              //       reverseDuration:
                                              //           const Duration(
                                              //               milliseconds: 200),
                                              //       child:
                                              //           const PhoenixVisualizer(),
                                              //     ),
                                              //   ).then((value) async {
                                              //     if (value) {
                                              //       setState(() {});
                                              //     }
                                              //   });
                                              // } else {
                                              //   stopPhoenixVisualizer();
                                              //   setState(() {});
                                              // }
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EqualizerPage()));
                                            },
                                            onLongPress: () async {
                                              await Navigator.push(
                                                context,
                                                PageTransition(
                                                  type: PageTransitionType.size,
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(17.0),
                                              child: Icon(
                                                Graviticons.phoenix,
                                                color: musicBox.get(
                                                            "dynamicArtDB") ??
                                                        true
                                                    ? isFlashin
                                                        ? isArtworkDark!
                                                            ? Colors.white
                                                            : Colors.black
                                                        : isArtworkDark!
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.4)
                                                            : Colors.black
                                                                .withOpacity(
                                                                    0.4)
                                                    : isFlashin
                                                        ? Colors.white
                                                        : Colors.white38,
                                                size: deviceWidth! / 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: musicBox.get("androidAutoLefty") ?? true
                              ? true
                              : false,
                          child: SizedBox(
                            height: deviceWidth,
                            width: deviceHeight! / 2,
                            child: InkWell(
                              enableFeedback: false,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: Stack(
                                  children: [
                                    Visibility(
                                      maintainState: true,
                                      visible: !onLyrics,
                                      child: NowArtLandScape(orientedCar),
                                    ),
                                    Center(
                                      child: Visibility(
                                        visible: onLyrics,
                                        child: ShaderMask(
                                          shaderCallback: (bounds) =>
                                              LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  stops: const [
                                                0.0,
                                                0.1,
                                                0.9,
                                                1.0
                                              ],
                                                  colors: [
                                                Colors.transparent,
                                                musicBox.get("dynamicArtDB") ??
                                                        true
                                                    ? isArtworkDark!
                                                        ? Colors.white
                                                        : Colors.black
                                                    : Colors.white,
                                                musicBox.get("dynamicArtDB") ??
                                                        true
                                                    ? isArtworkDark!
                                                        ? Colors.white
                                                        : Colors.black
                                                    : Colors.white,
                                                Colors.transparent
                                              ]).createShader(Rect.fromLTRB(
                                                  0,
                                                  0,
                                                  bounds.width,
                                                  bounds.height)),
                                          child: SingleChildScrollView(
                                            controller: lyricscrollController,
                                            padding: EdgeInsets.only(
                                                bottom: deviceHeight! / 18,
                                                top: deviceHeight! / 18),
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Text(
                                              lyricsDat ?? "",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                wordSpacing: 2,
                                                fontSize: deviceWidth! / 18,
                                                fontWeight: FontWeight.w600,
                                                color: musicBox.get(
                                                            "dynamicArtDB") ??
                                                        true
                                                    ? isArtworkDark!
                                                        ? Colors.white
                                                        : Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                HapticFeedback.lightImpact();
                                setState(() {
                                  onLyrics = !onLyrics;
                                });
                                if (onLyrics) lyricsFoo();
                              },
                              onLongPress: () {
                                HapticFeedback.lightImpact();
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.size,
                                    alignment: Alignment.center,
                                    duration: dialogueAnimationDuration,
                                    reverseDuration: dialogueAnimationDuration,
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
                  ],
                ),
              );
            },
          );
  }
}
