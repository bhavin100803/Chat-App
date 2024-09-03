class UserModel {
  String? uid;
  String? fullname;
  String? email;
  String? profilepic;
  String? phonenumber;
  String? photo;

  UserModel({this.uid, this.fullname, this.email, this.profilepic,this.phonenumber,this.photo});


  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    fullname = map["fullname"];
    email = map["email"];
    profilepic = map["profilepic"];
    phonenumber = map["phonenumber"];
    photo = map["photo"];

  }

  UserModel.fromMap2() {
    uid = "123456789";
    fullname = "Robot";
    email = "Jaydip@gmail.com";
    profilepic = "profilepic";
  }


  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": fullname,
      "email": email,
      "profilepic": profilepic,
      "phonenumber": phonenumber,
      "photo": photo
    };
  }
}