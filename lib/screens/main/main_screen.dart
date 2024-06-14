import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shotgun_v2/providers/auth_provider.dart';
import 'package:shotgun_v2/providers/nav_provider.dart';
import 'package:shotgun_v2/screens/friends/friends_screen.dart';
import 'package:shotgun_v2/screens/home/home_screen.dart';
import 'package:shotgun_v2/screens/music/music_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final tabItemTitles = const [
    "My Rides",
    "Friends",
    "Music",
  ];

  void _navToProfile(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavProvider>(context);
    final auth = Provider.of<Auth>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                _navToProfile(context);
              },
              child: auth.user?.photoURL != null
                  ? Hero(
                      tag: 'profileImage',
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(auth.user!.photoURL!),
                      ),
                    )
                  : const Icon(Icons.account_circle, size: 35),
            ),
          ),
        ],
        title: Text(
          tabItemTitles[navProvider.currentIndex],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: false,
      ),
      body: IndexedStack(
        index: navProvider.currentIndex,
        children: const [
          HomeScreen(),
          FriendsScreen(),
          MusicScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        currentIndex: navProvider.currentIndex,
        onTap: (index) {
          navProvider.setIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Music',
          ),
        ],
      ),
    );
  }
}
