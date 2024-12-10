import 'package:flutter/material.dart';
import 'package:flutter_app_ui/flutter_app_ui.dart';

class FlutCinematicStickyHeader extends StatelessWidget {
  const FlutCinematicStickyHeader({
    required this.headerText,
    required this.body,
    super.key,
  });
  final String headerText;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Padding(
            padding: edgeInsetsH20,
            child: Text(
              headerText,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
          centerTitle: false,
        ),
        body,
      ],
    );
  }
}
