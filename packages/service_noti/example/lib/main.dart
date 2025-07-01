import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:service_noti/service_noti.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _message = 'No action taken yet';
  bool _backgroundRunning = false;
  bool _foregroundRunning = false;
  final _serviceNotiPlugin = ServiceNoti();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _updateServiceStatus();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _serviceNotiPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> _updateServiceStatus() async {
    try {
      final status = await _serviceNotiPlugin.getServiceStatus();
      if (status != null && mounted) {
        setState(() {
          _backgroundRunning = status['backgroundRunning'] ?? false;
          _foregroundRunning = status['foregroundRunning'] ?? false;
        });
      }
    } catch (e) {
      print('Error getting service status: $e');
    }
  }

  Future<void> _startBackgroundService() async {
    try {
      final result = await _serviceNotiPlugin.startBackgroundService();
      setState(() {
        _message = result ?? 'Background service started';
      });
      await _updateServiceStatus();
    } on PlatformException catch (e) {
      setState(() {
        _message = 'Failed to start background service: ${e.message}';
      });
    }
  }

  Future<void> _stopBackgroundService() async {
    try {
      final result = await _serviceNotiPlugin.stopBackgroundService();
      setState(() {
        _message = result ?? 'Background service stopped';
      });
      await _updateServiceStatus();
    } on PlatformException catch (e) {
      setState(() {
        _message = 'Failed to stop background service: ${e.message}';
      });
    }
  }

  Future<void> _startForegroundService() async {
    try {
      final result = await _serviceNotiPlugin.startForegroundService();
      setState(() {
        _message = result ?? 'Foreground service started';
      });
      await _updateServiceStatus();
    } on PlatformException catch (e) {
      setState(() {
        _message = 'Failed to start foreground service: ${e.message}';
      });
    }
  }

  Future<void> _stopForegroundService() async {
    try {
      final result = await _serviceNotiPlugin.stopForegroundService();
      setState(() {
        _message = result ?? 'Foreground service stopped';
      });
      await _updateServiceStatus();
    } on PlatformException catch (e) {
      setState(() {
        _message = 'Failed to stop foreground service: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Service Manager'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Platform Info',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('Running on: $_platformVersion'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Service Status',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Background Service:'),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _backgroundRunning
                                      ? Colors.green
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _backgroundRunning ? 'RUNNING' : 'STOPPED',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Foreground Service:'),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _foregroundRunning
                                      ? Colors.green
                                      : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _foregroundRunning ? 'RUNNING' : 'STOPPED',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Background Service Controls',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _backgroundRunning ? null : _startBackgroundService,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Background'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _backgroundRunning ? _stopBackgroundService : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop Background'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Foreground Service Controls',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _foregroundRunning ? null : _startForegroundService,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Start Foreground'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _foregroundRunning ? _stopForegroundService : null,
                      icon: const Icon(Icons.stop),
                      label: const Text('Stop Foreground'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _updateServiceStatus,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Status'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Last Action Result',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
