
import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;
  final double? sigma;

  const BackgroundImage({Key? key, required this.child, this.sigma})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/kaespo.jfif'),
          fit: BoxFit.fill,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: sigma ?? 18,
          sigmaY: sigma ?? 18,
        ),
        child: child,
      ),
    );
  }
}