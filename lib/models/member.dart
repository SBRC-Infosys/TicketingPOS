class Member {
  final String memberName;
  final int membershipTypeId;
  final String memberAddress;
  final String memberEmail;
  final String memberPhone;
  final String startDate;
  final String? endDate; 
  final String status;
  final int discountPercentage;

  Member({
    required this.memberName,
    required this.membershipTypeId,
    required this.memberAddress,
    required this.memberEmail,
    required this.memberPhone,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.discountPercentage,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      memberName: json['memberName'],
      membershipTypeId: json['membershipTypeId'],
      memberAddress: json['memberAddress'],
      memberEmail: json['memberEmail'],
      memberPhone: json['memberPhone'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      status: json['status'],
      discountPercentage: json['discountPercentage'],
    );
  }
}
