class BookingRequest {
  final int customerId;
  final int carId;
  final String preferredStartDate;
  final String preferredEndDate;
  final String paymentMethod;

  BookingRequest({
    required this.customerId,
    required this.carId,
    required this.preferredStartDate,
    required this.preferredEndDate,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      "Customer_Id": customerId.toString(),
      "Car_Id": carId.toString(),
      "PreferredStartDate": preferredStartDate,
      "PreferredEndDate": preferredEndDate,
      "PreferredPaymentMethod" : paymentMethod,
    };
  }
}
