class GrowthRecord {
  final DateTime date;
  int germinated;
  int healthy;
  int damaged;

  GrowthRecord({
    required this.date,
    required this.germinated,
    required this.healthy,
    required this.damaged,
  }) {
    if (germinated < 0 || healthy < 0 || damaged < 0) {
      throw ArgumentError('Growth counts cannot be negative.');
    }
    if (healthy + damaged > germinated) {
      throw ArgumentError('Healthy + damaged cannot exceed germinated seedlings.');
    }
  }

  int get remainingGerminated => germinated - healthy - damaged;

  double get healthyRate =>
      germinated == 0 ? 0 : (healthy / germinated) * 100;
}
