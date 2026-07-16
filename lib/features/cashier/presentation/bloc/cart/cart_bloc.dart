import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/utils/id_generator.dart';
import '../../../../../features/cashier/data/datasources/cart_storage.dart';
import '../../../../../features/cashier/domain/entities/cart_item.dart';
import '../../../../../features/cashier/domain/entities/cart_tab.dart';
import 'cart_event.dart';
import 'cart_state.dart';

@lazySingleton
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartStorage _storage;

  CartBloc(this._storage) : super(const CartState.loading()) {
    on<CartStarted>(_onStarted);
    on<CartTabAdded>(_onTabAdded);
    on<CartTabSwitched>(_onTabSwitched);
    on<CartTabClosed>(_onTabClosed);
    on<CartCustomerAssigned>(_onCustomerAssigned);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemQtyChanged>(_onItemQtyChanged);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemDiscountSet>(_onItemDiscountSet);
    on<CartGlobalDiscountSet>(_onGlobalDiscountSet);
    on<CartCleared>(_onCleared);
  }

  // ── helpers ──────────────────────────────────────────────────────────────

  CartReady get _ready => state as CartReady;

  Future<void> _persistAndEmit(
    CartReady newState,
    Emitter<CartState> emit,
  ) async {
    emit(newState);
    await _saveAll(newState);
  }

  Future<void> _saveAll(CartReady state) async {
    for (final tab in state.tabs.values) {
      await _storage.saveTab(tab);
    }
    await _storage.saveMeta(
      tabIds: state.tabs.keys.toList(),
      activeTabId: state.activeTabId,
    );
  }

  CartReady _withUpdatedTab(CartTab updated) {
    final tabs = Map<String, CartTab>.from(_ready.tabs)
      ..[updated.id] = updated;
    return CartReady(tabs: tabs, activeTabId: _ready.activeTabId);
  }

  CartTab get _activeTab => _ready.tabs[_ready.activeTabId]!;

  // ── handlers ─────────────────────────────────────────────────────────────

  Future<void> _onStarted(CartStarted _, Emitter<CartState> emit) async {
    final saved = await _storage.loadAll();
    if (saved == null || saved.tabs.isEmpty) {
      final tab = CartTab(id: generateId());
      emit(CartReady(
        tabs: {tab.id: tab},
        activeTabId: tab.id,
      ));
      await _saveAll(state as CartReady);
    } else {
      final tabMap = {for (final t in saved.tabs) t.id: t};
      emit(CartReady(
        tabs: tabMap,
        activeTabId: saved.activeTabId ?? saved.tabs.first.id,
      ));
    }
  }

  Future<void> _onTabAdded(CartTabAdded _, Emitter<CartState> emit) async {
    final tab = CartTab(id: generateId());
    final tabs = Map<String, CartTab>.from(_ready.tabs)..[tab.id] = tab;
    await _persistAndEmit(
      CartReady(tabs: tabs, activeTabId: tab.id),
      emit,
    );
  }

  Future<void> _onTabSwitched(
    CartTabSwitched event,
    Emitter<CartState> emit,
  ) async {
    if (!_ready.tabs.containsKey(event.tabId)) return;
    await _persistAndEmit(
      CartReady(tabs: _ready.tabs, activeTabId: event.tabId),
      emit,
    );
  }

  Future<void> _onTabClosed(
    CartTabClosed event,
    Emitter<CartState> emit,
  ) async {
    if (_ready.tabs.length <= 1) return; // always keep at least one tab
    final tabs = Map<String, CartTab>.from(_ready.tabs)
      ..remove(event.tabId);
    final newActive = _ready.activeTabId == event.tabId
        ? tabs.keys.first
        : _ready.activeTabId;
    await _storage.deleteTab(event.tabId);
    await _persistAndEmit(CartReady(tabs: tabs, activeTabId: newActive), emit);
  }

  Future<void> _onCustomerAssigned(
    CartCustomerAssigned event,
    Emitter<CartState> emit,
  ) async {
    final tab = _ready.tabs[event.tabId];
    if (tab == null) return;
    await _persistAndEmit(
      _withUpdatedTab(
        tab.copyWith(customerId: event.customerId, customerName: event.name),
      ),
      emit,
    );
  }

  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    final items = List<CartItem>.from(_activeTab.items);
    final idx = items.indexWhere(
      (i) => i.productGuid == event.item.productGuid,
    );
    if (idx >= 0) {
      items[idx] = items[idx].copyWith(qty: items[idx].qty + event.item.qty);
    } else {
      items.add(event.item);
    }
    await _persistAndEmit(
      _withUpdatedTab(_activeTab.copyWith(items: items)),
      emit,
    );
  }

  Future<void> _onItemQtyChanged(
    CartItemQtyChanged event,
    Emitter<CartState> emit,
  ) async {
    if (event.qty <= 0) {
      add(CartEvent.itemRemoved(productGuid: event.productGuid));
      return;
    }
    final items = _activeTab.items.map((i) {
      return i.productGuid == event.productGuid ? i.copyWith(qty: event.qty) : i;
    }).toList();
    await _persistAndEmit(
      _withUpdatedTab(_activeTab.copyWith(items: items)),
      emit,
    );
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    final items = _activeTab.items
        .where((i) => i.productGuid != event.productGuid)
        .toList();
    await _persistAndEmit(
      _withUpdatedTab(_activeTab.copyWith(items: items)),
      emit,
    );
  }

  Future<void> _onItemDiscountSet(
    CartItemDiscountSet event,
    Emitter<CartState> emit,
  ) async {
    final items = _activeTab.items.map((i) {
      return i.productGuid == event.productGuid
          ? i.copyWith(discount: event.discount)
          : i;
    }).toList();
    await _persistAndEmit(
      _withUpdatedTab(_activeTab.copyWith(items: items)),
      emit,
    );
  }

  Future<void> _onGlobalDiscountSet(
    CartGlobalDiscountSet event,
    Emitter<CartState> emit,
  ) async {
    await _persistAndEmit(
      _withUpdatedTab(_activeTab.copyWith(globalDiscount: event.discount)),
      emit,
    );
  }

  Future<void> _onCleared(CartCleared event, Emitter<CartState> emit) async {
    final tab = _ready.tabs[event.tabId];
    if (tab == null) return;
    await _persistAndEmit(
      _withUpdatedTab(tab.copyWith(
        items: const [],
        globalDiscount: 0,
        customerId: null,
        customerName: null,
      )),
      emit,
    );
  }
}
