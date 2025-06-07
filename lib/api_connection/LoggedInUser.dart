class LoggedInUser {
  final int Customer_ID;
  final String Customer_Name;
  final String Customer_Address;
  final String Customer_Contact;
  final String Customer_Email;
  final String Customer_Password;

  LoggedInUser(
      this.Customer_ID,
      this.Customer_Name,
      this.Customer_Address,
      this.Customer_Contact,
      this.Customer_Email,
      this.Customer_Password,
      );

  factory LoggedInUser.fromJson(Map<String, dynamic> json) {
    return LoggedInUser(
      int.parse(json['Customer_ID'].toString()),
      json['Customer_Name'],
      json['Customer_Address'],
      json['Customer_Contact'],
      json['Customer_Email'],
      json['Customer_Password'],
    );
  }

  String get userType => 'customer';
}
