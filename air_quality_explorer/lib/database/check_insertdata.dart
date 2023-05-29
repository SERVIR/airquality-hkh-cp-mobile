import 'dart:async';
import 'package:air_quality_explorer/models/select_pollutantnm_model.dart';
import 'package:air_quality_explorer/module/savelocation/controller/save_location_screen_controller.dart';
import 'package:air_quality_explorer/widgets/alert_box_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CheckInsertdata {
  static CheckInsertdata? _instance;
  bool checkIsSelectSurface = false;
  bool checkIsSelectGround = true;
  String selectPlayAnimationName = "TerraModis-TrueColor";
  final saveController = Get.put(SaveLocationScreenController());
  final selectedAllLayerArr = <SelectedModelArr>[].obs;
  // static final _instance = CheckInsertdata._();
  // static CheckInsertdata get instance => _instance;
  final _networkConnectivity = Connectivity();
  final _controller = StreamController.broadcast();
  Stream get myStream => _controller.stream;
  var noInternet = false.obs;

  void initialise() async {
    ConnectivityResult result = await _networkConnectivity.checkConnectivity();
    _checkStatus(result);
    _networkConnectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  CheckInsertdata._() {
    saveController.storeEuationTable();
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    switch (result) {
      case ConnectivityResult.mobile:
        noInternet.value = true;
        break;
      case ConnectivityResult.wifi:
        noInternet.value = true;
        break;
      case ConnectivityResult.none:
      default:
        noInternet.value = false;
    }
    // try {
    //   final result = await InternetAddress.lookup('example.com');
    //   isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    // } on SocketException catch (_) {
    //   isOnline = false;
    // }
    _controller.sink.add({result: isOnline});
  }

  void disposeStream() => _controller.close();

  Future<bool> handleDevicesLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
          context: Get.context!,
          builder: (context) => InformationAlertDialog(
              alrtTitle: "Please Enable Location Services",
              alertFirstButtonNm: "Okay",
              firstBtnTap: () async {
                Get.back();
                await Geolocator.openLocationSettings();
              }));

      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  factory CheckInsertdata() {
    _instance ??= CheckInsertdata._();
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }
}
