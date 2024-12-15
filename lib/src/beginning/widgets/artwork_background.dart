import 'dart:ui';
import 'package:phoenix/src/beginning/utilities/constants.dart';
import 'package:phoenix/src/beginning/utilities/global_variables.dart';
import 'package:flutter/material.dart';

late var globaltaste;

class BackArt extends StatefulWidget {
  const BackArt({super.key});

  @override
  State<BackArt> createState() => _BackArtState();
}

class _BackArtState extends State<BackArt> {
  double firstVisible = 1.0;

  double secondVisible = 1.0;

  // void fastTransition(bool hideFirst) async {
  //   // await Future.delayed(Duration(milliseconds: crossfadeDuration));
  //   if (hideFirst) {
  //     firstVisible = 0;
  //   } else {
  //     secondVisible = 0;
  //   }
  //   print("HIDDEN");
  // }

  void animationHandler() async {
    if (first) {
      // firstVisible = 0;
      secondVisible = 0;
      // print("diffusing");
      // print("first");
      // await Future.delayed(Duration(milliseconds: crossfadeDuration));
      // secondVisible = 1;
      // fastTransition(true);
    } else {
      // print("emerging");
      secondVisible = 1.0;
      // firstVisible = 1.0;
      // await Future.delayed(Duration(milliseconds: crossfadeDuration));
      // print("second");
      // fastTransition(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("\n\n\n\n\n\n\n FIRST : $first \n\n\n\n\n\n");
    if (musicBox.get("dynamicArtDB") ?? true) {
      animationHandler();
      // return AnimatedCrossFade(
      //   reverseDuration: Duration(milliseconds: crossfadeDuration),
      //   duration: Duration(milliseconds: crossfadeDuration),
      //   firstChild: Container(
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: MemoryImage(art!),
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //     child: BackdropFilter(
      //       filter: ImageFilter.blur(
      //           tileMode: TileMode.mirror,
      //           sigmaX: artworkBlurConst,
      //           sigmaY: artworkBlurConst),
      //       child: Container(
      //         alignment: Alignment.center,
      //         color: Colors.black.withOpacity(0.22),
      //         child: Center(
      //           child: SizedBox(
      //             height: orientedCar ? deviceWidth : deviceHeight,
      //             width: orientedCar ? deviceHeight : deviceWidth,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      //   secondChild: Container(
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: MemoryImage(art2!),
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //     child: BackdropFilter(
      //       filter: ImageFilter.blur(
      //           tileMode: TileMode.mirror,
      //           sigmaX: artworkBlurConst,
      //           sigmaY: artworkBlurConst),
      //       child: Container(
      //         alignment: Alignment.center,
      //         color: Colors.black.withOpacity(0.22),
      //         child: Center(
      //           child: SizedBox(
      //             height: orientedCar ? deviceWidth : deviceHeight,
      //             width: orientedCar ? deviceHeight : deviceWidth,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      //   crossFadeState:
      //       first ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      // );
      return Stack(
        children: [
          AnimatedOpacity(
            opacity: firstVisible,
            duration: Duration(milliseconds: crossfadeDuration),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(art!),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    tileMode: TileMode.mirror,
                    sigmaX: artworkBlurConst,
                    sigmaY: artworkBlurConst),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.22),
                  child: Center(
                    child: SizedBox(
                      height: orientedCar ? deviceWidth : deviceHeight,
                      width: orientedCar ? deviceHeight : deviceWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
              opacity: secondVisible,
              duration: Duration(milliseconds: crossfadeDuration),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(art2!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      tileMode: TileMode.mirror,
                      sigmaX: artworkBlurConst,
                      sigmaY: artworkBlurConst),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.22),
                    child: Center(
                      child: SizedBox(
                        height: orientedCar ? deviceWidth : deviceHeight,
                        width: orientedCar ? deviceHeight : deviceWidth,
                      ),
                    ),
                  ),
                ),
              ))
        ],
      );
    } else {
      return Container(color: kMaterialBlack);
    }
  }
}
