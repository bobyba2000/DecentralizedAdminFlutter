import 'package:admin/page/location/location_list_page.dart';
import 'package:admin/page/servers/servers_page.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController page = PageController();

  bool isExpanded = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 249, 249, 1),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            onDisplayModeChanged: (mode) {},
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.open,
              hoverColor: const Color.fromARGB(255, 63, 63, 63),
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              unselectedIconColor: Colors.white,
              unselectedTitleTextStyle: const TextStyle(color: Colors.white),
              backgroundColor: const Color.fromARGB(255, 41, 41, 41),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Dashboard',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.home),
                badgeContent: const Text(
                  '3',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SideMenuItem(
                priority: 1,
                title: 'Location',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Servers',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.file_copy_rounded),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Settings',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: const Icon(Icons.settings),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Exit',
                onTap: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  child: const Center(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: LocationListPage(),
                ),
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: ServersPage(),
                ),
                Container(
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
