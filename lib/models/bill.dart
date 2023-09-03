class Bill {
  final int serviceId;
  final int membershipId;
  final double discountAmount;
  final double discountPercent;
  final double totalAmount;

  Bill({
    required this.serviceId,
    required this.membershipId,
    required this.discountAmount,
    required this.discountPercent,
    required this.totalAmount,
  });
}
