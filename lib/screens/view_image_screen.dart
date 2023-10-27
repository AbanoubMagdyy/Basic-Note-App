import 'dart:io';
import 'package:flutter/material.dart';

import '../style/colors.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defColor,
      appBar: AppBar(
        backgroundColor: defColor,
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
