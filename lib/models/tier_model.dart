class TierModel {
  final String currentTier;
  final String nextTier;
  final double currentPoints;
  final double lifetimePoints;
  final double nextTierPoints;
  final double progress;
  final double pointsToNext;

  const TierModel({
    required this.currentTier,
    required this.nextTier,
    required this.currentPoints,
    required this.lifetimePoints,
    required this.nextTierPoints,
    required this.progress,
    required this.pointsToNext,
  });

  factory TierModel.fromJson(Map<String, dynamic> json) {
    final tierProgress = json['tier_progress'] as Map<String, dynamic>?;

    return TierModel(
      currentTier: json['tier'] ?? 'BRONZE',
      nextTier: tierProgress?['next_tier'] ?? 'SILVER',
      currentPoints: (json['current_points'] ?? 0).toDouble(),
      lifetimePoints: (json['lifetime_points'] ?? 0).toDouble(),
      nextTierPoints: (tierProgress?['next_tier_points'] ?? 0).toDouble(),
      progress: (tierProgress?['progress_percentage'] ?? 0).toDouble(),
      pointsToNext: (tierProgress?['points_to_next_tier'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_tier': currentTier,
      'next_tier': nextTier,
      'current_points': currentPoints,
      'lifetime_points': lifetimePoints,
      'next_tier_points': nextTierPoints,
      'progress_percentage': progress,
      'points_to_next_tier': pointsToNext,
    };
  }

  TierModel copyWith({
    String? currentTier,
    String? nextTier,
    double? currentPoints,
    double? lifetimePoints,
    double? nextTierPoints,
    double? progress,
    double? pointsToNext,
  }) {
    return TierModel(
      currentTier: currentTier ?? this.currentTier,
      nextTier: nextTier ?? this.nextTier,
      currentPoints: currentPoints ?? this.currentPoints,
      lifetimePoints: lifetimePoints ?? this.lifetimePoints,
      nextTierPoints: nextTierPoints ?? this.nextTierPoints,
      progress: progress ?? this.progress,
      pointsToNext: pointsToNext ?? this.pointsToNext,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TierModel &&
          runtimeType == other.runtimeType &&
          currentTier == other.currentTier &&
          nextTier == other.nextTier &&
          currentPoints == other.currentPoints &&
          lifetimePoints == other.lifetimePoints &&
          nextTierPoints == other.nextTierPoints &&
          progress == other.progress &&
          pointsToNext == other.pointsToNext;

  @override
  int get hashCode =>
      currentTier.hashCode ^
      nextTier.hashCode ^
      currentPoints.hashCode ^
      lifetimePoints.hashCode ^
      nextTierPoints.hashCode ^
      progress.hashCode ^
      pointsToNext.hashCode;
}
