import 'dart:convert';

import 'package:splitz/data/models/splitwise/common/group.dart';

class GetGroupResponse {
  Group? group;

  GetGroupResponse({
    this.group,
  });

  GetGroupResponse copyWith({
    Group? group,
  }) =>
      GetGroupResponse(
        group: group ?? this.group,
      );

  factory GetGroupResponse.fromJson(String str) =>
      GetGroupResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetGroupResponse.fromMap(Map<String, dynamic> json) =>
      GetGroupResponse(
        group: json["group"] == null ? null : Group.fromMap(json["group"]),
      );

  Map<String, dynamic> toMap() => {
        "group": group?.toMap(),
      };
}
