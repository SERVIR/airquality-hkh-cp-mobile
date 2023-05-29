import 'package:air_quality_explorer/core/color.dart';
import 'package:air_quality_explorer/core/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.appPrimaryColor,
        title: const Text("Air Quality Information System"),
        titleTextStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: AppColor.appbarTextColor,
              fontWeight: FontWeight.w600,
              fontSize: 17,
            ),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: SizedBox(
            height: Get.size.height * 0.05,
            width: Get.size.height * 0.05,
            child: Center(
              child: SvgPicture.asset(
                AppImages.leftArrowIcon,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView(
          children: [
            const InfoTitleTextWidget(titleNm: "About"),
            const SizedBox(
              height: 10,
            ),
            Text(
              "ICIMOD is a regional intergovernmental learning and knowledge-sharing centre serving the eight regional member countries of the Hindu Kush Himalaya (HKH) – Afghanistan, Bangladesh, Bhutan, China, India, Myanmar, Nepal, and Pakistan. Working in partnership with regional and international organizations, ICIMOD aims to influence policy and practices to meet environmental and livelihood challenges emerging in the HKH. ICIMOD provides a platform for researchers, practitioners, and policy makers from the region and around the globe to generate and share knowledge, support evidence-based decision making, and encourage regional cooperation.\n\nICIMOD works through its six regional programmes: 1) Adaptation and Resilience Building, 2) Transboundary Landscapes, 3) River Basins and Cryosphere, 4) Atmosphere, 5) Mountain Environment Regional Information System, and 6) Mountain Knowledge and Action Networks. These regional programmes are supported by four thematic areas – Livelihoods, Ecosystem Services, Water and Air, and Geospatial Solutions – and underpinned by the Knowledge Management and Communication (KMC) Unit. The Regional Atmosphere Programme involves in identifying, testing, and piloting mitigation solutions; building capacity and outreach; fostering regional collaboration and building cross-border networks; and contributing to policy at local, national, regional, and global levels.\n\nThe Atmospheric Watch Initiative (AWI) was established in 2013 as part of our regional programme on Atmosphere. Until December 2019, this Initiative was known as the Atmosphere Initiative. AWI’s goal is to promote the adoption of effective measures and policies to reduce air pollution and its impacts within the HKH through improved knowledge and enhanced capacity of our regional partners. Its work includes improving scientific understanding of emissions sources, atmospheric processes and change, and air pollution impacts in the HKH. The initiative is involved in identifying, testing, and piloting mitigation solutions; building capacity and outreach; fostering regional collaboration and building cross-border networks; and contributing to policy at local, national, regional, and global levels.\n\nAWI is developing an integrated information platform linking air quality data from various platforms for enhanced decision support in the region. This open source platform provides data analysis support to professionals responsible for air quality management and regulators. Users of this system will be able to compare different pollutants as well as single pollutant observation from different publicly available data repositories (in-situ, satellite, model) giving a wider understanding of the observed situation.",
              textAlign: TextAlign.justify,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 16, height: 1.3),
            ),
            const SizedBox(
              height: 20,
            ),
            const InfoTitleTextWidget(
                titleNm: "Acknowledgement for Current Data Source"),
            const SizedBox(
              height: 10,
            ),
            const InfoDescriptionWidget(
                descText:
                    "Ground-based observation – Atmospheric Department of Environment Nepal, AirNow"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(
                descText: "Satellite products – MODIS, TROPOMI"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(
                descText: "Air quality models – GEOS-CF"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(
                descText: "Emission inventory – REAS, EDGAR-HTAP, GAINS"),
            const SizedBox(
              height: 20,
            ),
            const InfoTitleTextWidget(titleNm: "Pollutants"),
            const SizedBox(
              height: 10,
            ),
            const InfoDescriptionWidget(
                descText:
                    "Particulate Pollutants – PM2.5, PM10, PM1, TSP, AOD"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(
                descText: "Gaseous Pollutants – CO, NOx, SO2, O3"),
            const SizedBox(
              height: 20,
            ),
            const InfoTitleTextWidget(titleNm: "Data Categories"),
            const SizedBox(
              height: 10,
            ),
            const InfoDescriptionWidget(descText: "Recent (Last 24 hours)"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(descText: "Archive (Past 1 week)"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(descText: "Forecast (Next 48 hours),"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(
                descText: "Emission Inventory (Annual)"),
            const SizedBox(
              height: 20,
            ),
            const InfoTitleTextWidget(titleNm: "Contact"),
            const SizedBox(
              height: 10,
            ),
            const InfoDescriptionWidget(descText: "Bhupesh Adhikary"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(
                descText: "Senior Air Quality Specialist, Water and Air"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(descText: "ICIMOD"),
            const SizedBox(
              height: 5,
            ),
            const InfoDescriptionWidget(
                descText: "bhupesh.adhikary@icimod.org"),
            const SizedBox(
              height: 20,
            ),
            const InfoTitleTextWidget(
              titleNm: "Disclaimer!",
            ),
            const SizedBox(
              height: 10,
            ),
            const InfoDescriptionWidget(
              descText:
                  "Quality of the datasets are attributed to original data provider quality assurance/quality control. Additional datasets continue to be added as and when they are readily available.",
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoTitleTextWidget extends StatelessWidget {
  final String titleNm;
  const InfoTitleTextWidget({
    Key? key,
    required this.titleNm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      titleNm,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: const Color.fromARGB(255, 91, 89, 89),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
    );
  }
}

class InfoDescriptionWidget extends StatelessWidget {
  final String descText;
  const InfoDescriptionWidget({Key? key, required this.descText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        descText,
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(fontSize: 16, height: 1.3),
      ),
    );
  }
}
