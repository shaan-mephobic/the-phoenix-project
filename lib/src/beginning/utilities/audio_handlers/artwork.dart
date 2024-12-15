import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_edit/on_audio_edit.dart' as on_audio_edit;
import 'package:palette_generator/palette_generator.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import '../../widgets/artwork_background.dart';

Uint8List? artOfOnline;

playerontap({Uint8List? onlineArtwork}) async {
  if (!playerVisible) playerVisible = true;

  if (rnAccessing == "online") {
    artwork = onlineArtwork;
    artOfOnline = artwork;
  } else {
    artwork = artworksData[(musicBox.get("artworksPointer") ??
            {})[nowMediaItem.extras!["id"]]] ??
        defaultNone!;
  }
  advanceAudioData = null;
  final sw = Stopwatch();
  if (initialart && listEquals(art, art2)) {
    debugPrint("\n\n\n\n\n 1 \n\n\n\n\n");
    first = true;
    art = artwork;
    initialart = false;
    if (backArtStateChange) {
      rootCrossfadeState.provideman();
      if (crossfadeStateChange) {
        globaltaste.provideman();
      }
    }
  } else if (!initialart && first) {
    debugPrint("\n\n\n\n\n 2 \n\n\n\n\n");
    art2 = artwork;
    if (!listEquals(art, art2)) {
      first = false;
    }
    if (backArtStateChange) {
      rootCrossfadeState.provideman();
      if (crossfadeStateChange) {
        globaltaste.provideman();
      }
    }
  } else if (!initialart && !first) {
    debugPrint("\n\n\n\n\n 3 \n\n\n\n\n");
    art = artwork;
    if (!listEquals(art, art2)) {
      first = true;
    }
    if (backArtStateChange) {
      rootCrossfadeState.provideman();
      if (crossfadeStateChange) {
        globaltaste.provideman();
      }
    }
  }
  //TODO REMOVE

  // final decodedImage = img.decodeImage(artwork!);
  // defaultNone = Uint8List.fromList(img.encodePng(img.copyCrop(
  //   decodedImage!,
  //   decodedImage.width ~/ 4,
  //   decodedImage.height ~/ 2,
  //   decodedImage.width ~/ 2,
  //   decodedImage.height ~/ 2,
  // )));
  // sw.start();
  // print("```\nPERFORMO");
  // final decodedImage = img.decodeImage(artwork!);
  // var ip;
  // ip = img.copyRectify(
  //   decodedImage!,
  //   topLeft: img.Point(decodedImage.width / 2 - decodedImage.width / 4,
  //       decodedImage.height / 2),
  //   topRight: img.Point(
  //       decodedImage.width - decodedImage.width / 4, decodedImage.height / 2),
  //   bottomLeft: img.Point(decodedImage.width / 2 - decodedImage.width / 4,
  //       decodedImage.height / 1.01),
  //   bottomRight: img.Point(decodedImage.width - decodedImage.width / 4,
  //       decodedImage.height / 1.01),
  // );
  // defaultNone = Uint8List.fromList(img.encodePng(ip));
  // sw.stop();
  // print("${sw.elapsedMilliseconds}ms perofornnfnin\n```\n");
  sw.reset();
  // print(ip.runtimeType);
  sw.start();
  debugPrint("-------```\nColor Audio");
  if (rnAccessing == "online") {
    await getImagePalette(artwork!);
  } else {
    if (musicBox.get("colorsDB") == null
        ? true
        : musicBox.get("colorsDB")[(musicBox.get("artworksPointer") ??
                {})[nowMediaItem.extras!['id']]] ==
            null) {
      if (artwork == defaultNone) {
        if (musicBox.get("dominantDefault") != null) {
          nowColor = Color(musicBox.get("dominantDefault"));
          nowContrast = Color(musicBox.get("contrastDefault"));
          isArtworkDark = musicBox.get("isArtworkDarkDefault");
        } else {
          await getImagePalette(artwork!);
          musicBox.put("dominantDefault", nowColor.value);
          musicBox.put("contrastDefault", nowContrast.value);
          musicBox.put("isArtworkDarkDefault", isArtworkDark);
        }
      } else {
        await getImagePalette(artwork!);
        Map colorDB = musicBox.get("colorsDB") ?? {};
        colorDB[(musicBox.get("artworksPointer") ??
            {})[nowMediaItem.extras!['id']]] = [
          nowColor.value,
          nowContrast.value,
          isArtworkDark
        ];
        musicBox.put("colorsDB", colorDB);
      }
    } else {
      nowColor = Color(musicBox.get("colorsDB")[
          (musicBox.get("artworksPointer") ??
              {})[nowMediaItem.extras!['id']]][0]);
      nowContrast = Color(musicBox.get("colorsDB")[
          (musicBox.get("artworksPointer") ??
              {})[nowMediaItem.extras!['id']]][1]);
      isArtworkDark = musicBox.get("colorsDB")[
          (musicBox.get("artworksPointer") ??
              {})[nowMediaItem.extras!['id']]][2];
    }
    audioRead();
  }
  sw.stop();
  print("------------${sw.elapsedMilliseconds}ms\n```\n");
  sw.reset();
  if (!isPlayerShown) {
    isPlayerShown = true;
    pc.show();
  }
}

