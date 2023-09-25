class Manufacturers {
  String? name;
  String? createdAt;
  String? id;
  List<BrandModel>? brandModels;
  String? updatedBy;
  String? updatedAt;
  String? status;
  String? sortOrder;

  Manufacturers({
    this.name,
    this.createdAt,
    this.id,
    this.brandModels,
    this.updatedBy,
    this.updatedAt,
    this.status,
    this.sortOrder,
  });

  Manufacturers.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
    createdAt = json['createdAt'] as String?;
    id = json['_id'] as String?;
    if (json['models'] != null) {
      final modelsList = json['models'] as List;
      brandModels = <BrandModel>[];
      for (var v in modelsList) {
        brandModels!.add(BrandModel.fromJson(v as Map<String, dynamic>));
      }
    }
    updatedBy = json['updatedBy'] as String?;
    updatedAt = json['updatedAt'] as String?;
    status = json['status'] as String?;
    sortOrder = json['sortOrder'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['_id'] = id;
    if (brandModels != null) {
      data['models'] = brandModels!.map((v) => v.toJson()).toList();
    }
    data['updatedBy'] = updatedBy;
    data['updatedAt'] = updatedAt;
    data['status'] = status;
    data['sortOrder'] = sortOrder;
    return data;
  }
}

class BrandModel {
  String? manufacturer;
  String? createdAt;
  String? id;
  String? name;
  String? slug;
  String? status;

  BrandModel(
      {this.manufacturer,
      this.createdAt,
      this.id,
      this.name,
      this.slug,
      this.status});

  BrandModel.fromJson(Map<String, dynamic> json) {
    manufacturer = json['manufacturer'] as String?;
    createdAt = json['createdAt'] as String?;
    id = json['_id'] as String?;
    name = json['name'] as String?;
    slug = json['slug'] as String?;
    status = json['status'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['manufacturer'] = manufacturer;
    data['createdAt'] = createdAt;
    data['_id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['status'] = status;
    return data;
  }
}
