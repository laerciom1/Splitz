import 'package:splitz/data/entities/external/member_entity.dart';
import 'package:splitz/data/entities/external/simplified_debt_entity.dart';
import 'package:splitz/data/models/splitwise/common/group_full.dart';
import 'package:collection/collection.dart';

class GroupEntity {
  final String name;
  final String imageUrl;
  final int id;
  final DateTime updatedAt;
  final List<MemberEntity> members;
  final SimplifiedDebtEntity? simplifiedDebt;

  GroupEntity({
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.updatedAt,
    required this.members,
    this.simplifiedDebt,
  });

  factory GroupEntity.fromSplitwiseModel(
    FullGroup model,
    String currentUserId,
  ) {
    final sourceSimplifiedDebt = model.simplifiedDebts.firstWhereOrNull(
      (e) => '${e.from}' == currentUserId || '${e.to}' == currentUserId,
    );
    String fromName = '';
    String toName = '';
    SimplifiedDebtEntity? simplifiedDebt;
    final members = <MemberEntity>[];
    for (final member in model.members) {
      if (sourceSimplifiedDebt?.from == member.id) fromName = member.firstName;
      if (sourceSimplifiedDebt?.to == member.id) toName = member.firstName;
      members.add(MemberEntity.fromSplitwiseModel(member));
    }
    if (sourceSimplifiedDebt != null) {
      simplifiedDebt = SimplifiedDebtEntity(
        fromName: fromName,
        toName: toName,
        amount: double.parse(sourceSimplifiedDebt.amount),
      );
    }
    return GroupEntity(
      name: model.name,
      imageUrl: model.coverPhoto.xxlarge,
      id: model.id,
      updatedAt: model.updatedAt,
      members: members,
      simplifiedDebt: simplifiedDebt,
    );
  }
}
