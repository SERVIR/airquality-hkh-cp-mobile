import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PlayNPauseComponantWidget extends StatelessWidget {
  const PlayNPauseComponantWidget({
    Key? key,
    // required this.twelve,
    // required this.thirteen,
  }) : super(key: key);

  // final GlobalKey<State<StatefulWidget>> twelve;
  // final GlobalKey<State<StatefulWidget>> thirteen;

  @override
  Widget build(BuildContext context) {
    return /* Showcase(
      key: twelve,
      title: 'Watch the layer animation',
      titleTextStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 16,
            color: AppColor.appbarTextColor,
            fontWeight: FontWeight.w600,
          ),
      description:
          'This tool will allow you to watch\n the animation of the layers in\n archive and forecast mode.',
      descTextStyle: Theme.of(context)
          .textTheme
          .displayLarge!
          .copyWith(color: AppColor.appButtonColor, fontSize: 14),
      targetShapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      tooltipBorderRadius: BorderRadius.circular(3),
      onToolTipClick: () {
        // controller.menuButtonSelect.value = true;
        ShowCaseWidget.of(context).startShowCase([thirteen]);
      },
      child: */
        Container(
      height: Get.size.height * 0.066,
      width: Get.size.width * 0.6,
      decoration: BoxDecoration(
        color: AppColor.appPrimaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [
            SvgPicture.asset(AppImages.videoPreviousIcon),
            const Spacer(),
            SvgPicture.asset(AppImages.playIcon),
            const Spacer(),
            SvgPicture.asset(AppImages.videoNextIcon),
          ],
        ),
      ),
      // ),
    );
  }
}
