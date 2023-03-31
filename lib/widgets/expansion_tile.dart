import 'package:flutter/material.dart';

class AppExpansionTile extends StatefulWidget {
  final Widget child;
  final bool expand;
  final Duration duration;
  const AppExpansionTile({
    Key? key,
    this.expand = false,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
  }) : super(key: key);

  @override
  State<AppExpansionTile> createState() => _AppExpansionTileState();
}

class _AppExpansionTileState extends State<AppExpansionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(AppExpansionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1.0,
      axis: Axis.vertical,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
