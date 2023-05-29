import 'package:air_quality_explorer/core/enum.dart';
import 'package:air_quality_explorer/models/select_pollutantnm_model.dart';
import 'package:air_quality_explorer/module/home/controller/home_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class LayersControlsScreenController extends GetxController {
  var slelectPolutance = 0.obs;
  var radioGroupValue = 0.obs;
  var radioGroupValueArchive = 0.obs;
  var radioGroupValueForcast = 0.obs;
  var ratingGroundRecent = 30.obs;
  var ratingSurfaceRecent = 45.obs;
  var ratingGroundArchive = 20.obs;
  var ratingSurfaceArchive = 40.obs;
  var ratingModelArchive1 = 20.obs;
  var ratingModelArchive2 = 10.obs;
  var ratingSateliteArchive1 = 20.obs;
  var ratingSateliteArchive2 = 40.obs;
  var ratingSateliteArchiveSO21 = 40.obs;
  var ratingSateliteArchiveSO22 = 40.obs;
  var ratingModelForecast = 20.obs;
  var ratingSateliteForecast = 40.obs;
  var isLayerSelected = true.obs;
  var selectedArchivePolutanceNm = "PM2.5".obs;
  var selectedForcastPolutanceNm = "PM2.5".obs;
  // var arrPollutantModel = <SelectPollutantModel>[].obs;
  // List<SelectPollutantModel> selectAllLayer = [];
  // var selectLayerTitleNmArr = [].obs;
  // var totalLayerSelect = [].obs;
  final homeCntrl = Get.find<HomeScreenController>();
  final selectedLayerArr = <SelectedModelArr>[].obs;

  // Terramodis-AOD
  final DateTime now = DateTime.now();
  late Rx<DateTime> dateMin = DateTime(now.year, now.month, now.day - 6).obs;
  late Rx<DateTime> dateMax = DateTime(now.year, now.month, now.day + 2).obs;
  DateTime value = DateTime.now();
  var ifChangeDate = false.obs;
  late Rx<SfRangeValues> dateValues =
      SfRangeValues(DateTime(now.year, now.month, now.day), DateTime.now()).obs;
  var isSelectRangeForcast = false.obs;

  //// Add select layer control list

  var layerControlGroupList = <Menu>[].obs;

  // Add layer value in array.
  addLayerControllList(List<SelectPollutantModel> selectedList) {
    /// Terramodis True color
    SelectPollutantModel mTerraModisTrueColor = SelectPollutantModel(
        pollutantNm: 'TerraModis-TrueColor',
        status: false,
        showLegends: false,
        layerenum: SelectPollutantLayerNM.terraModisTrueColor);
    ///// PM2.5
    var mSurfaceObservariobAODSO2 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.mSurfaceObservariobAOD.pollutantNm)
        .toList();
    if (mSurfaceObservariobAODSO2.isNotEmpty) {
      homeCntrl.mSurfaceObservariobAOD.status = true;
    } else {
      homeCntrl.mSurfaceObservariobAOD.status = false;
    }
    var mGroundObservationPM2p5 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.mGroundObservationPM2.pollutantNm)
        .toList();
    if (mGroundObservationPM2p5.isNotEmpty) {
      homeCntrl.mGroundObservationPM2.status = true;
    } else {
      homeCntrl.mGroundObservationPM2.status = false;
    }

    var mTerraModisTrueColorPM2p5 = selectedList
        .where((element) =>
            element.pollutantNm == mTerraModisTrueColor.pollutantNm)
        .toList();
    if (mTerraModisTrueColorPM2p5.isNotEmpty) {
      mTerraModisTrueColor.status = true;
    } else {
      mTerraModisTrueColor.status = false;
    }
    var mGEOSPM2p5 = selectedList
        .where(
            (element) => element.pollutantNm == homeCntrl.mGEOSPM2.pollutantNm)
        .toList();

    if (mGEOSPM2p5.isNotEmpty) {
      homeCntrl.mGEOSPM2.status = true;
    } else {
      homeCntrl.mGEOSPM2.status = false;
    }
    var modelPM25ErfChemPM2p5 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.modelPM25ErfChem.pollutantNm)
        .toList();
    if (modelPM25ErfChemPM2p5.isNotEmpty) {
      homeCntrl.modelPM25ErfChem.status = true;
    } else {
      homeCntrl.modelPM25ErfChem.status = false;
    }
    Menu pM2p5 = Menu(name: "PM2.5", subMenuList: [
      homeCntrl.mSurfaceObservariobAOD,
      homeCntrl.mGroundObservationPM2,
      mTerraModisTrueColor,
      homeCntrl.mGEOSPM2,
      homeCntrl.modelPM25ErfChem
    ]);

    ///// CO
    var mTropomiCoTropomiGeeCO = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.mTropomiCoTropomiGee.pollutantNm)
        .toList();
    if (mTropomiCoTropomiGeeCO.isNotEmpty) {
      homeCntrl.mTropomiCoTropomiGee.status = true;
    } else {
      homeCntrl.mTropomiCoTropomiGee.status = false;
    }
    var mGeosCoCO = selectedList
        .where(
            (element) => element.pollutantNm == homeCntrl.mGeosCo.pollutantNm)
        .toList();
    if (mGeosCoCO.isNotEmpty) {
      homeCntrl.mGeosCo.status = true;
    } else {
      homeCntrl.mGeosCo.status = false;
    }
    var sateliiteCO2ServirAstCO = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.sateliiteCO2ServirAst.pollutantNm)
        .toList();
    if (sateliiteCO2ServirAstCO.isNotEmpty) {
      homeCntrl.sateliiteCO2ServirAst.status = true;
    } else {
      homeCntrl.sateliiteCO2ServirAst.status = false;
    }
    var modelCOWrfChemCO = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.modelCOWrfChem.pollutantNm)
        .toList();
    if (modelCOWrfChemCO.isNotEmpty) {
      homeCntrl.modelCOWrfChem.status = true;
    } else {
      homeCntrl.modelCOWrfChem.status = false;
    }
    Menu cO = Menu(name: "CO", subMenuList: [
      homeCntrl.mTropomiCoTropomiGee,
      homeCntrl.mGeosCo,
      homeCntrl.sateliiteCO2ServirAst,
      homeCntrl.modelCOWrfChem,
    ]);

    ///// O3
    var mGEOSo3 = selectedList
        .where(
            (element) => element.pollutantNm == homeCntrl.mGEOSO3.pollutantNm)
        .toList();
    if (mGEOSo3.isNotEmpty) {
      homeCntrl.mGEOSO3.status = true;
    } else {
      homeCntrl.mGEOSO3.status = false;
    }
    var modelO3WrfChemO3 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.modelO3WrfChem.pollutantNm)
        .toList();
    if (modelO3WrfChemO3.isNotEmpty) {
      homeCntrl.modelO3WrfChem.status = true;
    } else {
      homeCntrl.modelO3WrfChem.status = false;
    }
    var mTerraModisAODO3 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.mTerraModisAOD.pollutantNm)
        .toList();
    if (mTerraModisAODO3.isNotEmpty) {
      homeCntrl.mTerraModisAOD.status = true;
    } else {
      homeCntrl.mTerraModisAOD.status = false;
    }
    Menu o3 = Menu(name: "O3", subMenuList: [
      homeCntrl.mGEOSO3,
      homeCntrl.modelO3WrfChem,
      homeCntrl.mTerraModisAOD,
    ]);

    //// NO2
    var mTropomiNo2ServirAstNO2 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.mTropomiNo2ServirAst.pollutantNm)
        .toList();
    if (mTropomiNo2ServirAstNO2.isNotEmpty) {
      homeCntrl.mTropomiNo2ServirAst.status = true;
    } else {
      homeCntrl.mTropomiNo2ServirAst.status = false;
    }
    var mGEOSnO2 = selectedList
        .where(
            (element) => element.pollutantNm == homeCntrl.mGEOSNO2.pollutantNm)
        .toList();
    if (mGEOSnO2.isNotEmpty) {
      homeCntrl.mGEOSNO2.status = true;
    } else {
      homeCntrl.mGEOSNO2.status = false;
    }
    var sateliiteNO2ServirAstNO2 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.sateliiteNO2ServirAst.pollutantNm)
        .toList();
    if (sateliiteNO2ServirAstNO2.isNotEmpty) {
      homeCntrl.sateliiteNO2ServirAst.status = true;
    } else {
      homeCntrl.sateliiteNO2ServirAst.status = false;
    }
    var modelNO2WrfChemNO2 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.modelNO2WrfChem.pollutantNm)
        .toList();
    if (modelNO2WrfChemNO2.isNotEmpty) {
      homeCntrl.modelNO2WrfChem.status = true;
    } else {
      homeCntrl.modelNO2WrfChem.status = false;
    }
    Menu nO2 = Menu(name: "NO2", subMenuList: [
      homeCntrl.mTropomiNo2ServirAst,
      homeCntrl.mGEOSNO2,
      homeCntrl.sateliiteNO2ServirAst,
      homeCntrl.modelNO2WrfChem
    ]);

    /// SO2

    var mTropomiSO2 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.mTropomiSo2.pollutantNm)
        .toList();
    if (mTropomiSO2.isNotEmpty) {
      homeCntrl.mTropomiSo2.status = true;
    } else {
      homeCntrl.mTropomiSo2.status = false;
    }
    var sateliiteSO2ServirAstSO2 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.sateliiteSO2ServirAst.pollutantNm)
        .toList();
    if (sateliiteSO2ServirAstSO2.isNotEmpty) {
      homeCntrl.sateliiteSO2ServirAst.status = true;
    } else {
      homeCntrl.sateliiteSO2ServirAst.status = false;
    }
    var modelSO2WrfChemSO2 = selectedList
        .where((element) =>
            element.pollutantNm == homeCntrl.modelSO2WrfChem.pollutantNm)
        .toList();
    if (modelSO2WrfChemSO2.isNotEmpty) {
      homeCntrl.modelSO2WrfChem.status = true;
    } else {
      homeCntrl.modelSO2WrfChem.status = false;
    }
    var mGEOSSO2 = selectedList
        .where(
            (element) => element.pollutantNm == homeCntrl.mGEOSsO2.pollutantNm)
        .toList();
    if (mGEOSSO2.isNotEmpty) {
      homeCntrl.mGEOSsO2.status = true;
    } else {
      homeCntrl.mGEOSsO2.status = false;
    }
    Menu sO2 = Menu(name: "SO2", subMenuList: [
      homeCntrl.mTropomiSo2,
      homeCntrl.sateliiteSO2ServirAst,
      homeCntrl.modelSO2WrfChem,
      homeCntrl.mGEOSsO2
    ]);
    layerControlGroupList.add(pM2p5);
    layerControlGroupList.add(cO);
    layerControlGroupList.add(o3);
    layerControlGroupList.add(nO2);
    layerControlGroupList.add(sO2);
  }
}
