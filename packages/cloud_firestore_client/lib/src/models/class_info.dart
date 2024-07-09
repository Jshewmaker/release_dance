///{@template class_info}
/// Class information
/// {@endtemplate}
class ClassInfo {
  ///{@macro class_info}
  ClassInfo({
    required this.classId,
    required this.description,
    required this.durationTime,
    required this.durationWeeks,
    required this.name,
    required this.price,
  });

  /// Convert json to class info
  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      classId: json['class_id'] as String,
      description: json['description'] as String,
      durationTime: json['duration_time'] as int,
      durationWeeks: json['duration_weeks'] as int,
      name: json['name'] as String,
      price: (json['price'] as int).toDouble(),
    );
  }

  /// Class document id
  final String classId;

  /// Class description
  final String description;

  /// Duration of class in minutes
  final int durationTime;

  /// Duration of class in weeks
  final int durationWeeks;

  /// Class name
  final String name;

  /// Class price
  final double price;
}
