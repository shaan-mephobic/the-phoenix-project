/*-------------------------------------------------------------------------------------------------------
* Copyright © 2020, Shaan Faydh
*  
* The Phoenix Project is free software licensed under GPL v3.0.
* You can redistribute and/or modify it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
* 
* The Phoenix Project is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
* without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
* See the GNU General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with The Phoenix Project.  If not, see <http://www.gnu.org/licenses/>.
---------------------------------------------------------------------------------------------------------*/

import 'dart:io';
import 'package:phoenix/src/beginning/utilities/audio_handlers/background.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/pages/settings/settings_pages/privacy.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/init.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'src/beginning/begin.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await cacheImages();
  await dataInit();
  await fetchSongs();
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerTask(),
    config: const AudioServiceConfig(
      androidStopForegroundOnPause: false,
      androidNotificationChannelName: "Phoenix Music",
      androidNotificationIcon: "drawable/phoenix_awaken",
      androidNotificationChannelDescription: "Phoenix Music Notification",
    ),
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MaterialApp(
      theme: themeOfApp,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<Leprovider>(create: (_) => Leprovider()),
          ChangeNotifierProvider<MrMan>(
            create: (_) => MrMan(),
          ),
          ChangeNotifierProvider<Seek>(create: (_) => Seek()),
        ],
        child: permissionGiven ? const Begin() : const Privacy(),
      ),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
