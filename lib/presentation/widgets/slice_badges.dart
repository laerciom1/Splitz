import 'package:flutter/widgets.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/presentation/theme/slice_colors.dart';

const _size = 24.0;
const _spacerSize = 4.0;

class SliceBadges extends StatelessWidget {
  const SliceBadges({
    required this.configs,
    required this.totalWidth,
    super.key,
  });

  final Iterable<SplitzConfig> configs;
  final double totalWidth;

  List<Widget> getBadges() {
    int index = 0;
    double spacersSize = _spacerSize * (configs.length - 1);
    double availableWidth = totalWidth - spacersSize;
    double maxWidth = availableWidth - ((configs.length - 1) * _size);
    return configs
        .map<Widget>((value) => Container(
              height: _size,
              width:
                  (availableWidth * (value.slice / 100)).clamp(_size, maxWidth),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_size),
                color: sliceColors[index++],
              ),
              alignment: Alignment.center,
              child: Text('${value.slice}'),
            ))
        .intersperse(const SizedBox(width: _spacerSize))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: getBadges());
  }

  // List<Widget> getBadges() {
  //   int index = 0;
  //   return configs
  //       .map<Widget>((value) {
  //         final slice = value.slice;
  //         return Container(
  //           height: _size,
  //           constraints: const BoxConstraints(minWidth: _size),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(_size),
  //             color: sliceColors[index++],
  //           ),
  //           alignment: Alignment.center,
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: max(4, .0 + slice)),
  //             child: Text('$slice'),
  //           ),
  //         );
  //       })
  //       .intersperse(const SizedBox(width: 4.0))
  //       .toList();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Row(children: getBadges());
  // }
}
