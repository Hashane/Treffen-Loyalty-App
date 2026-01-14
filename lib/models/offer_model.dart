class OfferModel {
  final String id;
  final String title;
  final String store;
  final String imageUrl;
  final String? description;
  final int? pointsCost;
  final DateTime? expiryDate;
  final String? category;
  final bool isFeatured;

  OfferModel({
    required this.id,
    required this.title,
    required this.store,
    required this.imageUrl,
    this.description,
    this.pointsCost,
    this.expiryDate,
    this.category,
    this.isFeatured = false,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      store: json['store'] ?? '',
      imageUrl: json['image_url'] ?? json['image'] ?? '',
      description: json['description'],
      pointsCost: json['points_cost'],
      expiryDate: json['expiry_date'] != null
          ? DateTime.tryParse(json['expiry_date'])
          : null,
      category: json['category'],
      isFeatured: json['is_featured'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'store': store,
      'image_url': imageUrl,
      'description': description,
      'points_cost': pointsCost,
      'expiry_date': expiryDate?.toIso8601String(),
      'category': category,
      'is_featured': isFeatured,
    };
  }
}
