import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:splitz/presentation/widgets/splitz_divider.dart';

class SplitzAppBar extends AppBar {
  final Color detailColor;
  final Color bgColor;
  final String? center;
  final Widget? customLeading;
  SplitzAppBar({
    required this.detailColor,
    required this.bgColor,
    this.center,
    this.customLeading,
    super.key,
  }) : super(
          title: Text(center ?? 'Z'),
          leading: customLeading == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: customLeading,
                ),
          elevation: 0,
          centerTitle: true,
          surfaceTintColor: Colors.transparent,
          backgroundColor: bgColor,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(2.0),
            child: SplitzDivider(color: detailColor),
          ),
          actions: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: SizedBox(
                height: 56,
                width: 56,
                child: SvgPicture(SvgAssetLoader('assets/icon/logo.svg')),
              ),
            ),
          ],
        );
}
