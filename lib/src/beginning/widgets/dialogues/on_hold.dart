import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:on_audio_edit/on_audio_edit.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phoenix/src/beginning/utilities/delete.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/heart.dart';
import 'package:phoenix/src/beginning/utilities/native/go_native.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/pages/ringtone/ringtone.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/add_to_playlist.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/song_edit.dart';
import 'package:phoenix/src/beginning/widgets/snack.dart';
import '../../utilities/page_backend/artists_back.dart';
import 'package:phoenix/src/beginning/pages/genres/genres.dart';
import 'package:phoenix/src/beginning/pages/genres/genres_inside.dart';
import '../../utilities/page_backend/mansion_back.dart';
import 'package:phoenix/src/beginning/pages/playlist/playlist_inside.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/screenshot_ui.dart';
import 'package:share_plus/share_plus.dart';
import '../../utilities/constants.dart';
import 'package:metadata_god/metadata_god.dart' as god;

class OnHold extends StatefulWidget {
  final BuildContext classContext;
  final List<SongModel>? listOfSong;
  final int index;
  final bool car;
  final double? heightOfDevice;
  final double? widthOfDevice;
  final String songOf;
  const OnHold(
      {super.key,
      required this.classContext,
      required this.listOfSong,
      required this.index,
      required this.car,
      required this.heightOfDevice,
      required this.widthOfDevice,
      required this.songOf});

  @override
  State<OnHold> createState() => _OnHoldState();
}

