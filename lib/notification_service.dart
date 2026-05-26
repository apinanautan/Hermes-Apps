import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _ntfyUrl = 'https://ntfy.sh';
  static const String _topic = 'AiMeet';
  Timer? _pollTimer;
  DateTime? _lastSeen;

  Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOSInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      InitializationSettings(
        android: androidInit,
        iOS: iOSInit,
      ),
    );
  }

  Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> show(String title, String body) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'hermes',
          'Hermes',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  void startPolling() {
    _lastSeen = DateTime.now();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) => _check());
  }

  Future<void> _check() async {
    try {
      final res = await http
          .get(Uri.parse('$_ntfyUrl/$_topic/json?poll=1&since=${_lastSeen!.millisecondsSinceEpoch ~/ 1000}'))
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return;

      final messages = jsonDecode(res.body) as List;
      for (final msg in messages) {
        final m = msg as Map<String, dynamic>;
        if (m['message'] != null) {
          final title = m['title'] ?? 'Hermes';
          final body = m['message'] as String;
          await show(title, body);
        }
      }
      if (messages.isNotEmpty) {
        _lastSeen = DateTime.now();
      }
    } catch (_) {}
  }

  void stop() {
    _pollTimer?.cancel();
  }
}
