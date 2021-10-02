class UserDetails {
  final String? time;
  final String? name;
  final String? rfid;
  final String? keyStatus;

  UserDetails({this.time, this.name, this.rfid, this.keyStatus});

  factory UserDetails.fromJson(Map<dynamic, dynamic> json) {
    return UserDetails(
      time: json['Timestatus'],
      name: json['Name'],
      rfid: json['Rfid'],
      keyStatus: json['Key_status'],
    );
  }
}

// class KeyDetail {
//   String? timestamp;
//   UserDetails? userDetails;

//   KeyDetail({this.timestamp, this.userDetails});

//   factory KeyDetail.fromJson(Map<String, dynamic> parsedJson) {
//     // var list = parsedJson[timestamp] as List;
//     // List<UserDetails> detailList =
//     //     list.map((e) => UserDetails.fromJson(e)).toList();
//     return KeyDetail(
//       timestamp: parsedJson.,
//       userDetails: UserDetails.fromJson(parsedJson),
//     );
//   }
// }
