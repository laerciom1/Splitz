import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/entities/external/group_entity.dart';
import 'package:splitz/presentation/theme/util.dart';

const _cardHeight = 180.0;

class GroupItem extends StatelessWidget {
  const GroupItem({required this.group, required this.onTap, super.key});

  final GroupEntity group;
  final void Function(GroupEntity) onTap;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = group.imageUrl;
    return InkWell(
      onTap: () => onTap(group),
      child: SizedBox(
        height: _cardHeight,
        width: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CachedNetworkImage(
              width: double.infinity,
              imageUrl: imageUrl,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: ThemeColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ThemeColors.primary,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    group.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
