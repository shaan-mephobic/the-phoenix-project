import 'dart:io';
import 'package:flutter/material.dart';
import 'package:phoenix/src/Begin/begin.dart';
import 'native/go_native.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

Future<void> ringtoneTrim(
    {@required pathOfFile,
    @required List ranges,
    @required String title,
    @required int fade}) async {
  final String ext = getFileExt(pathOfFile);
  final String inputFile =
      "${applicationFileDirectory.path}/raw$ext".replaceAll(' ', "-");
  final String outputFile =
      "${applicationFileDirectory.path}/$title$ext".replaceAll(" ", "-");
  final String outputFileFade =
      "${applicationFileDirectory.path}/$title-fade$ext".replaceAll(" ", "-");
  final String finalFile =
      "/storage/emulated/0/Music/$title$ext".replaceAll(" ", "-");
  final String start = Duration(milliseconds: ranges[0] ~/ 1).toString();
  final String length = (Duration(milliseconds: ranges[1] ~/ 1) -
          Duration(milliseconds: ranges[0] ~/ 1))
      .toString();
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  // await getSettingPermission();
  await File(pathOfFile).copy("${applicationFileDirectory.path}/raw$ext");
  await _flutterFFmpeg
      .execute("-ss $start -i $inputFile -t $length -c copy $outputFile")
      .then((rc) => print("FFmpeg process 1 exited with rc $rc"));
  if (fade != 0) {
    // afade(fade in) works only in flac files in ffmpeg by default. Doing so
    // will need additional packages. So inorder to keep the app size small
    // I am converting non-flac files to flac to apply crossfade
    try {
      if (ext.contains(".flac")) {
        await _flutterFFmpeg
            .execute(
                '-i $outputFile -af "afade=t=in:st=0:d=$fade" $outputFileFade')
            .then((rc) => print("FFmpeg process 2 exited with rc $rc"));
        await File(outputFileFade).copy(finalFile);
        await broadcastFileChange(finalFile);
        await setRingtone(finalFile);
        await File(outputFileFade).delete();
      } else {
        final String convertFile =
            "${applicationFileDirectory.path}/$title-convert.flac"
                .replaceAll(" ", "-");
        final String convertFileFade =
            "${applicationFileDirectory.path}/$title-fade.flac"
                .replaceAll(" ", "-");
        final String finalConvertFile =
            "/storage/emulated/0/Music/$title.flac".replaceAll(" ", "-");

        await _flutterFFmpeg
            .execute('-i $outputFile -f flac $convertFile')
            .then((rc) => print("FFmpeg process 3 exited with rc $rc"));
        await _flutterFFmpeg
            .execute(
                '-i $convertFile -af "afade=t=in:st=0:d=$fade" $convertFileFade')
            .then((rc) => print("FFmpeg process 2 exited with rc $rc"));
        await File(convertFileFade).copy(finalConvertFile);
        await broadcastFileChange(finalConvertFile);
        await setRingtone(finalConvertFile);
        await File(convertFile).delete();
        await File(convertFileFade).delete();
      }
    } catch (e) {
      await File(outputFile).copy(finalFile);
      await broadcastFileChange(finalFile);
      await setRingtone(finalFile);
      print(e);
    }
  } else {
    await File(outputFile).copy(finalFile);
    await broadcastFileChange(finalFile);
    await setRingtone(finalFile);
  }
  //TODO write settings permission should be called first
  await File(inputFile).delete();
  await File(outputFile).delete();
}

String getFileExt(String file) {
  String trim = file.replaceRange(0, file.length - 5, "");
  if (trim.contains(".")) {
    String ext = trim.replaceRange(0, trim.indexOf("."), "");
    return ext;
  } else {
    throw "No Extension found in $file";
  }
}
