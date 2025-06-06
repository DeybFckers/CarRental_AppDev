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
  final int customerID;
  final String rentalStatus;
  final double totalPrice;

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
    required this.customerID,
    required this.rentalStatus,
    required this.totalPrice
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      totalPrice: json['TotalPrice'] == null ? 0.0 : double.parse(json['TotalPrice'].toString()),
      carId: json['Car_ID'] == null ? 0 : int.parse(json['Car_ID'].toString()),
      customerName: json['Customer_Name'] ?? '',
      brand: json['Brand'] ?? '',
      model: json['Model'] ?? '',
      plateNumber: json['PlateNumber'] ?? '',
      requestDate: json['RequestDate'] ?? '',
      preferredStartDate: json['PreferredStartDate'] ?? '',
      preferredEndDate: json['PreferredEndDate'] ?? '',
      requestStatus: json['RequestStatus'] ?? '',
      imageUrl: json['ImageURL'] ?? '',
      ownerName: json['Owner_Name'] ?? '',
      dailyRate: json['DailyRate'] == null ? 0.0 : double.parse(json['DailyRate'].toString()),
      customerID: json['Customer_ID'] == null ? 0 : int.parse(json['Customer_ID'].toString()),
      rentalStatus: json['RentalStatus'] ?? '',
    );
  }

}
