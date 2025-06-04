class RegistrationUser {

  String Customer_Name;
  String Customer_Address;
  String Customer_Contact;
  String Customer_Email;
  String Customer_Password;

  RegistrationUser (

      this.Customer_Name,
      this.Customer_Address,
      this.Customer_Contact,
      this.Customer_Email,
      this.Customer_Password
  );

  factory RegistrationUser.fromJson(Map<String, dynamic> json) =>
      RegistrationUser(

    json["Customer_Name"],
    json["Customer_Address"],
    json["Customer_Contact"],
    json["Customer_Email"],
    json["Customer_Password"],
  );

  Map<String, dynamic> toJson() => {

    'Customer_Name': Customer_Name,
    'Customer_Address': Customer_Address,
    'Customer_Contact': Customer_Contact,
    'Customer_Email': Customer_Email,
    'Customer_Password': Customer_Password,
  };
}