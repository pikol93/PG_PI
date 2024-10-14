extension DurationExtension on Duration {
  String toHoursMinutesSeconds() {
    final twoDigitMinutes = _toTwoDigits(inMinutes.remainder(60));
    final twoDigitSeconds = _toTwoDigits(inSeconds.remainder(60));
    return "${_toTwoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}
