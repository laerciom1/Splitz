import 'package:splitz/data/models/splitwise/common/group_full.dart';

class GetGroupsResponse {
  final List<FullGroup> groups;

  GetGroupsResponse({required this.groups});

  factory GetGroupsResponse.fromMap(Map<String, dynamic> json) =>
      GetGroupsResponse(
        groups: json["groups"] == null
            ? []
            : List<FullGroup>.from(json["groups"]!.map((x) => FullGroup.fromMap(x))),
      );
}
