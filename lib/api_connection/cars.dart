class Car {
  final int carId;
  final String ownerName;
  final String brand;
  final String model;
  final String plateNumber;
  final double dailyRate;
  final String imageUrl;
  final int seatCapacity;

  Car({
    required this.carId,
    required this.ownerName,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.dailyRate,
    required this.imageUrl,
    required this.seatCapacity,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      carId: int.parse(json['Car_ID'].toString()),
      brand: json['Brand'],
      model: json['Model'],
      plateNumber: json['PlateNumber'],
      imageUrl: json['ImageURL'],
      seatCapacity: int.parse(json['seat_capacity']),
      dailyRate: double.parse(json['DailyRate']),
      ownerName: json['Owner_Name'],
    );
  }
}
