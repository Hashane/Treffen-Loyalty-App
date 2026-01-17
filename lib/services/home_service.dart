import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/offer_model.dart';
import '../models/activity_model.dart';
import '../models/tier_model.dart';
import 'api_service.dart';

class HomeService {
  final ApiService _apiService;

  HomeService({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  /// Fetch user profile with tier info
  Future<({UserModel? user, TierModel? tier})> fetchUserWithTier() async {
    try {
      final response = await _apiService.get('/me');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final user = UserModel.fromJson(data);
        final tier = TierModel.fromJson(data);
        return (user: user, tier: tier);
      }
      return (user: null, tier: null);
    } catch (e) {
      debugPrint('[HomeService] Error fetching user with tier: $e');
      return (user: null, tier: null);
    }
  }

  /// Fetch featured offers
  Future<List<OfferModel>> fetchFeaturedOffers({int limit = 10}) async {
    try {
      final response = await _apiService.get('/offers/featured?limit=$limit');

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> offersJson = response['data'] is List
            ? response['data']
            : response['data']['offers'] ?? [];

        return offersJson.map((json) => OfferModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('[HomeService] Error fetching featured offers: $e');
      return [];
    }
  }

  /// Fetch all offers with optional category filter
  Future<List<OfferModel>> fetchOffers({String? category, int? limit}) async {
    try {
      String endpoint = '/offers';
      final params = <String>[];

      if (category != null) params.add('category=$category');
      if (limit != null) params.add('limit=$limit');

      if (params.isNotEmpty) {
        endpoint += '?${params.join('&')}';
      }

      final response = await _apiService.get(endpoint);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> offersJson = response['data'] is List
            ? response['data']
            : response['data']['offers'] ?? [];

        return offersJson.map((json) => OfferModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('[HomeService] Error fetching offers: $e');
      return [];
    }
  }

  /// Fetch recent activity
  Future<List<ActivityModel>> fetchRecentActivity({int limit = 10}) async {
    try {
      final response = await _apiService.get('/user/activity?limit=$limit');

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> activitiesJson = response['data'] is List
            ? response['data']
            : response['data']['activities'] ?? [];

        return activitiesJson.map((json) => ActivityModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('[HomeService] Error fetching recent activity: $e');
      return [];
    }
  }
}
