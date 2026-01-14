import 'package:flutter/material.dart';
import 'package:flutter_app/core/router/route_definition.dart';
import 'package:flutter_app/core/router/route_entry.dart';

/// Centralized navigation state following SRP.
/// Only this service mutates the navigation stack.
class RouterService {
  final ValueNotifier<List<RouteEntry>> stack;
  final List<RouteDefinition> registry;

  RouterService({required List<RouteDefinition> initialRegistry})
    : registry = List.unmodifiable(initialRegistry),
      stack = ValueNotifier<List<RouteEntry>>([RouteEntry(location: '/')]);

  List<RouteEntry> get currentStack => stack.value;

  RouteEntry _makeEntry(String location) {
    final uri = Uri.parse(location);
    for (final def in registry) {
      final params = def.match(uri);
      if (params != null)
        return RouteEntry(location: location, params: params, definition: def);
    }

    return RouteEntry(
      location: '/404',
      params: {'requested': location},
      definition: null,
    );
  }

  void push(String location) {
    final last = stack.value.isNotEmpty ? stack.value.last.location : null;
    if (last == location) return;
    stack.value = [...stack.value, _makeEntry(location)];
  }

  void pop() {
    if (stack.value.length <= 1) return;
    stack.value = stack.value.sublist(0, stack.value.length - 1);
  }

  void replaceAll(String location) {
    stack.value = [_makeEntry(location)];
  }

  /// Replace top entry (useful for redirecting)
  void replaceTop(String location) {
    if (stack.value.isEmpty) {
      stack.value = [_makeEntry(location)];
      return;
    }
    final newStack = List<RouteEntry>.from(stack.value);
    newStack[newStack.length - 1] = _makeEntry(location);
    stack.value = newStack;
  }
}
