import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import '../../../utilities/page_backend/file_exporer.dart';

class Directories extends StatefulWidget {
  const Directories({super.key});

  @override
  State<Directories> createState() => _DirectoriesState();
}

class _DirectoriesState extends State<Directories> {
  ScrollController? _scrollBarController;

  @override
  void dispose() {
    saveLocations();
    backArtStateChange = true;
    refresh = true;
    isHome = true;
    super.dispose();
  }

  @override
  void initState() {
    _scrollBarController = ScrollController();
    backArtStateChange = false;
    super.initState();
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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          splashColor: Colors.transparent,
          icon: const Icon(Icons.check_rounded, color: Colors.black),
          label: Text(
            "DONE",
            style: TextStyle(
              color: Colors.black,
              fontSize: deviceWidth! / 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF1DB954),
          elevation: 8.0,
          onPressed: () async {
            saveLocations();
            Navigator.pop(context);
          }),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white70,
        ),
        titleSpacing: 0,
        shadowColor: Colors.transparent,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "PICK YOUR FOLDERS",
          style: TextStyle(
            color: Colors.white,
            fontSize: deviceWidth! / 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 50,
              width: orientedCar ? deviceHeight : deviceWidth,
              child: InkWell(
                onTap: () {},
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.arrow_upward_rounded),
                          color: Colors.white60,
                          splashColor: const Color(0xFF05464f),
                          onPressed: () async {
                            HapticFeedback.lightImpact();
                            if (currentTopDir != topLevelDir &&
                                currentTopDir != externalTopLevelDir) {
                              currentTopDir = previousDir(currentTopDir);
                              await iterationManager(currentTopDir);
                              setState(() {});
                            }
                          }),
                      Container(
                        width: orientedCar
                            ? deviceHeight! / 1.5
                            : deviceWidth! / 1.5,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            currentTopDir.contains(topLevelDir)
                                ? currentTopDir.replaceAll(
                                    topLevelDir, "Internal/")
                                : currentTopDir.contains(
                                        topLevelDir.replaceRange(
                                            topLevelDir.length - 1,
                                            topLevelDir.length,
                                            ""))
                                    ? currentTopDir.replaceAll(
                                        topLevelDir.replaceRange(
                                            topLevelDir.length - 1,
                                            topLevelDir.length,
                                            ""),
                                        "Internal/")
                                    : currentTopDir
                                            .contains(externalTopLevelDir)
                                        ? currentTopDir.replaceAll(
                                            externalTopLevelDir, "External/")
                                        : currentTopDir.contains(
                                                externalTopLevelDir.replaceRange(
                                                    externalTopLevelDir.length -
                                                        1,
                                                    externalTopLevelDir.length,
                                                    ""))
                                            ? currentTopDir.replaceAll(
                                                externalTopLevelDir.replaceRange(
                                                    externalTopLevelDir.length -
                                                        1,
                                                    externalTopLevelDir.length,
                                                    ""),
                                                "External/")
                                            : currentTopDir,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.more_vert_rounded),
                          color: Colors.white60,
                          splashColor: const Color(0xFF05464f),
                          onPressed: () {}),
                    ]),
              ),
            ),
          ),
        ),
      ),
      body: Theme(
        data: themeOfApp,
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Container(
            color: kMaterialBlack,
            padding: const EdgeInsets.only(
                top: kToolbarHeight + kToolbarHeight + 50),
            height: deviceHeight,
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: Scrollbar(
                controller: _scrollBarController,
                child: ListView.builder(
                  controller: _scrollBarController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 5, bottom: 8),
                  addAutomaticKeepAlives: true,
                  physics: musicBox.get("fluidAnimation") ?? true
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics(),
                  itemCount: fileExplorer.length,
                  itemBuilder: (context, index) {
                    return Material(
                      color: Colors.transparent,
                      child: CheckboxListTile(
                        activeColor: kCorrect,
                        checkColor: kMaterialBlack,
                        title: Text(
                          fileExplorer.keys
                                      .toList()[index]
                                      .toString()
                                      .replaceAll(currentTopDir, "") ==
                                  topLevelDir
                              ? "Internal storage"
                              : fileExplorer.keys
                                          .toList()[index]
                                          .toString()
                                          .replaceAll(currentTopDir, "") ==
                                      externalTopLevelDir
                                  ? "External storage"
                                  : fileExplorer.keys
                                      .toList()[index]
                                      .toString()
                                      .replaceAll(currentTopDir, ""),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        secondary: Material(
                          color: Colors.transparent,
                          child: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios_rounded),
                              color: Colors.white,
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                await iterationManager(
                                    fileExplorer.keys.toList()[index]);
                                setState(() {});
                              }),
                        ),
                        value: isTicked(fileExplorer.keys.toList()[index]),
                        onChanged: (newValue) {
                          fileExplorer.values.toList()[index][0] = newValue;
                          if (newValue!) {
                            selectedFolders
                                .add(fileExplorer.keys.toList()[index]);
                          } else {
                            unTick(fileExplorer.keys.toList()[index]);
                          }
                          debugPrint(selectedFolders.toString());
                          setState(() {});
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (externalTopLevelDir == "") {
      if (currentTopDir == topLevelDir ||
          currentTopDir ==
              topLevelDir.replaceRange(
                  topLevelDir.length - 1, topLevelDir.length, "")) {
        Navigator.pop(context);
      } else {
        HapticFeedback.lightImpact();
        currentTopDir = previousDir(currentTopDir);
        await iterationManager(currentTopDir);
        setState(() {});
      }
    } else {
      if (currentTopDir == "...") {
        Navigator.pop(context);
      } else if (currentTopDir == topLevelDir ||
          currentTopDir == externalTopLevelDir ||
          currentTopDir ==
              topLevelDir.replaceRange(
                  topLevelDir.length - 1, topLevelDir.length, "") ||
          currentTopDir ==
              externalTopLevelDir.replaceRange(externalTopLevelDir.length - 1,
                  externalTopLevelDir.length, "")) {
        HapticFeedback.lightImpact();
        currentTopDir = "...";
        isHome = true;
        await iterationManager(currentTopDir);
        setState(() {});
      } else {
        HapticFeedback.lightImpact();
        currentTopDir = previousDir(currentTopDir);
        await iterationManager(currentTopDir);
        setState(() {});
      }
    }
    return false;
  }
}
