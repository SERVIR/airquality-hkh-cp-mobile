class ApiUrl {
  static String baseurl1 = "http://smog.icimod.org/apps/airquality/";
  static String baseurl2 = "http://216.218.226.167/api/v1/";

  static String groundObservation = "${baseurl1}getData/";
  static String getRecentSaveLocation =
      "${baseurl2}lat-long/nearest-location/list/";
  static String getForecastSaveLocation =
      "${baseurl2}lat-long/nearest-forcast-location/list/";
  static String getAeronetList =
      "${baseurl2}location/source/aero_net/geos/list/";
  static String getAirnowList = "${baseurl2}location/source/air_now/geos/list/";
  static String getSlicefromCatalog = "${baseurl1}slicedfromcatalog/";
  static String getTimeseriesModeldata = "${baseurl1}timeseriesmodeldata/";
  static String getUserAddLocationRecentApi =
      "${baseurl2}lat-long/recent-archive/list/";
  static String getUserAddLocationForecastApi =
      "${baseurl2}lat-long/forcast/list/";
  static String sliceCatelogApiParamUrl =
      "http://smog.spatialapps.net:8080/thredds/catalog/HKHAirQualityWatch/RecentAndArchive/pollutantLayerNm/catalog.xml";
  static String forecastChartDataApiUrl =
      "http://smog.icimod.org:8080/thredds/catalog/HKHAirQualityWatch/Forecast/WRF_Chem/d1_HKH/date/catalog.xml";
}
