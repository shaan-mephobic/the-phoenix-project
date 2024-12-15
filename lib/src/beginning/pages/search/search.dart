import 'dart:io';
import 'package:flutter_remixicon/flutter_remixicon.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phoenix/src/beginning/pages/albums/albums.dart';
import 'package:phoenix/src/beginning/pages/albums/albums_inside.dart';
import 'package:phoenix/src/beginning/pages/artists/artists_inside.dart';
import 'package:phoenix/src/beginning/pages/now_playing/mini_playing.dart';
import 'package:phoenix/src/beginning/pages/now_playing/now_playing_sky.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/artists_back.dart';
import 'package:phoenix/src/beginning/widgets/artist_collage.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/corrupted_file_dialog.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/on_hold.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/quick_tips.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Searchin extends StatefulWidget {
  const Searchin({super.key});

  @override
  State<Searchin> createState() => _SearchinState();
}

class _SearchinState extends State<Searchin> {
  PanelController searchPC = PanelController();
  ScrollController? _scrollBarController;
  List searchedAlbums = [];
  List searchedArtists = [];
  List searchedTracks = [];
  List customLocations = musicBox.get("customLocations") ?? [];

  @override
  void initState() {
    focusManager();
    crossfadeStateChange = true;
    _scrollBarController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!isPlayerShown) await searchPC.hide();
    });
    super.initState();
  }

  @override
  void dispose() {
    crossfadeStateChange = false;
    super.dispose();
  }

  FocusNode focusNode = FocusNode();

  theSearch(String name) async {
    if (name != "") {
      searchedTracks = [];
      if (musicBox.get("customScan") ?? false) {
        for (int i = 0; i < songList.length; i++) {
          for (int a = 0; a < customLocations.length; a++) {
            if (songList[i].data.contains(customLocations[a]) &&
                songList[i].title.toUpperCase().contains(name.toUpperCase())) {
              searchedTracks.add(songList[i]);
              break;
            }
          }
        }
      } else {
        for (int i = 0; i < songList.length; i++) {
          if (songList[i].title.toUpperCase().contains(name.toUpperCase())) {
            searchedTracks.add(songList[i]);
          }
        }
      }
      searchedAlbums = [];
      for (int i = 0; i < allAlbums.length; i++) {
        if (allAlbums[i].album.toUpperCase().contains(name.toUpperCase())) {
          searchedAlbums.add(allAlbums[i]);
        }
      }
      searchedArtists = [];
      for (int i = 0; i < allArtists.length; i++) {
        if (allArtists[i].toUpperCase().contains(name.toUpperCase())) {
          searchedArtists.add(allArtists[i]);
        }
      }
      setState(() {});
    } else {
      setState(() {
        searchedAlbums = [];
        searchedTracks = [];
        searchedArtists = [];
      });
    }
  }

  focusManager() async {
    await Future.delayed(const Duration(milliseconds: 150));
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    rootCrossfadeState = Provider.of<Leprovider>(context);
    rootState = Provider.of<Leprovider>(context);
    if (isPlayerShown && searchPC.isAttached && !searchPC.isPanelShown) {
      searchPC.show();
    }

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SlidingUpPanel(
        parallaxEnabled: true,
        isDraggable: true,
        backdropColor: Colors.black,
        minHeight: 60,
        controller: searchPC,
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
                  // ignore: prefer_const_constructors
                  BackArt(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                    borderRadius:
                                        BorderRadius.circular(kRounded),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.04)),
                                    color: glassOpacity,
                                  ),
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    cursorColor: const Color(0xFF3cb9cd),
                                    focusNode: focusNode,
                                    autofocus: false,
                                    style: const TextStyle(color: Colors.white),
                                    onChanged: (thetext) {
                                      theSearch(thetext);
                                    },
                                    decoration: InputDecoration(
                                      isCollapsed: true,
                                      suffixIcon: const Icon(
                                          Icons.music_note_rounded,
                                          color: Colors.white),
                                      prefixIcon: const Hero(
                                        tag: "aslongasiwakeup",
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Icon(
                                            MIcon.riSearchLine,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      border: const OutlineInputBorder(),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent)),
                                      hintStyle:
                                          TextStyle(color: Colors.grey[350]),
                                      hintText:
                                          "Search for songs,albums,artists...",
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
                              padding: EdgeInsets.only(
                                  top: 0, bottom: isPlayerShown ? 60 : 0),
                              addAutomaticKeepAlives: true,
                              physics: musicBox.get("fluidAnimation") ?? true
                                  ? const BouncingScrollPhysics()
                                  : const ClampingScrollPhysics(),
                              itemCount: searchedTracks.length + 3,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Visibility(
                                    visible: searchedAlbums.isNotEmpty,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 25.0),
                                                child: SizedBox(
                                                  height: deviceWidth! / 9,
                                                  child: Text(
                                                    "Albums",
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceWidth! / 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: deviceWidth! / 1.9,
                                            width: orientedCar
                                                ? deviceHeight
                                                : deviceWidth,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    searchedAlbums.length,
                                                physics: musicBox.get(
                                                            "fluidAnimation") ??
                                                        true
                                                    ? const BouncingScrollPhysics()
                                                    : const ClampingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              kRounded),
                                                      onTap: () async {
                                                        focusNode.unfocus();
                                                        passedIndexAlbum =
                                                            allAlbumsName.indexOf(
                                                                searchedAlbums[
                                                                        index]
                                                                    .album);

                                                        if (musicBox.get(
                                                                    "colorsOfAlbums") ==
                                                                null
                                                            ? true
                                                            : musicBox.get(
                                                                    "colorsOfAlbums")[allAlbums[
                                                                        passedIndexAlbum!]
                                                                    .album] ==
                                                                null) {
                                                          await albumColor(MemoryImage(
                                                              albumsArts[allAlbums[
                                                                          passedIndexAlbum!]
                                                                      .album] ??
                                                                  defaultNone!));
                                                          Map albumColors =
                                                              musicBox.get(
                                                                      "colorsOfAlbums") ??
                                                                  {};
                                                          albumColors[allAlbums[
                                                                  passedIndexAlbum!]
                                                              .album] = [
                                                            dominantAlbum!
                                                                .value,
                                                            contrastAlbum!.value
                                                          ];
                                                          musicBox.put(
                                                              "colorsOfAlbums",
                                                              albumColors);
                                                        } else {
                                                          dominantAlbum = Color(
                                                              musicBox.get(
                                                                  "colorsOfAlbums")[allAlbums[
                                                                      passedIndexAlbum!]
                                                                  .album][0]);
                                                          contrastAlbum = Color(
                                                              musicBox.get(
                                                                  "colorsOfAlbums")[allAlbums[
                                                                      passedIndexAlbum!]
                                                                  .album][1]);
                                                        }
                                                        inAlbumSongs = [];
                                                        inAlbumSongsArtIndex =
                                                            [];
                                                        albumMediaItems = [];
                                                        await albumSongs();
                                                        var rootCrossfadeStateDup =
                                                            rootCrossfadeState;
                                                        var rootStateDup =
                                                            rootState;
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                MultiProvider(
                                                              providers: [
                                                                ChangeNotifierProvider<
                                                                        Leprovider>(
                                                                    create: (_) =>
                                                                        Leprovider()),
                                                                ChangeNotifierProvider<
                                                                    MrMan>(
                                                                  create: (_) =>
                                                                      MrMan(),
                                                                ),
                                                                ChangeNotifierProvider<
                                                                        Seek>(
                                                                    create: (_) =>
                                                                        Seek()),
                                                                ChangeNotifierProvider<
                                                                    SortProvider>(
                                                                  create: (_) =>
                                                                      SortProvider(),
                                                                  builder: (context,
                                                                          child) =>
                                                                      ChangeNotifierProvider<
                                                                          Leprovider>.value(
                                                                    value:
                                                                        rootCrossfadeState,
                                                                    child:
                                                                        const AlbumsInside(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ).then((value) {
                                                          rootCrossfadeState =
                                                              rootCrossfadeStateDup;
                                                          rootState =
                                                              rootStateDup;
                                                          if (isPlayerShown) {
                                                            rootState
                                                                .provideman();
                                                          }
                                                        });
                                                      },
                                                      child: SizedBox(
                                                        height:
                                                            deviceWidth! / 2,
                                                        width:
                                                            deviceWidth! / 2.5,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: deviceWidth! /
                                                                            30)),
                                                            PhysicalModel(
                                                              color: Colors
                                                                  .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          kRounded),
                                                              elevation:
                                                                  deviceWidth! /
                                                                      140,
                                                              child: Container(
                                                                height:
                                                                    deviceWidth! /
                                                                        3,
                                                                width:
                                                                    deviceWidth! /
                                                                        3,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              kRounded),
                                                                  image:
                                                                      DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: MemoryImage(
                                                                        albumsArts[searchedAlbums[index].album] ??
                                                                            defaultNone!),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: deviceWidth! /
                                                                            40)),
                                                            Text(
                                                              searchedAlbums[
                                                                      index]
                                                                  .album
                                                                  .toUpperCase(),
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: orientedCar
                                                                    ? deviceHeight! /
                                                                        54
                                                                    : deviceWidth! /
                                                                        30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                shadows: [
                                                                  Shadow(
                                                                    offset: musicBox.get("dynamicArtDB") ??
                                                                            true
                                                                        ? const Offset(
                                                                            1.0,
                                                                            1.0)
                                                                        : const Offset(
                                                                            0,
                                                                            1.0),
                                                                    blurRadius:
                                                                        2.0,
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (index == 1) {
                                  return Visibility(
                                    visible: searchedArtists.isNotEmpty,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 25.0),
                                                child: SizedBox(
                                                  height: deviceWidth! / 9,
                                                  child: Text(
                                                    "Artists",
                                                    style: TextStyle(
                                                        fontSize:
                                                            deviceWidth! / 15,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: deviceWidth! / 1.9,
                                            width: deviceWidth,
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    searchedArtists.length,
                                                physics: musicBox.get(
                                                            "fluidAnimation") ??
                                                        true
                                                    ? const BouncingScrollPhysics()
                                                    : const ClampingScrollPhysics(),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              kRounded),
                                                      onTap: () async {
                                                        focusNode.unfocus();
                                                        inArtistsSongs = [];
                                                        artistPassed =
                                                            allArtists.indexOf(
                                                                searchedArtists[
                                                                    index]);
                                                        await artistsAllSongs(
                                                            searchedArtists[
                                                                index]);
                                                        if (musicBox.get(
                                                                    "mapOfArtists") !=
                                                                null &&
                                                            musicBox.get(
                                                                        "mapOfArtists")[
                                                                    searchedArtists[
                                                                        index]] !=
                                                                null) {
                                                          if (musicBox.get(
                                                                      "colorsOfArtists") ==
                                                                  null
                                                              ? true
                                                              : musicBox.get(
                                                                          "colorsOfArtists")[
                                                                      searchedArtists[
                                                                          index]] ==
                                                                  null) {
                                                            try {
                                                              await albumColor(
                                                                  FileImage(File(
                                                                      "${applicationFileDirectory.path}/artists/${searchedArtists[index]}.jpg")));
                                                              Map colorMap =
                                                                  musicBox.get(
                                                                          "colorsOfArtists") ??
                                                                      {};
                                                              colorMap[
                                                                  searchedArtists[
                                                                      index]] = [
                                                                dominantAlbum!
                                                                    .value,
                                                                contrastAlbum!
                                                                    .value
                                                              ];
                                                              musicBox.put(
                                                                  "colorsOfArtists",
                                                                  colorMap);
                                                            } catch (e) {
                                                              contrastAlbum =
                                                                  const Color(
                                                                      0xFF3cb9cd);
                                                              dominantAlbum =
                                                                  kMaterialBlack;
                                                            }
                                                          } else {
                                                            dominantAlbum = Color(
                                                                musicBox.get(
                                                                        "colorsOfArtists")[
                                                                    searchedArtists[
                                                                        index]][0]);
                                                            contrastAlbum = Color(
                                                                musicBox.get(
                                                                        "colorsOfArtists")[
                                                                    searchedArtists[
                                                                        index]][1]);
                                                          }
                                                        } else {
                                                          contrastAlbum =
                                                              Colors.white;
                                                          dominantAlbum =
                                                              kMaterialBlack;
                                                        }
                                                        var rootCrossfadeStateDup =
                                                            rootCrossfadeState;
                                                        var rootStateDup =
                                                            rootState;
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                MultiProvider(
                                                              providers: [
                                                                ChangeNotifierProvider<
                                                                        Leprovider>(
                                                                    create: (_) =>
                                                                        Leprovider()),
                                                                ChangeNotifierProvider<
                                                                    MrMan>(
                                                                  create: (_) =>
                                                                      MrMan(),
                                                                ),
                                                                ChangeNotifierProvider<
                                                                        Seek>(
                                                                    create: (_) =>
                                                                        Seek()),
                                                                ChangeNotifierProvider<
                                                                    SortProvider>(
                                                                  create: (_) =>
                                                                      SortProvider(),
                                                                  builder: (context,
                                                                          child) =>
                                                                      ChangeNotifierProvider<
                                                                          Leprovider>.value(
                                                                    value:
                                                                        rootCrossfadeState,
                                                                    child:
                                                                        const ArtistsInside(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ).then((value) {
                                                          rootCrossfadeState =
                                                              rootCrossfadeStateDup;
                                                          rootState =
                                                              rootStateDup;
                                                          if (isPlayerShown) {
                                                            rootState
                                                                .provideman();
                                                          }
                                                        });
                                                      },
                                                      child: SizedBox(
                                                        height:
                                                            deviceWidth! / 2,
                                                        width:
                                                            deviceWidth! / 2.5,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: deviceWidth! /
                                                                            30)),
                                                            PhysicalModel(
                                                              color: Colors
                                                                  .transparent,
                                                              shape: BoxShape
                                                                  .circle,
                                                              elevation:
                                                                  deviceWidth! /
                                                                      140,
                                                              child: Container(
                                                                height:
                                                                    deviceWidth! /
                                                                        3,
                                                                width:
                                                                    deviceWidth! /
                                                                        3,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: artistCollage(
                                                                    index,
                                                                    searchedArtists,
                                                                    deviceWidth! /
                                                                        1.5,
                                                                    deviceWidth! /
                                                                        3),
                                                              ),
                                                            ),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: deviceWidth! /
                                                                            40)),
                                                            Text(
                                                              searchedArtists[
                                                                  index],
                                                              maxLines: 2,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: musicBox.get(
                                                                            "dynamicArtDB") ??
                                                                        true
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .white,
                                                                fontSize: orientedCar
                                                                    ? deviceHeight! /
                                                                        54
                                                                    : deviceWidth! /
                                                                        30,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                shadows: [
                                                                  Shadow(
                                                                    offset: musicBox.get("dynamicArtDB") ??
                                                                            true
                                                                        ? const Offset(
                                                                            1.0,
                                                                            1.0)
                                                                        : const Offset(
                                                                            0,
                                                                            1.0),
                                                                    blurRadius:
                                                                        2.0,
                                                                    color: Colors
                                                                        .black45,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (index == 2) {
                                  return Visibility(
                                    visible: searchedTracks.isNotEmpty,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 25.0),
                                          child: SizedBox(
                                            height: deviceWidth! / 9,
                                            child: Text(
                                              "Tracks",
                                              style: TextStyle(
                                                  fontSize: deviceWidth! / 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Material(
                                    color: Colors.transparent,
                                    child: ListTile(
                                      onTap: () async {
                                        for (int i = 0;
                                            i < songList.length;
                                            i++) {
                                          if (searchedTracks[index - 3].id ==
                                              songList[i].id) {
                                            if (songListMediaItems[i]
                                                    .duration ==
                                                const Duration(
                                                    milliseconds: 0)) {
                                              corruptedFile(context);
                                            } else {
                                              await playThis(i, "all");
                                            }
                                            break;
                                          }
                                        }
                                      },
                                      onLongPress: () {
                                        for (int i = 0;
                                            i < songList.length;
                                            i++) {
                                          if (searchedTracks[index - 3].id ==
                                              songList[i].id) {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType.size,
                                                alignment: Alignment.center,
                                                duration:
                                                    dialogueAnimationDuration,
                                                reverseDuration:
                                                    dialogueAnimationDuration,
                                                child: OnHold(
                                                    classContext: context,
                                                    listOfSong: songList,
                                                    index: i,
                                                    car: orientedCar,
                                                    heightOfDevice:
                                                        deviceHeight,
                                                    widthOfDevice: deviceWidth,
                                                    songOf: "all"),
                                              ),
                                            );
                                            break;
                                          }
                                        }
                                      },
                                      dense: false,
                                      title: Text(
                                        searchedTracks[index - 3].title,
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
                                          searchedTracks[index - 3].artist,
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
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: MemoryImage(artworksData[
                                                        (musicBox.get(
                                                                "artworksPointer") ??
                                                            {})[searchedTracks[
                                                                index - 3]
                                                            .id]] ??
                                                    defaultNone!),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
