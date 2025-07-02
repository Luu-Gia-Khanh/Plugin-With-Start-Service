import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   if (message.notification != null) {
//     print(
//       'Background message notification: ${message.notification!.title} - ${message.notification!.body}',
//     );
//   }
// }

@pragma('vm:entry-point')
Future<void> backgroundFirebaseMessagingHandle(RemoteMessage message) async {
  debugPrint('backgroundFirebaseMessagingHandle: ${message}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FCMHomePage(),
    );
  }
}

class FCMHomePage extends StatefulWidget {
  const FCMHomePage({super.key});

  @override
  State<FCMHomePage> createState() => _FCMHomePageState();
}

class _FCMHomePageState extends State<FCMHomePage> {
  static const platform = MethodChannel(
    'com.example.start_service_flutter/fcm',
  );

  String _fcmToken = 'Token not received';
  String _lastMessage = 'No message received';
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    await _requestPermission();
    await _getFCMToken();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String messageText = 'Data: ${message.data}';
      if (message.notification != null) {
        messageText =
            '${message.notification!.title}: ${message.notification!.body}';
      }

      setState(() {
        _lastMessage = messageText;
        _messages.insert(
          0,
          '${DateTime.now().toString().substring(0, 19)}: $messageText',
        );
      });
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      String messageText = 'Opened from notification: ${message.data}';
      if (message.notification != null) {
        messageText =
            'Opened: ${message.notification!.title}: ${message.notification!.body}';
      }

      setState(() {
        _lastMessage = messageText;
        _messages.insert(
          0,
          '${DateTime.now().toString().substring(0, 19)}: $messageText',
        );
      });
    });

    // Subscribe to a topic
    await FirebaseMessaging.instance.subscribeToTopic('general');
  }

  Future<void> _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _getFCMToken() async {
    try {
      String? flutterToken = await FirebaseMessaging.instance.getToken();

      if (flutterToken != null && flutterToken.isNotEmpty) {
        setState(() {
          _fcmToken = flutterToken;
        });

        return; // Success, exit early
      }
    } catch (e) {
      print('✗ Flutter FCM token failed: $e');
    }

    try {
      final String result = await platform.invokeMethod('getFCMToken');
      setState(() {
        _fcmToken = result;
      });

      return; // Success, exit early
    } on PlatformException catch (e) {
      print('✗ Native FCM token failed: ${e.message}');
    } catch (e) {
      print('✗ Native FCM token error: $e');
    }

    // Both methods failed
    setState(() {
      _fcmToken =
          'Both Flutter and native methods failed due to AUTHENTICATION_FAILED. Please check Firebase setup.';
    });

    FirebaseMessaging.instance.onTokenRefresh
        .listen((String token) {
          print('FCM Token refreshed: $token');
          setState(() {
            _fcmToken = token;
          });
        })
        .onError((error) {
          print('Token refresh error: $error');
        });
  }

  void _copyTokenToClipboard() {
    Clipboard.setData(ClipboardData(text: _fcmToken));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Token copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'FCM Token:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: _copyTokenToClipboard,
                          tooltip: 'Copy token',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _fcmToken,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Message:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_lastMessage),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Message History:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(
              child:
                  _messages.isEmpty
                      ? const Center(child: Text('No messages received yet'))
                      : ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              title: Text(
                                _messages[index],
                                style: const TextStyle(fontSize: 14),
                              ),
                              leading: const Icon(Icons.message),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getFCMToken,
        tooltip: 'Refresh Token',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
