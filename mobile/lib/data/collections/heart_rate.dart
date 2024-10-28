import "package:isar/isar.dart";

part "heart_rate.g.dart";

@collection
class HeartRate {
  Id? id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late DateTime time;

  late double beatsPerMinute;

  HeartRate clone() => HeartRate()
    ..id = id
    ..time = time
    ..beatsPerMinute = beatsPerMinute;
}
