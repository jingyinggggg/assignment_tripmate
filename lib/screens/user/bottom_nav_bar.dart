import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: Colors.white,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              fontFamily: "inika"
            );
          }
          return const TextStyle(color: Colors.white, fontFamily: "inika");
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFF749CB9));
          }
          return const IconThemeData(color: Colors.white);
        }),
      ),
      child: NavigationBar(
        onDestinationSelected: onTap,
        selectedIndex: currentIndex,
        backgroundColor: const Color(0xFF749CB9),
        destinations: const [
          NavigationDestination(
            icon: ImageIcon(AssetImage("images/home.png")),
            label: "Home",
          ),
          NavigationDestination(
            icon: ImageIcon(AssetImage("images/map.png")),
            label: 'Itinerary',
          ),
          NavigationDestination(
            icon: ImageIcon(AssetImage("images/chat.png")),
            label: 'Messages',
          ),
          NavigationDestination(
            icon: ImageIcon(AssetImage("images/booking.png")),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: ImageIcon(AssetImage("images/account.png")),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
