import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';

import '../page_backend/artists_back.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'dart:async';

List neverDone = [];
bool isIsolated = false;

isolatedArtistScrapeInit() async {
  if (!await Directory("${applicationFileDirectory.path}/artists").exists()) {
    await Directory("${applicationFileDirectory.path}/artists").create();
  }
  Map mapOfArtists = musicBox.get("mapOfArtists") ?? {};
  List insideDB = mapOfArtists.keys.toList();
  neverDone = [];
  for (int i = 0; i < allArtists.length; i++) {
    if (!insideDB.contains(allArtists[i])) {
      neverDone.add(allArtists[i]);
    } else {
      if (!await File(
                  "${applicationFileDirectory.path}/artists/${allArtists[i]}.jpg")
              .exists() &&
          musicBox.get("mapOfArtists")[allArtists[i]] != null &&
          musicBox.get("mapOfArtists")[allArtists[i]].startsWith("https")) {
        debugPrint("not found ${allArtists[i]}");
        var response = await http
            .get(Uri.parse(musicBox.get("mapOfArtists")[allArtists[i]]));
        File file = File(
            "${applicationFileDirectory.path}/artists/${allArtists[i]}.jpg");
        await file.writeAsBytes(response.bodyBytes);
      }
    }
  }
  rootState.provideman();
  if (neverDone.isNotEmpty) {
    debugPrint("isolate##");
    try {
      if (!isIsolated) IsolatedArtistScrape().start();
    } catch (e) {
      debugPrint("weird! IsolatedArtistScape Crashed");
      debugPrint(e.toString());
    }
  }
}

class IsolatedArtistScrape {
  final receivePort = ReceivePort();
  Isolate? _isolate;

  void stop() {
    isIsolated = false;
    if (_isolate != null) {
      receivePort.close();
      _isolate!.kill(priority: Isolate.immediate);
      _isolate = null;
    }
  }

  Future<void> start() async {
    isIsolated = true;
    Map map = {
      "artists": neverDone,
      'port': receivePort.sendPort,
      'directory': applicationFileDirectory.path,
      'kMaterialBlack': kMaterialBlack
    };
    _isolate = await Isolate.spawn(_entryPoint, map);
    receivePort.listen(_handleMessage, onDone: () {
      debugPrint("done!");
    });
  }

  void _handleMessage(dynamic data) async {
    Map mapOfArtists = musicBox.get("mapOfArtists") ?? {};
    mapOfArtists[data[0]] = data[1];
    musicBox.put("mapOfArtists", mapOfArtists);
    // Map colorMap = musicBox.get("colorsOfArtists") ?? {};
    // colorMap[data[0]] = data[2];
    // musicBox.put("colorsOfArtists", colorMap);
    if (data[1] != null && data[1].startsWith("https")) {
      // var response = await http.get(Uri.parse(data[1]));
      // File file =
      //     File("${applicationFileDirectory.path}/artists/${data[0]}.jpg");
      // await file.writeAsBytes(response.bodyBytes);
      // rootState.provideman();
    }
  }

  static void _entryPoint(Map map) async {
    SendPort? port = map['port'];
    List<int> pallete = [];

    // colorPallete(ImageProvider image) async {
    //   print(image);
    //   Color dominantAlbum;
    //   Color contrastAlbum;
    //   PaletteGenerator paletteGenerator;
    //   print("shaanaahssshaif");
    //   paletteGenerator = await PaletteGenerator.fromImageProvider(image);
    //   print("start//end");
    //   dominantAlbum = (paletteGenerator.dominantColor.color);
    //   // print(dominant_album);
    //   if (dominantAlbum.computeLuminance() <= 0.5) {
    //     try {
    //       var pal = paletteGenerator.lightMutedColor.color;
    //       contrastAlbum = pal;
    //     } catch (e) {
    //       contrastAlbum = Colors.white;
    //     }

    //     if (dominantAlbum == contrastAlbum) {
    //       // print("damn! thats rare");
    //       contrastAlbum = paletteGenerator.darkMutedColor.color;
    //     }
    //   } else {
    //     try {
    //       var pal = (paletteGenerator.darkMutedColor.color);
    //       contrastAlbum = pal;
    //     } catch (e) {
    //       contrastAlbum = Colors.black;
    //     }
    //     if (dominantAlbum == contrastAlbum) {
    //       // print("damn! thats rare");
    //       contrastAlbum = paletteGenerator.lightMutedColor.color;
    //     }
    //   }
    //   if ((dominantAlbum.computeLuminance() - contrastAlbum.computeLuminance())
    //           .abs() <
    //       0.2) {
    //     if (dominantAlbum.computeLuminance() < 0.5) {
    //       contrastAlbum = Colors.white;
    //     } else {
    //       contrastAlbum = Colors.black;
    //     }
    //   }

    //   // print(contrast_album);

    //   return [dominantAlbum.value, contrastAlbum.value];
    //   // Map colorDB = musicBox.get("colorsDB") ?? {};
    //   // colorDB[nowMediaItem.id] = [nowColor.value, nowContrast.value];
    //   // musicBox.put("colorsDB", colorDB);
    // }

    scrapeArtist(String artistName) async {
      if (artistName.contains(",")) {
        artistName = artistName.replaceRange(
            artistName.indexOf(","), artistName.length, "");
      }
      if (artistName.contains(" FEAT")) {
        artistName = artistName.replaceRange(
            artistName.indexOf(" FEAT"), artistName.length, "");
      }
      if (artistName.contains(" &")) {
        artistName = artistName.replaceRange(
            artistName.indexOf(" &"), artistName.length, "");
      }
      if (artistName.contains(" FT")) {
        artistName = artistName.replaceRange(
            artistName.indexOf(" FT"), artistName.length, "");
      }
      try {
        var elements = (await http.get(Uri.parse(
                Uri.encodeFull("https://genius.com/artists/$artistName"))))
            .body;
        String short = elements.replaceRange(
            0,
            elements.indexOf(
                '<div class="user_avatar profile_header-avatar clipped_background_image'),
            "");
        short = short.replaceRange(
            0, short.indexOf("background-image: url(") + 23, "");
        String finalLink =
            short.replaceRange(short.indexOf("'"), short.length, "");
        if (finalLink.startsWith("https")) {
          return finalLink;
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
      // }
      // return null;
    }

    for (int i = 0; i < map['artists'].length; i++) {
      pallete = [];
      String? finalLink;
      if (map['artists'][i] == "<UNKNOWN>") {
        finalLink = null;
      } else {
        finalLink = await scrapeArtist(map['artists'][i]);
      }
      if (finalLink != null && finalLink.startsWith("https")) {
        var response = await http.get(Uri.parse(finalLink));
        File file =
            File("${map['directory']}/artists/${map['artists'][i]}.jpg");
        await file.writeAsBytes(response.bodyBytes);
        // try {
        //   pallete = await colorPallete(FileImage(
        //       File("${map['directory']}/artists/${map['artists'][i]}.jpg")));
        // } catch (e) {
        //   print(e);
        //   pallete = [map['kMaterialBlack'].value, Colors.white.value];
        // }
      }
      port!.send([map['artists'][i], finalLink, pallete]);
    }
    IsolatedArtistScrape().stop();
  }
}
