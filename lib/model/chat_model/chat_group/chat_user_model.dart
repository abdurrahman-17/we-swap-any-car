class ChatUserModel {
  String? userId;
  String? userName;
  String? userImage;
  String? userType;
  num? rating;

  ChatUserModel({
    this.userId,
    this.userName,
    this.userImage,
    this.userType,
    this.rating,
  });

  ChatUserModel.fromJson(Map<String, dynamic> json) {
    userId = json["userId"] as String?;
    userName = json["userName"] as String?;
    userImage = json["userImage"] as String?;
    userType = json["userType"] as String?;
    rating = json["rating"] as num?;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "userId": userId,
        "userName": userName,
        "userImage": userImage,
        "userType": userType,
        "rating": rating,
      };

  Map<String, dynamic> getTransactionUser() => <String, dynamic>{
        "id": userId,
        "userName": userName,
        if (userImage != null) "avatarImage": userImage,
        if (userType != null) "userType": userType,
      };
}
