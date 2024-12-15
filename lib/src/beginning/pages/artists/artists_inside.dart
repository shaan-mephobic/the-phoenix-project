import 'dart:io';
import 'package:page_transition/page_transition.dart';
import 'package:phoenix/src/beginning/pages/now_playing/mini_playing.dart';
import 'package:phoenix/src/beginning/pages/now_playing/now_playing_sky.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/pages/albums/albums_inside.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/artist_collage.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/quick_tips.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../utilities/page_backend/artists_back.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/corrupted_file_dialog.dart';
import 'package:phoenix/src/beginning/widgets/list_header.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/on_hold.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:flutter/material.dart';

int? artistPassed;

class ArtistsInside extends StatefulWidget {
  const ArtistsInside({super.key});

  @override
  State<ArtistsInside> createState() => _ArtistsInsideState();
}

class _ArtistsInsideState extends State<ArtistsInside> {
  PanelController artistPC = PanelController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!isPlayerShown) await artistPC.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isPlayerShown && artistPC.isAttached && !artistPC.isPanelShown) {
      artistPC.show();
    }
    rootCrossfadeState = Provider.of<Leprovider>(context);
    rootState = Provider.of<Leprovider>(context);
    final provider = Provider.of<SortProvider>(context);
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SlidingUpPanel(
        parallaxEnabled: true,
        isDraggable: true,
        backdropColor: Colors.black,
        minHeight: 60,
        controller: artistPC,
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
        body: Theme(
          data: themeOfApp,
          child: Container(
            color: musicBox.get("dynamicArtDB") ?? true
                ? dominantAlbum
                : kMaterialBlack,
            child: CustomScrollView(
              physics: musicBox.get("fluidAnimation") ?? true
                  ? const BouncingScrollPhysics()
                  : const ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                    color: musicBox.get("dynamicArtDB") ?? true
                        ? contrastAlbum
                        : Colors.white,
                  ),
                  expandedHeight: 350,
                  backgroundColor: musicBox.get("dynamicArtDB") ?? true
                      ? dominantAlbum
                      : kMaterialBlack,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    titlePadding: const EdgeInsets.all(0),
                    background: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 80)),
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kRounded),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6.0,
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(kRounded),
                              child: musicBox.get("mapOfArtists") == null
                                  ? artistCollage(artistPassed, allArtists,
                                      kRounded, deviceHeight! / 4.6)
                                  : musicBox.get("mapOfArtists")[
                                              allArtists[artistPassed!]] ==
                                          null
                                      ? artistCollage(artistPassed, allArtists,
                                          kRounded, deviceHeight! / 4.6)
                                      : Image.file(
                                          File(
                                              "${applicationFileDirectory.path}/artists/${allArtists[artistPassed!]}.jpg"),
                                        ),
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
                        Text(
                          allArtists[artistPassed!].contains(",")
                              ? allArtists[artistPassed!]
                                      .replaceRange(
                                          allArtists[artistPassed!]
                                              .indexOf(","),
                                          allArtists[artistPassed!].length,
                                          "")
                                      .contains(" FEAT")
                                  ? allArtists[artistPassed!]
                                      .replaceRange(
                                          allArtists[artistPassed!]
                                              .indexOf(","),
                                          allArtists[artistPassed!].length,
                                          "")
                                      .replaceRange(
                                          allArtists[artistPassed!]
                                              .indexOf(" FEAT"),
                                          allArtists[artistPassed!]
                                              .replaceRange(
                                                  allArtists[artistPassed!]
                                                      .indexOf(","),
                                                  allArtists[artistPassed!]
                                                      .length,
                                                  "")
                                              .length,
                                          "")
                                  : allArtists[artistPassed!].replaceRange(
                                      allArtists[artistPassed!].indexOf(","),
                                      allArtists[artistPassed!].length,
                                      "")
                              : allArtists[artistPassed!].contains(" FEAT")
                                  ? allArtists[artistPassed!].replaceRange(
                                      allArtists[artistPassed!]
                                          .indexOf(" FEAT"),
                                      allArtists[artistPassed!].length,
                                      "")
                                  : allArtists[artistPassed!],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            shadows: const [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 2.2,
                                color: Colors.black26,
                              ),
                            ],
                            fontSize: deviceHeight! / 39,
                            color: musicBox.get("dynamicArtDB") ?? true
                                ? contrastAlbum
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(bottom: isPlayerShown ? 60 : 0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == 0) {
                          return ListHeader(
                              deviceWidth, inArtistsSongs, "artist",
                              stateNotifier: provider);
                        }
                        return Material(
                          color: Colors.transparent,
                          child: ListTile(
                            onTap: () async {
                              if (artistMediaItems[index - 1].duration ==
                                  const Duration(milliseconds: 0)) {
                                corruptedFile(context);
                              } else {
                                insideInArtistsSongs = inArtistsSongs;
                                await playThis(index - 1, "artist");
                              }
                            },
                            onLongPress: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.size,
                                  alignment: Alignment.center,
                                  duration: dialogueAnimationDuration,
                                  reverseDuration: dialogueAnimationDuration,
                                  child: OnHold(
                                      classContext: context,
                                      listOfSong: inArtistsSongs,
                                      index: index - 1,
                                      car: orientedCar,
                                      heightOfDevice: deviceHeight,
                                      widthOfDevice: deviceWidth,
                                      songOf: "artist"),
                                ),
                              );
                            },
                            dense: false,
                            title: Text(
                              inArtistsSongs[index - 1].title,
                              maxLines: 2,
                              style: TextStyle(
                                color: musicBox.get("dynamicArtDB") ?? true
                                    ? contrastAlbum
                                    : Colors.white,
                                // fontSize: orientedCar
                                //     ? deviceWidth / 28
                                //     : deviceHeight / 60,
                                shadows: const [
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
                                inArtistsSongs[index - 1].artist!,
                                maxLines: 1,
                                style: TextStyle(
                                  color: musicBox.get("dynamicArtDB") ?? true
                                      ? contrastAlbum
                                      : Colors.white,
                                  shadows: const [
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
                                constraints: musicBox.get("squareArt") ?? true
                                    ? kSqrConstraint
                                    : kRectConstraint,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: MemoryImage(artworksData[(musicBox
                                                      .get("artworksPointer") ??
                                                  {})[
                                              inArtistsSongs[index - 1].id]] ??
                                          defaultNone!),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: numberOfSongsOfArtist + 1,
                      addAutomaticKeepAlives: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  artHeroManager(oink) {
    int? toGetIndex;
    for (int woah = 0; woah < allAlbums.length; woah++) {
      if (artistData[allArtists[artistPassed!]]![oink].albumName ==
          allAlbums[woah].album) {
        toGetIndex = woah;
      }
    }
    return "sterio-$toGetIndex";
  }
}
