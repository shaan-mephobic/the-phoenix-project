import 'package:another_flushbar/flushbar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import '../../utilities/page_backend/playlist_back.dart';
import 'package:phoenix/src/beginning/pages/playlist/playlist.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:provider/provider.dart';

List<bool> playListCheck = [];
List playListSongsId = [];

class AddSongs extends StatefulWidget {
  final bool modify;
  final String? playlistName;
  const AddSongs({required this.modify, required this.playlistName, super.key});
  @override
  State<AddSongs> createState() => _AddSongsState();
}

class _AddSongsState extends State<AddSongs> {
  bool isNameChanged = false;
  String? nameOfPlaylist;
  ScrollController? _scrollBarController;

  @override
  void initState() {
    _scrollBarController = ScrollController();
    crossfadeStateChange = true;
    super.initState();
  }

  @override
  void dispose() {
    crossfadeStateChange = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Leprovider>(
      builder: (context, taste, _) {
        globaltaste = taste;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
            splashColor: Colors.transparent,
            icon: const Icon(Icons.check_rounded, color: Colors.black),
            label: Text(widget.modify ? "MODIFY" : "CREATE",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: deviceWidth! / 25,
                    fontWeight: FontWeight.w600)),
            backgroundColor: const Color(0xFF1DB954),
            elevation: 8.0,
            onPressed: () async {
              if (!((widget.playlistName == "Enter Playlist Name" &&
                      nameOfPlaylist != null) ||
                  (widget.playlistName != "Enter Playlist Name"))) {
                Flushbar(
                  messageText: const Text("Enter a Playlist Name! ¯\\_(ツ)_/¯",
                      style:
                          TextStyle(fontFamily: "Futura", color: Colors.white)),
                  icon: const Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Color(0xFFCB0447),
                  ),
                  shouldIconPulse: true,
                  dismissDirection: FlushbarDismissDirection.HORIZONTAL,
                  duration: const Duration(seconds: 5),
                  borderColor: Colors.white.withOpacity(0.04),
                  borderWidth: 1,
                  backgroundColor: glassOpacity!,
                  flushbarStyle: FlushbarStyle.FLOATING,
                  isDismissible: true,
                  barBlur: musicBox.get("glassBlur") ?? 18,
                  margin: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
                  borderRadius: BorderRadius.circular(15),
                ).show(context);
              } else {
                if (musicBox.get("playlists") != null &&
                    musicBox
                        .get("playlists")
                        .keys
                        .toList()
                        .contains(widget.playlistName)) {
                  fetchPlaylistSongs(widget.playlistName);
                }
                if (isNameChanged) {
                  await removePlaylists(widget.playlistName);
                }
                await newPlaylist(
                    nameOfPlaylist ?? widget.playlistName, playListSongsId);
                Navigator.pop(context);
              }
            },
          ),
          body: Theme(
            data: themeOfApp,
            child: Stack(children: [
              // ignore: prefer_const_constructors
              BackArt(),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    height: 120,
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Center(
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(glassShadowOpacity! / 100),
                              blurRadius: glassShadowBlur,
                              offset: kShadowOffset,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(kRounded),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kRounded),
                          child: BackdropFilter(
                            filter: glassBlur,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kRounded),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.04),
                                ),
                                color: glassOpacity,
                              ),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: const Color(0xFF3cb9cd),
                                autofocus: false,
                                style: const TextStyle(color: Colors.white),
                                onChanged: (thetext) {
                                  nameOfPlaylist = thetext;
                                  if (widget.modify) isNameChanged = true;
                                },
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent),
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[350],
                                  ),
                                  hintText: widget.playlistName,
                                  prefixIcon: Icon(
                                      MdiIcons.playlistMusicOutline,
                                      color: Colors.white),
                                  suffixIcon: Visibility(
                                    visible: widget.modify,
                                    child: IconButton(
                                      icon: const Icon(Ionicons.trash_outline,
                                          color: Color(0xFFCB0047)),
                                      onPressed: () async {
                                        await removePlaylists(
                                            widget.playlistName);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Scrollbar(
                        controller: _scrollBarController,
                        child: ListView.builder(
                          controller: _scrollBarController,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 0, bottom: 8),
                          addAutomaticKeepAlives: true,
                          physics: musicBox.get("fluidAnimation") ?? true
                              ? const BouncingScrollPhysics()
                              : const ClampingScrollPhysics(),
                          itemCount: songList.length,
                          itemBuilder: (context, index) {
                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                onTap: () {
                                  if (playListCheck[index]) {
                                    if (!widget.modify) {
                                      playListCheck[index] = false;
                                      playListSongsId
                                          .remove(songList[index].data);
                                    } else {
                                      playListCheck[index] = false;
                                      modifyPlayList!
                                          .remove(songList[index].data);
                                    }
                                  } else {
                                    if (!widget.modify) {
                                      playListCheck[index] = true;
                                      playListSongsId.add(songList[index].data);
                                    } else {
                                      playListCheck[index] = true;
                                      modifyPlayList!.add(songList[index].data);
                                    }
                                  }
                                  setState(() {});
                                },
                                dense: false,
                                enabled: true,
                                title: Text(
                                  songList[index].title,
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                                tileColor: Colors.transparent,
                                subtitle: Text(
                                  songList[index].artist!,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.white38,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 1.0),
                                        blurRadius: 2.0,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Checkbox(
                                  activeColor: const Color(0xFF1DB954),
                                  value: playListCheck[index],
                                  onChanged: (_) {
                                    if (playListCheck[index]) {
                                      if (!widget.modify) {
                                        playListCheck[index] = false;
                                        playListSongsId
                                            .remove(songList[index].data);
                                      } else {
                                        playListCheck[index] = false;
                                        modifyPlayList!
                                            .remove(songList[index].data);
                                      }
                                    } else {
                                      if (!widget.modify) {
                                        playListCheck[index] = true;
                                        playListSongsId
                                            .add(songList[index].data);
                                      } else {
                                        playListCheck[index] = true;
                                        modifyPlayList!
                                            .add(songList[index].data);
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                                leading: Card(
                                  elevation: 3,
                                  color: Colors.transparent,
                                  child: ConstrainedBox(
                                    constraints:
                                        musicBox.get("squareArt") ?? true
                                            ? kSqrConstraint
                                            : kRectConstraint,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(artworksData[
                                                  (musicBox.get(
                                                          "artworksPointer") ??
                                                      {})[songList[
                                                          index]
                                                      .id]] ??
                                              defaultNone!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}
