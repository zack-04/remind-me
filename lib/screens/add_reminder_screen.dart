import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:reminder_app/provider/email_provider.dart';
import 'package:reminder_app/provider/loader_provider.dart';
import 'package:reminder_app/screens/home_screen.dart';
import 'package:reminder_app/utils/firebase_service.dart';
import 'package:reminder_app/widgets/custom_button.dart';

class AddReminderScreen extends ConsumerStatefulWidget {
  const AddReminderScreen({super.key});

  @override
  ConsumerState<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends ConsumerState<AddReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  DateTime? _selectedTime;

  void _selectTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100), // Adjust this as needed
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _timeController.text =
              DateFormat('d MMM, hh:mm a').format(_selectedTime!);
        });
      }
    }
  }

  void _saveReminder(WidgetRef ref) async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final time = _selectedTime;

    if (title.isEmpty || description.isEmpty || time == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      final formattedTime = DateFormat.jm().format(time);
      final email = ref.watch(emailProvider);
      final loaderNotifier = ref.read(loaderProvider.notifier);
      loaderNotifier.setLoading(true);
      await FirebaseService().saveReminders(
        {'title': title, 'description': description, 'time': time},
        email,
      );
      loaderNotifier.setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reminder saved: $title at $formattedTime'),
          backgroundColor: Colors.green,
        ),
      );

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: createUniqueId(),
          channelKey: 'basic_channel',
          title: title,
          body: description,
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(date: time),
      );

      if (mounted) {
        Navigator.pop(context);
        
      }
    }

    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedTime = null;
    });
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loaderProvider);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: ListView(
                      children: [
                        TextField(
                          controller: _titleController,
                          style:
                              TextStyle(color: Colors.white70, fontSize: 30.sp),
                          cursorColor: Colors.white70,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Title',
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 30.sp,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _descriptionController,
                          style:
                              TextStyle(color: Colors.white70, fontSize: 20.sp),
                          maxLines: 4,
                          maxLength: 80,
                          cursorColor: Colors.white70,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type something here...',
                            helperStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _selectTime(context);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: _timeController,
                              readOnly: true,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20.sp,
                              ),
                              cursorColor: Colors.white70,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Pick time',
                                hintStyle: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18.sp,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                  vertical: 4,
                                ),
                                prefixIcon: Icon(
                                  FontAwesomeIcons.clock,
                                  color: Colors.white,
                                  size: 17.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.sp),
                  child: CustomButton(
                    text: 'Save Reminder',
                    onPressed: () => _saveReminder(ref),
                    color: Colors.yellow[800],
                    textColor: Colors.black,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                width: ScreenUtil().screenWidth,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
