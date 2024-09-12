enum AppRoute {
  home,
  navigation,
  workout,
  settings,
}

extension AppRouteExtension on AppRoute {
  String getName() {
    switch (this) {
      case AppRoute.home:
        return "/";
      case AppRoute.navigation:
        return "/navigation";
      case AppRoute.workout:
        return "/workout";
      case AppRoute.settings:
        return "/settings";
    }
  }
}
