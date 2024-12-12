import 'package:flutter/material.dart';
import 'package:splitz/presentation/theme/util.dart';

class BaseItem extends StatelessWidget {
  static const contentMinHeight = 80.0;
  static const contentPadding = 8.0;
  static const badgeHeight = 32.0;
  const BaseItem({
    required this.child,
    this.dismissible = false,
    this.dismissibleKey,
    this.confirmDismiss,
    this.dismissibleBgColor,
    this.dismissibleBgIcon,
    this.dismissible2ndBgColor,
    this.dismissible2ndBgIcon,
    this.onTap,
    this.badgeContent,
  })  : assert(!dismissible || dismissibleKey != null, ''),
        super(key: dismissibleKey);

  final Widget child;
  final bool dismissible;
  final Key? dismissibleKey;
  final Future<bool?> Function(DismissDirection)? confirmDismiss;
  final Color? dismissibleBgColor;
  final IconData? dismissibleBgIcon;
  final Color? dismissible2ndBgColor;
  final IconData? dismissible2ndBgIcon;
  final void Function()? onTap;
  final Widget? badgeContent;

  Widget baseWidget({
    required BuildContext context,
    required bool dismissible,
  }) =>
      Container(
        constraints: const BoxConstraints(
          minHeight: (contentMinHeight / 2) + contentPadding * 2,
        ),
        decoration: BoxDecoration(
          color: ThemeColors.surfaceBright,
          borderRadius:
              dismissible ? null : const BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(contentPadding),
          child: child,
        ),
      );

  Widget addDismissibleBehavior(Widget child) => ClipRRect(
        clipBehavior: Clip.hardEdge,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Dismissible(
          key: dismissibleKey!,
          confirmDismiss: confirmDismiss,
          // start to end
          background: Container(
            color: dismissibleBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(dismissibleBgIcon, color: Colors.white),
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ],
            ),
          ),
          // end to start
          secondaryBackground: Container(
            color: dismissible2ndBgColor ?? dismissibleBgColor,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                Icon(
                  dismissible2ndBgIcon ?? dismissibleBgIcon,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          child: child,
        ),
      );

  Widget addBadgeContent({
    required BuildContext context,
    required Widget badgeContent,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            bottom: -1 * (badgeHeight / 2),
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ThemeColors.primary),
                  borderRadius: BorderRadius.circular(badgeHeight),
                  color: ThemeColors.surface,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: badgeHeight,
                    maxHeight: badgeHeight,
                    minWidth: badgeHeight,
                  ),
                  child: badgeContent,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget = baseWidget(context: context, dismissible: dismissible);

    if (dismissible) {
      widget = addDismissibleBehavior(widget);
    }

    if (onTap != null) {
      widget = InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: widget,
      );
    }

    if (badgeContent != null) {
      widget = addBadgeContent(
        context: context,
        badgeContent: badgeContent!,
        child: widget,
      );
    }

    return widget;
  }
}
