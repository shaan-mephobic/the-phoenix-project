import 'dart:io';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import '../../pages/albums/albums.dart';
import 'package:flutter/foundation.dart';

List<AlbumModel> allAlbums = [];
List<String?> allAlbumsName = [];
Map<String, Uint8List?> albumsArts = {};
List<SongModel> inAlbumSongs = [];
List inAlbumSongsArtIndex = [];
List? insideInAlbumSongs = [];
int? numberOfAlbumArtist;
List<MediaItem> albumMediaItems = [];
Map<int, Uint8List?> artworksData = {};
List<int> allSongIds = [];

//TODO albumModel's album on_audio_query returns null while it is not nullable. See error in the page end which was reported from one device.
gettinAlbums() async {
  allAlbums = [];
  albumsArts = {};
  inAlbumSongs = [];
  inAlbumSongsArtIndex = [];
  insideInAlbumSongs = [];
  allAlbumsName = [];
  List<AlbumModel> albumsIn =
      await OnAudioQuery().queryAlbums(ignoreCase: true);
  List<AlbumModel> albumsInFiltered = [];
  albumsInFiltered.addAll(albumsIn);
  for (int i = 0; i < albumsIn.length; i++) {
    // ignore: unnecessary_null_comparison
    if (albumsIn[i].album == null) {
      albumsInFiltered.remove(albumsIn[i]);
    }
  }
  albumsIn = albumsInFiltered;
  List rmDup = [];
  for (int i = 0; i < albumsIn.length; i++) {
    if (!rmDup.contains(albumsIn[i].album.toUpperCase())) {
      rmDup.add(albumsIn[i].album.toUpperCase());
      if (musicBox.get('customScan') ?? false) {
        if (specificAlbums.contains(albumsIn[i].album.toUpperCase())) {
          allAlbums.add(albumsIn[i]);
          allAlbumsName.add(albumsIn[i].album);
        }
      } else {
        allAlbums.add(albumsIn[i]);
        allAlbumsName.add(albumsIn[i].album);
      }
    }
  }
}

gettinAlbumsArts() async {
  List<String> albumswoArt = [];
  if (!await Directory("${applicationFileDirectory.path}/artworks").exists()) {
    await Directory("${applicationFileDirectory.path}/artworks").create();
  }
  if (!await File("${applicationFileDirectory.path}/artworks/null.jpeg")
      .exists()) {
    ByteData bytes = await rootBundle.load("assets/res/default.jpg");
    Uint8List data = bytes.buffer.asUint8List();
    await File("${applicationFileDirectory.path}/artworks/null.jpeg")
        .writeAsBytes(data);
  }
  for (int i = 0; i < allAlbums.length; i++) {
    if (await File(
            "${applicationFileDirectory.path}/artworks/${allAlbums[i].album.replaceAll(RegExp(r'[^\w\s]+'), '')}.jpeg")
        .exists()) {
      albumsArts[allAlbums[i].album] = await File(
              "${applicationFileDirectory.path}/artworks/${allAlbums[i].album.replaceAll(RegExp(r'[^\w\s]+'), '')}.jpeg")
          .readAsBytes();
    } else {
      albumsArts[allAlbums[i].album] = await OnAudioQuery().queryArtwork(
          allAlbums[i].id, ArtworkType.ALBUM,
          format: ArtworkFormat.JPEG, size: 375);
      if (albumsArts[allAlbums[i].album] != null) {
        await File(
                "${applicationFileDirectory.path}/artworks/${allAlbums[i].album.replaceAll(RegExp(r'[^\w\s]+'), '')}.jpeg")
            .writeAsBytes(albumsArts[allAlbums[i].album]!,
                mode: FileMode.write);
      } else {
        albumswoArt.add(allAlbums[i].album);
      }
    }
  }
  musicBox.put("AlbumsWithoutArt", albumswoArt);
}

