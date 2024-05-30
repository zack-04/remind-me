import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/provider/email_provider.dart';
import 'package:reminder_app/provider/reminder_provider.dart';
import 'package:reminder_app/screens/add_reminder_screen.dart';
import 'package:reminder_app/screens/signin_screen.dart';
import 'package:reminder_app/services/notification_service.dart';
import 'package:reminder_app/utils/firebase_service.dart';
import 'package:reminder_app/widgets/reminder_card.dart';


class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen(this.email, {super.key});

  final String email;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool on = true;
  @override
  void initState() {
    super.initState();
  }

  void signOut() async {
    await FirebaseService().logOut();
    ref.watch(emailProvider);
  }

  @override
  Widget build(BuildContext context) {
   
    // final email = ref.watch(emailProvider);
    final _firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RemindMe',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigninScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.sp,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Reminders')
                      .where('email', isEqualTo: widget.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return Container(
                        margin: EdgeInsets.only(top: 40.sp),
                        child: Text(
                          'No reminders added...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                          ),
                        ),
                      );
                    } else {
                      final reminders = snapshot.data?.docs ?? [];
                      return ListView.builder(
                        itemCount: reminders.length,
                        itemBuilder: (context, index) {
                          var reminder = reminders[index];

                          DateTime dateTime = reminder['time'].toDate();
                          String formattedDateTime =
                              DateFormat('d MMM, hh:mm a').format(dateTime);
                          // on = reminder['isActive'];
                          // if (on) {
                          //   NotificationService.showNotifications(
                          //     dateTime: dateTime,
                          //     title: reminder['title'],
                          //     description: reminder['description'],
                          //   );
                          // }
                          return ReminderCard(
                            title: reminder['title'],
                            description: reminder['description'],
                            time: formattedDateTime,
                            initialToggleValue: reminder['isActive'],
                            onToggle: (value) {},
                            onDelete: () {
                              _firestore
                                  .collection('Reminders').doc(reminder.id).delete();
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddReminderScreen(),
            ),
          );
        },
        backgroundColor: Colors.grey.shade800,
        elevation: 10,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
