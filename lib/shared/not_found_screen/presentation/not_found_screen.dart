import 'package:flutter/material.dart';
import 'package:flutter_app/core/router/router.dart';

class NotFoundPage extends StatelessWidget {
  final String requested;
  const NotFoundPage({super.key, required this.requested});
  @override
  Widget build(BuildContext context) {
    final routerService = RouterProvider.of(context)!.service;
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('No route for $requested'),
            ElevatedButton(
              onPressed: () => routerService.replaceAll('/'),
              child: const Text('Go home'),
            ),
          ],
        ),
      ),
    );
  }
}
