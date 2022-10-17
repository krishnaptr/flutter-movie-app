import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:movie_provider/styles/constants.dart';

class CustomBadges extends StatelessWidget {
  const CustomBadges({
    Key? key,
    required this.title,
    required this.fontSize,
    required this.badgeColor,
    required this.textColor,
  }) : super(key: key);

  final String title;
  final double fontSize;
  final Color badgeColor;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return Badge(
      elevation: 0,
      toAnimate: false,
      shape: BadgeShape.square,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      badgeColor: badgeColor,
      borderRadius: BorderRadius.circular(100),
      badgeContent: Text(title,
          style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.32)),
    );
  }
}
