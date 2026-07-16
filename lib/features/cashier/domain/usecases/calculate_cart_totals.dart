import 'package:injectable/injectable.dart';

import '../entities/cart_tab.dart';
import '../entities/cart_totals.dart';

/// Pure function — single source of truth for all cart calculations.
/// Widgets MUST NOT calculate totals themselves.
@injectable
class CalculateCartTotals {
  const CalculateCartTotals();

  CartTotals call(CartTab tab) {
    double subTotal = 0;
    double totalDiscount = tab.globalDiscount;
    double totalPpn = 0;

    for (final item in tab.items) {
      final lineBase = item.price * item.qty;
      final lineAfterDiscount = lineBase - item.discount;
      subTotal += lineBase;
      totalDiscount += item.discount;
      totalPpn += lineAfterDiscount * (item.ppn / 100);
    }

    final grandTotal = subTotal - totalDiscount + totalPpn;
    return CartTotals(
      subTotal: subTotal,
      totalDiscount: totalDiscount,
      totalPpn: totalPpn,
      grandTotal: grandTotal,
    );
  }
}
