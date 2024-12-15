// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// // import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:phoenix/src/beginning/utilities/apis/saavn.dart';
// import 'package:phoenix/src/beginning/utilities/edit_song.dart';
// import 'package:phoenix/src/beginning/utilities/native/go_native.dart';

// class SaavnDownload {
//   ValueNotifier<double> progress = ValueNotifier(0.0);
//   bool download = false;
//   Future<void> downloadSong({
//     required String fileName,
//     required BuildContext context,
//     required Map data,
//   }) async {
//     String? filepath;
//     late String filepath2;
//     String applicationFileDirectory =
//         (await getApplicationDocumentsDirectory()).path;
//     String downloadPath = "/storage/emulated/0/Music/";
//     await Directory(downloadPath).create();
//     String? lyrics;

//     // await Directory(appPath).create();
//     final List<int> bytes = [];
//     final ext = fileName.replaceRange(0, fileName.lastIndexOf("."), "");
//     String file = fileName
//         .replaceRange(fileName.lastIndexOf("."), fileName.length, "")
//         .replaceAll(RegExp(r'[^\w\s]+'), '');
//     int dupNum = 0;
//     while (await File('$applicationFileDirectory$file$ext').exists()) {
//       print("duplliciapjfiojeiofio");
//       print(file);
//       dupNum++;
//       file = '$file$dupNum';
//     }
//     fileName = file + ext;
//     final artname = fileName.replaceAll('.m4a', '.jpg');

//     try {
//       await File('$applicationFileDirectory$fileName')
//           .create(recursive: true)
//           .then((value) => filepath = value.path);
//       // print('created audio file');

//       await File('$applicationFileDirectory$artname')
//           .create(recursive: true)
//           .then((value) => filepath2 = value.path);
//     } catch (e) {
//       // await [
//       //   Permission.manageExternalStorage,
//       // ].request();
//       await File('$applicationFileDirectory$fileName')
//           .create(recursive: true)
//           .then((value) => filepath = value.path);
//       // print('created audio file');
//       await File('$applicationFileDirectory$artname')
//           .create(recursive: true)
//           .then((value) => filepath2 = value.path);
//     }
//     // debugPrint('Audio path $filepath');
//     // debugPrint('Image path $filepath2');
//     String kUrl = data['url'].toString();

//     if (data['url'].toString().contains('google')) {
//       // filename = filename.replaceAll('.m4a', '.opus');

//       kUrl = data['highUrl'].toString();
//       if (kUrl == 'null') {
//         kUrl = data['url'].toString();
//       }
//     } else {
//       kUrl = kUrl.replaceAll(
//         '_96.',
//         "_320.",
//       );
//     }

//     final client = Client();
//     final response = await client.send(Request('GET', Uri.parse(kUrl)));
//     final int total = response.contentLength ?? 0;
//     int recieved = 0;
//     response.stream.asBroadcastStream();
//     // print("already");
//     response.stream.listen((value) async {
//       // print("seems reasonable");
//       bytes.addAll(value);
//       try {
//         recieved += value.length;
//         progress.value = (recieved / total) > 0.9 ? 0.9 : (recieved / total);
//         if (recieved / total == 1.0) {
//           print("SHUT UP!");
//           final file = File(filepath!);
//           await file.writeAsBytes(bytes);
//           final client = HttpClient();
//           final HttpClientRequest request2 =
//               await client.getUrl(Uri.parse(data['image'].toString()));
//           final HttpClientResponse response2 = await request2.close();
//           final bytes2 = await consolidateHttpClientResponseBytes(response2);
//           if (data["has_lyrics"] == "true") {
//             lyrics = await SaavnAPI().fetchLyrics(data["id"]);
//           }
//           final File file2 = File(filepath2);
//           await file2.writeAsBytes(bytes2);
//           // print("toxsi");
//           // print(await File(filepath!).length());
//           try {
//             print(data["artist"]);
//             print(data["album"]);
//             bool editDone = await editSong(
//               context: context,
//               songFile: filepath!,
//               album: data['album'].toString(),
//               genre: data['language'].toString(),
//               year: data['year'].toString(),
//               albumArtist: data['album_artist']?.toString() ??
//                   data['artist']?.toString().split(', ')[0],
//               title: data['title'].toString(),
//               artwork: filepath2,
//               artist: data['artist'].toString(),
//               lyrics: lyrics,
//               downloaded: true
//             );
//             print("Was edit success? $editDone");
//           } catch (e) {
//             print(e);
//           }
//           await File(applicationFileDirectory + fileName)
//               .copy(downloadPath + fileName);
//           await File(applicationFileDirectory + artname).delete();
//           await File(applicationFileDirectory + fileName).delete();

//           await broadcastFileChange(downloadPath + fileName);
//           // await broadcastFileChange(applicationFileDirectory + artname);
//           // await broadcastFileChange(applicationFileDirectory + fileName);
//           // print(await File(filepath!).length());

//           client.close();
//           progress.value = 1;
//         }
//         // notifyListeners();
//         // if (!download) {
//         //   client.close();
//         // }
//       } catch (e) {
//         debugPrint('$e');
//       }
//     });
//     // }).onDone(() async {
//     //   print("SHUT UP!");
//     //   final file = File(filepath!);
//     //   await file.writeAsBytes(bytes);
//     //   final client = HttpClient();
//     //   final HttpClientRequest request2 =
//     //       await client.getUrl(Uri.parse(data['image'].toString()));
//     //   final HttpClientResponse response2 = await request2.close();
//     //   final bytes2 = await consolidateHttpClientResponseBytes(response2);
//     //   if (data["has_lyrics"] == "true") {
//     //     lyrics = await SaavnAPI().fetchLyrics(data["id"]);
//     //   }
//     //   final File file2 = File(filepath2);
//     //   await file2.writeAsBytes(bytes2);
//     //   await editSong(
//     //     context: context,
//     //     songFile: filepath!,
//     //     album: data['album'].toString(),
//     //     genre: data['language'].toString(),
//     //     year: data['year'].toString(),
//     //     albumArtist: data['album_artist']?.toString() ??
//     //         data['artist']?.toString().split(', ')[0],
//     //     title: data['title'].toString(),
//     //     artwork: filepath2,
//     //     artist: data['artist'].toString(),
//     //     lyrics: lyrics,
//     //   );
//     //   await broadcastFileChange(downloadPath + artname);
//     //   await broadcastFileChange(downloadPath + fileName);
//     //   client.close();
//     //   progress.value = 1;
//     // });
//   }
// }
