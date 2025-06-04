class BookingDetails {
  final String customerName;
  final String brand;
  final String model;
  final String plateNumber;
  final String requestDate;
  final String preferredStartDate;
  final String preferredEndDate;
  final String requestStatus;
  final String imageUrl;
  final String ownerName;
  final double dailyRate;
  final int carId;

  BookingDetails({
    required this.customerName,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.requestDate,
    required this.preferredStartDate,
    required this.preferredEndDate,
    required this.requestStatus,
    required this.imageUrl,
    required this.ownerName,
    required this.dailyRate,
    required this.carId,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      carId: int.parse(json['Car_ID']),
      customerName: json['Customer_Name'],
      brand: json['Brand'],
      model: json['Model'],
      plateNumber: json['PlateNumber'],
      requestDate: json['RequestDate'],
      preferredStartDate: json['PreferredStartDate'],
      preferredEndDate: json['PreferredEndDate'],
      requestStatus: json['RequestStatus'],
      imageUrl: json['ImageURL'],
      ownerName: json['Owner_Name'],
      dailyRate: double.parse(json['DailyRate']),
    );
  }
}
