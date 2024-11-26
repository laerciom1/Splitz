import 'dart:convert';

class AppPreferencesEntity {
  String? selectedGroup;
  String? currentUserId;

  AppPreferencesEntity({this.selectedGroup, this.currentUserId});

  factory AppPreferencesEntity.fromJson(String str) =>
      AppPreferencesEntity.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppPreferencesEntity.fromMap(Map<String, dynamic> json) =>
      AppPreferencesEntity(selectedGroup: json["selected_group"]);

  Map<String, dynamic> toMap() => {"selected_group": selectedGroup};
}
