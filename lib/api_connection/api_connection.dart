class API
{
  static const hostConnect = "http://192.168.1.45/carrentalbackend_php";
  static const hostConnectUser = "$hostConnect/user";

  //signUp/login user
  static const signUp = "$hostConnect/user/signup.php";
  static const validateEmail = "$hostConnect/user/validate_email.php";
  static const login = "$hostConnect/user/login.php";
  static const Ownerlogin = "$hostConnect/user/loginowner.php";

  //cars
  static const getcars = "$hostConnect/cars/get_cars.php";

  //bookingRequest
  static const getbookingrequest = "$hostConnect/bookingrequest/submit_bookin"
      "g.php";

  //bookingDetails
  static const getbookingdetails = "$hostConnect/bookingrequest/details_booki"
      "ng.php";

  //rental
  static const cancelRental = "$hostConnect/rental/rental_cancel.php";
  static const approvedRental = "$hostConnect/rental/rental_confirm.php";
  static const completedRental = "$hostConnect/rental/rental_completed.php";

  //caravailable
  static const carAvailable = "$hostConnect/cars/carAvailability.php";

  //review
  static const submitReview ="$hostConnect/review/submit_review.php";
  static const checkReview = "$hostConnect/review/check_review.php";
  static const getReview = "$hostConnect/review/get_review.php";

  //messages
  static const getConversation = "$hostConnect/messages/getconversation.php";
  static const getMessage = "$hostConnect/messages/getmessages.php";
  static const sendMessage = "$hostConnect/messages/sendmessage.php";

}