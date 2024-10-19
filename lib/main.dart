import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_pop_up/overlay_pop_up.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Widget Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overlay Widget Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _showOverlay(context);
          },
          child: Text('Show Overlay'),
        ),
      ),
    );
  }

  Future<void> _showOverlay(BuildContext context) async {
    bool permissionGranted = await OverlayPopUp.checkPermission();
    if (!permissionGranted) {
      await OverlayPopUp.requestPermission();
    }
    await OverlayPopUp.showOverlay(
      closeWhenTapBackButton: false, // Do not close on back button
      isDraggable: false, // Make it non-draggable
    );

    // Listen for data from the overlay
    OverlayPopUp.dataListener?.listen((data) {
      print("Data from overlay: $data");
    });
    await OverlayPopUp.sendToOverlay({'message': 'Hello from main app!'});
  }
}

/// Entry point for the overlay popup
@pragma("vm:entry-point")
void overlayPopUp() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OverlayScreen(),
  ));
}

/// The overlay widget screen
class OverlayScreen extends StatelessWidget {
  const OverlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close the overlay
        OverlayPopUp.closeOverlay();
        
        // Open the main app when overlay is clicked
        _openMainApp();
      },
      child: Container(
        color: Colors.red,
        width: 300,
        height: 200,
        alignment: Alignment.center,
        child: const Text(
          'Overlay Click Me!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Future<void> _openMainApp() async {
    const platform = MethodChannel('com.example.sampoverlay/openApp');
    try {
      await platform.invokeMethod('openApp');
    } on PlatformException catch (e) {
      print("Failed to open main app: '${e.message}'.");
    }
  }
}
