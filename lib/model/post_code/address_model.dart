class AddressModel {
  String? address;
  String? url;
  String? id;

  AddressModel({
    this.address,
    this.url,
    this.id,
  });

  factory AddressModel.fromJson(Map<String, dynamic> data) => AddressModel(
        address: data['address'] as String?,
        url: data['url'] as String?,
        id: data['id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'address': address,
        'url': url,
        'id': id,
      };
}
