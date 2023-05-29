import 'package:air_quality_explorer/core/color.dart';
import 'package:flutter/material.dart';

class SubmitButtonWidget extends StatelessWidget {
  final double height;
  final double width;
  final String btnText;
  final Function onTap;
  const SubmitButtonWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.btnText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: AppColor.appButtonColor,
          boxShadow: const [
            BoxShadow(
                color: AppColor.shadowColor, blurRadius: 24, spreadRadius: 1),
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
          color: AppColor.transparentColor,
          child: InkWell(
            onTap: () {
              onTap();
            },
            child: Center(
              child: Text(
                btnText,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColor.whiteColor,
                      fontSize: 14,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
