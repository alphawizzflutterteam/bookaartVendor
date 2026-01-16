import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';

class CustomButton extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final bool isColor;
  final Color? backgroundColor;
  final Color? fontColor;
  final double? borderRadius;
  const CustomButton({Key? key, this.onTap, required this.btnTxt, this.backgroundColor, this.isColor = false, this.fontColor, this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isColor? backgroundColor : backgroundColor ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(borderRadius != null? borderRadius! : Dimensions.paddingSizeExtraSmall)),
        child: Text(btnTxt!,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: fontColor ?? Colors.white,
            )),
      ),
    );
  }
}



class CommonCustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CommonCustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 90 / 100,
      // Fixed width
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text??"",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

