import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/init.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/awakening.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utilities/page_backend/albums_back.dart';
import 'albums_inside.dart';

int? passedIndexAlbum;
String? selectedAlbumName;

class Albums extends StatefulWidget {
  const Albums({super.key});

  @override
  State<Albums> createState() => _AlbumsState();
}

class _AlbumsState extends State<Albums> with AutomaticKeepAliveClientMixin {
  ScrollController? _scrollBarController;
  @override
  void initState() {
    _scrollBarController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (ascend) {
      return Scrollbar(
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
          child: GridView.builder(
            controller: _scrollBarController,
            addAutomaticKeepAlives: true,
            physics: musicBox.get("fluidAnimation") ?? true
                ? const BouncingScrollPhysics()
                : const ClampingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 0, top: 0),
            itemCount: allAlbums.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: orientedCar
                    ? (deviceHeight! / 4) /
                        (deviceHeight! / 4 + deviceHeight! / 16)
                    : (deviceWidth! / 3) /
                        (deviceWidth! / 3 + deviceWidth! / 12),
                crossAxisCount: orientedCar ? 4 : 3),
            itemBuilder: (BuildContext context, int index) {
              return Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(kRounded),
                child: InkWell(
                  borderRadius: BorderRadius.circular(kRounded),
                  onTap: () async {
                    passedIndexAlbum = index;
                    if (musicBox.get("colorsOfAlbums") == null
                        ? true
                        : musicBox.get(
                                "colorsOfAlbums")[allAlbums[index].album] ==
                            null) {
                      await albumColor(MemoryImage(
                          albumsArts[allAlbums[index].album] ?? defaultNone!));

                      Map albumColors = musicBox.get("colorsOfAlbums") ?? {};
                      albumColors[allAlbums[index].album] = [
                        dominantAlbum!.value,
                        contrastAlbum!.value
                      ];
                      musicBox.put("colorsOfAlbums", albumColors);
                    } else {
                      dominantAlbum = Color(musicBox
                          .get("colorsOfAlbums")[allAlbums[index].album][0]);
                      contrastAlbum = Color(musicBox
                          .get("colorsOfAlbums")[allAlbums[index].album][1]);
                    }
                    inAlbumSongs = [];
                    albumMediaItems = [];
                    inAlbumSongsArtIndex = [];
                    await albumSongs();
                    var rootCrossfadeStateDup = rootCrossfadeState;
                    var rootStateDup = rootState;
                    await Navigator.push(
                      context,
                      // PageRouteBuilder(
                      //   pageBuilder: (c, a1, a2) => MultiProvider(
                      //     providers: [
                      //       ChangeNotifierProvider<Leprovider>(
                      //           create: (_) => Leprovider()),
                      //       ChangeNotifierProvider<MrMan>(
                      //         create: (_) => MrMan(),
                      //       ),
                      //       ChangeNotifierProvider<Seek>(create: (_) => Seek()),
                      //       ChangeNotifierProvider<SortProvider>(
                      //         create: (_) => SortProvider(),
                      //         builder: (context, child) => const AlbumsInside(),
                      //       ),
                      //     ],
                      //   ),
                      //   transitionsBuilder: (c, anim, a2, child) =>
                      //       FadeTransition(opacity: anim, child: child),
                      //   transitionDuration: const Duration(milliseconds: 200),
                      //   reverseTransitionDuration:
                      //       const Duration(milliseconds: 200),
                      // ),
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
                              builder: (context, child) => const AlbumsInside(),
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
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      PhysicalModel(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(kRounded),
                        elevation: deviceWidth! / 140,
                        child: Container(
                          width: orientedCar
                              ? deviceHeight! / 4 - 17
                              : deviceWidth! / 3 - 17,
                          height: orientedCar
                              ? deviceHeight! / 4 - 17
                              : deviceWidth! / 3 - 17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kRounded),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(
                                albumsArts[allAlbums[index].album] ??
                                    defaultNone!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: orientedCar
                                ? deviceHeight! / 100
                                : deviceWidth! / 70),
                      ),
                      SizedBox(
                        width: orientedCar
                            ? deviceHeight! / 4 - 17
                            : deviceWidth! / 3 - 17,
                        child: Text(
                          allAlbums[index].album.toString().toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: orientedCar
                                ? deviceHeight! / 58
                                : deviceWidth! / 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: musicBox.get("dynamicArtDB") ?? true
                                    ? const Offset(1.0, 1.0)
                                    : const Offset(0, 1.0),
                                blurRadius: 2.0,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return orientedCar
          ? const SingleChildScrollView(child: Awakening())
          : const Awakening();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
