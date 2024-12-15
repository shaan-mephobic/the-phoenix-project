// ignore_for_file: prefer_const_constructors

import 'package:page_transition/page_transition.dart';
import 'package:phoenix/src/beginning/pages/now_playing/mini_playing.dart';
import 'package:phoenix/src/beginning/pages/now_playing/now_playing_sky.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/quick_tips.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../utilities/page_backend/genres_back.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/corrupted_file_dialog.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/list_header.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/on_hold.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'genres.dart';

List? insidegenreSongs = [];

class GenresInside extends StatefulWidget {
  const GenresInside({super.key});

  @override
  State<GenresInside> createState() => _GenresInsideState();
}

class _GenresInsideState extends State<GenresInside> {
  ScrollController? _scrollBarController;
  PanelController genresPC = PanelController();

  @override
  void initState() {
    crossfadeStateChange = true;
    _scrollBarController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!isPlayerShown) await genresPC.hide();
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
    if (isPlayerShown && genresPC.isAttached && !genresPC.isPanelShown) {
      genresPC.show();
    }
    rootCrossfadeState = Provider.of<Leprovider>(context);
    rootState = Provider.of<Leprovider>(context);
    final provider = Provider.of<SortProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SlidingUpPanel(
        parallaxEnabled: true,
        isDraggable: true,
        backdropColor: Colors.black,
        minHeight: 60,
        controller: genresPC,
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
                    shadowColor: Colors.transparent,
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    title: Text(
                      musicBox.get('customScan') ?? false
                          ? insideAllGenreData.keys.toList()[genreSelected]
                          : allgenres[genreSelected].genre,
                      style: TextStyle(
                        fontSize: deviceWidth! / 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: deviceWidth! / 4.3),
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Scrollbar(
                        controller: _scrollBarController,
                        child: ListView.builder(
                          controller: _scrollBarController,
                          padding: EdgeInsets.only(
                              top: 5, bottom: isPlayerShown ? 60 : 0),
                          physics: musicBox.get("fluidAnimation") ?? true
                              ? const BouncingScrollPhysics()
                              : const ClampingScrollPhysics(),
                          itemCount: genreSongs!.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return ListHeader(
                                deviceWidth,
                                genreSongs,
                                "genre",
                                stateNotifier: provider,
                              );
                            }
                            return Material(
                              color: Colors.transparent,
                              child: ListTile(
                                onTap: () async {
                                  if (genreMediaItems[index - 1].duration ==
                                      const Duration(milliseconds: 0)) {
                                    corruptedFile(context);
                                  } else {
                                    insidegenreSongs = [];
                                    insidegenreSongs = genreSongs;
                                    await playThis(index - 1, "genre");
                                  }
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
                                      child: OnHold(
                                          classContext: context,
                                          listOfSong: genreSongs!,
                                          index: index - 1,
                                          car: orientedCar,
                                          heightOfDevice: deviceHeight,
                                          widthOfDevice: deviceWidth,
                                          songOf: "genre"),
                                    ),
                                  );
                                },
                                dense: false,
                                title: Text(
                                  genreSongs![index - 1].title,
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
                                    genreSongs![index - 1].artist!,
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
                                                      {})[genreSongs![
                                                          index - 1]
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
            );
          },
        ),
      ),
    );
  }
}
