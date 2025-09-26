import 'package:flutter/material.dart';

class PaddingWidget extends StatelessWidget {
 final String text;
 final EdgeInsetsGeometry padding;
  const PaddingWidget({super.key, required this.text, required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding,
           child: Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700)),
    
    );
  }
}
