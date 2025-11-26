import 'package:chat_app/features/auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> loginWithEmailandPassword({
    required String email,
    required String password,
  });
  Future<UserModel> signInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  AuthRemoteDatasourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });
  @override
  Future<UserModel> loginWithEmailandPassword({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw Exception("Login failed");

    return UserModel(
      user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      password: password,
    );
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    await firestore.collection('Users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
    });
    return UserModel(uid, name: name, email: email, password: password);
  }
}
