import 'package:flutter/material.dart';
import 'package:sixvalley_vendor_app/view/screens/Service/widget.dart';
import 'package:sizer/sizer.dart';
import 'colors.dart';
import 'constant.dart';

class UtilityWidget {
  static AnimatedContainer lodingButton({required buttonLogin, btntext}) {
    return AnimatedContainer(
      width: 40, //buttonLogin ? 40.0 : 69.99.w,
      height: 20, //buttonLogin ? 8.0 : 6.46.h,
      decoration: boxDecoration(radius: 15.0, bgColor: Colors.blue),
      duration: Duration(microseconds: 750),
      curve: Curves.bounceOut,
      child: Center(
        child: buttonLogin
            ? CircularProgressIndicator(
                color: Colors.white,
              )
            : text(
                btntext ?? "",
                textColor: Color(0xffffffff),
                fontSize: 14.0, // 14.sp,
                fontFamily: fontRegular,
              ),
      ),
    );
  }
}
