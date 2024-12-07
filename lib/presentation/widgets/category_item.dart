import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splitz/data/entities/splitz/group_config_entity.dart';
import 'package:splitz/presentation/widgets/base_item.dart';
import 'package:splitz/presentation/widgets/slice_badges.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    required this.category,
    required this.splitzConfigs,
    required this.onDelete,
    required this.onSelect,
    required this.index,
    super.key,
  });

  final SplitzCategory category;
  final Map<String, SplitzConfig> splitzConfigs;
  final Future<bool> Function(SplitzCategory) onDelete;
  final Future<void> Function(SplitzCategory) onSelect;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: Key('${category.id}-${category.prefix}'),
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: BaseItem(
        dismissible: true,
        dismissibleKey: Key('${category.id}-${category.prefix}'),
        dismissibleBgColor: Colors.red,
        dismissibleBgIcon: Icons.delete,
        confirmDismiss: (_) async => onDelete(category),
        onTap: () => onSelect(category),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: BaseItem.contentMinHeight,
                  width: BaseItem.contentMinHeight,
                  clipBehavior: Clip.hardEdge,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: CachedNetworkImage(imageUrl: category.imageUrl),
                ),
                const SizedBox(width: BaseItem.contentMinHeight / 10),
                Expanded(
                  child: LayoutBuilder(builder: (_, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.prefix,
                          style: const TextStyle(
                            fontSize: BaseItem.contentMinHeight / 4,
                          ),
                        ),
                        const SizedBox(height: BaseItem.contentMinHeight / 10),
                        SliceBadges(
                          configs: splitzConfigs.values,
                          totalWidth: constraints.maxWidth,
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
          ],
        ),
      ),
    );
  }
}
