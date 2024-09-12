enum LoggedInAppRoute {
  home,
  navigation,
  workout,
  settings,
}

extension AppRouteExtension on LoggedInAppRoute {
  String getName() {
    switch (this) {
      case LoggedInAppRoute.home:
        return "/";
      case LoggedInAppRoute.navigation:
        return "/navigation";
      case LoggedInAppRoute.workout:
        return "/workout";
      case LoggedInAppRoute.settings:
        return "/settings";
    }
  }
}
