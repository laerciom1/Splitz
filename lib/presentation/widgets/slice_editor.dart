import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/presentation/theme/slice_colors.dart';
import 'package:splitz/presentation/widgets/circle_avatar.dart';
import 'package:splitz/presentation/widgets/field_percentage.dart';
import 'package:splitz/presentation/widgets/slice_slider.dart';

const _userCardHeight = 48.0;
const _badgeHeight = 8.0;

class SliceEditor extends StatelessWidget {
  const SliceEditor({
    required this.config,
    required this.onEditConfig,
    super.key,
  });

  final GroupConfig config;
  final void Function(GroupConfig) onEditConfig;

  List<double> getRanges() =>
      config.splitConfig.map((e) => e.slice.toDouble()).toList();

  void setRange(SplitzConfig c, int newSlice) => onEditConfig(
        config.copyWith(
          splitConfig: config.splitConfig.asMap().entries.map((e) {
            if (e.value != c) return e.value;
            return e.value.copyWith(slice: newSlice);
          }).toList(),
        ),
      );

  void setRanges(List<double> newRanges) => onEditConfig(
        config.copyWith(
          splitConfig: newRanges
              .asMap()
              .entries
              .map(
                (e) =>
                    config.splitConfig[e.key].copyWith(slice: e.value.round()),
              )
              .toList(),
        ),
      );

  Widget getUserInfo(MapEntry<int, SplitzConfig> e, BuildContext ctx) {
    final inverseSurface = Theme.of(ctx).colorScheme.inverseSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PercentageField(
          text: e.value.slice.toString(),
          textColor: inverseSurface,
          backgroundColor: sliceColors[e.key],
          onChanged: (newValue) => setRange(
            e.value,
            newValue.isNotNullNorEmpty ? int.parse(newValue) : 0,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              e.value.name,
              style: const TextStyle(fontSize: 16),
            ),
            Container(
              width: _badgeHeight * 2,
              height: _badgeHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_badgeHeight / 2),
                color: sliceColors[e.key],
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ranges = getRanges();
    final sum = ranges.fold(0.0, (accu, curr) => accu + curr);
    return Column(
      children: [
        ...config.splitConfig
            .asMap()
            .entries
            .map(
              (e) => SizedBox(
                height: _userCardHeight,
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SplitzCircleAvatar(
                      radius: _userCardHeight,
                      avatarUrl: e.value.avatarUrl,
                    ),
                    const SizedBox(width: 12),
                    getUserInfo(e, context),
                  ],
                ),
              ).withPadding(const EdgeInsets.only(left: 24)),
            )
            .intersperse(const SizedBox(height: 12)),
        if (sum == 100.0)
          SliceSlider(
            onRangesChanged: setRanges,
            initRangeValues: getRanges(),
          ),
        if (sum != 100.0)
          const Text('The sum of the users\' parts must be 100%').withPadding(
            const EdgeInsets.only(top: 24),
          ),
      ],
    );
  }
}
