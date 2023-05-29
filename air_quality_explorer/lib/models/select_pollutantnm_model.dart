import 'package:air_quality_explorer/core/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';

class SelectPollutantModel {
  SelectPollutantModel({
    required this.pollutantNm,
    this.isLayerType = true,
    this.status = false,
    this.opacity = 0.5,
    this.showOpacity = true,
    this.defaultSelect = false,
    this.isExpanded = false,
    this.showLegends = true,
    this.isPlay = false,
    this.tileWmsOption,
    this.layerenum = SelectPollutantLayerNM.terraModisTrueColor,
  });
  late final String pollutantNm;
  bool isLayerType;
  bool status;
  double opacity;
  bool showOpacity;
  bool defaultSelect;
  bool isExpanded;
  bool showLegends;
  bool isPlay;
  WMSTileLayerOptions? tileWmsOption;
  SelectPollutantLayerNM? layerenum;

  WMSTileLayerOptions getLayer(
      {required String date1, required bool isForcast}) {
    WMSTileLayerOptions? wmslayer;
    String date = "";
    if (date1.isEmpty) {
      if (isForcast) {
        var preDate = DateTime.now().add(const Duration(days: 1));
        String formattedDate = DateFormat('yyyy-MM-dd').format(preDate);
        date = formattedDate;
      } else {
        var preDate = DateTime.now().subtract(const Duration(days: 1));
        String formattedDate = DateFormat('yyyy-MM-dd').format(preDate);
        date = formattedDate;
      }
    } else {
      date = date1;
    }
    switch (layerenum) {
      case SelectPollutantLayerNM.terraModisTrueColor:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/TerraMODIS-TrueColor1km/ModisTerra-TrueColor-$date.nc?",
            layers: ["red"],
            format: "image/png",
            transparent: true,
            otherParameters: {
              "layerName": "TerraModis-TrueColor",
              "SLD_BODY":
                  '<?xml version="1.0" encoding="ISO-8859-1"?><StyledLayerDescriptor version="1.1.0" xsi:schemaLocation="http://www.opengis.net/sldStyledLayerDescriptor.xsd"                       xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"                       xmlns:se="http://www.opengis.net/se" xmlns:xlink="http://www.w3.org/1999/xlink"                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:resc="http://www.resc.reading.ac.uk">    <NamedLayer>     <se:Name>red</se:Name>        <UserStyle>            <se:Name>Thesholded colour scheme</se:Name>            <se:CoverageStyle>                <se:Rule>                    <resc:RasterRGBSymbolizer>                        <se:Opacity>1.0</se:Opacity>                        <se:ColorMap>                            <resc:RedBand>                                <resc:BandName>red</resc:BandName>                                <resc:Range>                                    <resc:Minimum>0</resc:Minimum>                                    <resc:Maximum>255</resc:Maximum>                                </resc:Range>                            </resc:RedBand>                            <resc:GreenBand>                                <resc:BandName>green</resc:BandName>                                <resc:Range>                                    <resc:Minimum>0</resc:Minimum>                                    <resc:Maximum>255</resc:Maximum>                                </resc:Range>                            </resc:GreenBand>                            <resc:BlueBand>                                <resc:BandName>blue</resc:BandName>                                <resc:Range>                                    <resc:Minimum>1</resc:Minimum>                                    <resc:Maximum>255</resc:Maximum>                                    <resc:Spacing>linear</resc:Spacing>                                </resc:Range>                            </resc:BlueBand>                        </se:ColorMap>                    </resc:RasterRGBSymbolizer>                </se:Rule>            </se:CoverageStyle>        </UserStyle>    </NamedLayer></StyledLayerDescriptor>',
            });
        break;

      case SelectPollutantLayerNM.modelPM25GEOS:
        wmslayer = isForcast != true
            //// Archiv
            ? WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/PM/GEOS-PM2p5/Geos-PM2p5-$date-00-30.nc?",
                layers: ["PM2p5"],
                format: "image/png",
                transparent: true,
                styles: ["default-scalar/x-Rainbow"],
                otherParameters: {
                  "COLORSCALERANGE": "0,100",
                })
            //// Forcast
            : WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230515/aero_trgas.d01.2023051702.latlon.nc?",
                format: "image/png",
                transparent: true,
                styles: [
                    "default-scalar/x-Rainbow"
                  ],
                otherParameters: {
                    "COLORSCALERANGE": "0,100",
                    "layer": "PM25_SFC",
                    "catalogUrl":
                        "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/$date/catalog.xml",
                    "urlWithoutNC":
                        "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/",
                  });
        break;

      case SelectPollutantLayerNM.satelliteAODTERRAMODIS:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/PM/TerraModis-AOD/Terra-MODIS-AOD-$date.nc?",
            layers: ["aod_550"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0.01,1"});
        break;
      case SelectPollutantLayerNM.modelO3GEOS:
        wmslayer = isForcast != true
            //// Archiv
            ? WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/O3/GEOS-O3/Geos-O3-$date-00-30.nc?",
                layers: ["O3"],
                format: "image/png",
                transparent: true,
                styles: ["default-scalar/x-Rainbow"],
                otherParameters: {"COLORSCALERANGE": "0,80"})

            /// Forcast
            : WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/O3/GEOS-O3/20230310/Geos-O3-2023-03-10-12-30.nc?",
                layers: ["O3"],
                format: "image/png",
                transparent: true,
                styles: ["default-scalar/x-Rainbow"],
                otherParameters: {
                  "COLORSCALERANGE": "0,80",
                  "catalogUrl":
                      "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/O3/GEOS-O3/$date/catalog.xml",
                  "urlWithoutNC":
                      "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/O3/GEOS-O3/",
                  "layer": "O3_TOTCOL"
                });
        break;
      case SelectPollutantLayerNM.satelliteSO2TROPOMIGEE:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/SO2/TROPOMI-SO2/TROPOMI-SO2-$date.nc?",
            layers: ["SO2"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0.01,1"});
        break;
      case SelectPollutantLayerNM.modelSO2GEOS:
        wmslayer = isForcast != true
            //// Archiv
            ? WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/SO2/GEOS-SO2/Geos-SO2-$date-12-30.nc?",
                layers: ["SO2"],
                format: "image/png",
                transparent: true,
                styles: ["default-scalar/x-Rainbow"],
                otherParameters: {"COLORSCALERANGE": "0.01,10"})
            //// Forecast
            : WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
                // layers: ["SO2"],
                format: "image/png",
                transparent: true,
                styles: [
                    "default-scalar/x-Rainbow"
                  ],
                otherParameters: {
                    "COLORSCALERANGE": "0.01,10",
                    "catalogUrl":
                        "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/SO2/GEOS-SO2/$date/catalog.xml",
                    "urlWithoutNC":
                        "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/SO2/GEOS-SO2/",
                    "layer": "SO2_SFC"
                  });
        break;
      case SelectPollutantLayerNM.satelliteNO2TROPOMIGEE:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/NO2/TROPOMI-NO2/TROPOMI-NO2-$date.nc?",
            layers: ["NO2"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0.01,10"});
        break;
      case SelectPollutantLayerNM.modelNO2GEOS:
        wmslayer = isForcast != true
            //// Archiv
            ? WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/NO2/GEOS-NO2/Geos-NO2-$date-12-30.nc?",
                layers: ["NO2"],
                format: "image/png",
                transparent: true,
                styles: ["default-scalar/x-Rainbow"],
                otherParameters: {"COLORSCALERANGE": "0,10"})
            //// Forcast
            : WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/NO2/GEOS-NO2/20230310/Geos-NO2-2023-03-10-12-30.nc?",
                layers: ["NO2"],
                format: "image/png",
                transparent: true,
                styles: ["default-scalar/x-Rainbow"],
                otherParameters: {
                  "COLORSCALERANGE": "0,10",
                  "catalogUrl":
                      "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/NO2/GEOS-NO2/$date/catalog.xml",
                  "urlWithoutNC":
                      "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/NO2/GEOS-NO2/",
                  "layer": "NO2"
                });
        break;
      case SelectPollutantLayerNM.satelliteCOTROPOMIGEE:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/CO/TROPOMI-CO/TROPOMI-CO-$date.nc?",
            layers: ["CO"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "1,4"});
        break;
      case SelectPollutantLayerNM.modelCOGEOS:
        wmslayer = isForcast != true
            ? WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/CO/GEOS-CO/Geos-CO-$date-12-30.nc?",
                layers: ["CO"],
                format: "image/png",
                transparent: true,
                styles: ["default-scalar/x-Rainbow"],
                otherParameters: {"COLORSCALERANGE": "1,500"})
            : WMSTileLayerOptions(
                baseUrl:
                    "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/CO/GEOS-CO/20230310/Geos-CO-2023-03-10-12-30.nc?",
                layers: ["CO"],
                format: "image/png",
                transparent: true,
                styles: ["default-scalar/x-Rainbow"],
                otherParameters: {
                  "COLORSCALERANGE": "0,500",
                  "catalogUrl":
                      "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/CO/GEOS-CO/$date/catalog.xml",
                  "urlWithoutNC":
                      "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/CO/GEOS-CO/",
                  "layer": "CO",
                });
        break;
      case SelectPollutantLayerNM.satelliteSO2TROPOMISERVIRAST:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/SO2/AST-HKH-SO2/dataS5P_NRTI_L3__SO2_hkh_2023-03-05.nc?",
            layers: ["SO2"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0,10"});
        break;
      case SelectPollutantLayerNM.satelliteNO2TROPOMISERVIRAST:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/NO2/AST-HKH-NO2/dataS5P_NRTI_L3__NO2_hkh_2023-03-03.nc?",
            layers: ["NO2"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0,10"});
        break;
      case SelectPollutantLayerNM.satelliteCOTROPOMISERVIRAST:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/RecentAndArchive/CO/AST-HKH-CO/S5P_NRTI_L3__CO_hkh_2023-03-05.nc?",
            layers: ["vertical_column"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "1,4"});
        break;
      case SelectPollutantLayerNM.modelPM25WRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["PM25_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,100",
              "catalogUrl":
                  "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/$date/catalog.xml",
              "urlWithoutNC":
                  "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/",
            });
        break;
      case SelectPollutantLayerNM.modelO3WRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["O3_TOTCOL"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,80",
              "layer": "O3_TOTCOL",
              "catalogUrl":
                  "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/$date/catalog.xml",
              "urlWithoutNC":
                  "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/",
            });
        break;
      case SelectPollutantLayerNM.modelSO2WRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["SO2_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,10",
              "layer": "SO2_SFC",
              "catalogUrl":
                  "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/$date/catalog.xml",
              "urlWithoutNC":
                  "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/",
            });
        break;

      case SelectPollutantLayerNM.modelNO2WRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["NO2_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,10",
              "layerName": "NO2_SFC",
              "catalogUrl":
                  "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/$date/catalog.xml",
              "urlWithoutNC":
                  "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/",
            });
        break;

      case SelectPollutantLayerNM.modelCOWRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["CO_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,500",
              "layerName": "CO_SFC",
              "catalogUrl":
                  "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/$date/catalog.xml",
              "urlWithoutNC":
                  "http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/",
            });
        break;
      default:
    }
    return wmslayer!;
  }

  /// Forcast layer
  /*  WMSTileLayerOptions getForcastLayer(String date) {
    WMSTileLayerOptions? wmslayer;
    switch (layerenum) {
      case SelectPollutantLayerNM.modelPM25GEOS:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/PM/GEOS-PM2p5/20230310/Geos-PM2p5-2023-03-10-12-30.nc?",
            layers: ["PM2p5"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0,100"});
        break;
      case SelectPollutantLayerNM.modelPM25WRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["PM25_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0,100"});
        break;
      case SelectPollutantLayerNM.modelO3GEOS:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/O3/GEOS-O3/20230310/Geos-O3-2023-03-10-12-30.nc?",
            layers: ["O3"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0,80"});
        break;
      case SelectPollutantLayerNM.modelO3WRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["O3_TOTCOL"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,80",
              "layerName": "O3_TOTCOL"
            });
        break;
      case SelectPollutantLayerNM.modelSO2GEOS:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["SO2_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,10",
              "layerName": "SO2_SFC"
            });
        break;
      case SelectPollutantLayerNM.modelSO2WRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["SO2_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,10",
              "layerName": "SO2_SFC"
            });
        break;
      case SelectPollutantLayerNM.modelNO2GEOS:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/NO2/GEOS-NO2/20230310/Geos-NO2-2023-03-10-12-30.nc?",
            layers: ["NO2"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0,10"});
        break;
      case SelectPollutantLayerNM.modelNO2WRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["NO2_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,10",
              "layerName": "NO2_SFC"
            });
        break;
      case SelectPollutantLayerNM.modelCOGEOS:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/CO/GEOS-CO/20230310/Geos-CO-2023-03-10-12-30.nc?",
            layers: ["CO"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {"COLORSCALERANGE": "0,500"});
        break;
      case SelectPollutantLayerNM.modelCOWRFCHEM:
        wmslayer = WMSTileLayerOptions(
            baseUrl:
                "http://smog.icimod.org/apps/airqualitynp/WMSProxy/http://smog.spatialapps.net:8080/thredds/wms/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/20230310/aero_trgas.d01.2023031012.latlon.nc?",
            layers: ["CO_SFC"],
            format: "image/png",
            transparent: true,
            styles: ["default-scalar/x-Rainbow"],
            otherParameters: {
              "COLORSCALERANGE": "0,500",
              "layerName": "CO_SFC"
            });
        break;
      default:
    }
    return wmslayer!;
  }
 */
}

class Menu {
  String? name;
  List<SelectPollutantModel>? subMenuList;
  Menu({this.name, this.subMenuList});
}

class SelectedModelArr {
  int? mainIndex;
  int? subIndex;
  SelectPollutantModel? selectedLayer;
  SelectedModelArr({this.mainIndex, this.subIndex, this.selectedLayer});
}