getImagePalette(Uint8List imageProvider) async {
  final sw = Stopwatch();
  // sw.start();
  // print("\t```\nCrop");
  // img.Image decodedImage = img.decodeImage(imageProvider)!;
  // imageProvider = Uint8List.fromList(img.encodePng(img.copyCrop(
  //   decodedImage!,
  //   decodedImage.width ~/ 4,
  //   decodedImage.height ~/ 2,
  //   decodedImage.width ~/ 2,
  //   decodedImage.height ~/ 2,
  // )));
  // defaultNone = imageProvider;
  // final decodedImage = img.decodeImage(artwork!);
  // imageProvider = Uint8List.fromList(img.encodePng(img.copyRectify(
  //   decodedImage!,
  //   topLeft: img.Point(decodedImage.width / 2 - decodedImage.width / 4,
  //       decodedImage.height / 2),
  //   topRight: img.Point(
  //       decodedImage.width - decodedImage.width / 4, decodedImage.height / 2),
  //   bottomLeft: img.Point(decodedImage.width / 2 - decodedImage.width / 4,
  //       decodedImage.height / 1.01),
  //   bottomRight: img.Point(decodedImage.width - decodedImage.width / 4,
  //       decodedImage.height / 1.01),
  // )));
  // sw.stop();
  // print("\t```${sw.elapsedMilliseconds}ms\n```\n\n");
  // sw.reset();
  sw.start();
  debugPrint("\t```\nSWATCH");
  // img.Image decodedImage = img.decodeImage(imageProvider)!;
  // print(decodedImage.width);
  double side = 100;
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(
    MemoryImage(imageProvider),
    size: Size(side, side),
    region:
        Rect.fromPoints(Offset(side / 4, side / 2), Offset(side * 3 / 4, side)),
  );
  nowColor = paletteGenerator.dominantColor!.color;
  double luminance = nowColor.computeLuminance();
  isArtworkDark = luminance < 0.5 ? true : false;
  if (luminance < 0.5) {
    try {
      nowContrast = paletteGenerator.lightMutedColor!.color;
    } catch (e) {
      nowContrast = Colors.white;
    }
    if (nowColor == nowContrast) {
      try {
        nowContrast = paletteGenerator.darkMutedColor!.color;
      } catch (e) {
        nowContrast = Colors.white;
      }
    }
  } else {
    try {
      nowContrast = (paletteGenerator.darkMutedColor!.color);
    } catch (e) {
      nowContrast = Colors.black;
    }

    if (nowColor == nowContrast) {
      try {
        nowContrast = paletteGenerator.lightMutedColor!.color;
      } catch (e) {
        nowContrast = Colors.black;
      }
    }
  }
  if ((luminance - nowContrast.computeLuminance()).abs() < 0.3) {
    if (luminance < 0.5) {
      nowContrast = Colors.white;
    } else {
      nowContrast = Colors.black;
    }
  }
  sw.stop();
  print("\t```${sw.elapsedMilliseconds}ms\n```\n\n");
  sw.reset();

  if (backArtStateChange) {
    if (crossfadeStateChange) {
      globaltaste.provideman();
    }
    rootCrossfadeState.provideman();
  }
}

void audioRead() async {
  //TODO cache this

  // final sw = Stopwatch();
  // sw.start();
  // print("++++++++++++++++```\nRead Audio");
  try {
    advanceAudioData =
        await on_audio_edit.OnAudioEdit().readAudio(nowMediaItem.id);
  } catch (e) {
    advanceAudioData = null;
  }
  // sw.stop();
  // print("++++++++++++++++${sw.elapsedMilliseconds}ms\n```\n");
  // sw.reset();

  if (backArtStateChange) {
    if (crossfadeStateChange) {
      globaltaste.provideman();
    }
    rootCrossfadeState.provideman();
  }
}
