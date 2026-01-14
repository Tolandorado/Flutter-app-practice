import 'package:flutter/material.dart';
import 'package:flutter_app/core/router/router.dart';

class HomePage extends StatelessWidget {
  final PageNotifier notifier;
  const HomePage({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0), // Альтернатива
              child: ElevatedButton(
                onPressed: () => notifier.setNewPage(AppRoute.about()),
                child: const Text('Go to About'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0), // Альтернатива
              child: ElevatedButton(
                onPressed: () => notifier.setNewPage(AppRoute.contact()),
                child: const Text('Go to Contact'),
              ),
            ),Padding(
              padding: const EdgeInsets.only(bottom: 10.0), // Альтернатива
              child: ElevatedButton(
                onPressed: () => notifier.setNewPage(AppRoute.services()),
                child: const Text('Go to Services'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
