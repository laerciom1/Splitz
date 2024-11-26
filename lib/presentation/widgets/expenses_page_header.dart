import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/common/group_full.dart';

const _avatarSize = 80.0;
const _avatarLeftPadding = 60.0;
const _actionsIconSize = 24.0;
const _maxExtent = 200.0;
const _minExtent = _maxExtent * (2 / 3);
const _actionsTopPadding = _avatarLeftPadding - (_actionsIconSize / 2);
const _actionsPadding = (_avatarLeftPadding - (_actionsIconSize * 2)) / 2;

class ExpensesPageHeader extends SliverPersistentHeaderDelegate {
  ExpensesPageHeader({
    required this.groupInfo,
    required this.scaffold,
    this.popOverText,
  })  : minExtent = _minExtent,
        maxExtent = _maxExtent;

  @override
  final double minExtent;

  @override
  final double maxExtent;

  final FullGroup groupInfo;
  final GlobalKey<ScaffoldState> scaffold;
  final String? popOverText;

  Widget getBackgroundImage(double size) => SizedBox(
        width: double.infinity,
        height: size,
        child: CachedNetworkImage(
          imageUrl: groupInfo.coverPhoto.xxlarge,
          fit: BoxFit.cover,
        ),
      );

  Widget getShadow(double size, double opacity) => Container(
        width: double.infinity,
        height: size,
        color: Colors.black.withOpacity(opacity),
      );

  Widget getGroupInfo({
    required double offset,
    required double opacity,
    required Color avatarBgColor,
    required String text,
    required String imageUrl,
  }) =>
      Positioned(
        top: offset,
        left: _avatarLeftPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: opacity,
              child: Container(
                width: _avatarSize,
                height: _avatarSize,
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: avatarBgColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: CachedNetworkImage(imageUrl: imageUrl),
                ),
              ),
            ),
            Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      );

  Widget getActions() => Positioned(
        top: _actionsTopPadding,
        left: _actionsPadding,
        right: _actionsPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              iconSize: _actionsIconSize,
              onPressed: () => scaffold.currentState!.openDrawer(),
              icon: const Icon(Icons.menu),
            ),
            if (popOverText != null)
              Directionality(
                textDirection: TextDirection.rtl,
                child: MenuAnchor(
                  builder: (context, controller, child) => IconButton(
                    iconSize: _actionsIconSize,
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(Icons.info_outline),
                  ),
                  menuChildren: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Text(popOverText!),
                    )
                  ],
                ),
              ),
          ],
        ),
      );

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final minScale = minExtent / maxExtent;
    final firstScale = 1 - shrinkOffset / maxExtent;
    final secondScale = max(1 - (shrinkOffset / maxExtent) * 1.5, 0.0);
    final scale = max(firstScale, minScale);

    final headerSize = maxExtent * scale;
    final avatarOffset = max(
        (maxExtent * firstScale) - (_avatarSize / 2), -1 * (_avatarSize / 4));
    final shadowOpacity = 1 - scale;

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        // physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  getBackgroundImage(headerSize),
                  getShadow(headerSize, shadowOpacity),
                  getGroupInfo(
                    offset: avatarOffset,
                    opacity: secondScale,
                    avatarBgColor: Theme.of(context).primaryColor,
                    text: groupInfo.name,
                    imageUrl: groupInfo.coverPhoto.xxlarge,
                  ),
                  getActions(),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  bool shouldRebuild(oldDelegate) => true;
}
