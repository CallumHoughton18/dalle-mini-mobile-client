import 'package:dalle_mobile_client/shared/app_constants.dart';
import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  final void Function(AppPage page) onNavItemTapped;
  const AppBottomNavigationBar({Key? key, required this.onNavItemTapped})
      : super(key: key);

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.blue,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.image),
          label: 'Images',
          backgroundColor: Colors.blue,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue[800],
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int value) {
    _selectedIndex = value;
    widget.onNavItemTapped(AppPage.values[value]);
  }
}
