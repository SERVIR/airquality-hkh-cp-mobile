import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/module/home/controller/home_screen_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPlaceListComponant extends StatelessWidget {
  final HomeScreenController controller;
  // RxDouble lat = 0.0.obs;
  // RxDouble long = 0.0.obs;
  const SearchPlaceListComponant({
    super.key,
    required this.controller,
    // required this.lat,
    // required this.long,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.size.height * 0.4,
      width: Get.size.width,
      decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(10)),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: false,
          itemCount: controller.searchCityList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                controller.searchLocationLat.value =
                    double.parse(controller.searchCityList[index]['lat']);
                controller.searchLocationLong.value =
                    double.parse(controller.searchCityList[index]['lon']);
                controller.searchCityName.value =
                    controller.searchCityList[index]["display_name"];

                controller.placeId.value =
                    controller.searchCityList[index]['place_id'].toString();
                controller.zoom.value = 14;
                // controller.mapController();
                controller.gotoSearchLocation(
                    controller.searchLocationLat.value,
                    controller.searchLocationLong.value);

                controller.searchCityList.clear();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CachedNetworkImage(
                            imageUrl:
                                controller.searchCityList[index]['icon'] ?? '',
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        color: AppColor.appButtonColor,
                                        strokeWidth: 2,
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(
                          width: 11,
                        ),
                        SizedBox(
                          width: Get.size.width * 0.63,
                          child: Text(
                            controller.searchCityList[index]['display_name'],
                          ),
                        ),
                      ],
                    ),
                    const Divider()
                  ],
                ),
              ),
            );
          }),
    );
  }
}
