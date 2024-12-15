import 'package:flutter/material.dart';

/// The default black Color
Color kMaterialBlack = const Color(0xFF000000);

/// Green/Correct Color
Color kCorrect = const Color(0xFF1DB954);

/// Roundedness of widgets
double kRounded = 12;

/// Phoenix color
Color kPhoenixColor = const Color(0xFF028ac4);

/// Crossfade duration.
int crossfadeDuration = 250;

/// Blur constant for artwork background
double artworkBlurConst = 14;

/// Blur constant for glass shadow
double glassShadowBlur = 13;

/// Shadow ffset of every glassmorphic widgets
Offset kShadowOffset = const Offset(0, 3);

/// Shadow for nowart
BoxShadow nowArtShadow =
    BoxShadow(color: Colors.black54, blurRadius: 13.0, offset: kShadowOffset);

/// Aesthetic Quotes.
Map quotes = {
  "I don't wanna believe. I wanna Know.": "Carl Sagan",
  "The truth is like a black bouquet, Money's got us all enslaved, the bullets and the bombs we make, oh, no.":
      "Stephen Swartz",
  "I don't care for your drugs, I don't care for your fame. Do you care for the truth if you're not entertained?":
      "Stephen Swartz",
  "No child of ours should have to starve, should have to die for us.":
      "Stephen Swartz",
  "What I cannot create, I do not understand.": "Richard Feynman",
  "Can I trust what I'm given? \n When faith still needs a gun.":
      "Stephen Swartz"
};

/// Changelogs
Map<String, String> changelogs = {
  "HERTZ - 2.0.0": "• Initial Awaken release.\n• Rebuilt entire app.",
  "FALL - 2.1.0":
      "• Add option to change default artwork.\n• Add option to change glass look.\n• Add pull to refresh.",
  "FORTRESS - 2.2.0":
      "• Biggest update ever — literally, app is almost thrice the size it used to be.\n• Add ringtone/crossfade/trim.\n• New search UI.\n• New now playing design.\n• Wider lyrics support.\n• Progress bar in mini-playing.\n• Performance improvements.\n• Minor UI changes.\n• Accurate artworks for songs.\n• Support editing songs for all android versions.\n• Smoother seekbar.",
  "PERSEUS - 2.3.0":
      "• Upstream everything.\n• Fix crashes during loading.\n• Sort music in albums with date.",
  "EPHEMERAL - 2.4.0":
      "• Add sorting option.\n• Fix add-to-queue bug in mansion.\n• Upstream everything."
};

/// Theme data of entire app
ThemeData themeOfApp = ThemeData(
  unselectedWidgetColor: Colors.grey[900],
  scaffoldBackgroundColor: kMaterialBlack,
  useMaterial3: false,
  fontFamily: "Urban",
  focusColor: Colors.transparent,
  dividerTheme: const DividerThemeData(
    color: Colors.white54,
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
      builders: {TargetPlatform.android: OpenUpwardsPageTransitionsBuilder()}),
  scrollbarTheme: ScrollbarThemeData(
    interactive: true,
    thumbVisibility: MaterialStateProperty.all(false),
    radius: const Radius.circular(50),
    thickness: MaterialStateProperty.all(4),
    crossAxisMargin: 2,
    thumbColor: MaterialStateProperty.all(Colors.white30),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
);

/// BoxContraints for artwork shape in listtile
BoxConstraints kSqrConstraint = const BoxConstraints(
  minWidth: 48,
  minHeight: 48,
  maxWidth: 48,
  maxHeight: 48,
);
BoxConstraints kRectConstraint = const BoxConstraints(
  minWidth: 44,
  minHeight: 44,
  maxWidth: 64,
  maxHeight: 64,
);