albumSongs() async {
  bool sortByDate =
      (musicBox.get('albumSort') ?? [0, 2])[0] == 0 ? true : false;
  bool sortAscending =
      (musicBox.get('albumSort') ?? [0, 2])[1] == 2 ? true : false;
  inAlbumSongs = await OnAudioQuery().queryAudiosFrom(
      AudiosFromType.ALBUM, allAlbums[passedIndexAlbum!].album,
      sortType: sortByDate ? SongSortType.DATE_ADDED : SongSortType.TITLE,
      ignoreCase: true,
      orderType:
          sortAscending ? OrderType.ASC_OR_SMALLER : OrderType.DESC_OR_GREATER);
  for (int i = 0; i < inAlbumSongs.length; i++) {
    MediaItem mi = MediaItem(
        id: inAlbumSongs[i].data,
        album: inAlbumSongs[i].album,
        title: inAlbumSongs[i].title,
        artist: inAlbumSongs[i].artist,
        duration: Duration(milliseconds: getDuration(inAlbumSongs[i])!),
        artUri: Uri.file(
          (musicBox.get("artworksPointer") ?? {})[inAlbumSongs[i].id] == null
              ? "${applicationFileDirectory.path}/artworks/null.jpeg"
              : "${applicationFileDirectory.path}/artworks/songarts/${(musicBox.get("artworksPointer") ?? {})[inAlbumSongs[i].id]}.jpeg",
        ),
        extras: {"id": inAlbumSongs[i].id});
    albumMediaItems.add(mi);
    inAlbumSongsArtIndex.add(i);
  }
}

gettinSongArts() async {
  Map artworksPointer = {};
  List<Uint8List?> allArtworks = [];
  List allSongIds = [];
  List cachedIds = musicBox.get("artworksPointer") == null
      ? []
      : musicBox.get("artworksPointer").keys.toList();
  artworksData = {};
  for (int i = 0; i < songList.length; i++) {
    allSongIds.add(songList[i].id);
  }
  allSongIds.sort();
  cachedIds.sort();
  bool hasNewInCustom(List small, List big) {
    for (int i = 0; i < small.length; i++) {
      if (!big.contains(small[i])) return true;
    }
    return false;
  }

  List nowList = allSongIds;
  if (listEquals(allSongIds, cachedIds) ||
      (((musicBox.get("customScan") ?? false) ||
              (musicBox.get("clutterFree") ?? false)) &&
          !hasNewInCustom(nowList, cachedIds))) {
    List allArtworksName = [];
    if ((musicBox.get("customScan") ?? false) ||
        (musicBox.get("clutterFree") ?? false)) {
      Map pointers = musicBox.get("artworksPointer") ?? {};
      for (int i = 0; i < allSongIds.length; i++) {
        allArtworksName.add(pointers[allSongIds[i]]);
      }
    } else {
      allArtworksName = musicBox.get("artworksName") ?? [];
    }

    debugPrint("allCache");
    allArtworksName.removeWhere((element) => element == null);
    for (int i = 0; i < allArtworksName.length; i++) {
      artworksData[allArtworksName[i]] = await File(
              "${applicationFileDirectory.path}/artworks/songarts/${allArtworksName[i]}.jpeg")
          .readAsBytes();
    }
  } else {
    bool isDuplicate(Uint8List? artwork, int id) {
      List artworkKeys = artworksData.values.toList();
      for (int a = 0; a < artworkKeys.length; a++) {
        if (listEquals(artwork, artworkKeys[a])) {
          artworksPointer[id] = artworksData.keys.toList()[a];
          return true;
        }
      }
      artworksData[id] = artwork;
      artworksPointer[id] = id;
      allArtworks.add(artwork);
      return false;
    }

    if (cachedIds.isEmpty) {
      for (int i = 0; i < allSongIds.length; i++) {
        Uint8List? artwork = await OnAudioQuery()
            .queryArtwork(allSongIds[i], ArtworkType.AUDIO, size: 375);
        if (artwork == null) {
          artworksPointer[allSongIds[i]] = null;
          allArtworks.add(null);
          artworksData[allSongIds[i]] = null;
        } else {
          isDuplicate(artwork, allSongIds[i]);
        }
      }
      if (!await Directory("${applicationFileDirectory.path}/artworks/songarts")
          .exists()) {
        await Directory("${applicationFileDirectory.path}/artworks/songarts")
            .create();
      }
      final List<int> dataKey = artworksData.keys.toList();
      final List<Uint8List?> dataValue = artworksData.values.toList();
      for (int i = 0; i < artworksData.length; i++) {
        if (!(await File(
                    "${applicationFileDirectory.path}/artworks/songarts/${dataKey[i]}.jpeg")
                .exists()) &&
            dataValue[i] != null) {
          await File(
                  "${applicationFileDirectory.path}/artworks/songarts/${dataKey[i]}.jpeg")
              .writeAsBytes(dataValue[i]!);
        }
      }
      List<int> allImageNames = [];
      for (int i = 0; i < artworksData.length; i++) {
        if (dataValue[i] != null) {
          allImageNames.add(dataKey[i]);
        }
      }
      musicBox.put("artworksPointer", artworksPointer);
      musicBox.put("artworksName", allImageNames);
      refresh = true;
    } else {
      debugPrint("dirty-cache");
      artworksPointer = musicBox.get("artworksPointer");
      List newIds =
          allSongIds.where((element) => !cachedIds.contains(element)).toList();
      for (int i = 0; i < newIds.length; i++) {
        refresh = true;
        Uint8List? artwork = await OnAudioQuery()
            .queryArtwork(newIds[i], ArtworkType.AUDIO, size: 375);
        if (artwork == null) {
          artworksPointer[newIds[i]] = null;
          allArtworks.add(null);
          artworksData[newIds[i]] = null;
        } else {
          isDuplicate(artwork, newIds[i]);
        }
      }
      if (!await Directory("${applicationFileDirectory.path}/artworks/songarts")
          .exists()) {
        await Directory("${applicationFileDirectory.path}/artworks/songarts")
            .create();
      }
      final List<int> dataKey = artworksData.keys.toList();
      final List<Uint8List?> dataValue = artworksData.values.toList();
      for (int i = 0; i < artworksData.length; i++) {
        if (!(await File(
                    "${applicationFileDirectory.path}/artworks/songarts/${dataKey[i]}.jpeg")
                .exists()) &&
            dataValue[i] != null) {
          await File(
                  "${applicationFileDirectory.path}/artworks/songarts/${dataKey[i]}.jpeg")
              .writeAsBytes(dataValue[i]!);
        }
      }
      List<int> allImageNames = musicBox.get("artworksName") ?? [];
      for (int i = 0; i < artworksData.length; i++) {
        if (dataValue[i] != null) {
          allImageNames.add(dataKey[i]);
        }
      }
      musicBox.put("artworksPointer", artworksPointer);
      musicBox.put("artworksName", allImageNames);
      for (int i = 0; i < allImageNames.length; i++) {
        artworksData[allImageNames[i]] = await File(
                "${applicationFileDirectory.path}/artworks/songarts/${allImageNames[i]}.jpeg")
            .readAsBytes();
      }
    }
  }
  allSongIds = musicBox.get("artworksName") ?? [];
}

