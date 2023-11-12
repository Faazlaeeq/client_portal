class DocFileModel {
  late String name;
  late String path;
  late String type;
  late String size;
  late String date;
  late String user;

  DocFileModel(
      {required this.name,
      required this.path,
      required this.type,
      required this.size,
      required this.date,
      required this.user});

  DocFileModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    type = json['type'] ?? '';
    path = json['path'] ?? '';
    size = json['size'] ?? '';
    this.date = json['date'] ?? DateTime.now().toString();
    this.user = json['user'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['path'] = this.path;
    data['type'] = this.type;
    data['size'] = this.size;
    data['date'] = this.date;
    data['user'] = this.user;
    return data;
  }
}
