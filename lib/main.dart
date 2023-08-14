import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_frontend_psychology_app/src/features/autentication/login.dart';
import 'package:flutter_frontend_psychology_app/src/features/medical-record/screens/medical_record_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/psychologist_search/screens/psychologist_search_screen.dart';

void main() {
  runApp(const MyApp());
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 10.0
    ..progressColor = Colors.black
    ..backgroundColor = Colors.cyan.shade100
    ..indicatorColor = Colors.black
    ..textColor = Colors.black
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      home: const MedicalRecordScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}

class HorizontalMenu extends StatelessWidget {
  const HorizontalMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (const PsychologistSearchScreen())),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.assignment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MedicalRecordScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notification_important),
            onPressed: () {
              // Handle icon button press
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Handle icon button press
            },
          ),
        ],
      ),
    );
  }
}
