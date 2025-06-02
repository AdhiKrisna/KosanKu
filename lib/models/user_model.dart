class UserModel {
  String? status;
  String? message;
  String? accessToken;
  User? data;

  UserModel({this.status, this.message, this.accessToken, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    accessToken = json['accessToken'];
    data = json['data'] != null ? User.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'accessToken': accessToken,
    'data': data?.toJson(),
  };
}

class User {
  int? userId;
  String? userName;
  String? userPhone;
  String? userEmail;
  String? userPassword;
  String? userToken;

  User({this.userId, this.userName, this.userPhone, this.userEmail, this.userPassword, this.userToken});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    userEmail = json['user_email'];
    userPassword = json['user_password'];
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_name': userName,
    'user_phone': userPhone,
    'user_email': userEmail,
    'user_password': userPassword,
  };
}
