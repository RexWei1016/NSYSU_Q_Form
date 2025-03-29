class TransportRecord {
  final String date;
  final int steps;
  final int bike;
  final int publicTransport;

  TransportRecord({
    required this.date,
    required this.steps,
    required this.bike,
    required this.publicTransport,
  });

  Map<String, dynamic> toMap() => {
    'date': date,
    'steps': steps,
    'bike': bike,
    'public': publicTransport,
  };

  factory TransportRecord.fromMap(Map<String, dynamic> map) {
    return TransportRecord(
      date: map['date'],
      steps: map['steps'],
      bike: map['bike'],
      publicTransport: map['public'],
    );
  }
}
