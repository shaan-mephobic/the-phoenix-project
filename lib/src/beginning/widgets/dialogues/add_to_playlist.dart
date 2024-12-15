import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';

class AddToPlaylist extends StatefulWidget {
  final double? heightOfDevice;
  final double? widthOfDevice;
  final bool car;
  final String songFile;
  final Map data;
  const AddToPlaylist({
    super.key,
    required this.heightOfDevice,
    required this.widthOfDevice,
    required this.songFile,
    required this.car,
    required this.data,
  });

  @override
  State<AddToPlaylist> createState() => _AddToPlaylistState();
}

class _AddToPlaylistState extends State<AddToPlaylist> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kRounded),
                    ),
                    alignment: Alignment.center,
                    width: widget.car
                        ? widget.heightOfDevice! / 2
                        : widget.widthOfDevice! / 1.2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(kRounded),
                      child: BackdropFilter(
                        filter: glassBlur,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kRounded),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.04)),
                            color: glassOpacity,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListView(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  for (int o = 0;
                                      o < widget.data.keys.toList().length;
                                      o++)
                                    Material(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: SizedBox(
                                          width: widget.car
                                              ? widget.heightOfDevice
                                              : widget.widthOfDevice,
                                          height: widget.car
                                              ? widget.widthOfDevice! / 6
                                              : widget.heightOfDevice! / 12.5,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                                debugPrint(
                                                    widget.data.toString());
                                                if (widget.data[widget.data.keys
                                                        .toList()[o]]
                                                    .contains(
                                                        widget.songFile)) {
                                                  Flushbar(
                                                    messageText: const Text(
                                                        "Song Already In Playlist",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Futura",
                                                            color:
                                                                Colors.white)),
                                                    icon: const Icon(
                                                      Icons
                                                          .error_outline_rounded,
                                                      size: 28.0,
                                                      color: Color(0xFFCB0447),
                                                    ),
                                                    shouldIconPulse: true,
                                                    dismissDirection:
                                                        FlushbarDismissDirection
                                                            .HORIZONTAL,
                                                    duration: const Duration(
                                                        seconds: 5),
                                                    borderColor: Colors.white
                                                        .withOpacity(0.04),
                                                    borderWidth: 1,
                                                    backgroundColor:
                                                        glassOpacity!,
                                                    flushbarStyle:
                                                        FlushbarStyle.FLOATING,
                                                    isDismissible: true,
                                                    barBlur: musicBox
                                                            .get("glassBlur") ??
                                                        18,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 20,
                                                            left: 8,
                                                            right: 8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ).show(context);
                                                } else {
                                                  widget.data[widget.data.keys
                                                          .toList()[o]]
                                                      .add(widget.songFile);
                                                  musicBox.put(
                                                      "playlists", widget.data);
                                                  Flushbar(
                                                    messageText: const Text(
                                                        "Song Added To Playlist",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Futura",
                                                            color:
                                                                Colors.white)),
                                                    icon: Icon(
                                                      Icons.add,
                                                      size: 28.0,
                                                      color: kCorrect,
                                                    ),
                                                    shouldIconPulse: true,
                                                    dismissDirection:
                                                        FlushbarDismissDirection
                                                            .HORIZONTAL,
                                                    duration: const Duration(
                                                        seconds: 5),
                                                    borderColor: Colors.white
                                                        .withOpacity(0.04),
                                                    borderWidth: 1,
                                                    backgroundColor:
                                                        glassOpacity!,
                                                    flushbarStyle:
                                                        FlushbarStyle.FLOATING,
                                                    isDismissible: true,
                                                    barBlur: musicBox
                                                            .get("glassBlur") ??
                                                        18,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            bottom: 20,
                                                            left: 8,
                                                            right: 8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ).show(context);
                                                }
                                              },
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Text(
                                                    widget.data.keys
                                                        .toList()[o],
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: musicBox.get(
                                                                  "dynamicArtDB") ??
                                                              true
                                                          ? Colors.white70
                                                          : Colors.white70,
                                                      fontSize: widget.car
                                                          ? widget.widthOfDevice! /
                                                              26
                                                          : widget.heightOfDevice! /
                                                              56,
                                                      shadows: [
                                                        Shadow(
                                                          offset: musicBox.get(
                                                                      "dynamicArtDB") ??
                                                                  true
                                                              ? const Offset(
                                                                  0, 1.0)
                                                              : const Offset(
                                                                  0, 1.0),
                                                          blurRadius: musicBox.get(
                                                                      "dynamicArtDB") ??
                                                                  true
                                                              ? 3.0
                                                              : 3.0,
                                                          color: Colors.black54,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: widget.car
                                            ? widget.widthOfDevice! / 12
                                            : widget.heightOfDevice! / 25),
                                  ),
                                ],
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
    );
  }
}
