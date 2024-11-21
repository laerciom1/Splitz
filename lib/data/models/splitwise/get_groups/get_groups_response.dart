import 'dart:convert';

import 'package:splitz/data/models/splitwise/common/group.dart';

class GetGroupsResponse {
  List<Group>? groups;

  GetGroupsResponse({
    this.groups,
  });

  GetGroupsResponse copyWith({
    List<Group>? groups,
  }) =>
      GetGroupsResponse(
        groups: groups ?? this.groups,
      );

  factory GetGroupsResponse.fromJson(String str) =>
      GetGroupsResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetGroupsResponse.fromMap(Map<String, dynamic> json) =>
      GetGroupsResponse(
        groups: json["groups"] == null
            ? []
            : List<Group>.from(json["groups"]!.map((x) => Group.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "groups": groups == null
            ? []
            : List<dynamic>.from(groups!.map((x) => x.toMap())),
      };
}
