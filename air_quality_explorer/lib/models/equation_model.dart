class EquationCalculationTableModel {
  EquationCalculationTableModel({
    this.id,
    this.pollutantLayerType,
    required this.bpLo,
    required this.bpHi,
    required this.iLo,
    required this.iHi,
    required this.hour,
    this.category,
    required this.message,
  });
  int? id;
  String? pollutantLayerType;
  double bpLo;
  double bpHi;
  int iLo;
  int iHi;
  int hour;
  String? category;
  String? message;
}
