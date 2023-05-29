import 'package:air_quality_explorer/core/color.dart';
import 'package:flutter/material.dart';

class OutlineSubmitButtonWidget extends StatelessWidget {
  final double height;
  final double width;
  final String buttonNm;
  final Function onTap;
  const OutlineSubmitButtonWidget({
    Key? key,
    required this.height,
    required this.width,
    required this.buttonNm,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColor.appButtonColor),
      ),
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
                buttonNm,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColor.appButtonColor,
                    fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
