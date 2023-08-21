import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/features/medical-record/screens/medical_record_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/notification/screens/notification_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/psychologist_search/screens/psychologist_search_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const PsychologistSearchScreen(),
    const MedicalRecordScreen(),
    const NotificationScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: updatePage,
        selectedIndex: _page,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Buscar',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Prontuários',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Notificações',
          )
        ],
      ),
    );
  }
}
