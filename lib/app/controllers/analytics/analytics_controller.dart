import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../services/analytics_service.dart';
import '../../../services/subscription_service.dart';

class AnalyticsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final isLoading = false.obs;
  final hasData = false.obs;

  final summary = <String, dynamic>{}.obs; // current month summary
  final remainingInvoices = 0.obs;

  late final AnalyticsService _analytics;
  late final PlanService _planService;

  String? get email => _auth.currentUser?.email;
  String vendorId = '';
  String shopId = '';

  @override
  void onInit() {
    super.onInit();
    _analytics = AnalyticsService();
    _planService = PlanService();
    _init();
  }

  Future<void> _init() async {
    if (email == null) return;
    isLoading.value = true;
    vendorId = email!;

    final shopSnapshot = await _db
        .collection('vendors')
        .doc(vendorId)
        .collection('shops')
        .limit(1)
        .get();
    if (shopSnapshot.docs.isEmpty) {
      isLoading.value = false;
      hasData.value = false;
      return;
    }
    shopId = shopSnapshot.docs.first.id;

    await refreshAnalytics();
    await _computeRemainingInvoices();
    isLoading.value = false;
  }

  Future<void> _computeRemainingInvoices() async {
    final info = await _planService.checkPlanLimit(vendorId, shopId: shopId);
    final remaining = info['remaining'];
    if (remaining is num) {
      remainingInvoices.value = remaining.toInt();
    } else {
      remainingInvoices.value = 99999; // effectively unlimited
    }
  }

  Future<void> refreshAnalytics() async {
    if (email == null) return;
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    final periodKey = DateFormat('yyyy-MM').format(now);

    // Try saved first
    final saved = await _analytics.getSavedSummary(
      vendorEmail: email!,
      granularity: 'monthly',
      periodKey: periodKey,
    );

    if (saved != null) {
      final normalized = Map<String, dynamic>.from(saved);
      final lid = normalized['lastInvoiceDate'];
      if (lid != null && lid is Timestamp) {
        normalized['lastInvoiceDate'] = lid.toDate();
      }
      summary.assignAll(normalized);
      hasData.value = (normalized['totalInvoices'] ?? 0) > 0;
      if (hasData.value) return;
      // fall through to compute fallback if monthly has zero
    }

    // Compute and persist
    final computed = await _analytics.computePeriodAnalytics(
      vendorEmail: email!,
      from: monthStart,
      to: nextMonth,
    );

    if (computed.isNotEmpty) {
      await _analytics.saveAnalyticsSummary(
        vendorEmail: email!,
        summary: computed,
        granularity: 'monthly',
        periodKey: periodKey,
      );
      final normalized = Map<String, dynamic>.from(computed);
      summary.assignAll(normalized);
      hasData.value = (normalized['totalInvoices'] ?? 0) > 0;
    } else {
      hasData.value = false;
    }

    // Fallback: if this month has no invoices, show last 90 days
    if (!hasData.value) {
      final from90 = now.subtract(const Duration(days: 90));
      final computed90 = await _analytics.computePeriodAnalytics(
        vendorEmail: email!,
        from: from90,
        to: now.add(const Duration(days: 1)),
      );
      if (computed90.isNotEmpty && (computed90['totalInvoices'] ?? 0) > 0) {
        // do not overwrite monthly doc; just present in-memory
        final normalized = Map<String, dynamic>.from(computed90);
        final lid = normalized['lastInvoiceDate'];
        if (lid != null && lid is Timestamp) {
          normalized['lastInvoiceDate'] = lid.toDate();
        }
        summary.assignAll(normalized);
        hasData.value = true;
      }
    }
  }
}
