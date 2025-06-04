class BookingRequest {
  final int customerId;
  final int carId;
  final String preferredStartDate;
  final String preferredEndDate;

  BookingRequest({
    required this.customerId,
    required this.carId,
    required this.preferredStartDate,
    required this.preferredEndDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "Customer_Id": customerId.toString(),
      "Car_Id": carId.toString(),
      "PreferredStartDate": preferredStartDate,
      "PreferredEndDate": preferredEndDate,
    };
  }
}
