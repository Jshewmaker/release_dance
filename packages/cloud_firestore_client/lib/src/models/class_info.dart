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
    required this.isDropIn,
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
      isDropIn: json['is_drop_in'] as bool,
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

  /// If the class is a drop in
  final bool isDropIn;

  /// Create a deep copy of this ClassInfo
  ClassInfo copyWith({
    String? classId,
    String? description,
    int? durationTime,
    int? durationWeeks,
    String? name,
    double? price,
    bool? isDropIn,
  }) {
    return ClassInfo(
      classId: classId ?? this.classId,
      description: description ?? this.description,
      durationTime: durationTime ?? this.durationTime,
      durationWeeks: durationWeeks ?? this.durationWeeks,
      name: name ?? this.name,
      price: price ?? this.price,
      isDropIn: isDropIn ?? this.isDropIn,
    );
  }
}
