import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pastillero_inteligente/models/medication.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// A service that manages local notifications for the application.
///
/// This class follows the singleton pattern and provides methods to initialize,
/// request permissions, and schedule/cancel notifications.
class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  /// Returns the singleton instance of [NotificationService].
  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes the notification service and platform-specific settings.
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'app_icon'); // Reemplazar con el nombre del ícono

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  /// Requests notification permissions from the user (primarily for iOS).
  Future<void> requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Schedules a daily repeating notification for a given medication.
  Future<void> scheduleDailyNotification(Medication medication) async {
    final timeParts = medication.time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      medication.id.hashCode, // ID único para la notificación
      'Hora de tu medicamento',
      'No olvides tomar tu ${medication.name} (${medication.dosage})',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_medication_channel',
          'Recordatorios de Medicamentos',
          channelDescription:
              'Canal para recordatorios diarios de medicamentos.',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Calculates the next instance of a given time for scheduling.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  /// Cancels a scheduled notification by its medication ID.
  Future<void> cancelNotification(String medicationId) async {
    await flutterLocalNotificationsPlugin.cancel(medicationId.hashCode);
  }
}
