// import 'package:elastic_widgets/elastic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'dart:math';

import 'package:phoenix/src/beginning/utilities/global_variables.dart';

class EqualizerControls extends StatelessWidget {
  final AndroidEqualizer equalizer;

  const EqualizerControls({
    super.key,
    required this.equalizer,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AndroidEqualizerParameters>(
      future: equalizer.parameters,
      builder: (context, snapshot) {
        final parameters = snapshot.data;
        if (parameters == null) return const SizedBox();
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (var band in parameters.bands)
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<double>(
                        stream: band.gainStream,
                        builder: (context, snapshot) {
                          return VerticalSlider(
                            min: parameters.minDecibels,
                            max: parameters.maxDecibels,
                            value: band.gain,
                            onChanged: band.setGain,
                          );
                        },
                      ),
                    ),
                    Text(
                      '${band.centerFrequency.round()} Hz',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class VerticalSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  const VerticalSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      alignment: Alignment.bottomCenter,
      child: Transform.rotate(
        angle: -pi / 2,
        child: Container(
          width: 350.0,
          height: 350.0,
          alignment: Alignment.center,
          child: Slider(
            activeColor: nowContrast,
            inactiveColor: nowColor,
            value: value,
            min: min,
            max: max,
            onChanged: (val) {
              return onChanged!(val);
            },
          ),
          // child: SeekBar(
          //   circleRadius: 10,
          //   thickLineColor: nowContrast,
          //   stretchRange: 30,
          //   size: const Size(400, 400),
          //   minValue: 0,
          //   maxValue: 100,
          //   valueListener: (va) {
          //     return onChanged!(((max - min) / 100 * double.parse(va)) - max);
          //   },
          // ),
        ),
      ),
    );
  }
}

class EqualizerPage extends StatefulWidget {
  const EqualizerPage({Key? key}) : super(key: key);

  @override
  State<EqualizerPage> createState() => _EqualizerPageState();
}

class _EqualizerPageState extends State<EqualizerPage> {
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
                            child: StreamBuilder<bool>(
                              stream: equalizer.enabledStream,
                              builder: (context, snapshot) {
                                final enabled = snapshot.data ?? false;
                                return Column(children: [
                                  SwitchListTile(
                                    inactiveTrackColor: nowColor,
                                    activeColor: nowContrast,
                                    activeTrackColor: nowColor,
                                    title: const Text(
                                      'Equalizer',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    value: enabled,
                                    onChanged: equalizer.setEnabled,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: EqualizerControls(
                                          equalizer: equalizer),
                                    ),
                                  ),
                                ]);
                              },
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
