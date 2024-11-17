// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/get_groups/get_groups_response.dart';
import 'package:splitz/extensions/widgets.dart';

const _cardHeight = 100.0;

class GroupItem extends StatelessWidget {
  const GroupItem({required this.group, required this.onTap, super.key});

  final Group group;
  final void Function(Group) onTap;

  @override
  Widget build(BuildContext context) {
    final String avatarUrl = group.avatar!.xxlarge!;
    return InkWell(
      onTap: () => onTap(group),
      borderRadius: BorderRadius.all(
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular((1 / 10) * _cardHeight),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                placeholder: (_, __) => CircularProgressIndicator()
                    .withPadding(EdgeInsets.all((1 / 4) * _cardHeight)),
              ),
            ),
            Flexible(
              child: Text(
                group.name!,
                softWrap: true,
              ).withPadding(EdgeInsets.all(12.0)),
            ),
          ],
        ),
      ),
    );
  }
}
