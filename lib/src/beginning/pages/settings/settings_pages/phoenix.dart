import 'package:another_flushbar/flushbar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:phoenix/src/beginning/pages/settings/settings_pages/privacy.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/pages/settings/settings_pages/license.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Phoenix extends StatefulWidget {
  const Phoenix({super.key});

  @override
  State<Phoenix> createState() => _PhoenixState();
}

class _PhoenixState extends State<Phoenix> {
  @override
  void initState() {
    rootCrossfadeState = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rootCrossfadeState = Provider.of<Leprovider>(context);
    int randomNumber = random.nextInt(quotes.length);
    if (MediaQuery.of(context).orientation != Orientation.portrait) {
      orientedCar = true;
      deviceHeight = MediaQuery.of(context).size.width;
      deviceWidth = MediaQuery.of(context).size.height;
    } else {
      orientedCar = false;
      deviceHeight = MediaQuery.of(context).size.height;
      deviceWidth = MediaQuery.of(context).size.width;
    }
    return Consumer<Leprovider>(
      builder: (context, taste, _) {
        globaltaste = taste;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          body: Theme(
            data: themeOfApp,
            child: Stack(
              children: [
                // ignore: prefer_const_constructors
                BackArt(),
                SingleChildScrollView(
                  physics: musicBox.get("fluidAnimation") ?? true
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: orientedCar
                            ? deviceWidth! / 1.8
                            : deviceWidth! / 1.8,
                        height: orientedCar
                            ? deviceWidth! / 2.5 +
                                deviceWidth! / 5 +
                                deviceWidth! / 13
                            : deviceWidth! / 1.5 +
                                deviceWidth! / 4 +
                                deviceWidth! / 12,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.only(
                                  top: orientedCar
                                      ? deviceWidth! / 6
                                      : deviceWidth! / 5),
                              width: orientedCar
                                  ? deviceWidth! / 1.8
                                  : deviceWidth! / 1.8,
                              height: orientedCar
                                  ? deviceWidth! / 2.8 + deviceWidth! / 5
                                  : deviceWidth! / 1.8 + deviceWidth! / 4,
                              child: Center(
                                child: Image.asset(
                                  "assets/res/phoenix.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(
                              "PHOENIX",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: orientedCar
                                      ? deviceWidth! / 18
                                      : deviceWidth! / 13,
                                  fontFamily: "NightMachine"),
                              textAlign: TextAlign.start,
                            ),
                            const Padding(padding: EdgeInsets.only(top: 2)),
                            Text(
                              changelogs.keys
                                  .toList()[changelogs.length - 1]
                                  .replaceRange(
                                      changelogs.keys
                                              .toList()[changelogs.length - 1]
                                              .length -
                                          8,
                                      changelogs.keys
                                          .toList()[changelogs.length - 1]
                                          .length,
                                      ""),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: orientedCar
                                    ? deviceWidth! / 31
                                    : deviceWidth! / 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: orientedCar
                                ? deviceWidth! / 8
                                : deviceWidth! / 4),
                      ),
                      Container(
                        height: orientedCar
                            ? deviceHeight! / 4
                            : deviceWidth! / 1.6,
                        width: orientedCar
                            ? deviceHeight! / 2
                            : deviceWidth! / 1.1,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(glassShadowOpacity! / 100),
                              blurRadius: glassShadowBlur,
                              offset: kShadowOffset,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(kRounded),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kRounded),
                          child: BackdropFilter(
                            filter: glassBlur,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kRounded),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.04)),
                                color: glassOpacity,
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, left: 16),
                                    child: Text(
                                      "The Phoenix Project will forever be free and open-source.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: orientedCar
                                            ? deviceWidth! / 32
                                            : deviceWidth! / 28,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: orientedCar
                                            ? deviceWidth! / 16
                                            : deviceWidth! / 16),
                                  ),
                                  Text(
                                    '@SHΛΛИ FΛYDH',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontSize: orientedCar
                                          ? deviceWidth! / 27
                                          : deviceWidth! / 25,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: orientedCar
                                            ? deviceWidth! / 32
                                            : deviceWidth! / 32),
                                  ),
                                  Material(
                                    type: MaterialType.transparency,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: orientedCar
                                                    ? deviceWidth! / 17
                                                    : deviceWidth! / 17)),
                                        IconButton(
                                            iconSize: orientedCar
                                                ? deviceWidth! / 17
                                                : deviceWidth! / 17,
                                            icon: Icon(MdiIcons.gmail,
                                                color: Colors.white),
                                            onPressed: () {
                                              final Uri emailLaunchUri = Uri(
                                                scheme: 'mailto',
                                                path:
                                                    'sincerelyshaan@protonmail.com',
                                              );
                                              launchUrl(emailLaunchUri);
                                            }),
                                        IconButton(
                                            iconSize: orientedCar
                                                ? deviceWidth! / 17
                                                : deviceWidth! / 17,
                                            icon: Icon(MdiIcons.github,
                                                color: Colors.white),
                                            onPressed: () async {
                                              Uri url = Uri.parse(
                                                  "https://github.com/shaan-mephobic/The-Phoenix-Project");
                                              await canLaunchUrl(url)
                                                  ? await launchUrl(url)
                                                  : throw Exception(
                                                      'Could not launch $url');
                                            }),
                                        IconButton(
                                            iconSize: orientedCar
                                                ? deviceWidth! / 17
                                                : deviceWidth! / 17,
                                            icon: const Icon(
                                                Ionicons.logo_paypal,
                                                color: Colors.white),
                                            onPressed: () async {
                                              Flushbar(
                                                messageText: const Text(
                                                    "Money doesn't interest me. Have a great day!",
                                                    style: TextStyle(
                                                        fontFamily: "Futura",
                                                        color: Colors.white)),
                                                icon: Icon(
                                                  Icons
                                                      .money_off_csred_outlined,
                                                  size: 28.0,
                                                  color: kCorrect,
                                                ),
                                                shouldIconPulse: true,
                                                dismissDirection:
                                                    FlushbarDismissDirection
                                                        .HORIZONTAL,
                                                duration:
                                                    const Duration(seconds: 2),
                                                borderColor: Colors.white
                                                    .withOpacity(0.04),
                                                borderWidth: 1,
                                                backgroundColor: glassOpacity!,
                                                flushbarStyle:
                                                    FlushbarStyle.FLOATING,
                                                isDismissible: true,
                                                barBlur:
                                                    musicBox.get("glassBlur") ??
                                                        18,
                                                margin: const EdgeInsets.only(
                                                    bottom: 20,
                                                    left: 8,
                                                    right: 8),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                // leftBarIndicatorColor:
                                                //     Color(0xFFCB0047),
                                              ).show(context);
                                              await Future.delayed(
                                                  const Duration(seconds: 2));
                                              Uri url = Uri.parse(
                                                  "https://www.youtube.com/watch?v=dQw4w9WgXcQ");
                                              await canLaunchUrl(url)
                                                  ? await launchUrl(url)
                                                  : throw Exception(
                                                      'Could not launch $url');
                                            }),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: orientedCar
                                                    ? deviceWidth! / 17
                                                    : deviceWidth! / 17)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: orientedCar
                                ? deviceWidth! / 10
                                : deviceWidth! / 8),
                      ),
                      Container(
                        height:
                            orientedCar ? deviceWidth! / 3 : deviceWidth! / 3.0,
                        width: orientedCar
                            ? deviceWidth! / 1.5
                            : deviceWidth! / 1.5,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(glassShadowOpacity! / 100),
                              blurRadius: glassShadowBlur,
                              offset: kShadowOffset,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(kRounded),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(kRounded),
                          child: BackdropFilter(
                            filter: glassBlur,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kRounded),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.04)),
                                color: glassOpacity,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(kRounded),
                                child: Container(
                                  height: orientedCar
                                      ? deviceWidth! / 3.0
                                      : deviceWidth! / 3.0,
                                  width: orientedCar
                                      ? deviceWidth! / 1.5
                                      : deviceWidth! / 1.5,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(kRounded),
                                  ),
                                  child: InkWell(
                                      borderRadius:
                                          BorderRadius.circular(kRounded),
                                      child: Center(
                                        child: Text(
                                          "DATA PRIVACY",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: orientedCar
                                                ? deviceWidth! / 18
                                                : deviceWidth! / 18,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            maintainState: false,
                                            builder: (context) =>
                                                ChangeNotifierProvider<
                                                        Leprovider>(
                                                    create: (_) => Leprovider(),
                                                    child: const Privacy()),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: orientedCar
                                ? deviceWidth! / 10
                                : deviceWidth! / 8),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right:
                              orientedCar ? deviceWidth! / 6 : deviceWidth! / 6,
                          left:
                              orientedCar ? deviceWidth! / 6 : deviceWidth! / 6,
                        ),
                        child: Column(
                          children: [
                            Text(
                              " \"${quotes.keys.toList()[randomNumber]}\" ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Raleway",
                                  fontSize: orientedCar
                                      ? deviceWidth! / 30
                                      : deviceWidth! / 30),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "~${quotes.values.toList()[randomNumber]}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Raleway",
                                        fontSize: orientedCar
                                            ? deviceWidth! / 32
                                            : deviceWidth! / 32),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: orientedCar
                                ? deviceWidth! / 10
                                : deviceWidth! / 8),
                      ),
                      Text(
                        "Copyright © 2020, Shaan Faydh",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: orientedCar
                                ? deviceWidth! / 32
                                : deviceWidth! / 32),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LicensesPage()),
                          );
                        },
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.white30)),
                        child: Text(
                          "Licenses",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: orientedCar
                                ? deviceWidth! / 34
                                : deviceWidth! / 34,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
