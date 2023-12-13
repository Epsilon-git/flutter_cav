import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cav/camera_page.dart';
import 'package:flutter_cav/voice_page.dart';
import 'package:wakelock/wakelock.dart';

late final List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Wakelock.enable();

  cameras = await availableCameras();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter CaV',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade800),
        useMaterial3: true,
      ),
      home: const BottomNavigationPage(),
    );
  }
}

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///
      body: IndexedStack(
        index: currentPageIndex,
        children: const [
          CameraPage(),
          VoicePage(),
        ],
      ),

      ///
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() => currentPageIndex = index);
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.camera_rounded),
            label: 'Камера',
          ),
          NavigationDestination(
            icon: Icon(Icons.voice_chat),
            label: 'Голос',
          ),
        ],
      ),
    );
  }
}
