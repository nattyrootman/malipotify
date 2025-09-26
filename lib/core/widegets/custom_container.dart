
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double width, hight;
  final EdgeInsets padding, margin;
  final BoxDecoration? boxDecoration;
  final Widget? child;
  final DecorationImage? decorationImage;
  final double radius;

  const CustomContainer({
    super.key,
     this.width=0,
     this.hight=0,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.boxDecoration,
    this.child,
    this.decorationImage,
    this.radius = 5.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: hight,
      padding: padding,
      margin: margin,
      decoration:boxDecoration,
      child: child
    );
  }
}
