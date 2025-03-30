class skincareModel {
  String? name;
  String? description;
  String? timestamp;
  String? imageUrl;
  bool? isDone;

  skincareModel({this.name, this.description, this.timestamp, this.imageUrl,this.isDone});

  skincareModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    timestamp = json['timestamp'];
    imageUrl = json['imageUrl'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['timestamp'] = this.timestamp;
    data['imageUrl'] = this.imageUrl;
    data['isDone'] = this.isDone;
    return data;
  }
}
