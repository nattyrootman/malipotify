import 'package:flutter/material.dart';

class TextFields extends StatelessWidget {
  final String textHint;
  final TextEditingController? controller;
  final bool isTextOsbcure;
  final Widget? suffix;
  const TextFields({
    super.key,
    required this.textHint,
    required this.controller,
    this.isTextOsbcure = false,
   
    this.suffix
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),

      //padding: EdgeInsets.all(8),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return "Champ obligatoire";
          }
          return null;
        },

        controller: controller,
        obscureText: isTextOsbcure,

        decoration: InputDecoration(
          suffixIcon: suffix,
          hintText: textHint,
          border: OutlineInputBorder(
            
            borderRadius: BorderRadius.circular(10),
          ),
         
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Theme.of(context).focusColor),
          ),
        ),
      ),
    );
  }
}
