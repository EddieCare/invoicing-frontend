enum PlanId { free, plus, premium }

class PlanLimits {
  final int? invoices; // null => unlimited
  final int? products; // null => unlimited
  final int? services; // null => unlimited

  const PlanLimits({this.invoices, this.products, this.services});

  factory PlanLimits.fromMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      int? _toInt(dynamic v) {
        if (v == null) return null;
        if (v is int) return v;
        if (v is double) return v.toInt();
        final s = v.toString();
        if (s.toLowerCase() == 'unlimited') return null;
        return int.tryParse(s);
      }

      return PlanLimits(
        invoices: _toInt(data['invoices']),
        products: _toInt(data['products']),
        services: _toInt(data['services']),
      );
    }

    // Safe defaults
    return const PlanLimits(invoices: 5, products: 5, services: 2);
  }

  PlanLimits copyWith({int? invoices, int? products, int? services}) {
    return PlanLimits(
      invoices: invoices ?? this.invoices,
      products: products ?? this.products,
      services: services ?? this.services,
    );
  }
}

class SubscriptionInfo {
  final PlanId planId;
  final String planName;
  final String period; // MONTHLY or YEARLY
  final DateTime? expiry;
  final PlanLimits limits;

  const SubscriptionInfo({
    required this.planId,
    required this.planName,
    required this.period,
    required this.limits,
    this.expiry,
  });
}

