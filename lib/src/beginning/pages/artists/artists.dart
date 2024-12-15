import 'dart:io';
import 'package:phoenix/src/beginning/pages/albums/albums_inside.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/init.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/artist_collage.dart';
import 'package:provider/provider.dart';
import '../../utilities/page_backend/artists_back.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/awakening.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'artists_inside.dart';

class Artists extends StatefulWidget {
  const Artists({super.key});

  @override
  State<Artists> createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> with AutomaticKeepAliveClientMixin {
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
            itemCount: allArtists.length,
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
                    artistPassed = index;
                    await artistsAllSongs(allArtists[index]);
                    if (musicBox.get("mapOfArtists") != null &&
                        musicBox.get("mapOfArtists")[allArtists[index]] !=
                            null) {
                      if (musicBox.get("colorsOfArtists") == null
                          ? true
                          : musicBox
                                  .get("colorsOfArtists")[allArtists[index]] ==
                              null) {
                        try {
                          await albumColor(FileImage(File(
                              "${applicationFileDirectory.path}/artists/${allArtists[index]}.jpg")));
                          Map colorMap = musicBox.get("colorsOfArtists") ?? {};
                          colorMap[allArtists[index]] = [
                            dominantAlbum!.value,
                            contrastAlbum!.value
                          ];
                          musicBox.put("colorsOfArtists", colorMap);
                        } catch (e) {
                          contrastAlbum = Colors.white;
                          dominantAlbum = kMaterialBlack;
                        }
                      } else {
                        dominantAlbum = Color(musicBox
                            .get("colorsOfArtists")[allArtists[index]][0]);
                        contrastAlbum = Color(musicBox
                            .get("colorsOfArtists")[allArtists[index]][1]);
                      }
                    } else {
                      contrastAlbum = Colors.white;
                      dominantAlbum = kMaterialBlack;
                    }
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
                              builder: (context, child) =>
                                  const ArtistsInside(),
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
                        child: SizedBox(
                            width: orientedCar
                                ? deviceHeight! / 4 - 17
                                : deviceWidth! / 3 - 17,
                            height: orientedCar
                                ? deviceHeight! / 4 - 17
                                : deviceWidth! / 3 - 17,
                            child: artistCollage(
                              index,
                              allArtists,
                              kRounded,
                              orientedCar
                                  ? deviceHeight! / 4 - 17
                                  : deviceWidth! / 3 - 17,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: orientedCar
                                ? deviceHeight! / 100
                                : deviceWidth! / 70),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 9, right: 9),
                        child: Text(
                          allArtists[index].contains(",")
                              ? allArtists[index]
                                      .replaceRange(
                                          allArtists[index].indexOf(","),
                                          allArtists[index].length,
                                          "")
                                      .contains(" FEAT")
                                  ? allArtists[index]
                                      .replaceRange(
                                          allArtists[index].indexOf(","),
                                          allArtists[index].length,
                                          "")
                                      .replaceRange(
                                          allArtists[index].indexOf("FEAT"),
                                          allArtists[index]
                                              .replaceRange(
                                                  allArtists[index]
                                                      .indexOf(","),
                                                  allArtists[index].length,
                                                  "")
                                              .length,
                                          "")
                                  : allArtists[index].replaceRange(
                                      allArtists[index].indexOf(","),
                                      allArtists[index].length,
                                      "")
                              : allArtists[index].contains(" FEAT")
                                  ? allArtists[index].replaceRange(
                                      allArtists[index].indexOf(" FEAT"),
                                      allArtists[index].length,
                                      "")
                                  : allArtists[index],
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: orientedCar
                                ? deviceHeight! / 58
                                : deviceWidth! / 32,
                            fontWeight: FontWeight.w600,
                            color: musicBox.get("dynamicArtDB") ?? true
                                ? Colors.white
                                : Colors.white,
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
