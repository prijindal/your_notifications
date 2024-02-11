import 'package:flutter/material.dart';
import 'package:flutter_notification_listener/flutter_notification_listener.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool started = false;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _startListening();
  }

  void _startListening() async {
    print("start listening");
    var hasPermission = await NotificationsListener.hasPermission;
    if (hasPermission == null || !hasPermission) {
      print("no permission, so open settings");
      NotificationsListener.openPermissionSettings();
      return;
    }

    var isR = await NotificationsListener.isRunning;

    if (isR == null || !isR) {
      await NotificationsListener.startService();
    }

    setState(() => started = true);
  }

// define the handler for ui
  @pragma('vm:entry-point')
  static void _onData(NotificationEvent event) {
    print(event.toString());
  }

  Future<void> _initPlatformState() async {
    NotificationsListener.initialize(callbackHandle: _onData);
    // register you event handler in the ui logic.
    NotificationsListener.receivePort?.listen((evt) => _onData(evt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Started: $started"),
      ),
    );
  }
}
