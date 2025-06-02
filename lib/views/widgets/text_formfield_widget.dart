import 'package:flutter/material.dart';
import 'package:kosanku/constants/constant_colors.dart';
import 'package:kosanku/constants/constant_text_styles.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isNumber;
  final bool obscureText;
  final Widget? suffixIcon;
  final int? maxLines;

  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.isNumber = false,
    this.obscureText = false,
    this.maxLines,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PoppinsStyle.stylePoppins(
            color: fontBlueSky,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          obscureText: obscureText,
          maxLines: maxLines ?? 1,
          style: PoppinsStyle.stylePoppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: bgBlue,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: pink),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: fontBlue),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
