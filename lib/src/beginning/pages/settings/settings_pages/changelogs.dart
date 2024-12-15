import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:phoenix/src/beginning/utilities/provider/provider.dart';
import 'package:phoenix/src/beginning/widgets/artwork_background.dart';
import 'package:provider/provider.dart';

class Changelogs extends StatefulWidget {
  const Changelogs({super.key});
  @override
  State<Changelogs> createState() => _ChangelogsState();
}

class _ChangelogsState extends State<Changelogs> {
  @override
  void initState() {
    rootCrossfadeState = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    rootCrossfadeState = Provider.of<Leprovider>(context);
    return Consumer<Leprovider>(
      builder: (context, taste, _) {
        globaltaste = taste;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              "Changelogs",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: deviceWidth! / 18,
              ),
            ),
          ),
          body: Theme(
            data: themeOfApp,
            child: Stack(
              children: [
                // ignore: prefer_const_constructors
                BackArt(),
                Padding(
                  padding: EdgeInsets.only(
                      top: kToolbarHeight + MediaQuery.of(context).padding.top),
                  child: SingleChildScrollView(
                    physics: musicBox.get("fluidAnimation") ?? true
                        ? const BouncingScrollPhysics()
                        : const ClampingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        for (int i = changelogs.length - 1; i > -1; i--)
                          Column(
                            children: [
                              ListTile(
                                title: Text(
                                  changelogs.keys.toList()[i],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.only(left: 50, right: 25),
                                child: Text(
                                  changelogs.values.toList()[i],
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              const Divider(
                                color: Colors.white54,
                                indent: 50,
                                thickness: 0.2,
                                endIndent: 50,
                                height: 110,
                              ),
                            ],
                          ),
                      ],
                    ),
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
