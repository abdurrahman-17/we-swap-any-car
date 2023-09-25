class HPIHistoryCheck {
  num? v5cDataQty;
  bool? vehicleIdentityCheckQty;
  num? keeperChangesQty;
  bool? colourChangesQty;
  bool? financeDataQty;
  bool? cherishedDataQty;
  bool? conditionDataQty;
  bool? stolenVehicleDataQty;
  bool? highRiskDataQty;
  bool? isScrapped;

  HPIHistoryCheck(
      {this.v5cDataQty,
      this.vehicleIdentityCheckQty,
      this.keeperChangesQty,
      this.colourChangesQty,
      this.financeDataQty,
      this.cherishedDataQty,
      this.conditionDataQty,
      this.stolenVehicleDataQty,
      this.highRiskDataQty,
      this.isScrapped});

  HPIHistoryCheck.fromJson(Map<String, dynamic> json) {
    v5cDataQty = json['v5cDataQty'] as num?;
    vehicleIdentityCheckQty = json['vehicleIdentityCheckQty'] as bool?;
    keeperChangesQty = json['KeeperChangesQty'] as num?;
    colourChangesQty = json['colourChangesQty'] as bool?;
    financeDataQty = json['financeDataQty'] as bool?;
    cherishedDataQty = json['cherishedDataQty'] as bool?;
    conditionDataQty = json['conditionDataQty'] as bool?;
    stolenVehicleDataQty = json['stolenVehicleDataQty'] as bool?;
    highRiskDataQty = json['highRiskDataQty'] as bool?;
    isScrapped = json['isScrapped'] as bool?;
  }

  Map<String, dynamic> toJson() => {
        'v5cDataQty': v5cDataQty,
        'vehicleIdentityCheckQty': vehicleIdentityCheckQty,
        'KeeperChangesQty': keeperChangesQty,
        'colourChangesQty': colourChangesQty,
        'financeDataQty': financeDataQty,
        'cherishedDataQty': cherishedDataQty,
        'conditionDataQty': conditionDataQty,
        'stolenVehicleDataQty': stolenVehicleDataQty,
        'highRiskDataQty': highRiskDataQty,
        'isScrapped': isScrapped,
      };
}
