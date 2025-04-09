
class PostOfficeModel {
  final String name;
  final String description;
  final String branchType;
  final String deliveryStatus;
  final String circle;
  final String district;
  final String division;
  final String region;
  final String block;
  final String state;
  final String country;
  final String pincode;

  PostOfficeModel({
    required this.name,
    required this.description,
    required this.branchType,
    required this.deliveryStatus,
    required this.circle,
    required this.district,
    required this.division,
    required this.region,
    required this.block,
    required this.state,
    required this.country,
    required this.pincode,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'branchType': branchType,
      'deliveryStatus': deliveryStatus,
      'circle': circle,
      'district': district,
      'division': division,
      'region': region,
      'block': block,
      'state': state,
      'country': country,
      'pincode': pincode,
    };
  }

  factory PostOfficeModel.fromJson(Map<String, dynamic> json) {
    return PostOfficeModel(
      name: json['Name'] ?? '',
      description: json['Description'] ?? '',
      branchType: json['BranchType'] ?? '',
      deliveryStatus: json['DeliveryStatus'] ?? '',
      circle: json['Circle'] ?? '',
      district: json['District'] ?? '',
      division: json['Division'] ?? '',
      region: json['Region'] ?? '',
      block: json['Block'] ?? '',
      state: json['State'] ?? '',
      country: json['Country'] ?? '',
      pincode: json['Pincode'] ?? '',
    );
  }
} 