/* 

See previous commit to find the exact line number where the error occured.

An Observatory debugger and profiler on M2101K7AI is available at: http://127.0.0.1:60062/n6oTMscqX6w=/
The Flutter DevTools debugger and profiler on M2101K7AI is available at:
http://127.0.0.1:9100?uri=http://127.0.0.1:60062/n6oTMscqX6w=/
I/Phoenix.projec(20988): ProcessProfilingInfo new_methods=2070 is saved saved_to_disk=1 resolve_classes_delay=8000
E/flutter (20988): [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: type 'Null' is not a subtype of type 'String'
E/flutter (20988): #0      AlbumModel.album (package:on_audio_query_platform_interface/details/models/album_model.dart:14:28)
E/flutter (20988): #1      gettinAlbums (package:phoenix/src/beginning/utilities/page_backend/albums_back.dart:33:37)
E/flutter (20988): <asynchronous suspension>
E/flutter (20988): #2      fetchAll (package:phoenix/src/beginning/utilities/init.dart:101:3)
E/flutter (20988): <asynchronous suspension>
E/flutter (20988): #3      _AllofemState.build.<anonymous closure> (package:phoenix/src/beginning/pages/tracks/tracks.dart:56:11)
E/flutter (20988): <asynchronous suspension>
E/flutter (20988):
*/