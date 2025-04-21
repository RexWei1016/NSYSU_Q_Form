class TransportRecord {
  final String date;
  final int steps;
  final int bike; // 腳踏車
  final int motorcycle; // 摩托車
  final int publicTransport;

  TransportRecord({
    required this.date,
    required this.steps,
    required this.bike,
    required this.motorcycle,
    required this.publicTransport,
  });

  Map<String, dynamic> toMap() => {
    'date': date,
    'steps': steps,
    'bike': bike,
    'motorcycle': motorcycle,
    'public': publicTransport,
  };

  factory TransportRecord.fromMap(Map<String, dynamic> map) {
    return TransportRecord(
      date: map['date'],
      steps: map['steps'],
      bike: map['bike'],
      motorcycle: map['motorcycle'],
      publicTransport: map['public'],
    );
  }
}
