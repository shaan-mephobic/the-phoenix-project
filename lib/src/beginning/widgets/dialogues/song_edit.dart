import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/edit_song.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/widgets/snack.dart';

class SongEdit extends StatefulWidget {
  final double? heightOfDevice;
  final double? widthOfDevice;
  final bool car;
  final String? title;
  final String? artist;
  final String? album;
  final String? genre;
  final String filePath;
  final Uint8List? artwork;
  const SongEdit(
      {super.key,
      required this.heightOfDevice,
      required this.widthOfDevice,
      required this.car,
      required this.title,
      required this.artist,
      required this.album,
      required this.genre,
      required this.filePath,
      required this.artwork});
  @override
  State<SongEdit> createState() => _SongEditState();
}

class _SongEditState extends State<SongEdit> with TickerProviderStateMixin {
  String? title;
  String? album;
  String? artist;
  String? genre;
  Uint8List? artwork;
  bool shouldEdit = false;

  @override
  void initState() {
    title = widget.title;
    album = widget.album;
    artist = widget.artist;
    genre = widget.genre;
    artwork = widget.artwork;
    super.initState();
  }

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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                          border:
                              Border.all(color: Colors.white.withOpacity(0.04)),
                          color: glassOpacity,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: orientedCar
                                        ? widget.widthOfDevice! / 8
                                        : widget.heightOfDevice! / 20,
                                    bottom: 5),
                                child: TextField(
                                  cursorColor: const Color(0xFF3cb9cd),
                                  autofocus: false,
                                  controller: TextEditingController()
                                    ..text = title ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (text) {
                                    shouldEdit = true;
                                    title = text;
                                  },
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF3cb9cd)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF3cb9cd)),
                                      ),
                                      filled: true,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[350]),
                                      labelText: "TITLE",
                                      hintText: "",
                                      labelStyle: TextStyle(
                                        color: Colors.grey[350],
                                      ),
                                      fillColor: Colors.transparent),
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: orientedCar
                                        ? widget.widthOfDevice! / 8
                                        : widget.heightOfDevice! / 20)),

                            ///ALBUM
                            Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                child: TextField(
                                  cursorColor: const Color(0xFF3cb9cd),
                                  autofocus: false,
                                  controller: TextEditingController()
                                    ..text = album ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (text) {
                                    shouldEdit = true;
                                    album = text;
                                  },
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF3cb9cd)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF3cb9cd)),
                                      ),
                                      filled: true,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[350]),
                                      labelText: "ALBUM",
                                      labelStyle: TextStyle(
                                        color: Colors.grey[350],
                                      ),
                                      hintText: "",
                                      fillColor: Colors.transparent),
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: orientedCar
                                        ? widget.widthOfDevice! / 8
                                        : widget.heightOfDevice! / 20)),

                            ///Artist
                            Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                child: TextField(
                                  cursorColor: const Color(0xFF3cb9cd),
                                  autofocus: false,
                                  controller: TextEditingController()
                                    ..text = artist ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (text) {
                                    shouldEdit = true;
                                    artist = text;
                                  },
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF3cb9cd)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF3cb9cd)),
                                      ),
                                      filled: true,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[350]),
                                      labelText: "ARTIST",
                                      labelStyle: TextStyle(
                                        color: Colors.grey[350],
                                      ),
                                      hintText: "",
                                      fillColor: Colors.transparent),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: orientedCar
                                      ? widget.widthOfDevice! / 8
                                      : widget.heightOfDevice! / 20),
                            ),

                            //Genre
                            Material(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 5, bottom: 5),
                                child: TextField(
                                  cursorColor: const Color(0xFF3cb9cd),
                                  autofocus: false,
                                  controller: TextEditingController()
                                    ..text = genre ?? "",
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  onChanged: (text) {
                                    shouldEdit = true;
                                    genre = text;
                                  },
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF3cb9cd)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                            color: Color(0xFF3cb9cd)),
                                      ),
                                      filled: true,
                                      hintStyle:
                                          TextStyle(color: Colors.grey[350]),
                                      labelText: "GENRE",
                                      labelStyle: TextStyle(
                                        color: Colors.grey[350],
                                      ),
                                      hintText: "",
                                      fillColor: Colors.transparent),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: orientedCar
                                      ? widget.widthOfDevice! / 8
                                      : widget.heightOfDevice! / 20),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: orientedCar
                                      ? widget.widthOfDevice! / 8
                                      : widget.heightOfDevice! / 20),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(kRounded),
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(kRounded),
                                onTap: () async {
                                  if (shouldEdit) {
                                    Navigator.pop(context);
                                    try {
                                      await editSong(
                                          context: context,
                                          songFile: widget.filePath,
                                          title: title,
                                          album: album,
                                          artist: artist,
                                          genre: genre);
                                      refresh = true;
                                      rootState.provideman();
                                    } catch (e) {
                                      debugPrint(e.toString());
                                      Snack().showFlushbar(
                                          context: context,
                                          message: "Failed to delete file",
                                          icon: const Icon(
                                            Icons.error_outline,
                                            size: 28.0,
                                            color: Color(0xFFCB0447),
                                          ));
                                    }
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  height: deviceWidth! / 12,
                                  width: deviceWidth! / 4,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 1.0,
                                        spreadRadius: deviceWidth! / 220,
                                      ),
                                    ],
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
                            Padding(
                                padding: EdgeInsets.only(
                                    top: orientedCar
                                        ? widget.widthOfDevice! / 16
                                        : widget.heightOfDevice! / 40)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ],
    );
  }
}
