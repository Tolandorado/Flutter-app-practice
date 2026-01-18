import './route_redirect.dart';

class AuthRedirect extends RouteRedirect {
  final bool isAuth;

  AuthRedirect(this.isAuth);

  @override
  String? redirect(String location) {
    final isProtected = location.startsWith('/');

    if (isProtected && !isAuth) {
      return '/auth';
    }
    return null;
  }
}
