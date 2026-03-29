import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) => LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) => json.encode(data.toJson());

class LoginRequestModel {
    String email;
    String pwd;

    LoginRequestModel({
        required this.email,
        required this.pwd,
    });

    factory LoginRequestModel.fromJson(Map<String, dynamic> json) => LoginRequestModel(
        email: json["email"],
        pwd: json["pwd"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "pwd": pwd,
    };
}
