import 'package:splitz/data/models/splitwise/common/group_full.dart';

class MemberEntity {
  final int id;
  final String firstName;
  final String imageUrl;

  MemberEntity({
    required this.id,
    required this.firstName,
    required this.imageUrl,
  });

  factory MemberEntity.fromSplitwiseModel(Member model) => MemberEntity(
        id: model.id,
        firstName: model.firstName,
        imageUrl: model.picture.large,
      );
}
