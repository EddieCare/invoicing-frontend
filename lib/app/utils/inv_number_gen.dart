String generateInvoiceNumber(String? lastInvoiceNumber) {
  final now = DateTime.now();
  final today =
      "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";

  if (lastInvoiceNumber != null && lastInvoiceNumber.contains(today)) {
    final parts = lastInvoiceNumber.split("-");
    final count = int.tryParse(parts.last) ?? 0;
    final next = count + 1;
    return "INV-$today-${next.toString().padLeft(3, '0')}";
  }
  return "INV-$today-001";
}
