// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:phoenix/src/beginning/utilities/apis/saavn.dart';
// import 'package:phoenix/src/beginning/utilities/download/download_music.dart';
// import 'package:phoenix/src/beginning/utilities/global_variables.dart';

// class Download extends StatefulWidget {
//   const Download({Key? key}) : super(key: key);

//   @override
//   State<Download> createState() => _DownloadState();
// }

// class _DownloadState extends State<Download> {
//   String? inputDownload;
//   bool isLoading = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Dowload"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                   autocorrect: false,
//                   onChanged: (String? s) {
//                     inputDownload = s;
//                   }),
//             ),
//             ElevatedButton(
//               child: isLoading
//                   ? const SizedBox(
//                       height: 25,
//                       width: 25,
//                       child: Padding(
//                         padding: EdgeInsets.all(2.0),
//                         child: CircularProgressIndicator(
//                             color: Colors.black, strokeWidth: 3),
//                       ),
//                     )
//                   : const Text("Download"),
//               onPressed: () async {
//                 if (inputDownload == null || inputDownload!.isEmpty) {
//                   Flushbar(
//                     messageText: const Text("Provide a song!",
//                         style: TextStyle(
//                             fontFamily: "Futura", color: Colors.white)),
//                     icon: const Icon(
//                       Icons.error_outline,
//                       size: 28.0,
//                       color: Color(0xFFCB0447),
//                     ),
//                     shouldIconPulse: true,
//                     dismissDirection: FlushbarDismissDirection.HORIZONTAL,
//                     duration: const Duration(seconds: 3),
//                     borderColor: Colors.white.withOpacity(0.04),
//                     borderWidth: 1,
//                     // backgroundColor: glassOpacity!,
//                     flushbarStyle: FlushbarStyle.FLOATING,
//                     isDismissible: true,
//                     // barBlur: musicBox.get("glassBlur") ?? 18,
//                     margin:
//                         const EdgeInsets.only(bottom: 20, left: 8, right: 8),
//                     borderRadius: BorderRadius.circular(15),
//                   ).show(context);
//                 } else if (!inputDownload!.startsWith("http")) {
//                   setState(() {
//                     isLoading = true;
//                   });
//                   var respones = (await SaavnAPI().fetchSongSearchResults(
//                       searchQuery: inputDownload!, count: 1));
//                   debugPrint(respones.toString(), wrapWidth: 1024);
//                   print("-------");
//                   // await downloadSong(
//                   //     fileName: respones["songs"][0]["title"] + ".m4a",
//                   //     context: context,
//                   //     data: respones['songs'][0]);
//                   // setState(() {
//                   //   isLoading = false;
//                   // });
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
