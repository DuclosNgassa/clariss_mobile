class Category {
  int id;
  String title;
  int parentid;
  String imageUrl;

  Category({this.id, this.title, this.parentid, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      title: json["title"],
      parentid: json["parentid"],
      imageUrl: json["imageUrl"],
    );
  }

  //To use when retrieving category from sharedpreference
  factory Category.fromJsonPref(Map<String, dynamic> json) {
    return Category(
      id: int.parse(json["id"]),
      title: json["title"],
      parentid: json["parentid"] == "null" ? null : int.parse(json["parentid"]),
      imageUrl: json["imageUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.toString(),
        'title': title,
        'parentid': parentid.toString(),
        'imageUrl': imageUrl,
      };
}
