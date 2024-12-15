// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phoenix/src/beginning/pages/albums/albums.dart';
import 'package:phoenix/src/beginning/pages/now_playing/now_playing_sky.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/widgets/custom/graviticons.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/phoenix_visualizer.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/quick_tips.dart';
import 'package:phoenix/src/beginning/pages/now_playing/mini_playing.dart';
import 'package:phoenix/src/beginning/pages/playlist/playlist.dart';
import 'package:phoenix/src/beginning/pages/settings/settings.dart';
import 'pages/tracks/tracks.dart';
import 'package:phoenix/src/beginning/pages/genres/genres.dart';
import 'package:phoenix/src/beginning/pages/artists/artists.dart';
import 'package:phoenix/src/beginning/pages/search/search.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:phoenix/src/beginning/pages/mansion/mansion.dart';
import 'package:phoenix/src/beginning/widgets/custom/physics.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/tab_bar.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:ionicons/ionicons.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/visualizer_notification.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_remixicon/flutter_remixicon.dart';

class Begin extends StatefulWidget {
  static final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  static bool isLoading = true;
  const Begin({super.key});
  @override
  State<Begin> createState() => _BeginState();
}

class _BeginState extends State<Begin>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool isonexit = false;
  bool stackedPhoenix = false;
  TabController? tabController;

  @override
  void initState() {
    setScreenFrames();
    audioServiceStream();
    tabController = TabController(vsync: this, length: 6, initialIndex: 1);
    visualizerNotificationInit();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Begin.refreshIndicatorKey.currentState?.show();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    animatedPlayPause.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (onSettings) {
          yeahRotate();
        }
        break;
      case AppLifecycleState.paused:
        breakRotate = true;
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  @override
  Future<bool> didPopRoute() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (musicBox.get("timeBasedDark") ?? false) {
      if (DateTime.now().hour < 19 && DateTime.now().hour > 6) {
        musicBox.put("timeBasedDark", false);
        musicBox.put("dynamicArtDB", true);
        musicBox.put("timeBasedDark", false);
      }
    }
    if (refresh) {
      debugPrint("Refreshing...");
      refresh = false;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Begin.refreshIndicatorKey.currentState?.show();
      });
    }
    orientedCar = false;
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
    rootCrossfadeState = Provider.of<Leprovider>(context);
    rootState = Provider.of<Leprovider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: SlidingUpPanel(
          parallaxEnabled: true,
          isDraggable: true,
          backdropColor: Colors.black,
          minHeight: 60,
          controller: pc,
          borderRadius: musicBox.get("classix") ?? true
              ? null
              : BorderRadius.only(
                  topLeft: Radius.circular(deviceWidth! / 40),
                  topRight: Radius.circular(deviceWidth! / 40)),
          backdropEnabled: true,
          onPanelOpened: () {
            if (musicBox.get("quickTip") == null) {
              musicBox.put("quickTip", true);
              quickTip(context);
            }
          },
          onPanelClosed: () {
            if (isPlayerShown) {
              rootState.provideman();
            }
          },
          collapsed: Classix(),
          maxHeight: deviceHeight!,
          backdropTapClosesPanel: true,
          renderPanelSheet: true,
          color: Colors.transparent,
          panel: NowPlayingSky(),
          body: Stack(
            children: [
              BackArt(),
              SafeArea(
                top: true,
                child: Column(
                  children: [
                    SizedBox(
                      width: orientedCar ? deviceHeight : deviceWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(top: deviceHeight! / 100)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Stack(
                                  children: [
                                    Visibility(
                                      visible: stackedPhoenix,
                                      child: Text(
                                        "  PHOENIX",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: orientedCar
                                                ? deviceWidth! / 16
                                                : deviceHeight! / 32,
                                            fontFamily: "NightMachine"),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Visibility(
                                      visible: !stackedPhoenix,
                                      child: AnimatedTextKit(
                                        animatedTexts: [
                                          TypewriterAnimatedText(
                                            "  PHOENIX",
                                            cursor: " ",
                                            speed: const Duration(
                                                milliseconds: 70),
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: orientedCar
                                                    ? deviceWidth! / 16
                                                    : deviceHeight! / 32,
                                                fontFamily: "NightMachine"),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                        isRepeatingAnimation: false,
                                        onFinished: () {
                                          stackedPhoenix = true;
                                          rootState.provideman();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: orientedCar
                                      ? deviceWidth! > 400
                                          ? 5
                                          : 0
                                      : deviceHeight! > 900
                                          ? 5
                                          : 0)),
                          TabBar(
                            unselectedLabelColor:
                                musicBox.get("dynamicArtDB") ?? true
                                    ? Colors.white24
                                    : Colors.white24,
                            labelColor: musicBox.get("dynamicArtDB") ?? true
                                ? Colors.white
                                : Colors.white,
                            indicatorWeight: 0.000001,
                            tabAlignment: TabAlignment.start,
                            isScrollable: true,
                            enableFeedback: false,
                            dividerColor: Colors.transparent,
                            physics: const ScrollPhysics(),
                            controller: tabController,
                            // labelPadding: EdgeInsets.only(right: 100),
                            // padding: EdgeInsets.only(right: 140),
                            tabs: tabsData(deviceWidth!, deviceHeight),
                            indicatorColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: isPlayerShown ? 60 : 0),
                        child: TabBarView(
                          physics: const CustomPageViewScrollPhysics(),
                          controller: tabController,
                          children: [
                            Mansion(),
                            Allofem(),
                            Albums(),
                            Artists(),
                            Genres(),
                            Playlist()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                right: true,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: deviceHeight! / 100,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(
                                orientedCar
                                    ? deviceWidth! / 16 / 2
                                    : deviceHeight! / 36 / 2)),
                            child: Icon(
                              Graviticons.phoenix,
                              color: musicBox.get("dynamicArtDB") ?? true
                                  ? bgPhoenixVisualizer
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4)
                                  : bgPhoenixVisualizer
                                      ? Colors.white
                                      : Colors.white38,
                              size: orientedCar
                                  ? deviceWidth! / 16
                                  : deviceHeight! / 36,
                            ),
                            onTap: () async {
                              if (bgPhoenixVisualizer) {
                                stopPhoenixVisualizerGlobal();
                                setState(() {});
                              } else {
                                await Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.size,
                                    alignment: Alignment.center,
                                    duration: dialogueAnimationDuration,
                                    reverseDuration: dialogueAnimationDuration,
                                    child: const PhoenixVisualizerGlobal(),
                                  ),
                                ).then((value) async {
                                  setState(() {});
                                });
                              }
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
                          ),
                        ),
                        Visibility(
                          visible: DateTime.now().hour >= 19 ||
                                  DateTime.now().hour <= 6
                              ? true
                              : false,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: orientedCar
                                    ? deviceHeight! / 32
                                    : deviceWidth! / 16),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    orientedCar
                                        ? deviceWidth! / 16 / 2
                                        : deviceHeight! / 36 / 2)),
                                child: Icon(
                                  musicBox.get("timeBasedDark") == null
                                      ? MIcon.riMoonLine
                                      : musicBox.get("timeBasedDark")
                                          ? MIcon.riMoonFill
                                          : MIcon.riMoonLine,
                                  color: Colors.white,
                                  size: orientedCar
                                      ? deviceWidth! / 16
                                      : deviceHeight! / 36,
                                ),
                                onTap: () async {
                                  if (!(musicBox.get("timeBasedDark") ??
                                      false)) {
                                    await musicBox.put("timeBasedDark", true);
                                    await musicBox.put("dynamicArtDB", false);

                                    musicBox.put("timeBasedDark", true);
                                  } else {
                                    await musicBox.put("timeBasedDark", false);
                                    await musicBox.put("dynamicArtDB", true);

                                    musicBox.put("timeBasedDark", false);
                                  }
                                  rootState.provideman();
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: orientedCar
                                  ? deviceHeight! / 32
                                  : deviceWidth! / 16),
                          child: Hero(
                            tag: "aslongasiwakeup",
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    orientedCar
                                        ? deviceWidth! / 16 / 2
                                        : deviceHeight! / 36 / 2)),
                                child: Icon(
                                  MIcon.riSearchLine,
                                  color: musicBox.get("dynamicArtDB") ?? true
                                      ? Colors.white
                                      : Colors.white,
                                  size: orientedCar
                                      ? deviceWidth! / 17
                                      : deviceHeight! / 36,
                                ),
                                onTap: () async {
                                  var rootCrossfadeStateDup =
                                      rootCrossfadeState;
                                  var rootStateDup = rootState;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider<
                                              Astronautintheocean>(
                                            create: (_) =>
                                                Astronautintheocean(),
                                          ),
                                          ChangeNotifierProvider<Leprovider>(
                                            create: (_) => Leprovider(),
                                          ),
                                          ChangeNotifierProvider<MrMan>(
                                            create: (_) => MrMan(),
                                          ),
                                          ChangeNotifierProvider<Seek>(
                                              create: (_) => Seek()),
                                          ChangeNotifierProvider<SortProvider>(
                                            create: (_) => SortProvider(),
                                          ),
                                        ],
                                        builder: (context, child) =>
                                            const Searchin(),
                                      ),
                                    ),
                                  ).then(
                                    (value) {
                                      rootCrossfadeState =
                                          rootCrossfadeStateDup;
                                      rootState = rootStateDup;
                                      if (isPlayerShown) {
                                        rootState.provideman();
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              left: orientedCar
                                  ? deviceHeight! / 32
                                  : deviceWidth! / 16,
                              right: orientedCar
                                  ? deviceHeight! / 80
                                  : deviceWidth! / 40),
                          child: Hero(
                            tag: "fortress",
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.all(Radius.circular(
                                    orientedCar
                                        ? deviceWidth! / 16 / 2
                                        : deviceHeight! / 36 / 2)),
                                child: Icon(
                                  Ionicons.settings_outline,
                                  color: musicBox.get("dynamicArtDB") ?? true
                                      ? Colors.white
                                      : Colors.white,
                                  size: orientedCar
                                      ? deviceWidth! / 17
                                      : deviceHeight! / 36,
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      maintainState: true,
                                      builder: (context) => MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider<Leprovider>(
                                            create: (_) => Leprovider(),
                                          ),
                                          ChangeNotifierProvider<MrMan>(
                                            create: (_) => MrMan(),
                                          ),
                                        ],
                                        builder: (context, child) =>
                                            const Settings(),
                                      ),
                                    ),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                              ),
                            ),
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
    );
  }

  Future<bool> _onWillPop() async {
    if (pc.isPanelOpen) {
      pc.close();
      return false;
    } else if ((pc.isPanelClosed || !pc.isPanelShown) && !isonexit) {
      isonexit = true;
      bool result = await fivesecsbacker() &&
          isonexit &&
          (pc.isPanelClosed || !pc.isPanelShown);
      isonexit = false;
      return result;
    }
    return false;
  }

  Future<void> setScreenFrames() async {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  Future<bool> fivesecsbacker() async {
    bool confirmExit = false;
    bool isAutoDismiss = false;
    Future.delayed(const Duration(seconds: 5)).then((value) {
      isAutoDismiss = true;
    });
    await Flushbar(
      onStatusChanged: (FlushbarStatus? status) {
        switch (status!) {
          case FlushbarStatus.DISMISSED:
            break;
          case FlushbarStatus.SHOWING:
            break;
          case FlushbarStatus.IS_APPEARING:
            break;
          case FlushbarStatus.IS_HIDING:
            confirmExit = true;
            break;
        }
      },
      messageText: const Text("Go back once more to exit",
          style: TextStyle(fontFamily: "Futura", color: Colors.white)),
      icon: const Icon(
        Icons.exit_to_app_rounded,
        size: 28.0,
        color: Color(0xFFCB0447),
      ),
      shouldIconPulse: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      duration: const Duration(milliseconds: 5000),
      borderColor: Colors.white.withOpacity(0.04),
      borderWidth: 1,
      backgroundColor: glassOpacity!,
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: true,
      barBlur: musicBox.get("glassBlur") ?? 18,
      margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
      borderRadius: BorderRadius.circular(15),
    ).show(context);
    if (confirmExit && !isAutoDismiss) {
      audioHandler.stop();
      return true;
    } else {
      isonexit = false;
      return false;
    }
  }
}
