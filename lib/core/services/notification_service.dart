import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static const _channelId = 'slam_daily';
  static const _notifId = 1;

  static const _messages = [
    ('Zeit zum Lernen! 🧠', 'Dein tägliches Mathe-Training wartet.'),
    ('Streak bewahren 🔥', 'Beantworte eine Frage — es dauert nur 2 Minuten.'),
    ('Heute schon geübt? 📐', 'Dein Lernplan braucht dich!'),
    ('Mathe wartet auf dich ✨', 'Bleib dran — kleine Schritte zählen.'),
    ('Lernzeit! 🎯', 'Öffne SLAM und mach weiter, wo du aufgehört hast.'),
  ];

  /// Initialize the plugin and request permissions.
  static Future<void> initialize() async {
    tz_data.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    if (!kIsWeb && Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  /// Schedule (or reschedule) the daily reminder at 18:00 local time.
  static Future<void> scheduleDailyReminder() async {
    if (kIsWeb) return;
    try {
      await _plugin.cancel(_notifId);
      final (title, body) = _messages[
          DateTime.now().millisecondsSinceEpoch % _messages.length];

      await _plugin.zonedSchedule(
        _notifId,
        title,
        body,
        _nextInstanceOf(18, 0),
        NotificationDetails(
          android: const AndroidNotificationDetails(
            _channelId,
            'Tägliche Lern-Erinnerung',
            channelDescription:
                'Erinnert dich täglich daran, Mathe zu üben.',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('NotificationService: schedule failed — $e');
    }
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> cancelAll() => _plugin.cancelAll();
}
