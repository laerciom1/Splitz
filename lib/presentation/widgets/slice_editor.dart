import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/strings.dart';
import 'package:splitz/presentation/theme/slice_colors.dart';
import 'package:splitz/presentation/widgets/circle_avatar.dart';
import 'package:splitz/presentation/widgets/field_percentage.dart';
import 'package:splitz/presentation/widgets/slice_slider.dart';

const _userCardHeight = 48.0;
const _badgeHeight = 8.0;

class SliceEditor extends StatelessWidget {
  const SliceEditor({
    required this.splitzConfigs,
    required this.focusNodes,
    required this.controllers,
    required this.onEditConfigs,
    super.key,
  });

  final List<SplitzConfig> splitzConfigs;
  final List<FocusNode> focusNodes;
  final List<TextEditingController> controllers;
  final void Function(List<SplitzConfig>) onEditConfigs;

  List<double> getRanges() =>
      splitzConfigs.map((e) => e.slice.toDouble()).toList();

  void setRange(SplitzConfig c, int newSlice) => onEditConfigs(
        splitzConfigs.asMap().entries.map((e) {
          if (e.value != c) return e.value;
          return e.value.copyWith(slice: newSlice);
        }).toList(),
      );

  void setRanges(List<double> newRanges) => onEditConfigs(
        newRanges.asMap().entries.map((e) {
          return splitzConfigs[e.key].copyWith(slice: e.value.round());
        }).toList(),
      );

  Widget getUserInfo(MapEntry<int, SplitzConfig> e, BuildContext ctx) {
    final inverseSurface = Theme.of(ctx).colorScheme.inverseSurface;
    final index = e.key;
    final config = e.value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PercentageField(
          text: config.slice.toString(),
          textColor: inverseSurface,
          backgroundColor: sliceColors[index],
          focusNode: focusNodes[index],
          controller: controllers[index],
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
              config.name,
              style: const TextStyle(fontSize: 16),
            ),
            Container(
              width: _badgeHeight * 2,
              height: _badgeHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_badgeHeight / 2),
                color: sliceColors[index],
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
        ...splitzConfigs.asMap().entries.map<Widget>((e) {
          final config = e.value;
          return Padding(
            padding: const EdgeInsets.only(left: 24),
            child: SizedBox(
              height: _userCardHeight,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SplitzCircleAvatar(
                    radius: _userCardHeight,
                    avatarUrl: config.avatarUrl,
                  ),
                  const SizedBox(width: 12),
                  Focus(child: getUserInfo(e, context)),
                ],
              ),
            ),
          );
        }).intersperse(const SizedBox(height: 12)),
        if (sum == 100.0)
          SliceSlider(
            onRangesChanged: setRanges,
            initRangeValues: getRanges(),
          ),
        if (sum != 100.0)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text('The sum of the users\' parts must be 100%'),
          ),
      ],
    );
  }
}
