
class RentalCancel{
  final int customerID;
  final int carID;
  final String startDate;
  final String endDate;
  final double totalPrice;
  final String rentalStatus;

  RentalCancel({

    required this.customerID,
    required this.carID,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.rentalStatus,

  });

  Map<String, dynamic> toJson(){
    return {
      "Customer_ID": customerID.toString(),
      "Car_ID": carID.toString(),
      "StartDate": startDate,
      "EndDate": endDate,
      "TotalPrice": totalPrice.toString(),
      "RentalStatus": rentalStatus,

    };
  }
}