class userModal {
  String? uId;
  String? fullName;
  String? email;
  String? profilePic;
  String? phoneNo;

  userModal({this.uId, this.fullName, this.email, this.profilePic,this.phoneNo});

  userModal.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    fullName = json['fullName'];
    email = json['email'];
    profilePic = json['profilePic'];
    phoneNo = json['phoneNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['fullName'] = this.fullName;
    data['email'] = this.email;
    data['profilePic'] = this.profilePic;
    data['phoneNo'] = this.phoneNo;
    return data;
  }
}
