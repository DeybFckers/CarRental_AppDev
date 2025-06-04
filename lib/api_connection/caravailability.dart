class CarAvailability {
  final DateTime availableFrom;
  final DateTime availableTo;

  CarAvailability({
    required this.availableFrom,
    required this.availableTo,
  });

  factory CarAvailability.fromJson(Map<String, dynamic> json) {
    return CarAvailability(
      availableFrom: DateTime.parse(json['AvailableFrom']),
      availableTo: DateTime.parse(json['AvailableTo']),
    );
  }
}
