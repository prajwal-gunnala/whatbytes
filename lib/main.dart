import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
const String conversationShortcutId = 'burnmate_notifications';
const MethodChannel shortcutsChannel = MethodChannel('burnmate/shortcuts');

Future<void> _configureConversationShortcut() async {
  if (!Platform.isAndroid) {
    return;
  }

  try {
    await shortcutsChannel.invokeMethod<void>('configureConversationShortcut');
    debugPrint('Conversation shortcut configured');
  } catch (e) {
    debugPrint('Error configuring conversation shortcut: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  debugPrint('Initializing notifications with icon: notification');
  const androidSettings = AndroidInitializationSettings('notification');
  const iosSettings = DarwinInitializationSettings();
  const initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (details) {
      debugPrint('Notification clicked: ${details.payload}');
    },
  );
  debugPrint('Notification plugin initialized');
  await _configureConversationShortcut();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BurnMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _status = 'Ready';
  int _notificationId = 0;
  final TextEditingController _titleController = TextEditingController(
    text: 'Reminder',
  );
  final TextEditingController _bodyController = TextEditingController(
    text: 'This is your scheduled notification!',
  );

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  NotificationDetails _notificationDetails(String title, String body) {
    final sender = Person(
      name: title,
      key: conversationShortcutId,
      important: true,
      icon: const FlutterBitmapAssetAndroidIcon(
        'assets/burnmate_notification_large.png',
      ),
    );
    final messageStyle = MessagingStyleInformation(
      const Person(
        name: 'You',
        key: 'burnmate_user',
      ),
      conversationTitle: title,
      groupConversation: false,
      messages: [
        Message(body, DateTime.now(), sender),
      ],
    );

    final androidDetails = AndroidNotificationDetails(
      'burnmate_channel',
      'BurnMate Notifications',
      channelDescription: 'BurnMate local notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'notification',
      category: AndroidNotificationCategory.message,
      color: Color(0xFF84CC16),
      shortcutId: conversationShortcutId,
      styleInformation: messageStyle,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
  }

  Future<void> _scheduleNotification() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      setState(() => _status = 'Title and Body cannot be empty');
      return;
    }

    setState(() => _status = 'Scheduling...');

    final androidPlugin = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }

    final scheduledTime = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 10));

    final notificationDetails = _notificationDetails(title, body);

    debugPrint('Scheduling notification with icon: notification');

    try {
      await notificationsPlugin.zonedSchedule(
        _notificationId++,
        title,
        body,
        scheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );

      debugPrint('Notification scheduled successfully');

      setState(
        () => _status =
            'Scheduled!\nWill arrive in 10 seconds.\nYou can close the app now.',
      );
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
      setState(() => _status = 'Error: $e');
    }
  }

  Future<void> _sendNow() async {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      setState(() => _status = 'Title and Body cannot be empty');
      return;
    }

    final notificationDetails = _notificationDetails(title, body);

    try {
      debugPrint('Showing instant notification with icon: notification');
      await notificationsPlugin.show(
        _notificationId++,
        title,
        body,
        notificationDetails,
      );
      debugPrint('Instant notification shown successfully');
      setState(() => _status = 'Notification sent!');
    } catch (e) {
      debugPrint('Error showing notification: $e');
      setState(() => _status = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BurnMate'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    'assets/burnamte_notification.png',
                    width: 112,
                    height: 112,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'BurnMate Notifications',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Test instant and scheduled local notifications with a messaging-style Android layout.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Notification Title',
                    border: OutlineInputBorder(),
                    hintText: 'Enter title here',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bodyController,
                  decoration: const InputDecoration(
                    labelText: 'Notification Body',
                    border: OutlineInputBorder(),
                    hintText: 'Enter body here',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _scheduleNotification,
                    icon: const Icon(Icons.schedule),
                    label: const Text(
                      'Notify in 10 seconds',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _sendNow,
                    icon: const Icon(Icons.send),
                    label: const Text(
                      'Send Now (Test)',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _status,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
