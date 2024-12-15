import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';

List<String> allArtists = [];
Map<String, List<dynamic>> artistData = {};
List<SongModel> inArtistsSongs = [];
List<SongModel>? insideInArtistsSongs = [];
Map artistsAlbums = {};
List<MediaItem> artistMediaItems = [];
int numberOfSongsOfArtist = 0;

// IMPURE artist method. Get all the artists from the albums.
gettinArtists() async {
  allArtists = [];
  artistData = {};
  inArtistsSongs = [];
  insideInArtistsSongs = [];
  artistsAlbums = {};
  List<String> mainList = [];

  for (int i = 0; i < allAlbums.length; i++) {
    mainList.add(allAlbums[i].artist!.toUpperCase());
  }
  var result = mainList.toSet().toList();
  result.sort();
  allArtists = result;

  if (musicBox.get("stopUnknown") ?? false) {
    allArtists.remove("<UNKNOWN>");
  }
}

gettinArtistsAlbums() async {
  for (int a = 0; a < allArtists.length; a++) {
    String artistRN = allArtists[a].toLowerCase();
    List emall = [];
    for (int i = 0; i < allAlbums.length; i++) {
      if (allAlbums[i].artist!.toLowerCase() == artistRN) {
        emall.add(allAlbums[i]);
      }
    }
    artistData[artistRN.toLowerCase()] = emall;
  }
}

artistsAllSongs(String who) async {
  inArtistsSongs = [];
  artistMediaItems = [];

  // look for the artist in the songList, this makes it not follow album order
  for (int i = 0; i < songList.length; i++) {
    if (songList[i].artist!.toLowerCase() == who.toLowerCase()) {
      inArtistsSongs.add(songList[i]);
    }
  }

  // https: //github.com/shaan-mephobic/The-Phoenix-Project/issues/4
  // to sort them in the album order too we try querying from on_audio_query
  // TODO

  int sort = (musicBox.get('artistSort') ?? [0, 3])[0];
  int order = (musicBox.get('artistSort') ?? [0, 3])[1];
  if (sort == 0) {
    //TITLE
    inArtistsSongs
        .sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  } else if (sort == 1) {
    //DATE
    inArtistsSongs
        .sort((a, b) => (a.dateAdded ?? 0).compareTo((b.dateAdded ?? 0)));
  } else {
    //ALBUM
    inArtistsSongs.sort((a, b) =>
        (a.album ?? "").toLowerCase().compareTo((b.album ?? "").toLowerCase()));
  }
  if (order == 4) {
    //DESCENDING
    inArtistsSongs = inArtistsSongs.reversed.toList();
  }

  for (int i = 0; i < inArtistsSongs.length; i++) {
    MediaItem item = MediaItem(
        id: inArtistsSongs[i].data,
        album: inArtistsSongs[i].album,
        artist: inArtistsSongs[i].artist,
        duration: Duration(milliseconds: getDuration(inArtistsSongs[i])!),
        artUri: Uri.file(
          (musicBox.get("artworksPointer") ?? {})[inArtistsSongs[i].id] == null
              ? "${applicationFileDirectory.path}/artworks/null.jpeg"
              : "${applicationFileDirectory.path}/artworks/songarts/${(musicBox.get("artworksPointer") ?? {})[inArtistsSongs[i].id]}.jpeg",
        ),
        title: inArtistsSongs[i].title,
        extras: {"id": inArtistsSongs[i].id});
    artistMediaItems.add(item);
  }
  numberOfSongsOfArtist = inArtistsSongs.length;
}

smartArtistsArts() {
  for (int i = 0; i < allArtists.length; i++) {
    for (int o = 0; o < allAlbums.length; o++) {
      if (allArtists[i] == allAlbums[o].artist.toString().toUpperCase()) {
        List add = artistsAlbums[allArtists[i]] ?? [];
        add.add(allAlbums[o].album);
        artistsAlbums[allArtists[i]] = add;
      }
    }
  }
}
