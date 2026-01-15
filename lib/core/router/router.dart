// flutter_custom_router.dart
// Custom declarative router for Flutter (Navigator 2.0)
// Features: declarative pages, deep-linking, dynamic routes, easy extension
// Guided by: "The Definitive Guide to Navigator 2.0" (hungrimind.com)

import 'package:flutter/material.dart';
import 'package:flutter_app/core/router/router_service.dart';

class RouterProvider extends InheritedWidget {
  final RouterService service;
  const RouterProvider({
    required this.service,
    required super.child,
    super.key,
  });

  static RouterProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RouterProvider>();

  @override
  bool updateShouldNotify(covariant RouterProvider oldWidget) =>
      service != oldWidget.service;
}
