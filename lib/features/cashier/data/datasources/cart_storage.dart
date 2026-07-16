import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/cart_tab.dart';

@lazySingleton
class CartStorage {
  static const _boxName = 'cart_box';
  static const _metaKey = 'cart_meta';

  Future<Box> get _box async => Hive.openBox(_boxName);

  Future<void> saveTab(CartTab tab) async {
    final box = await _box;
    await box.put('cart_tab_${tab.id}', jsonEncode(tab.toJson()));
  }

  Future<void> deleteTab(String tabId) async {
    final box = await _box;
    await box.delete('cart_tab_$tabId');
  }

  Future<void> saveMeta({
    required List<String> tabIds,
    required String activeTabId,
  }) async {
    final box = await _box;
    await box.put(_metaKey, jsonEncode({'tabIds': tabIds, 'activeTabId': activeTabId}));
  }

  /// Returns all saved tabs + active tab id. Null if no saved state.
  Future<({List<CartTab> tabs, String? activeTabId})?> loadAll() async {
    final box = await _box;
    final rawMeta = box.get(_metaKey) as String?;
    if (rawMeta == null) return null;

    final meta = jsonDecode(rawMeta) as Map<String, dynamic>;
    final tabIds = (meta['tabIds'] as List).cast<String>();
    final activeTabId = meta['activeTabId'] as String?;

    final tabs = <CartTab>[];
    for (final id in tabIds) {
      final raw = box.get('cart_tab_$id') as String?;
      if (raw != null) {
        tabs.add(CartTab.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      }
    }

    return (tabs: tabs, activeTabId: activeTabId);
  }
}
