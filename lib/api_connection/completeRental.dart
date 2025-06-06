class RentalComplete {
  final int rentalID;
  final int customerID;
  final int carID;
  final String startDate;
  final String endDate;
  final double totalPrice;
  final String rentalStatus;

  RentalComplete({
    required this.rentalID,
    required this.customerID,
    required this.carID,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.rentalStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'Rental_ID': rentalID.toString(),
      'Customer_ID': customerID.toString(),
      'Car_ID': carID.toString(),
      'StartDate': startDate,
      'EndDate': endDate,
      'TotalPrice': totalPrice.toString(),
      'RentalStatus': rentalStatus,
    };
  }

}
