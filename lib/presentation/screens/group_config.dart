// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitwise/common/group.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/presentation/theme/slice_colors.dart';
import 'package:splitz/presentation/widgets/loading.dart';
import 'package:splitz/presentation/widgets/slice_slider.dart';
import 'package:splitz/presentation/widgets/snackbar.dart';
import 'package:splitz/services/splitz_service.dart';

const _userCardHeight = 48.0;
const _badgeHeight = 8.0;

class GroupConfigScreen extends StatefulWidget {
  const GroupConfigScreen({
    required this.id,
    required this.config,
    super.key,
  });

  final String id;
  final GroupConfig? config;

  @override
  State<GroupConfigScreen> createState() => _GroupConfigScreenState();
}

class _GroupConfigScreenState extends State<GroupConfigScreen> {
  Group? group;
  late GroupConfig? config;
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    config = widget.config;
    syncGroup();
  }

  Future<void> syncGroup({bool forceSync = false}) async {
    if (config == null || forceSync) {
      final groupInfo = await SplitzService.getGroupInfo(widget.id);
      if (groupInfo == null) {
        showToast(
          'Something went wrong retrieving your group. Drag down to refresh.',
        );
      } else {
        final splitConfigsFromMembers =
            SplitzService.getSplitConfigsFromMembers(
          groupInfo.group?.members ?? [],
        );
        /* The order here is important. SplitConfigs from the widget MUST be the
           first param, because they have priority
        */
        final splitConfigs = SplitzService.mergeSplitConfigs(
          widget.config?.splitConfig ?? [],
          splitConfigsFromMembers,
        );
        setState(() {
          config = GroupConfig(
            categories: config!.categories,
            splitConfig: splitConfigs,
          );
          group = groupInfo.group;
        });
      }
    }
  }

  Widget getUserPhoto(MapEntry<int, SplitConfig> e) => Container(
        height: _userCardHeight,
        width: _userCardHeight,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: CachedNetworkImage(
          imageUrl: e.value.avatarUrl ?? '',
        ),
      );

  Widget getUserInfo(MapEntry<int, SplitConfig> e) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text('${e.value.name}: '),
              Text('${e.value.slice}%'),
            ],
          ),
          SizedBox(height: 4),
          Container(
            width: _badgeHeight * 2,
            height: _badgeHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_badgeHeight / 2),
              color: sliceColors[e.key],
            ),
          ),
        ],
      ),
    );
  }

  List<double> getRanges() =>
      config?.splitConfig?.map((e) => e.slice?.toDouble() ?? 50).toList() ?? [];

  void setRanges(List<double> newRanges) {
    setState(() {
      config = config?.copyWith(
        splitConfig: newRanges
            .asMap()
            .entries
            .map((e) =>
                config!.splitConfig![e.key].copyWith(slice: e.value.round()))
            .toList(),
      );
    });
  }

  List<Widget> getUsersSlices(BuildContext ctx) {
    return [
      Text('Users default slice:').withPadding(EdgeInsets.all(24)),
      ...config!.splitConfig!
          .asMap()
          .entries
          .map(
            (e) => SizedBox(
              height: _userCardHeight,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  getUserPhoto(e),
                  SizedBox(width: 12),
                  getUserInfo(e),
                ],
              ),
            ).withPadding(EdgeInsets.only(left: 24)),
          )
          .intersperse(SizedBox(height: 12)),
      SliceSlider(
        onRangesChanged: setRanges,
        initRangeValues: getRanges(),
      ),
    ];
  }

  @override
  Widget build(BuildContext ctx) {
    return SafeArea(
      child: Scaffold(
        body: config != null
            ? RefreshIndicator(
                onRefresh: () => syncGroup(forceSync: true),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [...getUsersSlices(ctx)],
                  ),
                ),
              )
            : const Loading(),
      ),
    );
  }
}
