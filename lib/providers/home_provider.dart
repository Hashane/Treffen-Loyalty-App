import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/offer_model.dart';
import '../models/activity_model.dart';
import '../models/tier_model.dart';
import '../services/home_service.dart';

enum HomeLoadingState { initial, loading, loaded, error, refreshing }

class HomeProvider with ChangeNotifier {
  final HomeService _homeService;

  HomeProvider({HomeService? homeService}) : _homeService = homeService ?? HomeService();

  // State
  HomeLoadingState _state = HomeLoadingState.initial;
  String? _errorMessage;

  // Data
  UserModel? _user;
  TierModel? _tier;
  List<OfferModel> _offers = [];
  List<ActivityModel> _activities = [];

  // Getters
  HomeLoadingState get state => _state;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;
  TierModel? get tier => _tier;
  List<OfferModel> get offers => _offers;
  List<ActivityModel> get activities => _activities;

  bool get isLoading => _state == HomeLoadingState.loading;
  bool get isRefreshing => _state == HomeLoadingState.refreshing;
  bool get hasError => _state == HomeLoadingState.error;
  bool get isLoaded => _state == HomeLoadingState.loaded;

  /// Load all home screen data
  Future<void> loadHomeData({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        _state = HomeLoadingState.refreshing;
      } else {
        _state = HomeLoadingState.loading;
        _errorMessage = null;
      }
      notifyListeners();

      // Fetch user+tier combined, and offers/activities in parallel
      final results = await Future.wait([
        _homeService.fetchUserWithTier(),
        _homeService.fetchFeaturedOffers(limit: 10),
        _homeService.fetchRecentActivity(limit: 10),
      ]);

      final userTier = results[0] as ({UserModel? user, TierModel? tier});
      _user = userTier.user;
      _tier = userTier.tier;
      _offers = results[1] as List<OfferModel>;
      _activities = results[2] as List<ActivityModel>;

      _state = HomeLoadingState.loaded;
      _errorMessage = null;
    } catch (e) {
      _state = HomeLoadingState.error;
      _errorMessage = e.toString();
      debugPrint('[HomeProvider] Error loading home data: $e');
    } finally {
      notifyListeners();
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadHomeData(isRefresh: true);
  }

  /// Clear error state
  void clearError() {
    _errorMessage = null;
    if (_state == HomeLoadingState.error) {
      _state = HomeLoadingState.initial;
      notifyListeners();
    }
  }

  /// Reset provider state
  void reset() {
    _state = HomeLoadingState.initial;
    _errorMessage = null;
    _user = null;
    _tier = null;
    _offers = [];
    _activities = [];
    notifyListeners();
  }
}
