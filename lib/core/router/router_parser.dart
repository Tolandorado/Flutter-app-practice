import 'package:flutter/material.dart';
import 'package:flutter_app/core/router/router_service.dart';
import 'package:flutter_app/core/router/route_entry.dart';

/// Lightweight configuration - the whole app stack represented as list of locations.
class AppRouteConfiguration {
  final List<String> locations;
  AppRouteConfiguration(this.locations);

  factory AppRouteConfiguration.fromStack(List<RouteEntry> stack) =>
      AppRouteConfiguration(stack.map((e) => e.location).toList());

  RouteEntry get top =>
      RouteEntry(location: locations.isEmpty ? '/' : locations.last);
}

/// Parses RouteInformation into [AppRouteConfiguration] and back.
class AppRouteInformationParser
    extends RouteInformationParser<AppRouteConfiguration> {
  final RouterService routerService;

  AppRouteInformationParser({required this.routerService});

  @override
  Future<AppRouteConfiguration> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final location = routeInformation.uri.path;
    // For simplicity: we treat the URL as the single stack root (replaceAll).
    // In more advanced use-cases you can parse multi-segment stacks like '/books/42/settings'.
    return AppRouteConfiguration([location]);
  }

  @override
  RouteInformation? restoreRouteInformation(
    AppRouteConfiguration configuration,
  ) {
    final loc = configuration.locations.isNotEmpty
        ? configuration.locations.last
        : '/';
    return RouteInformation(uri: Uri.parse(loc));
  }
}
