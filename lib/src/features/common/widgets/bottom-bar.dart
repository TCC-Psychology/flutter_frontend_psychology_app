import 'package:flutter/material.dart';
import 'package:flutter_frontend_psychology_app/src/features/medical-record/screens/medical_record_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/menu/screens/menu-screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/notification/screens/notification_screen.dart';
import 'package:flutter_frontend_psychology_app/src/features/psychologist_search/screens/psychologist_search_screen.dart';
import 'package:flutter_frontend_psychology_app/src/shared/services/auth/secure_storage_service.dart';
import 'package:flutter_frontend_psychology_app/src/shared/utils/user_type.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;
  UserType? _userType;

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  void _fetchUserType() async {
    SecureStorageService secureStorageService = SecureStorageService();
    final currentUser = await secureStorageService.getCurrentUser();

    setState(() {
      _userType = currentUser?.userType;
    });
    print(currentUser);
  }

  @override
  void initState() {
    super.initState();
    _fetchUserType();
  }

  @override
  Widget build(BuildContext context) {
    List<NavigationDestination> userSpecificDestinations;
    List<Widget> userSpecificPages;

    if (_userType == UserType.PSYCHOLOGIST) {
      userSpecificDestinations = const [
        NavigationDestination(
          icon: Icon(Icons.assignment_outlined),
          selectedIcon: Icon(Icons.assignment),
          label: 'Prontuários',
        ),
      ];
      userSpecificPages = [
        const MedicalRecordScreen(),
      ];
    } else if (_userType == UserType.CLIENT) {
      userSpecificDestinations = const [
        NavigationDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: 'Buscar',
        ),
      ];
      userSpecificPages = [
        PsychologistSearchScreen(),
      ];
    } else {
      userSpecificDestinations = [];
      userSpecificPages = [];
    }

    List<NavigationDestination> commonDestinations = const [
      NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications),
        label: 'Notificações',
      ),
      NavigationDestination(
        icon: Icon(Icons.more_vert), // Three dots icon
        label: 'Mais', // or another suitable label
      ),
      // ... add more common destinations as needed.
    ];

    List<Widget> commonPages = [
      const NotificationScreen(),
      MenuScreen(),
    ];

    List<NavigationDestination> destinations = [
      ...userSpecificDestinations,
      ...commonDestinations,
    ];

    List<Widget> pages = [
      ...userSpecificPages,
      ...commonPages,
    ];

    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: updatePage,
        selectedIndex: _page,
        destinations: destinations,
      ),
    );
  }
}
