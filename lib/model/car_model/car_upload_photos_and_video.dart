class UploadPhotosAndVideo {
  List<String>? rightImages;
  List<String>? leftImages;
  List<String>? frontImages;
  List<String>? rearImages;
  List<String>? interiorImages;
  List<String>? bootSpaceImages;
  List<String>? adittionalImages;
  List<String>? videos;

  UploadPhotosAndVideo({
    this.rightImages,
    this.leftImages,
    this.frontImages,
    this.rearImages,
    this.interiorImages,
    this.bootSpaceImages,
    this.adittionalImages,
    this.videos,
  });

  factory UploadPhotosAndVideo.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? rightImages = json['rightImages'] as List?;
    final List<dynamic>? leftImages = json['leftImages'] as List?;
    final List<dynamic>? frontImages = json['frontImages'] as List?;
    final List<dynamic>? rearImages = json['rearImages'] as List?;
    final List<dynamic>? interiorImages = json['interiorImages'] as List?;
    final List<dynamic>? bootSpaceImages = json['bootSpaceImages'] as List?;
    final List<dynamic>? adittionalImages = json['adittionalImages'] as List?;
    final List<dynamic>? videos = json['videos'] as List?;

    return UploadPhotosAndVideo(
      rightImages: List<String>.from((rightImages ?? []).map((x) => x)),
      leftImages: List<String>.from((leftImages ?? []).map((x) => x)),
      frontImages: List<String>.from((frontImages ?? []).map((x) => x)),
      rearImages: List<String>.from((rearImages ?? []).map((x) => x)),
      interiorImages: List<String>.from((interiorImages ?? []).map((x) => x)),
      bootSpaceImages: List<String>.from((bootSpaceImages ?? []).map((x) => x)),
      adittionalImages:
          List<String>.from((adittionalImages ?? []).map((x) => x)),
      videos: List<String>.from((videos ?? []).map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        'rightImages': List<dynamic>.from(rightImages!.map((x) => x)),
        'leftImages': List<dynamic>.from(leftImages!.map((x) => x)),
        'frontImages': List<dynamic>.from(frontImages!.map((x) => x)),
        'rearImages': List<dynamic>.from(rearImages!.map((x) => x)),
        'interiorImages': List<dynamic>.from(interiorImages!.map((x) => x)),
        'bootSpaceImages': List<dynamic>.from(bootSpaceImages!.map((x) => x)),
        'adittionalImages': List<dynamic>.from(adittionalImages!.map((x) => x)),
        'videos': List<dynamic>.from(videos!.map((x) => x)),
      };
}
