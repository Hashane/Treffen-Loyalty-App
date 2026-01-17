class UserModel {
  final String id;
  final String name;
  final String email;
  final String tier;
  final double currentPoints;
  final double lifetimePoints;
  final String? avatarUrl;
  final String? initials;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.tier,
    required this.currentPoints,
    required this.lifetimePoints,
    this.avatarUrl,
    this.initials,
  });

  /// For backwards compatibility
  double get points => currentPoints;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      tier: json['tier'] ?? 'BRONZE',
      currentPoints: (json['current_points'] ?? json['points'] ?? 0).toDouble(),
      lifetimePoints: (json['lifetime_points'] ?? json['points'] ?? 0).toDouble(),
      avatarUrl: json['avatar_url'],
      initials: json['initials'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'tier': tier,
      'current_points': currentPoints,
      'lifetime_points': lifetimePoints,
      'avatar_url': avatarUrl,
      'initials': initials,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? tier,
    double? currentPoints,
    double? lifetimePoints,
    String? avatarUrl,
    String? initials,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      tier: tier ?? this.tier,
      currentPoints: currentPoints ?? this.currentPoints,
      lifetimePoints: lifetimePoints ?? this.lifetimePoints,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      initials: initials ?? this.initials,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          tier == other.tier &&
          currentPoints == other.currentPoints &&
          lifetimePoints == other.lifetimePoints;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      tier.hashCode ^
      currentPoints.hashCode ^
      lifetimePoints.hashCode;

  String get displayInitials {
    if (initials != null && initials!.isNotEmpty) {
      return initials!;
    }
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }
}
