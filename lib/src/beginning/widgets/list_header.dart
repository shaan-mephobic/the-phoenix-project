import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ionicons/ionicons.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:phoenix/src/beginning/begin.dart';
import 'package:phoenix/src/beginning/pages/artists/artists_inside.dart';
import 'package:phoenix/src/beginning/pages/genres/genres.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/albums_back.dart';
import 'package:phoenix/src/beginning/utilities/page_backend/genres_back.dart';
import '../utilities/page_backend/artists_back.dart';
import 'package:phoenix/src/beginning/pages/genres/genres_inside.dart';
import 'package:phoenix/src/beginning/pages/playlist/playlist_inside.dart';
import 'package:phoenix/src/beginning/utilities/audio_handlers/previous_play_skip.dart';

class ListHeader extends StatelessWidget {
  final double? widthOfDevice;
  final List<SongModel>? listOfSong;
  final String rnAccess;
  final List<String> trackSorts = const [
    'Title',
    'Date',
    'Album',
    'Artist',
    'Ascending',
    'Descending'
  ];
  final List<String> artistSorts = const [
    'Title',
    'Date',
    'Album',
    'Ascending',
    'Descending'
  ];
  final stateNotifier;
  final List<String> albumSorts = const [
    "Date",
    "Title",
    'Ascending',
    'Descending'
  ];
  const ListHeader(this.widthOfDevice, this.listOfSong, this.rnAccess,
      {super.key, this.stateNotifier});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: widthOfDevice,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(glassShadowOpacity! / 100 / 1.4),
            blurRadius: glassShadowBlur / 2,
            offset: kShadowOffset,
          ),
        ],
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: glassBlur,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.04)),
              color: glassOpacity,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: rnAccess != "playlist",
                      child: Material(
                        color: Colors.transparent,
                        child: PopupMenuButton<String>(
                            color: Colors.black87,
                            icon: const Icon(
                              Icons.short_text_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kRounded / 2)),
                            onSelected: (String result) async {
                              if (rnAccess == "all") {
                                return tracksSelected(result);
                              } else if (rnAccess == "album") {
                                return await albumsSelected(result);
                              } else if (rnAccess == "artist") {
                                return await artistsSelected(result);
                              } else if (rnAccess == "genre") {
                                return genresSelected(result);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              if (rnAccess == "all") {
                                return tracksBuilder();
                              } else if (rnAccess == "album") {
                                return albumsBuilder();
                              } else if (rnAccess == "artist") {
                                return artistsBuilder();
                              } else if (rnAccess == "genre") {
                                return genresBuilder();
                              } else {
                                return tracksBuilder();
                              }
                            }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "${listOfSong!.length} Tracks",
                        style:
                            const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: TextButton.icon(
                        onPressed: () async {
                          shuffleSelected = true;
                          if (rnAccess == "artist") {
                            insideInArtistsSongs = listOfSong;
                          } else if (rnAccess == "album") {
                            insideInAlbumSongs = listOfSong;
                          } else if (rnAccess == "genre") {
                            insidegenreSongs = listOfSong;
                          } else if (rnAccess == "playlist") {
                            insideplaylistSongsInside = listOfSong;
                          }
                          await playThis(
                              random.nextInt(listOfSong!.length), rnAccess);
                        },
                        icon: const Icon(Ionicons.shuffle_outline,
                            color: Colors.white),
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.white30)),
                        label: const Text(
                          "Shuffle",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () async {
                          if (rnAccess == "artist") {
                            insideInArtistsSongs = listOfSong;
                          } else if (rnAccess == "album") {
                            insideInAlbumSongs = listOfSong;
                          } else if (rnAccess == "genre") {
                            insidegenreSongs = listOfSong;
                          } else if (rnAccess == "playlist") {
                            insideplaylistSongsInside = listOfSong;
                          }
                          await playThis(0, rnAccess);
                        },
                        icon: const Icon(Ionicons.play),
                        color: Colors.white,
                        iconSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  refreshSongs() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Begin.refreshIndicatorKey.currentState?.show();
    });
  }

  tracksBuilder() {
    List<PopupMenuEntry<String>> categories = [];
    for (int i = 0; i < trackSorts.length; i++) {
      if (i == 4) {
        categories.add(const PopupMenuDivider());
      }
      categories.add(
        PopupMenuItem<String>(
          value: trackSorts[i],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trackSorts[i], style: const TextStyle(color: Colors.white)),
              Visibility(
                  visible: (musicBox.get('trackSort') ?? [0, 4]).contains(i),
                  child: Icon(Icons.check, color: kCorrect))
            ],
          ),
        ),
      );
    }
    return categories;
  }

  Future<void> tracksSelected(String result) async {
    switch (result) {
      case 'Title':
        List<int> trackSort = musicBox.get('trackSort') ?? [0, 4];
        if (trackSort[0] != 0) {
          trackSort[0] = 0;
          await musicBox.put('trackSort', trackSort);
          refreshSongs();
        }
        break;
      case 'Date':
        List<int> trackSort = musicBox.get('trackSort') ?? [0, 4];
        if (trackSort[0] != 1) {
          trackSort[0] = 1;
          await musicBox.put('trackSort', trackSort);
          refreshSongs();
        }
        break;
      case 'Album':
        List<int> trackSort = musicBox.get('trackSort') ?? [0, 4];
        if (trackSort[0] != 2) {
          trackSort[0] = 2;
          await musicBox.put('trackSort', trackSort);
          refreshSongs();
        }
        break;
      case 'Artist':
        List<int> trackSort = musicBox.get('trackSort') ?? [0, 4];
        if (trackSort[0] != 3) {
          trackSort[0] = 3;
          await musicBox.put('trackSort', trackSort);
          refreshSongs();
        }
        break;
      case 'Ascending':
        List<int> trackSort = musicBox.get('trackSort') ?? [0, 4];
        if (trackSort[1] != 4) {
          trackSort[1] = 4;
          await musicBox.put('trackSort', trackSort);
          refreshSongs();
        }
        break;
      case 'Descending':
        List<int> trackSort = musicBox.get('trackSort') ?? [0, 4];
        if (trackSort[1] != 5) {
          trackSort[1] = 5;
          await musicBox.put('trackSort', trackSort);
          refreshSongs();
        }
        break;
      default:
    }
  }

  albumsBuilder() {
    List<PopupMenuEntry<String>> categories = [];
    for (int i = 0; i < albumSorts.length; i++) {
      if (i == 2) {
        categories.add(const PopupMenuDivider());
      }
      categories.add(
        PopupMenuItem<String>(
          value: albumSorts[i],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(albumSorts[i], style: const TextStyle(color: Colors.white)),
              Visibility(
                  visible: (musicBox.get('albumSort') ?? [0, 2]).contains(i),
                  child: Icon(Icons.check, color: kCorrect))
            ],
          ),
        ),
      );
    }
    return categories;
  }

  Future<void> albumsSelected(String result) async {
    switch (result) {
      case 'Date':
        List<int> albumSort = musicBox.get('albumSort') ?? [0, 2];
        if (albumSort[0] != 0) {
          albumSort[0] = 0;
          await musicBox.put('albumSort', albumSort);
          inAlbumSongs = [];
          albumMediaItems = [];
          inAlbumSongsArtIndex = [];
          await albumSongs();
          stateNotifier.notify();
        }
        break;
      case 'Title':
        List<int> albumSort = musicBox.get('albumSort') ?? [0, 2];
        if (albumSort[0] != 1) {
          albumSort[0] = 1;
          await musicBox.put('albumSort', albumSort);
          inAlbumSongs = [];
          albumMediaItems = [];
          inAlbumSongsArtIndex = [];
          await albumSongs();
          stateNotifier.notify();
        }
        break;

      case 'Ascending':
        List<int> albumSort = musicBox.get('albumSort') ?? [0, 2];
        if (albumSort[1] != 2) {
          albumSort[1] = 2;
          await musicBox.put('albumSort', albumSort);
          inAlbumSongs = [];
          albumMediaItems = [];
          inAlbumSongsArtIndex = [];
          await albumSongs();
          stateNotifier.notify();
        }
        break;
      case 'Descending':
        List<int> albumSort = musicBox.get('albumSort') ?? [0, 2];
        if (albumSort[1] != 3) {
          albumSort[1] = 3;
          await musicBox.put('albumSort', albumSort);
          inAlbumSongs = [];
          albumMediaItems = [];
          inAlbumSongsArtIndex = [];
          await albumSongs();
          stateNotifier.notify();
        }
        break;
      default:
    }
  }

  artistsBuilder() {
    List<PopupMenuEntry<String>> categories = [];
    for (int i = 0; i < artistSorts.length; i++) {
      if (i == 3) {
        categories.add(const PopupMenuDivider());
      }
      categories.add(
        PopupMenuItem<String>(
          value: artistSorts[i],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(artistSorts[i], style: const TextStyle(color: Colors.white)),
              Visibility(
                  visible: (musicBox.get('artistSort') ?? [0, 3]).contains(i),
                  child: Icon(Icons.check, color: kCorrect))
            ],
          ),
        ),
      );
    }
    return categories;
  }

  Future<void> artistsSelected(String result) async {
    switch (result) {
      case 'Title':
        List<int> artistSort = musicBox.get('artistSort') ?? [0, 3];
        if (artistSort[0] != 0) {
          artistSort[0] = 0;
          await musicBox.put('artistSort', artistSort);
          await artistsAllSongs(allArtists[artistPassed!]);
          stateNotifier.notify();
        }
        break;
      case 'Date':
        List<int> artistSort = musicBox.get('artistSort') ?? [0, 3];
        if (artistSort[0] != 1) {
          artistSort[0] = 1;
          await musicBox.put('artistSort', artistSort);
          await artistsAllSongs(allArtists[artistPassed!]);
          stateNotifier.notify();
        }
        break;
      case 'Album':
        List<int> artistSort = musicBox.get('artistSort') ?? [0, 3];
        if (artistSort[0] != 2) {
          artistSort[0] = 2;
          await musicBox.put('artistSort', artistSort);
          await artistsAllSongs(allArtists[artistPassed!]);
          stateNotifier.notify();
        }
        break;

      case 'Ascending':
        List<int> artistSort = musicBox.get('artistSort') ?? [0, 3];
        if (artistSort[1] != 3) {
          artistSort[1] = 3;
          await musicBox.put('artistSort', artistSort);
          await artistsAllSongs(allArtists[artistPassed!]);
          stateNotifier.notify();
        }
        break;
      case 'Descending':
        List<int> artistSort = musicBox.get('artistSort') ?? [0, 3];
        if (artistSort[1] != 4) {
          artistSort[1] = 4;
          await musicBox.put('artistSort', artistSort);
          await artistsAllSongs(allArtists[artistPassed!]);
          stateNotifier.notify();
        }
        break;
      default:
    }
  }

  genresBuilder() {
    List<PopupMenuEntry<String>> categories = [];
    for (int i = 0; i < trackSorts.length; i++) {
      if (i == 4) {
        categories.add(const PopupMenuDivider());
      }
      categories.add(
        PopupMenuItem<String>(
          value: trackSorts[i],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(trackSorts[i], style: const TextStyle(color: Colors.white)),
              Visibility(
                  visible: (musicBox.get('genreSort') ?? [0, 4]).contains(i),
                  child: Icon(Icons.check, color: kCorrect))
            ],
          ),
        ),
      );
    }
    return categories;
  }

  Future<void> genresSelected(String result) async {
    switch (result) {
      case 'Title':
        List<int> genreSort = musicBox.get('genreSort') ?? [0, 4];
        if (genreSort[0] != 0) {
          genreSort[0] = 0;
          await musicBox.put('genreSort', genreSort);
          await fetchGenreSongs(genreSelected);
          stateNotifier.notify();
        }
        break;
      case 'Date':
        List<int> genreSort = musicBox.get('genreSort') ?? [0, 4];
        if (genreSort[0] != 1) {
          genreSort[0] = 1;
          await musicBox.put('genreSort', genreSort);
          await fetchGenreSongs(genreSelected);
          stateNotifier.notify();
        }
        break;
      case 'Album':
        List<int> genreSort = musicBox.get('genreSort') ?? [0, 4];
        if (genreSort[0] != 2) {
          genreSort[0] = 2;
          await musicBox.put('genreSort', genreSort);
          await fetchGenreSongs(genreSelected);
          stateNotifier.notify();
        }
        break;
      case 'Artist':
        List<int> genreSort = musicBox.get('genreSort') ?? [0, 4];
        if (genreSort[0] != 3) {
          genreSort[0] = 3;
          await musicBox.put('genreSort', genreSort);
          await fetchGenreSongs(genreSelected);
          stateNotifier.notify();
        }
        break;
      case 'Ascending':
        List<int> genreSort = musicBox.get('genreSort') ?? [0, 4];
        if (genreSort[1] != 4) {
          genreSort[1] = 4;
          await musicBox.put('genreSort', genreSort);
          await fetchGenreSongs(genreSelected);
          stateNotifier.notify();
        }
        break;
      case 'Descending':
        List<int> genreSort = musicBox.get('genreSort') ?? [0, 4];
        if (genreSort[1] != 5) {
          genreSort[1] = 5;
          await musicBox.put('genreSort', genreSort);
          await fetchGenreSongs(genreSelected);
          stateNotifier.notify();
        }
        break;
      default:
    }
  }
}
