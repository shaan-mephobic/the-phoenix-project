import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import "dart:collection";

import 'package:phoenix/src/beginning/utilities/global_variables.dart';

class LicensesPage extends StatefulWidget {
  const LicensesPage({super.key});

  @override
  State<LicensesPage> createState() => _LicensesPageState();
}

class _LicensesPageState extends State<LicensesPage> {
  ScrollController? _scrollBarController;
  @override
  void initState() {
    backArtStateChange = false;
    _scrollBarController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    backArtStateChange = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: licensesManager(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          // if (snapshot.data != null) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("Licenses",
                  style: TextStyle(fontFamily: "Futura")),
              backgroundColor: kMaterialBlack,
            ),
            body: Theme(
              data: themeOfApp,
              child: Scrollbar(
                controller: _scrollBarController,
                child: ListView.builder(
                  physics: musicBox.get("fluidAnimation") ?? true
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics(),
                  controller: _scrollBarController,
                  itemCount: snapshot.data.length - 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(
                          snapshot.data.keys.toList()[index],
                          style: const TextStyle(
                              color: Colors.white, fontFamily: "Futura"),
                        ),
                        subtitle: Text(
                          "${snapshot.data[snapshot.data.keys.toList()[index]].length} Licenses",
                          style: const TextStyle(
                              color: Colors.white, fontFamily: "Futura"),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InsideLicense(
                                snapshot.data.keys.toList()[index],
                                snapshot
                                    .data[snapshot.data.keys.toList()[index]],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                backgroundColor: kMaterialBlack,
                color: Colors.white,
              ),
            ),
          );
        }
      },
    );
  }
}

class InsideLicense extends StatelessWidget {
  final List<String>? licenseValue;
  final String? licenseKey;
  const InsideLicense(this.licenseKey, this.licenseValue, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMaterialBlack,
        title: Text(
          licenseKey!,
          style: const TextStyle(fontFamily: "Futura"),
        ),
      ),
      body: Theme(
        data: themeOfApp,
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: musicBox.get("fluidAnimation") ?? true
                ? const BouncingScrollPhysics()
                : const ClampingScrollPhysics(),
            child: Column(
              children: [
                for (int i = 0; i < licenseValue!.length; i++)
                  Column(
                    children: [
                      Text(
                        licenseValue![i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Futura",
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 32),
                      ),
                      const Divider(
                        color: Colors.white54,
                        indent: 50,
                        thickness: 0.2,
                        endIndent: 50,
                        height: 4,
                      )
                    ],
                  ),
                const Padding(
                  padding: EdgeInsets.only(top: 32),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

licensesManager() async {
  Map<String, List<String>> licenseData = {};
  List<LicenseEntry> rawLicense = await LicenseRegistry.licenses.toList();
  allLicenseIterator(String package) {
    for (int i = 0; i < rawLicense.length; i++) {
      for (int o = 0; o < rawLicense[i].packages.length; o++) {
        if (package == rawLicense[i].packages.toList()[o]) {
          String licenseParagraph = "";
          for (var element in rawLicense[i].paragraphs) {
            licenseParagraph += "\n \n ${element.text}";
          }
          licenseData[package]!.add(licenseParagraph);
        }
      }
    }
  }

  for (int i = 0; i < rawLicense.length; i++) {
    for (int o = 0; o < rawLicense[i].packages.length; o++) {
      if (!licenseData.keys
          .toList()
          .contains(rawLicense[i].packages.toList()[o])) {
        licenseData[rawLicense[i].packages.toList()[o]] = [];
        allLicenseIterator(rawLicense[i].packages.toList()[o]);
      }
    }
  }
  final sorted = SplayTreeMap<String, List<String>>.from(
      licenseData, (a, b) => a.compareTo(b));
  return sorted;
}
