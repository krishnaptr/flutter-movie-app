import 'package:flutter/material.dart';
import 'package:movie_provider/providers/bottom_navigatior/bottom_navigation.dart';
import 'package:movie_provider/screens/bookmarks/bookmarks_screen.dart';
import 'package:movie_provider/screens/home/home_screen.dart';
import 'package:movie_provider/screens/movies/movies_screen.dart';
import 'package:movie_provider/styles/constants.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List screens = [
    const HomeScreen(),
    const MoviesScreen(selectedGenre: 28),
    const BookMarksScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final _bottomNavIndex = Provider.of<BottomNavigation>(context).currentIndex;
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorStyle.customBlue),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Image.asset(
              'assets/icons/fi_bell.png',
              width: 24,
              height: 24,
            ),
            tooltip: 'Notifications',
            onPressed: () {},
          ),
        ],
        title: const Text(
          'FilmKu',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.32,
              color: ColorStyle.customBlue),
        ),
      ),
      body: screens[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(fontSize: 0),
        unselectedLabelStyle: const TextStyle(fontSize: 0),
        backgroundColor: Colors.white,
        currentIndex: _bottomNavIndex,
        onTap: Provider.of<BottomNavigation>(context, listen: false).onTap,
        items: [
          BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                'assets/icons/fi_home.png',
                color:
                    _bottomNavIndex == 0 ? ColorStyle.customBlue : Colors.grey,
                width: 24,
                height: 24,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                'assets/icons/fi_tv.png',
                color:
                    _bottomNavIndex == 1 ? ColorStyle.customBlue : Colors.grey,
                width: 24,
                height: 24,
              )),
          BottomNavigationBarItem(
              label: '',
              icon: Image.asset(
                'assets/icons/fi_bookmark.png',
                color:
                    _bottomNavIndex == 2 ? ColorStyle.customBlue : Colors.grey,
                width: 24,
                height: 24,
              )),
        ],
      ),
    );
  }
}
