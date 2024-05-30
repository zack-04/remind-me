// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reminder_app/models/reminder_model.dart';

// final reminderProvider = StreamProvider.family((ref,email) {
//   return FirebaseFirestore.instance
//       .collection('reminders')
//       .where('userId', isEqualTo: email)
//       .orderBy('timestamp', descending: true)
//       .snapshots()
//       .map((snapshot) => snapshot.docs
//           .map((doc) => Reminder.fromMap(doc.data()))
//           .toList());

// },);
