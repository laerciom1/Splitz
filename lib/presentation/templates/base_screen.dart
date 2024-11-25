import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splitz/presentation/widgets/app_bar.dart';
import 'package:splitz/presentation/widgets/drawer.dart';

class BaseScreen extends StatelessWidget {
  const BaseScreen({
    required this.child,
    this.topWidget,
    this.bottomWidget,
    this.floatingActionButton,
    this.safeArea = true,
    this.appBar = true,
    this.scaffoldKey,
    this.onRefresh,
    this.onPop,
    super.key,
  });

  final bool safeArea;
  final bool appBar;
  final Future<void> Function()? onRefresh;
  final Future<void> Function(bool, dynamic)? onPop;
  final Widget child;
  final Widget? topWidget;
  final Widget? bottomWidget;
  final Widget? floatingActionButton;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Widget build(BuildContext context) {
    final detailColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = Theme.of(context).primaryColor;
    Widget widget = LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: child,
        ),
      );
    });
    if (onRefresh != null) {
      widget = RefreshIndicator(
        onRefresh: () async => unawaited(onRefresh?.call()),
        child: widget,
      );
    }

    final body = Column(
      children: [
        if (topWidget != null) topWidget!,
        Expanded(child: widget),
        if (bottomWidget != null) bottomWidget!,
      ],
    );

    final splitzAppBar = !appBar
        ? null
        : SplitzAppBar(
            detailColor: detailColor,
            bgColor: backgroundColor,
          );

    Widget screen = Scaffold(
      key: scaffoldKey,
      floatingActionButton: floatingActionButton,
      body: body,
      drawer: SplitzDrawer(),
      appBar: splitzAppBar,
    );

    if (safeArea) screen = SafeArea(child: screen);
    if (onPop != null) {
      screen =
          PopScope(canPop: false, onPopInvokedWithResult: onPop, child: screen);
    }
    return screen;
  }
}
