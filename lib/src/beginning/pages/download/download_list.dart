// import 'dart:async';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:phoenix/src/beginning/utilities/apis/saavn.dart';
// import 'package:phoenix/src/beginning/utilities/constants.dart';
// import 'package:phoenix/src/beginning/utilities/download/download_music.dart';
// import 'package:phoenix/src/beginning/utilities/global_variables.dart';
// import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
// import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
// import 'package:provider/provider.dart';
// // import 'package:spotify_metadata/spotify_metadata.dart';

// class DownloadList extends StatefulWidget {
//   final String downloadInput;
//   const DownloadList({super.key, required this.downloadInput});

//   @override
//   State<DownloadList> createState() => _DownloadListState();
// }

// class _DownloadListState extends State<DownloadList> {
//   bool isLoading = true;
//   ScrollController? _scrollBarController;
//   List searchResults = [];
//   List<SaavnDownload?> saavnDownloadObj = [];
//   late List<Uint8List?> onlineArtworks;

//   @override
//   void initState() {
//     crossfadeStateChange = true;
//     // getPhoenixComplexPermission();
//     getAPISongs();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     crossfadeStateChange = false;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: FloatingActionButton.extended(
//         splashColor: Colors.transparent,
//         icon: const Icon(Icons.downloading_rounded, color: Colors.black),
//         label: Text("Download All",
//             style: TextStyle(
//                 color: Colors.black,
//                 fontSize: deviceWidth! / 25,
//                 fontWeight: FontWeight.w600)),
//         backgroundColor: const Color(0xFF1DB954),
//         elevation: 8.0,
//         onPressed: () async {
//           for (int i = 0; i < searchResults.length; i++) {
//             if (saavnDownloadObj[i] == null) {
//               download(i);
//             }
//           }
//         },
//       ),
//       extendBodyBehindAppBar: true,
//       body: Consumer<Leprovider>(
//         builder: (context, taste, _) {
//           print("state");
//           globaltaste = taste;
//           return Theme(
//             data: themeOfApp,
//             child: Stack(
//               children: [
//                 BackArt(),
//                 AppBar(
//                   elevation: 0,
//                   shadowColor: Colors.transparent,
//                   centerTitle: true,
//                   backgroundColor: Colors.transparent,
//                   title: Text(
//                     "Online",
//                     style: TextStyle(
//                       fontSize: deviceWidth! / 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: deviceWidth! / 4.3),
//                   child: MediaQuery.removePadding(
//                     context: context,
//                     removeTop: true,
//                     child: Scrollbar(
//                       controller: _scrollBarController,
//                       child: !isLoading
//                           ? ListView.builder(
//                               controller: _scrollBarController,
//                               padding:
//                                   const EdgeInsets.only(top: 5, bottom: 100),
//                               physics: musicBox.get("fluidAnimation") ?? true
//                                   ? const BouncingScrollPhysics()
//                                   : const ClampingScrollPhysics(),
//                               itemCount: searchResults.length,
//                               itemBuilder: (context, index) {
//                                 // if (index == 0) {
//                                 //   return ListHeader(
//                                 //     deviceWidth,
//                                 //     genreSongs,
//                                 //     "genre",
//                                 //     stateNotifier: provider,
//                                 //   );
//                                 // }
//                                 return Material(
//                                   color: Colors.transparent,
//                                   child: ListTile(
//                                     onTap: () async {
//                                       if (saavnDownloadObj[index] == null) {
//                                         download(index);
//                                       }
//                                       // print(searchResults[index]);
//                                       // artOfOnline = onlineArtworks[index];
//                                       // playThis(
//                                       //   0,
//                                       //   "online",
//                                       //   saavnData: searchResults[index],
//                                       // );
//                                     },
//                                     onLongPress: () async {
//                                       if (saavnDownloadObj[index] == null) {
//                                         download(index);
//                                       }
//                                     },
//                                     dense: false,
//                                     title: Text(
//                                       searchResults[index]['title'],
//                                       maxLines: 2,
//                                       style: const TextStyle(
//                                         color: Colors.white70,
//                                         shadows: [
//                                           Shadow(
//                                             offset: Offset(0, 1.0),
//                                             blurRadius: 2.0,
//                                             color: Colors.black45,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     tileColor: Colors.transparent,
//                                     subtitle: Opacity(
//                                       opacity: 0.5,
//                                       child: Text(
//                                         searchResults[index]['artist'],
//                                         maxLines: 1,
//                                         style: const TextStyle(
//                                           color: Colors.white70,
//                                           shadows: [
//                                             Shadow(
//                                               offset: Offset(0, 1.0),
//                                               blurRadius: 1.0,
//                                               color: Colors.black38,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     trailing: saavnDownloadObj[index] == null
//                                         ? Icon(
//                                             Icons.file_download,
//                                             color: nowContrast,
//                                           )
//                                         : ValueListenableBuilder<double>(
//                                             valueListenable:
//                                                 saavnDownloadObj[index]!
//                                                     .progress,
//                                             builder: (context, value, _) {
//                                               return value == 0
//                                                   ? SizedBox(
//                                                       width: 25,
//                                                       height: 25,
//                                                       child:
//                                                           CircularProgressIndicator(
//                                                         color: nowContrast,
//                                                         strokeWidth: 3,
//                                                         backgroundColor:
//                                                             Colors.transparent,
//                                                       ),
//                                                     )
//                                                   : value == 1
//                                                       ? Icon(
//                                                           MdiIcons.checkCircle,
//                                                           color: const Color(
//                                                               0xFF1DB954),
//                                                         )
//                                                       : SizedBox(
//                                                           width: 25,
//                                                           height: 25,
//                                                           child:
//                                                               CircularProgressIndicator(
//                                                             color: nowContrast,
//                                                             strokeWidth: 3,
//                                                             backgroundColor:
//                                                                 Colors
//                                                                     .transparent,
//                                                             value: value,
//                                                           ),
//                                                         );
//                                             }),
//                                     leading: Card(
//                                       elevation: 3,
//                                       color: Colors.transparent,
//                                       child: ConstrainedBox(
//                                         constraints:
//                                             musicBox.get("squareArt") ?? true
//                                                 ? kSqrConstraint
//                                                 : kRectConstraint,
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(3),
//                                           child:
//                                               // Image.memory(
//                                               //   onlineArtworks[index] ??
//                                               //       defaultNone!,
//                                               //   fit: BoxFit.cover,
//                                               //   errorBuilder:
//                                               //       (context, _, trace) {
//                                               //     return Container(
//                                               //       color: Colors.black,
//                                               //     );
//                                               //   },
//                                               // )
//                                               Image(
//                                             fit: BoxFit.cover,
//                                             image: NetworkImage(
//                                               searchResults[index]['image'],
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             )
//                           : Center(
//                               child: SizedBox(
//                                 width: 30,
//                                 height: 30,
//                                 child: CircularProgressIndicator(
//                                   // backgroundColor: kMaterialBlack,
//                                   color: nowContrast,
//                                 ),
//                               ),
//                             ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Future<void> getAPISongs() async {
//     if (!widget.downloadInput.startsWith("http")) {
//       // regular search => max 30 songs.
//       for (int i = 1; i <= 3; i++) {
//         List tenSongs = (await SaavnAPI().fetchSongSearchResults(
//                 searchQuery: widget.downloadInput,
//                 count: 10,
//                 page: i))['songs'] ??
//             [];
//         searchResults += tenSongs;
//         if (tenSongs.length != 10) {
//           break;
//         }
//       }
//       debugPrint(searchResults.toString(), wrapWidth: 1024);
//     } else if (widget.downloadInput.contains("www.jiosaavn.com/s/playlist/")) {
//       // Saavn playlist
//       String playlistId =
//           await SaavnAPI().fetchPlaylistId(widget.downloadInput);
//       searchResults +=
//           (await SaavnAPI().fetchPlaylistSongs(playlistId))['songs'] ?? [];
//     } else if (widget.downloadInput.contains("www.jiosaavn.com/album/")) {
//       // Saavn album
//       String albumId = await SaavnAPI().fetchAlbumId(widget.downloadInput);
//       searchResults +=
//           (await SaavnAPI().fetchAlbumSongs(albumId))['songs'] ?? [];
//     } else if (widget.downloadInput.contains("www.jiosaavn.com/artist/")) {
//       //TODO artist returns album models, which need to be processed further to download
//       print(widget.downloadInput
//           .substring(widget.downloadInput.lastIndexOf("/") + 1));
//       final data = (await SaavnAPI().fetchArtistSongs(
//           artistToken: widget.downloadInput
//               .substring(widget.downloadInput.lastIndexOf("/") + 1)));
//       searchResults += data['Top Albums'] ?? [];
//       searchResults += data['Singles'] ?? [];
//       print("modern warfare");
//       // print(data);
//     } else if (widget.downloadInput.contains("https://open.spotify.com")) {
//       SpotifyMetadata metaData = await SpotifyApi.getData(widget.downloadInput);
//       print(metaData.toMap().toString());
//     }
//     saavnDownloadObj = List.generate(searchResults.length, (index) => null);
//     // onlineArtworks = List.generate(searchResults.length, (index) => null);
//     // cache all artworks in memory
//     // for (int i = 0; i < searchResults.length; i++) {
//     //   if (searchResults[i]['image'] != null) {
//     //     http.Response response = await http.get(
//     //       Uri.parse(searchResults[i]['image']),
//     //     );
//     //     onlineArtworks[i] = response.bodyBytes;
//     //   }
//     // }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Future<void> download(int index) async {
//     refresh = true;
//     saavnDownloadObj[index] = SaavnDownload();
//     setState(() {});
//     //TODO save colors? multithread
//     await saavnDownloadObj[index]!.downloadSong(
//         fileName: searchResults[index]["title"] + ".m4a",
//         context: context,
//         data: searchResults[index]);

//     print("completed this shit");
//   }
// }
