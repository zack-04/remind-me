import 'package:cloud_firestore/cloud_firestore.dart';

class Reminder {
  Timestamp? timestamp;
  bool? onToggle;

  Reminder({
    required this.timestamp,
    required this.onToggle,
  });

  Map<String, dynamic> toMap() {
    return {
      'time': timestamp,
      'onToggle': onToggle,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      timestamp: map['time'] ?? '',
      onToggle: map['onToggle'] ?? '',
    );
  }
}
