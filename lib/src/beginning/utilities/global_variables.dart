import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_edit/on_audio_edit.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/background.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

double? deviceWidth;
double? deviceHeight;
bool orientedCar = false;
Uint8List? art;
Uint8List? art2 = art;
Uint8List? defaultArt;
Uint8List? defaultNone;
Uint8List? artwork;
Color nowColor = const Color(0xFF13272f);
Color nowContrast = const Color(0xFFdbdbdc);
AudioModel? advanceAudioData;
Random random = Random();
bool refresh = false;
bool permissionGiven = false;
late var musicBox;
bool crossfadeStateChange = false;
bool phoenixVisualizerShown = true;
bool playerVisible = false;
bool initialart = true;
bool first = false;
List<SongModel> songList = [];
List specificAlbums = [];
List<MediaItem> songListMediaItems = [];
MediaItem nowMediaItem = const MediaItem(
    title: "",
    id: "",
    album: "",
    artist: "",
    duration: Duration(seconds: 69),
    extras: {"id": 69420});
List<MediaItem> nowQueue = [];
late int indexOfList;
late AudioPlayerTask audioHandler;
late int androidSdkVersion;
bool backArtStateChange = true;
PanelController pc = PanelController();
late Directory applicationFileDirectory;
late var rootCrossfadeState;
late var rootState;
late var globalBigNow;
late AnimationController animatedPlayPause;
bool swapController = false;
bool bgPhoenixVisualizer = false;
bool ascend = false;
bool isPlayerShown = false;
late ImageFilter glassBlur;
Color? glassOpacity;
double? glassShadowOpacity;
Duration dialogueAnimationDuration = const Duration(milliseconds: 200);
bool? isArtworkDark = true;
bool onLyrics = false;
bool isFlashin = false;
bool loopSelected = false;
double defaultSensitivity = 50.0;
bool shuffleSelected = false;
BorderRadius radiusFullscreen = BorderRadius.only(
  topLeft: Radius.circular(deviceWidth! / 40),
  topRight: Radius.circular(deviceWidth! / 40),
);
final equalizer = AndroidEqualizer();
