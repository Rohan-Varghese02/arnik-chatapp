

import 'package:chat_app/features/auth/domain/entities/user_data.dart';

class UserModel extends UserData{
  UserModel(super.uid, {required super.name, required super.email, required super.password});
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      map['uid'],
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }
  //map for Firestore
  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password, 'uid': uid};
  }
}