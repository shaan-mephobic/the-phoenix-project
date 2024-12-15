import 'package:page_transition/page_transition.dart';
import 'package:phoenix/src/beginning/pages/now_playing/mini_playing.dart';
import 'package:phoenix/src/beginning/pages/now_playing/now_playing_sky.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/corrupted_file_dialog.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/quick_tips.dart';
import 'package:phoenix/src/beginning/widgets/list_header.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/on_hold.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'albums.dart';
import '../../utilities/page_backend/albums_back.dart';

Color? dominantAlbum;
Color? contrastAlbum;

class AlbumsInside extends StatefulWidget {
  const AlbumsInside({super.key});

  @override
  State<AlbumsInside> createState() => _AlbumsInsideState();
}

class _AlbumsInsideState extends State<AlbumsInside> {
  PanelController albumPC = PanelController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!isPlayerShown) await albumPC.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isPlayerShown && albumPC.isAttached && !albumPC.isPanelShown) {
      albumPC.show();
    }
    rootCrossfadeState = Provider.of<Leprovider>(context);
    rootState = Provider.of<Leprovider>(context);
    final provider = Provider.of<SortProvider>(context);

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider<Leprovider>.value(
        value: Provider.of<Leprovider>(context, listen: false),
        builder: (context, _) => SlidingUpPanel(
          parallaxEnabled: true,
          isDraggable: true,
          backdropColor: Colors.black,
          minHeight: 60,
          controller: albumPC,
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
                    expandedHeight: 380,
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
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(kRounded),
                                child: Image.memory(
                                  albumsArts[
                                          allAlbums[passedIndexAlbum!].album] ??
                                      defaultNone!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Text(
                            inAlbumSongs[0].album!,
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
                          const Padding(padding: EdgeInsets.only(top: 2)),
                          Opacity(
                            opacity: 0.5,
                            child: Text(
                              inAlbumSongs[0].artist!,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: TextStyle(
                                shadows: const [
                                  Shadow(
                                    offset: Offset(0, 1.8),
                                    blurRadius: 2.2,
                                    color: Colors.black26,
                                  ),
                                ],
                                fontSize: deviceHeight! / 57,
                                color: musicBox.get("dynamicArtDB") ?? true
                                    ? contrastAlbum
                                    : Colors.white,
                              ),
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
                                deviceWidth, inAlbumSongs, "album",
                                stateNotifier: provider);
                          }
                          return Material(
                            color: Colors.transparent,
                            child: ListTile(
                              onTap: () async {
                                if (albumMediaItems[index - 1].duration ==
                                    const Duration(milliseconds: 0)) {
                                  corruptedFile(context);
                                } else {
                                  insideInAlbumSongs = inAlbumSongs;
                                  await playThis(index - 1, "album");
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
                                    child: OnHold(
                                        classContext: context,
                                        listOfSong: inAlbumSongs,
                                        index: index - 1,
                                        car: orientedCar,
                                        heightOfDevice: deviceHeight,
                                        widthOfDevice: deviceWidth,
                                        songOf: "album"),
                                  ),
                                );
                              },
                              dense: false,
                              title: Text(
                                inAlbumSongs[index - 1].title,
                                maxLines: 2,
                                style: TextStyle(
                                  color: musicBox.get("dynamicArtDB") ?? true
                                      ? contrastAlbum
                                      : Colors.white,
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
                                  inAlbumSongs[index - 1].artist!,
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
                            ),
                          );
                        },
                        childCount: inAlbumSongs.length + 1,
                        addAutomaticKeepAlives: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future albumColor(image) async {
  PaletteGenerator paletteGenerator;
  paletteGenerator = await PaletteGenerator.fromImageProvider(image);
  dominantAlbum = (paletteGenerator.dominantColor!.color);
  if (dominantAlbum!.computeLuminance() < 0.5) {
    try {
      var pal = paletteGenerator.lightMutedColor!.color;
      contrastAlbum = pal;
    } catch (e) {
      contrastAlbum = Colors.white;
    }

    if (dominantAlbum == contrastAlbum) {
      try {
        contrastAlbum = paletteGenerator.darkMutedColor!.color;
      } catch (e) {
        contrastAlbum = Colors.white;
      }
    }
  } else {
    try {
      var pal = (paletteGenerator.darkMutedColor!.color);
      contrastAlbum = pal;
    } catch (e) {
      contrastAlbum = Colors.black;
    }
    if (dominantAlbum == contrastAlbum) {
      try {
        contrastAlbum = paletteGenerator.lightMutedColor!.color;
      } catch (e) {
        contrastAlbum = Colors.black;
      }
    }
  }
  if ((dominantAlbum!.computeLuminance() - contrastAlbum!.computeLuminance())
          .abs() <
      0.2) {
    if (dominantAlbum!.computeLuminance() < 0.5) {
      contrastAlbum = Colors.white;
    } else {
      contrastAlbum = Colors.black;
    }
  }
}
