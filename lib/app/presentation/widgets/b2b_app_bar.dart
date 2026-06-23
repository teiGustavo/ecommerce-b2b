import 'package:ecommerce_b2b/app/presentation/widgets/user_profile_dropdown.dart';
import 'package:flutter/material.dart';

class B2BAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showProfile;
  final PreferredSizeWidget? bottom;

  const B2BAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showProfile = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      centerTitle: false,
      actions: [
        ...?actions,
        if (showProfile) const UserProfileDropdown(),
      ],
      elevation: 0,
      scrolledUnderElevation: 3,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surface,
      bottom: bottom ?? PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 1));
}
