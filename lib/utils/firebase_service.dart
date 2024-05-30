import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reminder_app/utils/snackbar_helper.dart';

class FirebaseService {
  Future<dynamic> signInUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return {
        'type': 'SUCCESS',
        'data': credential,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = SnackbarHelper.getErrorMsgFromCode(e.code);
      return {
        'type': 'ERROR',
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'type': 'ERROR',
        'message': e.toString(),
      };
    }
  }

  Future<dynamic> createUser(
      String email, String password, String firstName, String lastName) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserDetails({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      });
      return {
        'type': 'SUCCESS',
        'data':credential
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage = SnackbarHelper.getErrorMsgFromCode(e.code);
     
      return {
        'type': 'ERROR',
        'message': errorMessage,
      };
    } catch (e) {
      return {
        'type': 'ERROR',
        'message': e.toString(),
      };
    }
  }

  Future<dynamic> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<dynamic> saveUserDetails(Map<String, dynamic> user) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection("Users");
    final userData = {
      "firstName": user['firstName'],
      "lastName": user['lastName'],
      "email": user['email'],
    };

    await usersRef.doc().set(userData).onError(
          (error, stackTrace) => print("Error writing document: $error"),
        );
  }

  Future<dynamic> saveReminders(
      Map<String, dynamic> reminder,String email) async {
        
    CollectionReference reminders = FirebaseFirestore.instance.collection("Reminders");
     
    await reminders.add({
      'title': reminder['title'],
      'description': reminder['description'],
      'time': reminder['time'],
      'email':email,
      'isActive':true,
    });
  }

}
