import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(ReceivedNotification receivedNotification) async {
    print('Notification created: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(ReceivedNotification receivedNotification) async {
    print('Notification displayed: ${receivedNotification.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(ReceivedAction receivedAction) async {
    print('Notification dismissed: ${receivedAction.id}');
  }

  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    print('Action received: ${receivedAction.id}, payload: ${receivedAction.payload}');
  }


  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch,
        channelKey: 'basic_channel',
        title: title,
        body: body,
        payload: {'key': payload},
      ),
    );
  }
}