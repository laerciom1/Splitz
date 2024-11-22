import 'package:flutter/material.dart';
import 'package:splitz/data/models/splitz/group_config.dart';
import 'package:splitz/extensions/list.dart';
import 'package:splitz/extensions/widgets.dart';
import 'package:splitz/presentation/widgets/category_selector.dart';
import 'package:splitz/presentation/widgets/expense_example.dart';
import 'package:splitz/presentation/widgets/field_primary.dart';
import 'package:splitz/presentation/widgets/slice_editor.dart';
import 'package:splitz/services/splitz_service.dart';

class CategoryConfigScreen extends StatefulWidget {
  const CategoryConfigScreen({
    required this.category,
    required this.groupConfig,
    super.key,
  });

  final SplitzCategory? category;
  final GroupConfig groupConfig;

  @override
  State<CategoryConfigScreen> createState() => _CategoryConfigScreenState();
}

class _CategoryConfigScreenState extends State<CategoryConfigScreen> {
  late SplitzCategory category;
  late GroupConfig groupConfig;
  List<SplitzCategory> availableCategories = [];
  bool shoulUseCustomSlices = false;

  @override
  void initState() {
    super.initState();
    category =
        widget.category ?? SplitzCategory(suffix: '', imageUrl: '', id: 0);
    groupConfig = widget.groupConfig;
    getCategories();
  }

  Future<void> getCategories() async {
    final results = await SplitzService.getAvailableCategories();
    setState(() {
      availableCategories = results;
    });
  }

  void selectCategory(SplitzCategory c) => setState(() {
        category = category.copyWith(imageUrl: c.imageUrl, id: c.id);
      });

  void onChangeSuffix(String s) => setState(() {
        category = category.copyWith(suffix: s);
      });

  void onEditConfig(GroupConfig newConfig) {
    setState(() {
      groupConfig = newConfig;
    });
  }

  void save() {}

  @override
  Widget build(BuildContext ctx) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Select an image for this category:'),
                  CategorySelector(
                    categories: availableCategories,
                    onSelect: selectCategory,
                    selectedCategory: category,
                  ),
                  const Text('Type a suffix for this category:'),
                  PrimaryField(onChanged: onChangeSuffix),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Use custom division for this category'),
                      Checkbox(
                        value: shoulUseCustomSlices,
                        onChanged: (newValue) => setState(() {
                          shoulUseCustomSlices = newValue ?? false;
                        }),
                      ),
                    ],
                  ),
                  if (shoulUseCustomSlices)
                    SliceEditor(config: groupConfig, onEditConfig: onEditConfig)
                ].intersperse(const SizedBox(height: 12)).toList(),
              ),
            ).withPadding(
              const EdgeInsets.only(
                top: 12 + ExpenseExample.exampleHeight,
                left: 12,
                right: 12,
                bottom: 24,
              ),
            ),
            ExpenseExample(
              category: category,
              configs: groupConfig.splitConfig,
              onSave: save,
            ),
          ],
        ),
      ),
    );
  }
}
