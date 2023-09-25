class CarAnalytics {
  num? likes;
  num? views;
  num? offersReceived;
  num? matches;
  num? opens;

  CarAnalytics(
      {this.likes, this.views, this.offersReceived, this.matches, this.opens});

  CarAnalytics.fromJson(Map<String, dynamic> json) {
    likes = json['likes'] as num?;
    views = json['views'] as num?;
    offersReceived = json['offersReceived'] as num?;
    matches = json['matches'] as num?;
    opens = json['opens'] as num?;
  }

  Map<String, dynamic> toJson() => {
        'likes': likes,
        'views': views,
        'offersReceived': offersReceived,
        'matches': matches,
        'opens': opens,
      };
}
