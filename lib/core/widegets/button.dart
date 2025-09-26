import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String textButton;
  final double height, width;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final VoidCallback onTap;
  final Color? color;
  final Gradient? gradient;

  const MyButton({
     super.key,
     this.height=40,
     this.width=150,
     required this.textButton,
     this.color,
     this.gradient,
     this.margin=const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
     this.padding=const EdgeInsets.all(8),
     required this.onTap,
  
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onTap,
      child: Container(
        margin: margin,
        padding: padding,
        width: width,
        height: height,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: gradient,
        ),
        child: Center(
          child: Text(textButton, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
