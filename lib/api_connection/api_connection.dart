class API
{
  static const hostConnect = "http://192.168.1.45/carrentalbackend_php";
  static const hostConnectUser = "$hostConnect/user";

  //signUp user
  static const signUp = "$hostConnect/user/signup.php";
  static const validateEmail = "$hostConnect/user/validate_email.php";
  static const login = "$hostConnect/user/login.php";

  //cars
  static const getcars = "$hostConnect/cars/get_cars.php";

  //bookingRequest
  static const getbookingrequest = "$hostConnect/bookingrequest/submit_bookin"
      "g.php";

  //bookingDetails
  static const getbookingdetails = "$hostConnect/bookingrequest/details_booki"
      "ng.php";

  //rentalCancellation
  static const cancelRental = "$hostConnect/cancellation/rental_cancel.php";

  //caravailable
  static const carAvailable = "$hostConnect/cars/carAvailability.php";
}