import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qrowd2/view/profile.dart';
import 'package:qrowd2/view/community.dart';
import 'package:qrowd2/view/map.dart';

// Provider to manage the selected index
final selectedIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavBarScreen extends ConsumerWidget {
  const BottomNavBarScreen({super.key});

  static final List<Widget> _pages = <Widget>[
    CustomMapPage(),
    CommunityPage(),
    ProfilePage(), // Add Profile Page
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Display the selected page
          _pages.elementAt(selectedIndex),

          // Floating Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff007BFF),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: BottomNavigationBar(
                  backgroundColor: const Color.fromARGB(255, 68, 152, 242),
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.ticket, color: Colors.white),
                      label: 'Events',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.person_2, color: Colors.white),
                      label: 'Community',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.person, color: Colors.white),
                      label: 'Profile', // Profile Icon
                    ),
                  ],
                  currentIndex: selectedIndex,
                  unselectedItemColor:
                      Colors.white.withOpacity(0.7), // Unselected icon and label color
                  selectedItemColor: Colors.white, // Selected icon and label color
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  onTap: (index) =>
                      ref.read(selectedIndexProvider.notifier).state = index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
