import 'package:chat_app/features/auth/data/model/user_model.dart';
import 'package:chat_app/features/home/data/datasource/cloudinary_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> loginWithEmailandPassword({
    required String email,
    required String password,
  });
  Future<UserModel> signInWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    String? photoUrl,
  });
  Future<UserModel> signInWithGoogle();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;
  AuthRemoteDatasourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
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
    String? photoUrl,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final uid = credential.user!.uid;
    
    String? uploadedPhotoUrl = photoUrl;
    if (photoUrl != null && photoUrl.isNotEmpty) {
      try {
        uploadedPhotoUrl = await CloudinaryService.uploadImage(photoUrl);
      } catch (e) {
        throw Exception('Failed to upload profile image: $e');
      }
    }

    await firestore.collection('Users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'photoUrl': uploadedPhotoUrl ?? '',
    });

    if (uploadedPhotoUrl != null && uploadedPhotoUrl.isNotEmpty) {
      await firebaseAuth.currentUser?.updatePhotoURL(uploadedPhotoUrl);
    }
    await firebaseAuth.currentUser?.updateDisplayName(name);

    return UserModel(uid, name: name, email: email, password: password);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign in was cancelled');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    
    if (user == null) {
      throw Exception('Google sign in failed');
    }

    final userName = user.displayName ?? googleUser.displayName ?? '';
    final userEmail = user.email ?? '';
    final photoUrl = user.photoURL ?? googleUser.photoUrl ?? '';

    await firestore.collection('Users').doc(user.uid).set({
      'uid': user.uid,
      'name': userName,
      'email': userEmail,
      'password': '',
      'photoUrl': photoUrl,
    }, SetOptions(merge: true));

    await firebaseAuth.currentUser?.updateDisplayName(userName);
    if (photoUrl.isNotEmpty) {
      await firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
    }

    return UserModel(
      user.uid,
      name: userName,
      email: userEmail,
      password: '',
    );
  }
}
