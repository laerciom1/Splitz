import 'package:splitz/data/models/splitwise/common/group_full.dart';

class GetGroupResponse {
  final FullGroup group;

  GetGroupResponse({required this.group});

  factory GetGroupResponse.fromMap(Map<String, dynamic> json) =>
      GetGroupResponse(group: FullGroup.fromMap(json["group"]));
}
