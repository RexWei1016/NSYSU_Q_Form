class FoodRecord {
  final String date;
  final String mealType; // breakfast, lunch, dinner
  final String bagType; // '一次性', '非一次性', '無用餐'

  FoodRecord({required this.date, required this.mealType, required this.bagType});

  Map<String, dynamic> toMap() => {
    'date': date,
    'mealType': mealType,
    'bagType': bagType,
  };

  factory FoodRecord.fromMap(Map<String, dynamic> map) => FoodRecord(
    date: map['date'],
    mealType: map['mealType'],
    bagType: map['bagType'],
  );
}
