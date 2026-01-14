class UserModel {
  final String id;
  final String name;
  final String email;
  final String tier;
  final double points;
  final String? avatarUrl;
  final String? initials;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.tier,
    required this.points,
    this.avatarUrl,
    this.initials,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      tier: json['tier'] ?? 'BRONZE',
      points: (json['points'] ?? 0).toDouble(),
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
      'points': points,
      'avatar_url': avatarUrl,
      'initials': initials,
    };
  }

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
