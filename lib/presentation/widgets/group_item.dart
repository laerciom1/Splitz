import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/common/group.dart';

const _cardHeight = 100.0;

class GroupItem extends StatelessWidget {
  const GroupItem({required this.group, required this.onTap, super.key});

  final Group group;
  final void Function(Group) onTap;

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = group.avatar?.xxlarge ?? '';
    return InkWell(
      onTap: () => onTap(group),
      borderRadius: const BorderRadius.all(
        Radius.circular((1 / 10) * _cardHeight),
      ),
      child: SizedBox(
        height: _cardHeight,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: _cardHeight,
              width: _cardHeight,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((1 / 10) * _cardHeight),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                placeholder: (_, __) => const Padding(
                  padding: EdgeInsets.all((1 / 4) * _cardHeight),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  group.name ?? '',
                  softWrap: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
