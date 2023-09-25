class ConditionAndDamage {
  String? additionalInfo;
  BrokenMissingItems? brokenMissingItems;
  Dents? dents;
  LockWheelNut? lockWheelNut;
  PaintProblem? paintProblem;
  Scratches? scratches;
  ScuffedAlloy? scuffedAlloy;
  SmokingInVehicle? smokingInVehicle;
  ToolPack? toolPack;
  TyreProblem? tyreProblem;
  WarningLightsDashboard? warningLightsDashboard;

  ConditionAndDamage({
    this.additionalInfo,
    this.brokenMissingItems,
    this.dents,
    this.lockWheelNut,
    this.paintProblem,
    this.scratches,
    this.scuffedAlloy,
    this.smokingInVehicle,
    this.toolPack,
    this.tyreProblem,
    this.warningLightsDashboard,
  });

  ConditionAndDamage.fromJson(Map<String, dynamic> json) {
    additionalInfo = json['additionalInfo'] as String?;
    if (json['brokenMissingItems'] != null) {
      brokenMissingItems = BrokenMissingItems.fromJson(
          json['brokenMissingItems'] as Map<String, dynamic>);
    }
    if (json['dents'] != null) {
      dents = Dents.fromJson(json['dents'] as Map<String, dynamic>);
    }
    if (json['lockWheelNut'] != null) {
      lockWheelNut =
          LockWheelNut.fromJson(json['lockWheelNut'] as Map<String, dynamic>);
    }
    if (json['paintProblem'] != null) {
      paintProblem =
          PaintProblem.fromJson(json['paintProblem'] as Map<String, dynamic>);
    }
    if (json['scratches'] != null) {
      scratches = Scratches.fromJson(json['scratches'] as Map<String, dynamic>);
    }
    if (json['scuffedAlloy'] != null) {
      scuffedAlloy =
          ScuffedAlloy.fromJson(json['scuffedAlloy'] as Map<String, dynamic>);
    }
    if (json['smokingInVehicle'] != null) {
      smokingInVehicle = SmokingInVehicle.fromJson(
          json['smokingInVehicle'] as Map<String, dynamic>);
    }
    if (json['toolPack'] != null) {
      toolPack = ToolPack.fromJson(json['toolPack'] as Map<String, dynamic>);
      tyreProblem =
          TyreProblem.fromJson(json['tyreProblem'] as Map<String, dynamic>);
    }
    if (json['warningLightsDashboard'] != null) {
      warningLightsDashboard = WarningLightsDashboard.fromJson(
          json['warningLightsDashboard'] as Map<String, dynamic>);
    }
  }

  Map<String, dynamic> toJson() => {
        'additionalInfo': additionalInfo,
        'brokenMissingItems': brokenMissingItems?.toJson(),
        'dents': dents?.toJson(),
        'lockWheelNut': lockWheelNut?.toJson(),
        'paintProblem': paintProblem?.toJson(),
        'scratches': scratches?.toJson(),
        'scuffedAlloy': scuffedAlloy?.toJson(),
        'smokingInVehicle': smokingInVehicle?.toJson(),
        'toolPack': toolPack?.toJson(),
        'tyreProblem': tyreProblem?.toJson(),
        'warningLightsDashboard': warningLightsDashboard?.toJson(),
      };
}

class BrokenMissingItems {
  bool? brokenMissingItems;
  List<String>? images;

  BrokenMissingItems({
    this.brokenMissingItems,
    this.images,
  });

  BrokenMissingItems.fromJson(Map<String, dynamic> json) {
    brokenMissingItems = json['brokenMissingItems'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'brokenMissingItems': brokenMissingItems,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}

class Dents {
  bool? dents;
  List<String>? images;

  Dents({
    this.dents,
    this.images,
  });

  Dents.fromJson(Map<String, dynamic> json) {
    dents = json['dents'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'dents': dents,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}

class LockWheelNut {
  bool? lockWheelNut;
  List<String>? images;

  LockWheelNut({
    this.lockWheelNut,
    this.images,
  });

  LockWheelNut.fromJson(Map<String, dynamic> json) {
    lockWheelNut = json['lockWheelNut'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'lockWheelNut': lockWheelNut,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}

class PaintProblem {
  bool? paintProblem;
  List<String>? images;

  PaintProblem({
    this.images,
    this.paintProblem,
  });

  PaintProblem.fromJson(Map<String, dynamic> json) {
    paintProblem = json['paintProblem'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'paintProblem': paintProblem,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}

class Scratches {
  bool? scratches;
  List<String>? images;

  Scratches({
    this.images,
    this.scratches,
  });

  Scratches.fromJson(Map<String, dynamic> json) {
    scratches = json['scratches'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'scratches': scratches,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}

class ScuffedAlloy {
  bool? scuffedAlloy;
  List<String>? images;

  ScuffedAlloy({
    this.images,
    this.scuffedAlloy,
  });

  ScuffedAlloy.fromJson(Map<String, dynamic> json) {
    scuffedAlloy = json['scuffedAlloy'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'scuffedAlloy': scuffedAlloy,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}

class SmokingInVehicle {
  List<String>? images;
  bool? smokingInVehicle;

  SmokingInVehicle({
    this.images,
    this.smokingInVehicle,
  });

  SmokingInVehicle.fromJson(Map<String, dynamic> json) {
    smokingInVehicle = json['smokingInVehicle'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'smokingInVehicle': smokingInVehicle,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}

class ToolPack {
  bool? toolPack;
  List<String>? images;

  ToolPack({
    this.images,
    this.toolPack,
  });

  ToolPack.fromJson(Map<String, dynamic> json) {
    toolPack = json['toolPack'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'images': List<dynamic>.from(images!.map((x) => x)),
        'toolPack': toolPack,
      };
}

class TyreProblem {
  bool? tyreProblem;
  List<String>? images;

  TyreProblem({
    this.images,
    this.tyreProblem,
  });

  TyreProblem.fromJson(Map<String, dynamic> json) {
    tyreProblem = json['tyreProblem'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'tyreProblem': tyreProblem,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}

class WarningLightsDashboard {
  List<String>? images;
  bool? warningLightsDashboard;

  WarningLightsDashboard({
    this.images,
    this.warningLightsDashboard,
  });

  WarningLightsDashboard.fromJson(Map<String, dynamic> json) {
    warningLightsDashboard = json['warningLightsDashboard'] as bool?;
    if (json['images'] != null) {
      final List<dynamic> imagesJson = json['images'] as List;
      images = List<String>.from(imagesJson.map((x) => x as String));
    }
  }

  Map<String, dynamic> toJson() => {
        'warningLightsDashboard': warningLightsDashboard,
        'images': List<dynamic>.from(images!.map((x) => x)),
      };
}
