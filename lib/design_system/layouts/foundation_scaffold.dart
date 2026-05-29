import 'package:bringly_app/design_system/tokens/bringly_spacing.dart';
import 'package:flutter/cupertino.dart';

class FoundationScaffold extends StatelessWidget {
  const FoundationScaffold({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(title)),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(BringlySpacing.md),
          child: child,
        ),
      ),
    );
  }
}
