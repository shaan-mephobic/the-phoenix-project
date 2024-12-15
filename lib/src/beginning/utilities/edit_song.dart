import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:metadata_god/metadata_god.dart' as god;
// import 'package:metadata_god/bridge_generated.dart' as god;
import 'package:mime/mime.dart';
import 'package:on_audio_edit/on_audio_edit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/native/go_native.dart';

Future<bool> editSong({
  BuildContext? context,
  required String songFile,
  String? title,
  String? album,
  String? artist,
  String? albumArtist,
  String? artwork,
  String? year,
  String? lyrics,
  String? genre,
}) async {
  if (androidSdkVersion <= 29) {
    // no scoped storage - on_audio_edit(Lucas)
    try {
      Map<TagType, dynamic> tags = {
        TagType.TITLE: title,
        TagType.ARTIST: artist,
        TagType.GENRE: genre,
        TagType.ALBUM: album,
      };
      bool song = await OnAudioEdit()
          .editAudio(songFile, tags, searchInsideFolders: true);
      return song;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  } else {
    // copying the file to app Dir and editing using Metadata God for API >= Scoped Storage
    String applicationFileDirectory =
        "${(await getApplicationDocumentsDirectory()).path}/";
    await File(songFile)
        .copy(applicationFileDirectory + songFile.split("/").last);

    int songLength = await File(songFile).length();

    late Uint8List artworkBytes;
    if (artwork != null) {
      artworkBytes = await File(artwork).readAsBytes();
    }
    // Set metadata to file
    try {
      // MetadataGod.
      await god.MetadataGod.writeMetadata(
        file: applicationFileDirectory + songFile.split("/").last,
        metadata: god.Metadata(
          title: title,
          artist: artist,
          album: album,
          durationMs: 2048000,
          genre: genre,
          year: int.parse(year ?? "2020"),
          albumArtist: albumArtist,
          fileSize: BigInt.from(songLength),
          picture: artwork == null
              ? null
              : god.Picture(
                  data: artworkBytes,
                  mimeType: lookupMimeType(artwork)!,
                ),
        ),
      );

      Uri? uri = await MediaStore().getUriFromFilePath(path: songFile);
      if (uri != null) {
        bool status = await MediaStore().editFile(
            uriString: uri.toString(),
            tempFilePath: applicationFileDirectory + songFile.split("/").last);
        debugPrint(status.toString());
      }
      await broadcastFileChange(songFile);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

// Future<bool> editSongDownloaded({
//   BuildContext? context,
//   required String songFile,
//   String? title,
//   String? album,
//   String? artist,
//   String? albumArtist,
//   String? artwork,
//   String? year,
//   String? lyrics,
//   String? genre,
// }) async {
//   Map<TagType, dynamic> tags = {
//     TagType.TITLE: title,
//     TagType.ARTIST: artist,
//     TagType.GENRE: genre,
//     TagType.ALBUM: album,
//     TagType.YEAR: year,
//     TagType.ALBUM_ARTIST: albumArtist,
//     TagType.LYRICS: lyrics,
//   };

//   bool song =
//       await OnAudioEdit().editAudio(songFile, tags, searchInsideFolders: true);
//   if (artwork != null) {
//     print(artwork);
//     await OnAudioEdit().editArtwork(songFile,
//         openFilePicker: false,
//         searchInsideFolders: true,
//         imagePath: artwork,
//         format: ArtworkFormat.JPEG);
//   }
//   await broadcastFileChange(songFile);
//   return song;
// }
  // String applicationFileDirectory =
  //     "${(await getApplicationDocumentsDirectory()).path}/";
  // hasPermission = true;
  // if (!hasPermission) {
  //   await File(songFile)
  //       .copy(applicationFileDirectory + songFile.split("/").last);
  //   print('Copied');
  //   print(applicationFileDirectory + songFile.split("/").last);
  //   print(await File(applicationFileDirectory + songFile.split("/").last)
  //       .exists());
  //   print(await File(applicationFileDirectory + songFile.split("/").last)
  //       .length());
  // }
  // Map<TagType, dynamic> tags = {
  //   TagType.TITLE: title,
  //   TagType.ARTIST: artist,
  //   TagType.GENRE: genre,
  //   TagType.ALBUM: album,
  //   TagType.YEAR: year,
  //   TagType.ALBUM_ARTIST: albumArtist,
  //   TagType.LYRICS: lyrics,
  // };
  // await getComplexPermission(songFile);

  ////////////////////////////////on_audio_edit//////////////////////////////////
  // bool song =
  //     await OnAudioEdit().editAudio(songFile, tags, searchInsideFolders: true);
  // if (artwork != null) {
  //   print(artwork);
  //   await OnAudioEdit().editArtwork(songFile,
  //       openFilePicker: false,
  //       searchInsideFolders: true,
  //       imagePath: artwork,
  //       format: ArtworkFormat.JPEG);
  // }
  // return song;
  /////////////////////////////////////////////////////////////////////////////////

  ///////////////////////////////metadata_god//////////////////////////////////////
  // Get metadata from file
  // print("metadata god");
  // try {
    // final stopwatch = Stopwatch();
    // stopwatch.start();
    // god.Metadata? metadata = await god.MetadataGod.getMetadata(songFile);
    // stopwatch.stop();
    // print(metadata);
    // print("Metadata GOD: ${stopwatch.elapsed.inMilliseconds}ms "); //43ms
    // stopwatch.reset();

    // int songLength = await File(songFile).length();
    // print("pre");
    // print(
    //     "is writable ${await mediaStorePlugin.isFileWritable(uriString: songFile)}");
    // print(
    //     "is deletable ${await mediaStorePlugin.isFileDeletable(uriString: songFile)}");
    // print(
    //     "is writable ${await mediaStorePlugin.isFileWritable(uriString: applicationFileDirectory + songFile.split("/").last)}");
    // print(
    //     "is deletable ${await mediaStorePlugin.isFileDeletable(uriString: applicationFileDirectory + songFile.split("/").last)}");
    // // DocumentTree? doc =
    //     await mediaStorePlugin.getDocumentTree(uriString: songFile);
    // print(doc == null ? doc : doc.childrenUriList);
    // print(doc == null ? doc : doc.uriString);
//     if (artwork != null) {
//       Uint8List artworkBytes = await File(artwork).readAsBytes();
// // Set metadata to file
//       try {
//         await MetadataGod.writeMetadata(
//           file: hasPermission
//               ? songFile
//               : applicationFileDirectory + songFile.split("/").last,
//           metadata: Metadata(
//             title: title,
//             artist: artist,
//             album: album,
//             genre: genre,
//             year: int.parse(year ?? "2020"),
//             albumArtist: albumArtist,
//             // durationMs: 248000,
//             fileSize: songLength,
//             picture: Picture(
//               data: artworkBytes,
//               mimeType: lookupMimeType(artwork)!,
//             ),
//           ),
//         );
//       } catch (e) {
//         print("Booom");
//         print(e);
//       }
//     } else {
//       try {
//         await MetadataGod.writeMetadata(
//             file: hasPermission
//                 ? songFile
//                 : applicationFileDirectory + songFile.split("/").last,
//             metadata: Metadata(
//               title: title,
//               artist: artist,
//               album: album,
//               genre: genre,
//               year: int.parse(year ?? "2020"),
//               albumArtist: albumArtist,
//               // durationMs: 248000,
//               fileSize: songLength,
//             ));
//       } catch (e) {
//         print("Booom");
//         print(e);
//       }
//     }
    // print("IUNINININI");
    // try {
    //   // print("awa");
    //   Uri? contentURIMain =
    //       await mediaStorePlugin.getUriFromFilePath(path: songFile);
    //   print(contentURIMain);
    //   print(contentURIMain.toString());
    //   // await mediaStorePlugin.requestForAccess(
    //   //     initialRelativePath: songFile.replaceRange(
    //   //         songFile.lastIndexOf("/"), songFile.length, "/"));
    //   // bool status = await mediaStorePlugin.editFile(
    //   //     uriString: contentURIMain!.path,
    //   //     tempFilePath: applicationFileDirectory + songFile.split("/").last);
    //   // print(status);
    // } catch (e) {
    //   print("Sooo close to everything");
    //   print(e);
    // }
    // print('post');
  //   await broadcastFileChange(songFile);
  //   return true;
  // }
  // catch(FrbAnyhowException e){}
//   catch (e) {
//     //TODO it was a FrbAnyhowException, prolly raised due to Flac editing.
//     // await OnAudioEdit().resetComplexPermission();
//     print(e);
//     Map<TagType, dynamic> tags = {
//       TagType.TITLE: title,
//       TagType.ARTIST: artist,
//       TagType.GENRE: genre,
//       TagType.ALBUM: album,
//       TagType.YEAR: year,
//       TagType.ALBUM_ARTIST: albumArtist,
//     };
//     bool song = await OnAudioEdit()
//         .editAudio(songFile, tags, searchInsideFolders: true);
//     if (artwork != null) {
//       print(artwork);
//       await OnAudioEdit().editArtwork(songFile,
//           openFilePicker: false,
//           searchInsideFolders: true,
//           imagePath: artwork,
//           format: ArtworkFormat.JPEG);
//     }
//     return song;
//   }
// }

/// get complex permission
// Future<void> getComplexPermission(String song) async {
//   final String? permissionPath = await OnAudioEdit().getUri();
//   debugPrint(permissionPath);
//   debugPrint(await OnAudioEdit().getUri(originalPath: true));
//   if (!song.contains(
//       permissionPath == null ? "" : permissionPath.replaceAll("%20", " "))) {
//     await OnAudioEdit().resetComplexPermission();
//     await OnAudioEdit().requestComplexPermission(
//         permissionPath:
//             song.replaceRange(song.lastIndexOf("/"), song.length, ""));
//     await getComplexPermission(song);
//   }
// }

/// get complex permission for song downloading path
// Future<void> getPhoenixComplexPermission() async {
//   final String? permissionPath = await OnAudioEdit().getUri();
//   debugPrint(permissionPath);
//   debugPrint(await OnAudioEdit().getUri(originalPath: true));
//   String phoenixDownloadPath = "/storage/emulated/0/Music/Phoenix";
//   if (permissionPath == null || phoenixDownloadPath.contains(permissionPath)) {
//     await OnAudioEdit().resetComplexPermission();
//     await OnAudioEdit()
//         .requestComplexPermission(permissionPath: phoenixDownloadPath);
//     await getPhoenixComplexPermission();
//   }
// }
