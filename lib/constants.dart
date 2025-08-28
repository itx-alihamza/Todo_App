import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color customColorWhite = Color.fromRGBO(255, 255, 255, 1);
const Color primaryColor = Color(0xFF9395D3);
const Color bodyColor = Color(0xFFD6D7EF);


//Icons
final Widget calendarIcon = SvgPicture.asset(
  'assets/icons/calendarIcon.svg',
  width: 40,
  height: 40,
  colorFilter: const ColorFilter.mode(Color.fromRGBO(255, 255, 255, 1), BlendMode.srcIn),
  semanticsLabel: 'Red dash paths',
);

final Widget allIcon = SvgPicture.asset(
  'assets/icons/Playlist.svg',
  width: 40,
  height: 40,
  // colorFilter: ColorFilter.mode(primaryColor, BlendMode.color),
  semanticsLabel: 'All',
);
final Widget tickIcon = SvgPicture.asset(
  'assets/icons/Tick.svg',
  width: 40,
  height: 40,
  // colorFilter: primaryColor,
  semanticsLabel: 'All',//semantic label is used for accessibility purposes like screen readers.
);