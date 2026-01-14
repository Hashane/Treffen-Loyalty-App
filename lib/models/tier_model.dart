class TierModel {
  final String currentTier;
  final String nextTier;
  final double currentPoints;
  final double nextTierPoints;
  final double progress;
  final double pointsToNext;

  TierModel({
    required this.currentTier,
    required this.nextTier,
    required this.currentPoints,
    required this.nextTierPoints,
    required this.progress,
    required this.pointsToNext,
  });

  factory TierModel.fromJson(Map<String, dynamic> json) {
    final current = (json['current_points'] ?? 0).toDouble();
    final next = (json['next_tier_points'] ?? 0).toDouble();
    final pointsToNext = next > 0 ? next - current : 0;
    final progress = next > 0 ? (current / next).clamp(0.0, 1.0) : 0.0;

    return TierModel(
      currentTier: json['current_tier'] ?? 'BRONZE',
      nextTier: json['next_tier'] ?? 'SILVER',
      currentPoints: current,
      nextTierPoints: next,
      progress: progress,
      pointsToNext: pointsToNext,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_tier': currentTier,
      'next_tier': nextTier,
      'current_points': currentPoints,
      'next_tier_points': nextTierPoints,
      'progress': progress,
      'points_to_next': pointsToNext,
    };
  }
}
