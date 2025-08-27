import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:projectmercury/models/store_item.dart';

class AnalyticsMethods {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> setUserProperties(String userId) async {
    await _analytics.setUserId(id: userId);
  }

  Future<void> setCurrentScreen(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logPurchaseEvent(StoreItem item) async {
    await _analytics.logSpendVirtualCurrency(
      itemName: item.name,
      virtualCurrencyName: '',
      value: item.price,
    );
  }
}
