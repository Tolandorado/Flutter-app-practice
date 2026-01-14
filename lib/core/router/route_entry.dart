import 'package:flutter_app/core/router/route_definition.dart';

// -----------------------------
// Router state & service
// -----------------------------

/// Simple descriptor for one entry in the navigation stack.
class RouteEntry {
  final String location; // canonical path, e.g. '/books/42'
  final Map<String, String> params; // extracted params
  final RouteDefinition? definition; // matched definition if any

  RouteEntry({required this.location, this.params = const {}, this.definition});
}
