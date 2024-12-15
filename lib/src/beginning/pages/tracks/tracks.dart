import 'package:page_transition/page_transition.dart';
import 'package:phoenix/src/beginning/begin.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/init.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/widgets/dialogues/corrupted_file_dialog.dart';
import 'package:phoenix/src/beginning/widgets/list_header.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:flutter/material.dart';
import '../../widgets/dialogues/on_hold.dart';

class Allofem extends StatefulWidget {
  const Allofem({super.key});

  @override
  State<Allofem> createState() => _AllofemState();
}

class _AllofemState extends State<Allofem>
    with AutomaticKeepAliveClientMixin<Allofem> {
  ScrollController? _scrollBarController;
  @override
  void initState() {
    _scrollBarController = ScrollController();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }

    if (!isPlayerShown) {
      pc.hide();
    }
    return Scrollbar(
      controller: _scrollBarController,
      child: RefreshIndicator(
        key: Begin.refreshIndicatorKey,
        backgroundColor:
            musicBox.get("dynamicArtDB") ?? true ? nowColor : Colors.white,
        color:
            musicBox.get("dynamicArtDB") ?? true ? nowContrast : kMaterialBlack,
        onRefresh: () async {
          await fetchAll();
        },
        child: ListView.builder(
          controller: _scrollBarController,
          padding: const EdgeInsets.only(top: 3, bottom: 8),
          addAutomaticKeepAlives: true,
          physics: musicBox.get("fluidAnimation") ?? true
              ? const BouncingScrollPhysics()
              : const ClampingScrollPhysics(),
          itemCount: songList.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return ListHeader(deviceWidth, songList, "all");
            }
            return Material(
              color: Colors.transparent,
              child: ListTile(
                onTap: () async {
                  if (!Begin.isLoading) {
                    if (songListMediaItems[index - 1].duration ==
                        const Duration(milliseconds: 0)) {
                      corruptedFile(context);
                    } else {
                      await playThis(index - 1, "all");
                    }
                  }
                },
                onLongPress: () async {
                  if (!Begin.isLoading) {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.size,
                        alignment: Alignment.center,
                        duration: dialogueAnimationDuration,
                        reverseDuration: dialogueAnimationDuration,
                        child: OnHold(
                            classContext: context,
                            listOfSong: songList,
                            index: index - 1,
                            car: orientedCar,
                            heightOfDevice: deviceHeight,
                            widthOfDevice: deviceWidth,
                            songOf: "all"),
                      ),
                    );
                  }
                },
                title: Text(
                  songList[index - 1].title,
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
                    songList[index - 1].artist ?? "<unknown>",
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
                    constraints: musicBox.get("squareArt") ?? true
                        ? kSqrConstraint
                        : kRectConstraint,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(artworksData[
                                  (musicBox.get("artworksPointer") ??
                                      {})[songList[index - 1].id]] ??
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
    );
  }
}
