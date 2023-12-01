import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'firebase_options.dart';

class FirebaseService {
  static init() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  static FirebaseApp getAppInstance() {
    return Firebase.app();
  }

  static Future<void> deleteAppInstance() async {
    await Firebase.app().delete();
  }
}

class FireStoreService {
  late FirebaseFirestore firestore;

  late CollectionReference col;

  FireStoreService(String collectionName) {
    firestore = FirebaseFirestore.instance;
    col = firestore.collection(collectionName);
  }
  Stream<QuerySnapshot> retriveData() {
    return col
        .where("user", isEqualTo: FirebaseAuthService().getCurrentUser()!.uid)
        .snapshots();
  }

  Future<Map<String, dynamic>> retriveDataMap() async {
    Map<String, dynamic> data = await col.get() as Map<String, dynamic>;
    return data;
  }

  retriveDataWhereMap(String columnName, String val) async {
    try {
      final data = await col.where(columnName, isEqualTo: val).get();
      if (data.docs.isEmpty) {
        return null;
      }
      return data;
    } catch (e) {
      rethrow;
    }
  }

  insertData(Map<String, dynamic> value) async {
    try {
      await col.add(value);
      debugPrint("Data added value ");
    } catch (e) {
      rethrow;
    }
  }

  deleteData(String docId) async {
    try {
      await col.doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }

  updateData(String docId, Map<String, dynamic> newVal) async {
    try {
      await col.where("uid", isEqualTo: docId).get().then((value) {
        value.docs.forEach((element) {
          col.doc(element.id).update(newVal);
        });
      });
    } catch (e) {
      rethrow;
    }
  }
}

class FireStorageService {
  late FirebaseStorage fstorage;

  FireStorageService() {
    fstorage = FirebaseStorage.instance;
  }
  Future<String?> uploadImage(String imgpath) async {
    try {
      String? imgUrl;
      File imgfile = File(imgpath);
      String imgName = DateTime.now().microsecond.toString();
      Reference ref = fstorage.ref().child("images/$imgName");

      UploadTask task = ref.putFile(imgfile);

      await task;

      task.whenComplete(() async {
        debugPrint("Image Upload complete");
      });

      imgUrl = await ref.getDownloadURL();

      return imgUrl;
    } on Exception catch (e) {
      debugPrint("Image Upload Error: $e");
      return e.toString();
    }
  }

  Future<Reference?> uploadToFirebaseStorage(
      Uint8List fileBytes, String fileName) async {
    try {
      // Reference to the root of your Firebase Storage
      final Reference storageReference = fstorage.ref();

      // Create a reference to the file you want to upload
      final Reference fileReference = storageReference.child(fileName);

      // Upload file data using putData
      await fileReference.putData(fileBytes);

      // Get the download URL for the file
      final String downloadURL = await fileReference.getDownloadURL();

      // Handle the download URL as needed (e.g., store it in your database)
      log('File uploaded to Firebase Storage. Download URL: $downloadURL');
      return fileReference;
    } catch (e) {
      log('Error uploading file to Firebase Storage: $e');
    }

    return null;
  }

  deleteFile(String filepath) async {
    // Create a reference to the file to delete
    Reference ref = fstorage.ref().child(filepath);

    // Delete the file
    try {
      await ref.delete();
    } catch (e) {
      debugPrint("Error deleting file: $e");
    }
  }
}

class FirebaseAuthService {
  late FirebaseAuth auth;

  FirebaseAuthService() {
    auth = FirebaseAuth.instance;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential? userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error: ${e.message}");
      throw ErrorDescription(e.message!);
    }
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential? userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Auth Error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Stream<User?> get onAuthStateChanged {
    return auth.authStateChanges();
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword(String password) async {
    await auth.currentUser!.updatePassword(password);
  }
}
