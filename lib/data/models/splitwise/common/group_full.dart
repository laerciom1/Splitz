class FullGroup {
  final String name;
  final CoverPhoto coverPhoto;
  final int id;
  final DateTime updatedAt;
  final List<Member> members;

  FullGroup({
    required this.name,
    required this.coverPhoto,
    required this.id,
    required this.updatedAt,
    required this.members,
  });

  factory FullGroup.fromMap(Map<String, dynamic> json) => FullGroup(
        name: json["name"],
        id: json["id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        coverPhoto: CoverPhoto.fromMap(json["cover_photo"]),
        members: json["members"] == null
            ? []
            : List<Member>.from(json["members"]!.map((x) => Member.fromMap(x))),
      );
}

class CoverPhoto {
  final String xxlarge;

  CoverPhoto({required this.xxlarge});

  factory CoverPhoto.fromMap(Map<String, dynamic> json) =>
      CoverPhoto(xxlarge: json["xxlarge"]);
}

class Member {
  final int id;
  final String firstName;
  final Picture picture;

  Member({
    required this.id,
    required this.firstName,
    required this.picture,
  });

  factory Member.fromMap(Map<String, dynamic> json) => Member(
        id: json["id"],
        firstName: json["first_name"],
        picture: Picture.fromMap(json["picture"]),
      );
}

class Picture {
  final String large;

  Picture({required this.large});

  factory Picture.fromMap(Map<String, dynamic> json) =>
      Picture(large: json["large"]);
}
