import '../models/user_model.dart';
import '../models/offer_model.dart';
import '../models/activity_model.dart';
import '../models/tier_model.dart';
import 'api_service.dart';

class HomeService {
  final ApiService _apiService;

  HomeService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Fetch user profile data
  Future<UserModel?> fetchUserProfile() async {
    try {
      final response = await _apiService.get('/user/profile');

      if (response['success'] == true && response['data'] != null) {
        return UserModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('[HomeService] Error fetching user profile: $e');
      return null;
    }
  }

  /// Fetch tier information
  Future<TierModel?> fetchTierInfo() async {
    try {
      final response = await _apiService.get('/user/tier');

      if (response['success'] == true && response['data'] != null) {
        return TierModel.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      print('[HomeService] Error fetching tier info: $e');
      return null;
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

        return offersJson
            .map((json) => OfferModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('[HomeService] Error fetching featured offers: $e');
      return [];
    }
  }

  /// Fetch all offers with optional category filter
  Future<List<OfferModel>> fetchOffers({
    String? category,
    int? limit,
  }) async {
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

        return offersJson
            .map((json) => OfferModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('[HomeService] Error fetching offers: $e');
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

        return activitiesJson
            .map((json) => ActivityModel.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print('[HomeService] Error fetching recent activity: $e');
      return [];
    }
  }

  /// Fetch all home screen data in one call (if your API supports it)
  Future<Map<String, dynamic>> fetchHomeData() async {
    try {
      final response = await _apiService.get('/home');

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];

        return {
          'user': data['user'] != null
              ? UserModel.fromJson(data['user'])
              : null,
          'tier': data['tier'] != null
              ? TierModel.fromJson(data['tier'])
              : null,
          'offers': (data['offers'] as List?)
              ?.map((json) => OfferModel.fromJson(json))
              .toList() ?? [],
          'activities': (data['activities'] as List?)
              ?.map((json) => ActivityModel.fromJson(json))
              .toList() ?? [],
        };
      }
      return {};
    } catch (e) {
      print('[HomeService] Error fetching home data: $e');
      return {};
    }
  }
}
