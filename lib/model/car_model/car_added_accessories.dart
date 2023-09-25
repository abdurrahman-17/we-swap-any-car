class AddedAccessories {
  List<ListedItem>? listedItems;
  List<NotListedItem>? notListedItems;

  AddedAccessories({
    this.listedItems,
    this.notListedItems,
  });

  AddedAccessories.fromJson(Map<String, dynamic> json) {
    if (json['listed'] != null) {
      listedItems = [];
      for (final item in json['listed'] as List) {
        listedItems!.add(ListedItem.fromJson(item as Map<String, dynamic>));
      }
    }
    if (json['notListed'] != null) {
      notListedItems = [];
      for (final item in json['notListed'] as List) {
        notListedItems!
            .add(NotListedItem.fromJson(item as Map<String, dynamic>));
      }
    }
  }

  Map<String, dynamic> toJson() => {
        'listed': (listedItems ?? []).map((e) => e.toJson()).toList(),
        'notListed': (notListedItems ?? []).map((e) => e.toJson()).toList(),
      };
}

//Listeditem
class ListedItem {
  String? id;
  bool? exist;
  String? name;

  ListedItem({this.id, this.exist, this.name});

  ListedItem.fromJson(Map<String, dynamic> json) {
    if (json['_id'] != null) {
      id = json['_id'] as String?;
    }
    if (json['id'] != null) {
      id = json['id'] as String?;
    }
    exist = json['exist'] as bool?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exist': exist,
        'name': name,
      };
}

// Not Listed
class NotListedItem {
  NotListedItem({this.name});
  String? name;

  NotListedItem.fromJson(Map<String, dynamic> json) {
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
