
import 'package:app3/core/themes/APP_text_Style.dart';
import 'package:app3/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:app3/core/widget/custom_text_from_feild.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CustomTextFromFeild extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
const CustomTextFromFeild({super.key,required this.hintText,  this.isPassword = false, this.validator, this.controller});

  @override
  State<CustomTextFromFeild> createState() => _CustomTextFromFeildState();
}

class _CustomTextFromFeildState extends State<CustomTextFromFeild> {
  bool isObcure = true;

@override
Widget build(BuildContext context) {
return TextFormField(
  controller: widget.controller,
  obscureText: widget.isPassword&& isObcure,
  validator:widget.validator ,
  onTapOutside: (v){
    Focus.of(context).unfocus();
  },
  cursorColor: AppColors.mainColor,
  decoration: InputDecoration(
    suffixIcon:widget.isPassword? InkWell(
      onTap: (){
        setState(() {
          isObcure=!isObcure;

        });

      }
    ,child: Icon(Icons.visibility)):null,
    fillColor: Colors.white,
    filled: true,
    hintStyle: AppTextStyle.hintTextStyle,
    hintText: widget.hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
              color:AppColors.borderColor
          )


    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: BorderSide(
            color:AppColors.mainColor
        )

    )
  ),
);
}
}
