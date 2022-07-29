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
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).colorScheme.tertiary, width: 1.5))),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            label: 'Generate Images',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Previous Images',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int value) {
    _selectedIndex = value;
    widget.onNavItemTapped(AppPage.values[value]);
  }
}
