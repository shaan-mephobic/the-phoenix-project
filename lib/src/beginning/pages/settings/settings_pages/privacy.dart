import 'package:flutter_remixicon/flutter_remixicon.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import '../../../widgets/switcher_button.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:provider/provider.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  void initState() {
    crossfadeStateChange = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rootCrossfadeState = Provider.of<Leprovider>(context);
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
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              top: orientedCar
                                  ? deviceWidth! / 4
                                  : deviceWidth! / 2)),
                      Padding(
                          padding: EdgeInsets.only(
                              top: orientedCar
                                  ? deviceHeight! / 5.5
                                  : deviceHeight! / 5.5)),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: orientedCar ? deviceHeight! / 3 / 2 : 30,
                              right: orientedCar ? deviceHeight! / 3 / 2 : 30),
                          child: RichText(
                            text: TextSpan(
                              text:
                                  "Phoenix does use the internet for lyrics and images, but collects no data. You could turn off the feature if you wish, below.",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Raleway",
                                fontWeight: FontWeight.w600,
                                fontSize: orientedCar
                                    ? deviceHeight! / 26
                                    : deviceHeight! / 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: orientedCar
                                  ? deviceWidth! / 4
                                  : deviceWidth! / 2)),
                      Container(
                        height: orientedCar
                            ? deviceHeight! / 3
                            : deviceWidth! / 1.6,
                        width: orientedCar
                            ? deviceHeight! / 1.5
                            : deviceWidth! / 1.1,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(deviceWidth! / 27),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(glassShadowOpacity! / 100),
                              blurRadius: glassShadowBlur,
                              offset: kShadowOffset,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(deviceWidth! / 27),
                          child: BackdropFilter(
                            filter: glassBlur,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(deviceWidth! / 27),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.04)),
                                color: glassOpacity,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 30,
                                      right: 30,
                                    ),
                                    child: Text(
                                      "Your data is Anonymous and isn't stored by phoenix, yet you can turn on Isolation to stop the features.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Raleway",
                                        fontWeight: FontWeight.w600,
                                        fontSize: deviceWidth! / 19,
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 30)),
                                  SwitcherButton(
                                    offColor: kMaterialBlack,
                                    onColor: kCorrect,
                                    value: musicBox.get("isolation") == null
                                        ? false
                                        : musicBox.get('isolation'),
                                    onChange: (value) {
                                      musicBox.put("isolation", value);
                                      setState(() {});
                                    },
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
                                  ? deviceWidth! / 6
                                  : deviceWidth! / 4)),
                      Text(
                        "#PRIVACYMATTERS",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: orientedCar
                              ? deviceWidth! / 25
                              : deviceWidth! / 22,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 13)),
                    ],
                  ),
                ),
                SizedBox(
                  height: orientedCar
                      ? deviceWidth! / 4.2
                      : deviceHeight! / 5.5 +
                          MediaQuery.of(context).padding.top,
                  child: AppBar(
                    iconTheme: IconThemeData(
                      color: kMaterialBlack,
                    ),
                    elevation: deviceWidth! / 60,
                    toolbarHeight:
                        orientedCar ? deviceWidth! / 4.2 : deviceHeight! / 5.5,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(deviceWidth! / 14),
                      ),
                    ),
                    centerTitle: true,
                    title: Text(
                      "PRIVACY",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontFamily: "Futura",
                          fontSize: deviceWidth! / 10,
                          color: kMaterialBlack),
                    ),
                  ),
                ),
                Positioned(
                  left: orientedCar
                      ? deviceHeight! / 2
                      : deviceWidth! / 2 - deviceWidth! / 14,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        top: orientedCar
                            ? deviceWidth! / 4.2 -
                                deviceWidth! / 14 +
                                MediaQuery.of(context).padding.top
                            : deviceHeight! / 5.5 -
                                deviceWidth! / 14 +
                                MediaQuery.of(context).padding.top),
                    child: Container(
                      height: deviceWidth! / 7,
                      width: deviceWidth! / 7,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 1.0,
                            spreadRadius: deviceWidth! / 230,
                          ),
                        ],
                        color: kMaterialBlack,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        MIcon.riLock2Line,
                        color: const Color(0xFF02c9d3),
                        size: deviceWidth! / 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}
