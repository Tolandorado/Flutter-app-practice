import 'package:flutter/material.dart';
import 'package:flutter_app/features/home/presentation/screen/home_screen.dart';

enum PageName { home, contact, about, services }

class AppRoute {
  final PageName? pageName;
  final bool _isUnknown;

  AppRoute.home() : pageName = PageName.home, _isUnknown = false;

  AppRoute.contact() : pageName = PageName.contact, _isUnknown = false;

  AppRoute.about() : pageName = PageName.about, _isUnknown = false;

  AppRoute.services() : pageName = PageName.services, _isUnknown = false;

  AppRoute.unknown() : pageName = null, _isUnknown = true;

  //Used to get the current path
  bool get isHome => pageName == PageName.home;
  bool get isAbout => pageName == PageName.about;
  bool get isContact => pageName == PageName.contact;
  bool get isServices => pageName == PageName.services;
  bool get isUnknown => _isUnknown;
}

class AppRouteInformationParser extends RouteInformationParser<AppRoute> {
  Uri? _unknownPath;

  @override
  Future<AppRoute> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;

    if (uri.pathSegments.isEmpty) {
      return AppRoute.home();
    }

    if (uri.pathSegments.length > 1) {
      _unknownPath = routeInformation.uri;
      return AppRoute.unknown();
    }

    if (uri.pathSegments.length == 1) {
      if (uri.pathSegments.first == PageName.about.name) {
        return AppRoute.about();
      }

      if (uri.pathSegments.first == PageName.contact.name) {
        return AppRoute.contact();
      }

      if (uri.pathSegments.first == PageName.services.name) {
        return AppRoute.services();
      }
    }

    _unknownPath = uri;
    return AppRoute.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoute configuration) {
    if (configuration.isAbout) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    if (configuration.isUnknown) {
      return RouteInformation(uri: _unknownPath);
    }

    if (configuration.isContact || configuration.isServices) {
      return _getRouteInformation(configuration.pageName!.name);
    }

    // if (configuration.isServices) {
    //   return _getRouteInformation(configuration.pageName!.name);
    // }
    return RouteInformation(uri: Uri(path: '/'));
  }

  RouteInformation _getRouteInformation(String page) {
    return RouteInformation(uri: Uri(path: "/$page"));
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoute> {
  final PageNotifier notifier;

  AppRouterDelegate({required this.notifier});

  // @override
  // TODO: implement navigatorKey
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  @override
  AppRoute? get currentConfiguration {
    if (notifier.isUnknown) {
      return AppRoute.unknown();
    }

    if (notifier.pageName == PageName.home) {
      return AppRoute.home();
    }

    if (notifier.pageName == PageName.about) {
      return AppRoute.about();
    }

    if (notifier.pageName == PageName.contact) {
      return AppRoute.contact();
    }

    if (notifier.pageName == PageName.services) {
      return AppRoute.services();
    }

    return AppRoute.unknown();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        if (notifier.isUnknown)
          const MaterialPage(
            child: Scaffold(body: Text("PageNotFoundScreen")),
          ), //PageNotFoundScreen
        if (!notifier.isUnknown)
          MaterialPage(child: HomePage(notifier: notifier)), // HomePage
        if (notifier.pageName == PageName.home)
          MaterialPage(child: HomePage(notifier: notifier)), //HomePage
        if (notifier.pageName == PageName.about)
          const MaterialPage(
            child: Scaffold(body: Text("AboutPage")),
          ), //AboutPage
        if (notifier.pageName == PageName.contact)
          const MaterialPage(
            child: Scaffold(body: Text("ContactPage")),
          ), //ContactPage
        if (notifier.pageName == PageName.services)
          const MaterialPage(
            child: Scaffold(body: Text("ServicesPage")),
          ), //servicesPage
      ],
      onDidRemovePage: (page) {
        if (notifier.pageName != PageName.home) {
          notifier.setNewPage(AppRoute.home());
        }
      },
    );
  }

  @override
  void addListener(VoidCallback listener) {
    notifier.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    notifier.removeListener(listener);
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) async {
    notifier.setNewPage(configuration);
  }
}

class PageNotifier extends ChangeNotifier {
  PageName? _pageName;
  bool _isUnknown = false;

  PageName? get pageName => _pageName;
  bool get isUnknown => _isUnknown;

  void setNewPage(AppRoute route) {
    _isUnknown = route.isUnknown;
    _pageName = route.pageName;
    notifyListeners();
  }
}