class _OnHoldState extends State<OnHold> {
  final List songMoreInfo = const [
    "Play Now",
    "Add To Queue",
    "Add To PlayList",
    "Share",
    "Set Ringtone",
    "Edit",
    "Delete"
  ];
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
                                  for (int i = 0; i < songMoreInfo.length; i++)
                                    Material(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: SizedBox(
                                          // color: Colors.black38,
                                          width: widget.car
                                              ? widget.heightOfDevice
                                              : widget.widthOfDevice,
                                          height: widget.car
                                              ? widget.widthOfDevice! / 6
                                              : widget.heightOfDevice! / 12.5,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () async {
                                                if (i == 0) {
                                                  if (widget.songOf ==
                                                      "album") {
                                                    // insideInAlbumSongs = [];
                                                    insideInAlbumSongs =
                                                        inAlbumSongs;
                                                  }
                                                  if (widget.songOf ==
                                                      "artist") {
                                                    // insideInArtistsSongs = [];
                                                    insideInArtistsSongs =
                                                        inArtistsSongs;
                                                  }
                                                  if (widget.songOf ==
                                                      "genre") {
                                                    // insidegenreSongs = [];
                                                    insidegenreSongs =
                                                        genreSongs;
                                                  }
                                                  await playThis(widget.index,
                                                      widget.songOf);
                                                  Navigator.pop(context);
                                                } else if (i == 1) {
                                                  if (widget.songOf == "all") {
                                                    addToQueue(
                                                        songListMediaItems[
                                                            widget.index]);
                                                  } else if (widget.songOf ==
                                                      "album") {
                                                    addToQueue(albumMediaItems[
                                                        widget.index]);
                                                  } else if (widget.songOf ==
                                                      "artist") {
                                                    addToQueue(artistMediaItems[
                                                        widget.index]);
                                                  } else if (widget.songOf ==
                                                      "genre") {
                                                    addToQueue(genreMediaItems[
                                                        widget.index]);
                                                  } else if (widget.songOf ==
                                                      "recent") {
                                                    addToQueue(
                                                        recentPlayedMediaItems[
                                                            recentPlayedMediaItems
                                                                    .length -
                                                                widget.index -
                                                                1]);
                                                  } else if (widget.songOf ==
                                                      "mostly") {
                                                    addToQueue(
                                                        alwaysPlayedMediaItems[
                                                            widget.index]);
                                                  } else if (widget.songOf ==
                                                      "never") {
                                                    addToQueue(
                                                        everPlayedLimitedMediaItems[
                                                            widget.index]);
                                                  } else if (widget.songOf ==
                                                      "playlist") {
                                                    addToQueue(
                                                        playlistMediaItems[
                                                            widget.index]);
                                                  }

                                                  Navigator.pop(context);
                                                } else if (i == 2) {
                                                  Map check = musicBox
                                                          .get('playlists') ??
                                                      {};
                                                  if (check.keys
                                                      .toList()
                                                      .isEmpty) {
                                                    Flushbar(
                                                      messageText: const Text(
                                                          "Create A Playlist First.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Futura",
                                                              color: Colors
                                                                  .white)),
                                                      icon: const Icon(
                                                        Icons
                                                            .error_outline_rounded,
                                                        size: 28.0,
                                                        color:
                                                            Color(0xFFCB0447),
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
                                                          FlushbarStyle
                                                              .FLOATING,
                                                      isDismissible: true,
                                                      barBlur: musicBox.get(
                                                              "glassBlur") ??
                                                          18,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 20,
                                                              left: 8,
                                                              right: 8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      // leftBarIndicatorColor:
                                                      //     Color(0xFFCB0047),
                                                    ).show(context);
                                                  } else {
                                                    Navigator.pop(context);
                                                    Navigator.push(
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
                                                        child: AddToPlaylist(
                                                            widthOfDevice:
                                                                deviceWidth,
                                                            heightOfDevice:
                                                                deviceHeight,
                                                            songFile: widget
                                                                .listOfSong![
                                                                    widget
                                                                        .index]
                                                                .data,
                                                            car: orientedCar,
                                                            data: check),
                                                      ),
                                                    );
                                                  }
                                                } else if (i == 3) {
                                                  await Share.shareFiles(
                                                    [
                                                      widget
                                                          .listOfSong![
                                                              widget.index]
                                                          .data
                                                    ],
                                                  );
                                                } else if (i == 4) {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Ringtone(
                                                          artworkId: widget
                                                              .listOfSong![
                                                                  widget.index]
                                                              .id,
                                                          filePath: widget
                                                              .listOfSong![
                                                                  widget.index]
                                                              .data,
                                                          artist: widget
                                                              .listOfSong![
                                                                  widget.index]
                                                              .artist,
                                                          title: widget
                                                              .listOfSong![
                                                                  widget.index]
                                                              .title,
                                                          songDuration: widget
                                                                  .listOfSong![
                                                                      widget
                                                                          .index]
                                                                  .duration! *
                                                              1.0),
                                                    ),
                                                  );
                                                } else if (i == 5) {
                                                  // Edit Song
                                                  try {
                                                    late SongEdit songEditPage;
                                                    if (androidSdkVersion <=
                                                        29) {
                                                      // before Scoped Storage on_audio_edit(Lucas)
                                                      final AudioModel
                                                          songInfo =
                                                          await OnAudioEdit()
                                                              .readAudio(widget
                                                                  .listOfSong![
                                                                      widget
                                                                          .index]
                                                                  .data);
                                                      songEditPage = SongEdit(
                                                        title: songInfo.title,
                                                        album: songInfo.album ??
                                                            "",
                                                        artist:
                                                            songInfo.artist ??
                                                                "",
                                                        genre: songInfo.genre ??
                                                            "",
                                                        car: orientedCar,
                                                        heightOfDevice:
                                                            deviceHeight,
                                                        widthOfDevice:
                                                            deviceWidth,
                                                        filePath: widget
                                                            .listOfSong![
                                                                widget.index]
                                                            .data,
                                                        artwork: songInfo
                                                                .firstArtwork ??
                                                            defaultNone,
                                                      );
                                                    } else {
                                                      // scoped storage metadata_god
                                                      god.Metadata metadata =
                                                          (await god.MetadataGod
                                                              .readMetadata(
                                                                  file: widget
                                                                      .listOfSong![
                                                                          widget
                                                                              .index]
                                                                      .data));
                                                      songEditPage = SongEdit(
                                                        title: metadata.title,
                                                        album: metadata.album,
                                                        artist: metadata.artist,
                                                        genre: metadata.genre,
                                                        car: orientedCar,
                                                        heightOfDevice:
                                                            deviceHeight,
                                                        widthOfDevice:
                                                            deviceWidth,
                                                        filePath: widget
                                                            .listOfSong![
                                                                widget.index]
                                                            .data,
                                                        artwork: metadata
                                                            .picture?.data,
                                                      );
                                                    }
                                                    Navigator.pop(context);
                                                    Navigator.of(context).push(
                                                      PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .size,
                                                          alignment:
                                                              Alignment.center,
                                                          duration:
                                                              dialogueAnimationDuration,
                                                          reverseDuration:
                                                              dialogueAnimationDuration,
                                                          child: songEditPage),
                                                    );
                                                  } catch (e) {
                                                    debugPrint(e.toString());
                                                    Flushbar(
                                                      message:
                                                          "The File Might be Unsupported/Corrupted.",
                                                      icon: const Icon(
                                                        Icons.info_outline,
                                                        size: 28.0,
                                                        color:
                                                            Color(0xFFCB0447),
                                                      ),
                                                      shouldIconPulse: true,
                                                      borderColor: Colors.white
                                                          .withOpacity(0.04),
                                                      borderWidth: 1,
                                                      backgroundColor:
                                                          glassOpacity!,
                                                      flushbarStyle:
                                                          FlushbarStyle
                                                              .FLOATING,
                                                      isDismissible: true,
                                                      barBlur: musicBox.get(
                                                              "glassBlur") ??
                                                          18,
                                                      dismissDirection:
                                                          FlushbarDismissDirection
                                                              .HORIZONTAL,
                                                      duration: const Duration(
                                                          seconds: 5),
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
                                                } else if (i == 6) {
                                                  try {
                                                    if (androidSdkVersion <
                                                        29) {
                                                      await deleteFileUsingPath(
                                                          widget
                                                              .listOfSong![
                                                                  widget.index]
                                                              .data);
                                                    } else {
                                                      await deleteFileWithMediaStore(
                                                          widget
                                                              .listOfSong![
                                                                  widget.index]
                                                              .data);
                                                    }
                                                    Navigator.pop(context);
                                                    refresh = true;
                                                    rootState.provideman();
                                                  } catch (e) {
                                                    Navigator.pop(context);
                                                    debugPrint("$e");
                                                    Snack().showFlushbar(
                                                        context: context,
                                                        message:
                                                            "Failed to delete file",
                                                        icon: const Icon(
                                                          Icons.error_outline,
                                                          size: 28.0,
                                                          color:
                                                              Color(0xFFCB0447),
                                                        ));
                                                  }
                                                  // try {

                                                  //   await deleteFileWithMediaStore(
                                                  //       widget
                                                  //           .listOfSong![
                                                  //               widget.index]
                                                  //           .data);
                                                  //   // }
                                                  //   Navigator.pop(context);
                                                  //   refresh = true;
                                                  //   rootState.provideman();
                                                  // } catch (e) {
                                                  //   Navigator.pop(context);
                                                  //   refresh = true;
                                                  //   rootState.provideman();
                                                  //   //TODO make this as warning
                                                  //   androidRSupport(context);
                                                  // }
                                                }
                                              },
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Text(
                                                    songMoreInfo[i],
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
                                                          blurRadius: 3.0,
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
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: widget.car
                                        ? widget.widthOfDevice! / 12
                                        : widget.heightOfDevice! / 25),
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

class OnHoldExtended extends StatefulWidget {
  final BuildContext context;
  final bool car;
  final double? heightOfDevice;
  final double? widthOfDevice;
  const OnHoldExtended({
    super.key,
    required this.context,
    required this.car,
    required this.heightOfDevice,
    required this.widthOfDevice,
  });

