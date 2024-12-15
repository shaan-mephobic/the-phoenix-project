import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/native/go_native.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PhoenixVisualizer extends StatefulWidget {
  const PhoenixVisualizer({super.key});

  @override
  State<PhoenixVisualizer> createState() => _PhoenixVisualizerState();
}

class _PhoenixVisualizerState extends State<PhoenixVisualizer> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: Container(
                      height: orientedCar
                          ? deviceHeight! / 1.4
                          : deviceWidth! * 1.3,
                      width: orientedCar
                          ? deviceHeight! / 1.5
                          : deviceWidth! / 1.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kRounded),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kRounded),
                        child: BackdropFilter(
                          filter: glassBlur,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kRounded),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.04)),
                                color: glassOpacity),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "PHOENIX VISUALIZER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: deviceWidth! / 14,
                                  ),
                                ),
                                Center(
                                  child: SleekCircularSlider(
                                    appearance: CircularSliderAppearance(
                                      infoProperties: InfoProperties(
                                        bottomLabelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: deviceHeight! / 60,
                                        ),
                                        bottomLabelText: 'SENSITIVITY',
                                        mainLabelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight! / 40,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      size: deviceHeight! / 6,
                                      customColors: CustomSliderColors(
                                        progressBarColor: kPhoenixColor,
                                        trackColor: Colors.black26,
                                      ),
                                      customWidths: CustomSliderWidths(
                                          progressBarWidth: deviceWidth! / 65),
                                    ),
                                    min: 0,
                                    max: 100,
                                    initialValue: defaultSensitivity,
                                    onChange: (double value) async {
                                      // goSensitivity(35 + (value * 0.3));
                                      goSensitivity(value);

                                      defaultSensitivity = value;
                                    },
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(kRounded),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(kRounded),
                                    onTap: () async {
                                      phoenixVisualizerShown = false;
                                      if (bgPhoenixVisualizer) {
                                        bgPhoenixVisualizer = false;
                                        await stopkotlinVisualizer();
                                        isFlashin = false;
                                      } else if (!isPlaying) {
                                        isFlashin = true;
                                      } else {
                                        kotlinVisualizer();
                                        isFlashin = true;
                                      }
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: deviceWidth! / 12,
                                      width: deviceWidth! / 4,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1DB954),
                                        borderRadius:
                                            BorderRadius.circular(kRounded),
                                      ),
                                      child: Center(
                                        child: Text("START",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: deviceWidth! / 25,
                                                fontWeight: FontWeight.w600)),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

stopPhoenixVisualizer() {
  if (bgPhoenixVisualizer) {
    bgPhoenixVisualizer = false;
    stopkotlinVisualizer();
    isFlashin = false;
  } else if (!isFlashin) {
    if (isPlaying) {
      kotlinVisualizer();
    }
    isFlashin = true;
  } else if (isFlashin) {
    stopkotlinVisualizer();
    isFlashin = false;
  }
}

class PhoenixVisualizerCustomize extends StatefulWidget {
  const PhoenixVisualizerCustomize({super.key});

  @override
  State<PhoenixVisualizerCustomize> createState() =>
      _PhoenixVisualizerCustomizeState();
}

class _PhoenixVisualizerCustomizeState
    extends State<PhoenixVisualizerCustomize> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
          ),
        ),
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: orientedCar
                          ? deviceHeight! / 1.4
                          : deviceWidth! * 1.3,
                      width: orientedCar
                          ? deviceHeight! / 1.5
                          : deviceWidth! / 1.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kRounded),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kRounded),
                        // make sure we apply clip it properly
                        child: BackdropFilter(
                          filter: glassBlur,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kRounded),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.04)),
                                color: glassOpacity),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "PHOENIX VISUALIZER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: deviceWidth! / 14,
                                  ),
                                ),
                                Center(
                                  child: SleekCircularSlider(
                                    appearance: CircularSliderAppearance(
                                      infoProperties: InfoProperties(
                                        bottomLabelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: deviceHeight! / 60,
                                        ),
                                        bottomLabelText: 'SENSITIVITY',
                                        mainLabelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight! / 40,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      size: deviceHeight! / 6,
                                      customColors: CustomSliderColors(
                                        progressBarColor: kPhoenixColor,
                                        trackColor: Colors.black26,
                                      ),
                                      customWidths: CustomSliderWidths(
                                          progressBarWidth: deviceWidth! / 65),
                                    ),
                                    min: 0,
                                    max: 100,
                                    initialValue: defaultSensitivity,
                                    onChange: (double value) async {
                                      // goSensitivity(35 + (value * 0.3));
                                      goSensitivity(value);

                                      defaultSensitivity = value;
                                    },
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(kRounded),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(kRounded),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: deviceWidth! / 12,
                                      width: deviceWidth! / 4,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1DB954),
                                        borderRadius:
                                            BorderRadius.circular(kRounded),
                                      ),
                                      child: Center(
                                        child: Text("DONE",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: deviceWidth! / 25,
                                                fontWeight: FontWeight.w600)),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PhoenixVisualizerGlobal extends StatefulWidget {
  const PhoenixVisualizerGlobal({super.key});

  @override
  State<PhoenixVisualizerGlobal> createState() =>
      _PhoenixVisualizerGlobalState();
}

