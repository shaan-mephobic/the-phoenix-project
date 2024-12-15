import 'package:audio_service/audio_service.dart';
import 'package:phoenix/src/beginning/pages/genres/genres_inside.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/init.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/awakening.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:provider/provider.dart';
import '../../utilities/page_backend/genres_back.dart';

late int genreSelected;
List<SongModel>? genreSongs;
List<MediaItem> genreMediaItems = [];

class Genres extends StatefulWidget {
  const Genres({super.key});

  @override
  State<Genres> createState() => _GenresState();
}

class _GenresState extends State<Genres> with AutomaticKeepAliveClientMixin {
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
          child: ListView.builder(
            controller: _scrollBarController,
            padding: const EdgeInsets.only(top: 5, bottom: 8),
            addAutomaticKeepAlives: true,
            itemExtent: orientedCar ? deviceWidth! / 1.4 : deviceWidth! / 2,
            physics: musicBox.get("fluidAnimation") ?? true
                ? const BouncingScrollPhysics()
                : const ClampingScrollPhysics(),
            itemCount: musicBox.get('customScan') ?? false
                ? insideAllGenreData.length
                : allgenres.length,
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
                            offset: kShadowOffset,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(kRounded),
                        child: BackdropFilter(
                          filter: glassBlur,
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(kRounded),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kRounded),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.04)),
                                color: glassOpacity,
                              ),
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () async {
                                  genreSelected = index;
                                  await fetchGenreSongs(index);
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
                                          ChangeNotifierProvider<SortProvider>(
                                            create: (_) => SortProvider(),
                                            builder: (context, child) =>
                                                const GenresInside(),
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
                                    musicBox.get('customScan') ?? false
                                        ? insideAllGenreData.keys
                                            .toList()[index]
                                        : allgenres[index].genre,
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
      );
    }
    {
      return orientedCar
          ? const SingleChildScrollView(child: Awakening())
          : const Awakening();
    }
  }

  @override
  bool get wantKeepAlive => true;
}
