import 'dart:convert';

class AppPreferences {
  String? selectedGroup;
  String? currentUserId;

  AppPreferences({this.selectedGroup, this.currentUserId});

  factory AppPreferences.fromJson(String str) =>
      AppPreferences.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppPreferences.fromMap(Map<String, dynamic> json) =>
      AppPreferences(selectedGroup: json["selected_group"]);

  Map<String, dynamic> toMap() => {"selected_group": selectedGroup};
}
