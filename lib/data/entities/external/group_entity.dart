import 'package:splitz/data/entities/external/member_entity.dart';
import 'package:splitz/data/models/splitwise/common/group_full.dart';

class GroupEntity {
  final String name;
  final String imageUrl;
  final int id;
  final DateTime updatedAt;
  final List<MemberEntity> members;

  GroupEntity({
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.updatedAt,
    required this.members,
  });

  factory GroupEntity.fromSplitwiseModel(FullGroup model) => GroupEntity(
        name: model.name,
        imageUrl: model.coverPhoto.xxlarge,
        id: model.id,
        updatedAt: model.updatedAt,
        members: model.members.map(MemberEntity.fromSplitwiseModel).toList(),
      );
}
