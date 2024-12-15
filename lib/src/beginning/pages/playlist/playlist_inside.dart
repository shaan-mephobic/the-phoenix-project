// ignore_for_file: prefer_const_constructors

import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/beginning/pages/now_playing/mini_playing.dart';
import 'package:phoenix/src/beginning/pages/now_playing/now_playing_sky.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/corrupted_file_dialog.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/quick_tips.dart';
import 'package:phoenix/src/beginning/widgets/list_header.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../utilities/page_backend/playlist_back.dart';

List<SongModel> playlistSongsInside = [];
List<SongModel>? insideplaylistSongsInside = [];
List<MediaItem> playlistMediaItems = [];

class PlaylistInside extends StatefulWidget {
  final String? playlistName;
  const PlaylistInside({super.key, required this.playlistName});
  @override
  State<PlaylistInside> createState() => _PlaylistInsideState();
}

class _PlaylistInsideState extends State<PlaylistInside> {
  ScrollController? _scrollBarController;
  PanelController playlistPC = PanelController();

  @override
  void initState() {
    crossfadeStateChange = true;
    _scrollBarController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!isPlayerShown) await playlistPC.hide();
    });
    super.initState();
  }

  @override
  void dispose() {
    crossfadeStateChange = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isPlayerShown && playlistPC.isAttached && !playlistPC.isPanelShown) {
      playlistPC.show();
    }
    rootCrossfadeState = Provider.of<Leprovider>(context);
    rootState = Provider.of<Leprovider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SlidingUpPanel(
        parallaxEnabled: true,
        isDraggable: true,
        backdropColor: Colors.black,
        minHeight: 60,
        controller: playlistPC,
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
        collapsed: musicBox.get("classix") ?? true ? Classix() : Moderna(),
        maxHeight: deviceHeight!,
        backdropTapClosesPanel: true,
        renderPanelSheet: true,
        color: Colors.transparent,
        panel: NowPlayingSky(),
        body: Consumer<Leprovider>(
          builder: (context, taste, _) {
            globaltaste = taste;
            return Theme(
              data: themeOfApp,
              child: Stack(
                children: [
                  BackArt(),
                  AppBar(
                    centerTitle: true,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    title: Text(
                      widget.playlistName!,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: deviceWidth! / 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: deviceWidth! / 4.3),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Scrollbar(
                        controller: _scrollBarController,
                        child: ReorderableListView.builder(
                            scrollController: _scrollBarController,
                            padding: EdgeInsets.only(
                                top: 0, bottom: isPlayerShown ? 60 : 0),
                            physics: musicBox.get("fluidAnimation") ?? true
                                ? const BouncingScrollPhysics()
                                : const ClampingScrollPhysics(),
                            header: ListHeader(
                                deviceWidth, playlistSongsInside, "playlist"),
                            itemCount: playlistSongsInside.length,
                            itemBuilder: (context, index) {
                              final String kee =
                                  playlistSongsInside[index].id.toString();
                              return Material(
                                color: Colors.transparent,
                                key: ValueKey(kee),
                                child: ListTile(
                                  onTap: () async {
                                    if (playlistMediaItems[index].duration ==
                                        const Duration(milliseconds: 0)) {
                                      corruptedFile(context);
                                    } else {
                                      insideplaylistSongsInside =
                                          playlistSongsInside;
                                      await playThis(index, "playlist");
                                    }
                                  },
                                  dense: false,
                                  title: Text(
                                    playlistSongsInside[index].title,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(0, 1.0),
                                          blurRadius: 2.0,
                                          color: Colors.black45,
                                        ),
                                      ],
                                    ),
                                  ),
                                  tileColor: Colors.transparent,
                                  subtitle: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                      playlistSongsInside[index].artist!,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(0, 1.0),
                                            blurRadius: 1.0,
                                            color: Colors.black38,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  trailing: Material(
                                    color: Colors.transparent,
                                    child: ReorderableDragStartListener(
                                      index: index,
                                      child: const Icon(Icons.drag_handle),
                                    ),
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
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: MemoryImage(artworksData[
                                                    (musicBox.get(
                                                            "artworksPointer") ??
                                                        {})[playlistSongsInside[
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
                            onReorder: (oldIndex, newIndex) async {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex = newIndex - 1;
                                }
                                final element =
                                    playlistSongsInside.removeAt(oldIndex);
                                playlistSongsInside.insert(newIndex, element);
                              });
                              await updateQueuePlayList(
                                  widget.playlistName, playlistSongsInside);
                              playlistMediaItems = [];
                              playlistSongsInside = [];
                              await fetchPlaylistSongs(widget.playlistName);
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
