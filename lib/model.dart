class UserDetails {
  final String? time;
  final String? name;
  final String? rfid;
  final String? keyStatus;

  UserDetails({this.time, this.name, this.rfid, this.keyStatus});

  factory UserDetails.fromJson(Map<dynamic, dynamic> json) {
    return UserDetails(
      time: json['Timestamp'],
      name: json['Name'],
      rfid: json['Rfid'],
      keyStatus: json['Key_status'],
    );
  }
}