  @override
  State<OnHoldExtended> createState() => _OnHoldExtendedState();
}

class _OnHoldExtendedState extends State<OnHoldExtended> {
  final List songMoreInfoNP = const [
    "Share Now Playing",
    "Add To Liked Songs",
    "Add To PlayList",
    "Share File",
    "Edit File",
    "Set Ringtone",
    "Save Wallpaper",
    "Set As Home Screen",
    "Delete"
  ];
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
                                  for (int i = 0;
                                      i < songMoreInfoNP.length;
                                      i++)
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
                                              onTap: () async {
                                                if (i == 0) {
                                                  // Share Now Playing
                                                  await screenShotUI(false);
                                                  Directory appDocDir =
                                                      (await getExternalStorageDirectory())!;
                                                  String appDocPath =
                                                      appDocDir.path;
                                                  await Share.shareFiles(
                                                    [
                                                      '$appDocPath/legendary-er.png'
                                                    ],
                                                  );
                                                } else if (i == 1) {
                                                  // Add to Liked Songs
                                                  if (!isSongLiked(
                                                      nowMediaItem.id)) {
                                                    rmLikedSong(
                                                        nowMediaItem.id);

                                                    Navigator.pop(context);
                                                    Flushbar(
                                                      messageText: const Text(
                                                          "Removed From Liked Songs",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Futura",
                                                              color: Colors
                                                                  .white)),
                                                      icon: const Icon(
                                                        Icons.block_rounded,
                                                        size: 28.0,
                                                        color:
                                                            Color(0xFFCB0447),
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
                                                          FlushbarStyle
                                                              .FLOATING,
                                                      isDismissible: true,
                                                      barBlur: musicBox.get(
                                                              "glassBlur") ??
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
                                                    addToLikedSong(
                                                        nowMediaItem.id);
                                                    Navigator.pop(context);
                                                    Flushbar(
                                                      messageText: const Text(
                                                          "Added To Liked Songs",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Futura",
                                                              color: Colors
                                                                  .white)),
                                                      icon: Icon(
                                                        MdiIcons.heart,
                                                        size: 28.0,
                                                        color: const Color(
                                                            0xFFCB0447),
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
                                                          FlushbarStyle
                                                              .FLOATING,
                                                      isDismissible: true,
                                                      barBlur: musicBox.get(
                                                              "glassBlur") ??
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
                                                } else if (i == 2) {
                                                  // add to playlist
                                                  Map check = musicBox
                                                          .get('playlists') ??
                                                      {};
                                                  if (check.keys
                                                      .toList()
                                                      .isEmpty) {
                                                    Flushbar(
                                                      messageText: const Text(
                                                          "Create A Playlist First.",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Futura",
                                                              color: Colors
                                                                  .white)),
                                                      icon: const Icon(
                                                        Icons
                                                            .error_outline_rounded,
                                                        size: 28.0,
                                                        color:
                                                            Color(0xFFCB0447),
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
                                                          FlushbarStyle
                                                              .FLOATING,
                                                      isDismissible: true,
                                                      barBlur: musicBox.get(
                                                              "glassBlur") ??
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
                                                    Navigator.pop(context);
                                                    Navigator.push(
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
                                                        child: AddToPlaylist(
                                                            widthOfDevice:
                                                                deviceWidth,
                                                            heightOfDevice:
                                                                deviceHeight,
                                                            songFile:
                                                                nowMediaItem.id,
                                                            car: orientedCar,
                                                            data: check),
                                                      ),
                                                    );
                                                  }
                                                } else if (i == 3) {
                                                  await Share.shareFiles(
                                                    [nowMediaItem.id],
                                                  );
                                                } else if (i == 4) {
                                                  // Edit Song
                                                  Navigator.pop(context);
                                                  try {
                                                    late SongEdit songEditPage;
                                                    if (androidSdkVersion <=
                                                        29) {
                                                      // before Scoped Storage on_audio_edit(Lucas)
                                                      final AudioModel
                                                          songInfo =
                                                          await OnAudioEdit()
                                                              .readAudio(
                                                                  nowMediaItem
                                                                      .id);
                                                      songEditPage = SongEdit(
                                                        title: songInfo.title,
                                                        album: songInfo.album ??
                                                            "",
                                                        artist:
                                                            songInfo.artist ??
                                                                "",
                                                        genre: songInfo.genre ??
                                                            "",
                                                        car: orientedCar,
                                                        heightOfDevice:
                                                            deviceHeight,
                                                        widthOfDevice:
                                                            deviceWidth,
                                                        filePath:
                                                            nowMediaItem.id,
                                                        artwork: songInfo
                                                                .firstArtwork ??
                                                            defaultNone,
                                                      );
                                                    } else {
                                                      // scoped storage metadata_god
                                                      god.Metadata metadata =
                                                          (await god.MetadataGod
                                                              .readMetadata(
                                                                  file:
                                                                      nowMediaItem
                                                                          .id));
                                                      songEditPage = SongEdit(
                                                        title: metadata.title,
                                                        album: metadata.album,
                                                        artist: metadata.artist,
                                                        genre: metadata.genre,
                                                        car: orientedCar,
                                                        heightOfDevice:
                                                            deviceHeight,
                                                        widthOfDevice:
                                                            deviceWidth,
                                                        filePath:
                                                            nowMediaItem.id,
                                                        artwork: metadata
                                                            .picture?.data,
                                                      );
                                                    }

                                                    await Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .size,
                                                          alignment:
                                                              Alignment.center,
                                                          duration:
                                                              dialogueAnimationDuration,
                                                          reverseDuration:
                                                              dialogueAnimationDuration,
                                                          child: songEditPage),
                                                    );
                                                  } catch (e) {
                                                    Flushbar(
                                                      message:
                                                          "The File Might be Unsupported/Corrupted.",
                                                      icon: const Icon(
                                                        Icons.info_outline,
                                                        size: 28.0,
                                                        color:
                                                            Color(0xFFCB0447),
                                                      ),
                                                      shouldIconPulse: true,
                                                      borderColor: Colors.white
                                                          .withOpacity(0.04),
                                                      borderWidth: 1,
                                                      backgroundColor:
                                                          glassOpacity!,
                                                      flushbarStyle:
                                                          FlushbarStyle
                                                              .FLOATING,
                                                      isDismissible: true,
                                                      barBlur: musicBox.get(
                                                              "glassBlur") ??
                                                          18,
                                                      dismissDirection:
                                                          FlushbarDismissDirection
                                                              .HORIZONTAL,
                                                      duration: const Duration(
                                                          seconds: 5),
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
                                                  // }
                                                } else if (i == 5) {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Ringtone(
                                                          artworkId:
                                                              nowMediaItem
                                                                      .extras![
                                                                  'id'],
                                                          filePath:
                                                              nowMediaItem.id,
                                                          artist: nowMediaItem
                                                              .artist,
                                                          title: nowMediaItem
                                                              .title,
                                                          songDuration: nowMediaItem
                                                                  .duration!
                                                                  .inMilliseconds *
                                                              1.0),
                                                    ),
                                                  );
                                                } else if (i == 6) {
                                                  // Save Wallpaper
                                                  if (await Permission.storage
                                                          .request()
                                                          .isGranted
                                                      //     &&
                                                      // await Permission
                                                      //     .manageExternalStorage
                                                      //     .request()
                                                      //     .isGranted
                                                      ) {
                                                    Navigator.pop(context);

                                                    Flushbar(
                                                      messageText: const Text(
                                                          "Saved In Downloads Directory",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Futura",
                                                              color: Colors
                                                                  .white)),
                                                      icon: Icon(
                                                        MdiIcons.image,
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
                                                      backgroundColor: Colors
                                                          .white
                                                          .withOpacity(0.05),
                                                      flushbarStyle:
                                                          FlushbarStyle
                                                              .FLOATING,
                                                      isDismissible: true,
                                                      barBlur: 20,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 20,
                                                              left: 8,
                                                              right: 8),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      // leftBarIndicatorColor:
                                                      //     Color(0xFFCB0047),
                                                    ).show(context);
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1));
                                                    await screenShotUI(true);
                                                  }
                                                } else if (i == 7) {
                                                  // set as home screen
                                                  Navigator.pop(context);
                                                  await screenShotUI(false);
                                                  await setHomeScreenWallpaper();
                                                } else if (i == 8) {
                                                  // if (androidSdkVersion >= 30) {
                                                  //   Navigator.pop(context);
                                                  //   androidRSupport(context);
                                                  // } else {
                                                  // if (await Permission.storage
                                                  //     .request()
                                                  //     .isGranted) {
                                                  // await mediaStorePlugin
                                                  //     .getUriFromFilePath(
                                                  //         path: songList[
                                                  //                 indexOfList]
                                                  //             .data)
                                                  //     .then((uri) async {
                                                  //   await mediaStorePlugin
                                                  //       .deleteFileUsingUri(
                                                  //     uriString: uri.toString(),
                                                  //   );
                                                  // });
                                                  // await deleteAFile(
                                                  //     songList[indexOfList]
                                                  //         .data);
                                                  try {
                                                    if (androidSdkVersion <
                                                        29) {
                                                      await deleteFileUsingPath(
                                                          songList[indexOfList]
                                                              .data);
                                                    } else {
                                                      await deleteFileWithMediaStore(
                                                          songList[indexOfList]
                                                              .data);
                                                    }
                                                    Navigator.pop(context);
                                                    refresh = true;
                                                    rootState.provideman();
                                                  } catch (e) {
                                                    Navigator.pop(context);
                                                    print("this? $e");
                                                    Snack().showFlushbar(
                                                        context: context,
                                                        message:
                                                            "Failed to delete file",
                                                        icon: const Icon(
                                                          Icons.error_outline,
                                                          size: 28.0,
                                                          color:
                                                              Color(0xFFCB0447),
                                                        ));
                                                  }

                                                  // }
                                                  // }
                                                }
                                              },
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 12),
                                                  child: Text(
                                                    i == 1
                                                        ? !isSongLiked(
                                                                nowMediaItem.id)
                                                            ? "Remove From Liked Songs"
                                                            : "Add to Liked Songs"
                                                        : songMoreInfoNP[i],
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
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: widget.car
                                        ? widget.widthOfDevice! / 12
                                        : widget.heightOfDevice! / 25),
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
