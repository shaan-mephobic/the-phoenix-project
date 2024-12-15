import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phoenix/src/beginning/utilities/file_handlers.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/native/go_native.dart';
import 'package:screenshot/screenshot.dart';
import 'filters.dart';

screenShotUI(save) async {
  ScreenshotController screenshotController = ScreenshotController();
  await screenshotController
      .captureFromWidget(
    SizedBox(
      height: deviceHeight! / 1.3,
      width: deviceWidth! / 1.3,
      child: Stack(
        children: [
          SizedBox(
            height: deviceHeight! / 1.3,
            width: deviceWidth! / 1.3,
            child: Image.memory(
              first ? art ?? defaultNone! : art2 ?? defaultNone!,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: deviceHeight! / 1.3,
            width: deviceWidth! / 1.3,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.2),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: deviceWidth! / 12, right: deviceWidth! / 12),
                    child: Center(
                      child: Text(
                        aestheticText(nowMediaItem.title),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w100,
                            color: Colors.white,
                            fontSize: deviceWidth! / 12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  )
      .then(
    (capturedImage) async {
      if (!save) {
        Directory appDocDir = (await getExternalStorageDirectory())!;
        String appDocPath = appDocDir.path;
        if (File("$appDocPath/legendary-er.png").existsSync()) {
          File("$appDocPath/legendary-er.png").delete();
        }
        final pathOfImage = await File('$appDocPath/legendary-er.png').create();
        final Uint8List bytes = capturedImage.buffer.asUint8List();
        await pathOfImage.writeAsBytes(bytes);
      } else {
        final pathOfImage =
            '${applicationFileDirectory.path}/${aestheticText(nowMediaItem.title)}.png';
        final Uint8List bytes = capturedImage.buffer.asUint8List();
        final String finalPath = await duplicateFile(
            "/storage/emulated/0/Download/${aestheticText(nowMediaItem.title)}.png"
                .replaceAll(" ", "-"));
        await File(pathOfImage).writeAsBytes(bytes);
        await File(pathOfImage).copy(finalPath);
        await broadcastFileChange(finalPath);
        await File(pathOfImage).delete();
      }
    },
  );
}

class WallpaperArt extends StatelessWidget {
  const WallpaperArt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight,
      width: deviceWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: MemoryImage(first ? art! : art2!),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.2),
            child: Center(
                child: Text(
              aestheticText(nowMediaItem.title),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Raleway",
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
                  fontSize: deviceWidth! / 10),
            )),
          ),
        ),
      ),
    );
  }
}