class _PhoenixVisualizerGlobalState extends State<PhoenixVisualizerGlobal> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.transparent,
          ),
        ),
        Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: Container(
                      height: orientedCar
                          ? deviceHeight! / 1.4
                          : deviceWidth! * 1.3,
                      width: orientedCar
                          ? deviceHeight! / 1.5
                          : deviceWidth! / 1.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kRounded),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kRounded),
                        child: BackdropFilter(
                          filter: glassBlur,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kRounded),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.04)),
                                color: glassOpacity),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "PHOENIX VISUALIZER",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: deviceWidth! / 14,
                                  ),
                                ),
                                Center(
                                  child: SleekCircularSlider(
                                    appearance: CircularSliderAppearance(
                                      infoProperties: InfoProperties(
                                        bottomLabelStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: deviceHeight! / 60,
                                        ),
                                        bottomLabelText: 'SENSITIVITY',
                                        mainLabelStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: deviceHeight! / 40,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      size: deviceHeight! / 6,
                                      customColors: CustomSliderColors(
                                        progressBarColor: kPhoenixColor,
                                        trackColor: Colors.black26,
                                      ),
                                      customWidths: CustomSliderWidths(
                                          progressBarWidth: deviceWidth! / 65),
                                    ),
                                    min: 0,
                                    max: 100,
                                    initialValue: defaultSensitivity,
                                    onChange: (double value) async {
                                      // goSensitivity(35 + (value * 0.3));

                                      goSensitivity(value);
                                      defaultSensitivity = value;
                                    },
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(kRounded),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(kRounded),
                                    onTap: () {
                                      bgPhoenixVisualizer = true;
                                      if (!isFlashin) {
                                        isFlashin = true;
                                        kotlinVisualizer();
                                      }

                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: deviceWidth! / 12,
                                      width: deviceWidth! / 4,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1DB954),
                                        borderRadius:
                                            BorderRadius.circular(kRounded),
                                      ),
                                      child: Center(
                                        child: Text("START",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: deviceWidth! / 25,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: deviceWidth! / 10,
                                      right: deviceWidth! / 10),
                                  child: Text(
                                    "NOTE: This will run in the background until stopped, causing battery drain",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: deviceWidth! / 30,
                                    ),
                                  ),
                                )
                              ],
                            ),
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
      ],
    );
  }
}

stopPhoenixVisualizerGlobal() {
  stopkotlinVisualizer();
  bgPhoenixVisualizer = false;
  isFlashin = false;
}
