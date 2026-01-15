import 'package:flutter/material.dart';
import 'package:flutter_app/core/router/router_service.dart';
import 'package:flutter_app/core/router/router_parser.dart';
import 'package:flutter_app/shared/not_found_screen/presentation/not_found_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppRouteConfiguration>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<AppRouteConfiguration> {
  final RouterService routerService;

  AppRouterDelegate({required this.routerService}) {
    routerService.stack.addListener(_onStackChanged);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void _onStackChanged() => notifyListeners();

  @override
  AppRouteConfiguration? get currentConfiguration =>
      AppRouteConfiguration.fromStack(routerService.currentStack);

  @override
  Widget build(BuildContext context) {
    final pages = <Page<dynamic>>[];

    for (final entry in routerService.currentStack) {
      if (entry.definition != null) {
        pages.add(
          MaterialPage(
            key: ValueKey(entry.location),
            child: entry.definition!.builder(context, entry.params),
          ),
        );
      } else {
        pages.add(
          MaterialPage(
            key: ValueKey('/404'),
            child: NotFoundPage(
              requested: entry.params['requested'] ?? entry.location,
            ),
          ),
        );
      }
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        routerService.pop();
      }
    );
  }

  @override
  Future<void> setNewRoutePath(AppRouteConfiguration configuration) async {
    final newTop = configuration.locations.isNotEmpty
        ? configuration.locations.last
        : '/';
    routerService.replaceAll(newTop);
  }
}
