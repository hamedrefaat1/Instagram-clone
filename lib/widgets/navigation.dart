// ignore_for_file: unused_element

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagram_app/screens/add_post_or_reels_screen.dart';
import 'package:instagram_app/screens/exploerscreen.dart';
import 'package:instagram_app/screens/home.dart';
import 'package:instagram_app/screens/profilescreen.dart';
import 'package:instagram_app/screens/reelsscreen.dart';

class Navigation_screen extends StatefulWidget {
  const Navigation_screen({super.key});

  @override
  State<Navigation_screen> createState() => __Navigation_screenState();
}

int _currentIndex = 0;

class __Navigation_screenState extends State<Navigation_screen> {
  late PageController pageController;
  int _currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const Exploerscreen(),
    const AddPostOrReelsScreen(),
    const Reelsscreen(),
     Profilescreen(FirebaseAuth.instance.currentUser!.uid)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.grey,
              currentIndex: _currentIndex,
              onTap: navigationTapped,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.camera),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/image/instagram-reels-icon.png',
                    height: 20.h,
                    color: _currentIndex == 3 ? Colors.black : Colors.grey,
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '',
                ),
              ]),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const BouncingScrollPhysics(), // إضافة تأثير السحب الناعم
          children: _pages,
        ));
  }
}
