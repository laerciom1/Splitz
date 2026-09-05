import 'dart:convert';

class AppPreferencesEntity {
  String? selectedGroup;
  String? currentUserId;

  AppPreferencesEntity({this.selectedGroup, this.currentUserId});

  factory AppPreferencesEntity.fromJson(String str) {
    final map = json.decode(str);
    return AppPreferencesEntity(
      selectedGroup: map["selected_group"],
      currentUserId: map["current_user_id"],
    );
  }

  String toJson() => json.encode({
        if (selectedGroup != null) "selected_group": selectedGroup,
        if (currentUserId != null) "current_user_id": currentUserId,
      });
}
