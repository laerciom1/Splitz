import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/common/group.dart';

const _cardHeight = 180.0;

class GroupItem extends StatelessWidget {
  const GroupItem({required this.group, required this.onTap, super.key});

  final Group group;
  final void Function(Group) onTap;

  @override
  Widget build(BuildContext context) {
    final String imageUrl = group.coverPhoto.xxlarge;
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
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
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
