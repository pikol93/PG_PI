enum LoggedOffAppRoute {
  welcome,
  register,
  login,
}

extension AppRouteExtension on LoggedOffAppRoute {
  String getName() {
    switch (this) {
      case LoggedOffAppRoute.welcome:
        return "/welcome";
      case LoggedOffAppRoute.register:
        return "/welcome/register";
      case LoggedOffAppRoute.login:
        return "/welcome/login";
    }
  }
}
