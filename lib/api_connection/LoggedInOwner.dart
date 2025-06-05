class LoggedInOwner {
  final int Owner_ID;
  final String Owner_Name;
  final String Owner_Address;
  final String Owner_Contact;
  final String Owner_Email;
  final String Owner_Password;

  LoggedInOwner(
      this.Owner_ID,
      this.Owner_Name,
      this.Owner_Address,
      this.Owner_Contact,
      this.Owner_Email,
      this.Owner_Password,
      );

  factory LoggedInOwner.fromJson(Map<String, dynamic> json) {
    return LoggedInOwner(
      int.parse(json['Owner_ID'].toString()),
      json['Owner_Name'],
      json['Owner_Address'],
      json['Owner_Contact'],
      json['Owner_Email'],
      json['Owner_Password'],
    );
  }
}
