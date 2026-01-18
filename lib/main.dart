import 'package:flutter/material.dart';
import 'package:flutter_app/core/router/redirects/auth_redirect.dart';
import 'package:flutter_app/core/router/router_service.dart';
import 'package:flutter_app/core/router/router_parser.dart';
import 'package:flutter_app/core/router/app_router_delegate.dart';
import 'package:flutter_app/core/router/route_definition.dart';
import 'package:flutter_app/features/auth/presentation/screen/auth_screen.dart';
import 'package:flutter_app/features/home/presentation/screen/home_screen.dart';
import 'package:flutter_app/core/router/router.dart';

void main() {
  final routes = [
    RouteDefinition(pattern: '/', builder: (c, p) => const HomePage()),
    RouteDefinition(pattern: '/auth', builder: (c, p) => const AuthScreen()),
    RouteDefinition(
      pattern: '/route',
      builder: (c, p) => const Scaffold(body: Center(child: Text('Googa'))),
    ),
  ];

  final routerService = RouterService(
    initialRegistry: routes,
    redirects: [AuthRedirect(false)],
  );
  final routerDelegate = AppRouterDelegate(routerService: routerService);
  final routeInformationParser = AppRouteInformationParser(
    routerService: routerService,
  );

  runApp(
    RouterProvider(
      service: routerService,
      child: MyApp(
        routerDelegate: routerDelegate,
        routeInformationParser: routeInformationParser,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouterDelegate routerDelegate;
  final AppRouteInformationParser routeInformationParser;
  const MyApp({
    required this.routerDelegate,
    required this.routeInformationParser,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Custom Router Demo',
      routerDelegate: routerDelegate,
      routeInformationParser: routeInformationParser,
      backButtonDispatcher: RootBackButtonDispatcher(),
    );
  }
}
