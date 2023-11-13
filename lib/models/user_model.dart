class User {
  late String uid;
  late String email;
  late String name;
  late String? phone;

  User(
      {required this.uid, required this.email, required this.name, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    email = json['email'] ?? '';
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}
