import 'package:flutter/material.dart';

/// PageBuilder receives [BuildContext] and extracted params.
typedef PageBuilder =
    Widget Function(BuildContext context, Map<String, String>? params);

/// Represents a registered route pattern and a page builder.
/// Example pattern: '/books/:id' or '/settings'
class RouteDefinition {
  final String pattern;
  final PageBuilder builder;

  late final RegExp _regex;
  late final List<String> _paramNames;

  RouteDefinition({required this.pattern, required this.builder}) {
    final segments = pattern.split('/').where((s) => s.isNotEmpty).toList();
    final regexParts = <String>[];
    final params = <String>[];

    for (final seg in segments) {
      if (seg.startsWith(':')) {
        regexParts.add('([^/]+)');
        params.add(seg.substring(1));
      } else {
        regexParts.add(RegExp.escape(seg));
      }
    }

    final regexPattern = '^/${regexParts.join('/')}\$';
    _regex = RegExp(regexPattern);
    _paramNames = params;
  }

  /// If [uri] matches this pattern - returns map of extracted params, otherwise null.
  Map<String, String>? match(Uri uri) {
    final path = uri.path;
    final m = _regex.firstMatch(path);
    if (m == null) return null;

    final params = <String, String>{};
    for (var i = 0; i < _paramNames.length; i++) {
      params[_paramNames[i]] = Uri.decodeComponent(m.group(i + 1) ?? '');
    }

    params.addAll(uri.queryParameters);
    return params;
  }
}
