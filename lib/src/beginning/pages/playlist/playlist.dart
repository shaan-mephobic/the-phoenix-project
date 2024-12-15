import 'package:phoenix/src/beginning/pages/playlist/playlist_inside.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/init.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/playlist_back.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:provider/provider.dart';
import 'add_songs.dart';

List? modifyPlayList = [];

class Playlist extends StatefulWidget {
  const Playlist({super.key});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist>
    with AutomaticKeepAliveClientMixin {
  ScrollController? _scrollBarController;

  @override
  void initState() {
    _scrollBarController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (musicBox.get('playlists') == null ||
        musicBox.get("playlists").isEmpty) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(glassShadowOpacity! / 100),
                blurRadius: glassShadowBlur,
                offset: kShadowOffset,
              ),
            ],
            borderRadius: BorderRadius.circular(kRounded),
          ),
          width: deviceWidth! / 1.7,
          height: deviceWidth! / 8,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(kRounded),
            child: BackdropFilter(
              filter: glassBlur,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kRounded),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                  color: glassOpacity,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(kRounded),
                    onTap: () async {
                      playlistSongsSelected(fresh: true);
                      var rootCrossfadeStateDup = rootCrossfadeState;
                      var rootStateDup = rootState;
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiProvider(
                            providers: [
                              ChangeNotifierProvider<Leprovider>(
                                  create: (_) => Leprovider()),
                              ChangeNotifierProvider<MrMan>(
                                create: (_) => MrMan(),
                              ),
                              ChangeNotifierProvider<Seek>(
                                  create: (_) => Seek()),
                              ChangeNotifierProvider<SortProvider>(
                                create: (_) => SortProvider(),
                                builder: (context, child) => const AddSongs(
                                  modify: false,
                                  playlistName: "Enter Playlist Name",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).then((value) {
                        rootCrossfadeState = rootCrossfadeStateDup;
                        rootState = rootStateDup;
                        if (isPlayerShown) {
                          rootState.provideman();
                        }
                      });
                    },
                    child: Center(
                      child: Text(
                        'Create Playlist',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: deviceWidth! / 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.transparent,
          backgroundColor: const Color(0xFF1DB954),
          elevation: 8.0,
          onPressed: () async {
            playListSongsId = [];
            playlistSongsSelected(fresh: true);
            var rootCrossfadeStateDup = rootCrossfadeState;
            var rootStateDup = rootState;
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider<Leprovider>(
                        create: (_) => Leprovider()),
                    ChangeNotifierProvider<MrMan>(
                      create: (_) => MrMan(),
                    ),
                    ChangeNotifierProvider<Seek>(create: (_) => Seek()),
                    ChangeNotifierProvider<SortProvider>(
                      create: (_) => SortProvider(),
                      builder: (context, child) => const AddSongs(
                        modify: false,
                        playlistName: "Enter Playlist Name",
                      ),
                    ),
                  ],
                ),
              ),
            ).then((value) {
              rootCrossfadeState = rootCrossfadeStateDup;
              rootState = rootStateDup;
              if (isPlayerShown) {
                rootState.provideman();
              }
            });
          },
          child: const Icon(Icons.add_rounded, color: Colors.black),
        ),
        body: Scrollbar(
          controller: _scrollBarController,
          child: RefreshIndicator(
            backgroundColor:
                musicBox.get("dynamicArtDB") ?? true ? nowColor : Colors.white,
            color: musicBox.get("dynamicArtDB") ?? true
                ? nowContrast
                : kMaterialBlack,
            onRefresh: () async {
              await fetchAll();
            },
            child: ListView.builder(
              controller: _scrollBarController,
              padding: EdgeInsets.only(top: 5, bottom: isPlayerShown ? 60 : 0),
              addAutomaticKeepAlives: true,
              itemExtent: orientedCar ? deviceWidth! / 1.4 : deviceWidth! / 2,
              physics: musicBox.get("fluidAnimation") ?? true
                  ? const BouncingScrollPhysics()
                  : const ClampingScrollPhysics(),
              itemCount: musicBox.get('playlists').length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: orientedCar ? deviceHeight! / 3 : deviceWidth! / 2,
                  width: orientedCar ? deviceHeight : deviceWidth,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: deviceWidth! / 25),
                      ),
                      Container(
                        width: orientedCar
                            ? deviceHeight! / 1.4
                            : deviceWidth! / 1.05,
                        height: orientedCar
                            ? deviceHeight! / 3.3
                            : deviceWidth! / 2.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(kRounded),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black
                                    .withOpacity(glassShadowOpacity! / 100),
                                blurRadius: glassShadowBlur,
                                offset: kShadowOffset),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kRounded),
                          child: BackdropFilter(
                            filter: glassBlur,
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(kRounded),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.04)),
                                  color: glassOpacity,
                                ),
                                alignment: Alignment.center,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(kRounded),
                                  onTap: () async {
                                    String? playListName = musicBox
                                        .get('playlists')
                                        .keys
                                        .toList()[index];
                                    await fetchPlaylistSongs(playListName);
                                    var rootCrossfadeStateDup =
                                        rootCrossfadeState;
                                    var rootStateDup = rootState;
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MultiProvider(
                                          providers: [
                                            ChangeNotifierProvider<Leprovider>(
                                                create: (_) => Leprovider()),
                                            ChangeNotifierProvider<MrMan>(
                                              create: (_) => MrMan(),
                                            ),
                                            ChangeNotifierProvider<Seek>(
                                                create: (_) => Seek()),
                                            ChangeNotifierProvider<
                                                SortProvider>(
                                              create: (_) => SortProvider(),
                                              builder: (context, child) =>
                                                  PlaylistInside(
                                                playlistName: playListName,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).then((value) {
                                      rootCrossfadeState =
                                          rootCrossfadeStateDup;
                                      rootState = rootStateDup;
                                      if (isPlayerShown) {
                                        rootState.provideman();
                                      }
                                    });
                                  },
                                  onLongPress: () {
                                    String? playListName = musicBox
                                        .get('playlists')
                                        .keys
                                        .toList()[index];
                                    modifyPlayList =
                                        musicBox.get('playlists')[playListName];
                                    playlistSongsSelected(
                                        fresh: false,
                                        playlistName: playListName);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider<Leprovider>(
                                          create: (_) => Leprovider(),
                                          builder: (context, child) => AddSongs(
                                            modify: true,
                                            playlistName: playListName,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Center(
                                    child: Text(
                                      musicBox
                                          .get('playlists')
                                          .keys
                                          .toList()[index],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: deviceWidth! / 20,
                                        fontWeight: FontWeight.w600,
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
                );
              },
            ),
          ),
        ),
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
