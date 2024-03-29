import 'package:flutter/material.dart';
import 'package:listadecoisa/core/services/global.dart';
import 'package:listadecoisa/modules/home/presenter/ui/atoms/borda_padrao.dart';

class CampoPadrao extends StatelessWidget {
  final Global gb;
  final Widget? suffixIcon;
  final bool? lObescure;
  final String hintText;
  final TextEditingController? controller;
  const CampoPadrao({
    super.key,
    required this.hintText,
    this.lObescure,
    this.suffixIcon,
    this.controller,
    required this.gb,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: lObescure ?? false,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        border: BordaPadrao.build(),
        enabledBorder: BordaPadrao.build(),
        focusedBorder: BordaPadrao.build(),
        hintStyle: const TextStyle(color: Colors.white),
        hintText: hintText,
      ),
      controller: controller,
    );
  }
}
