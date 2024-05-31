import 'package:dailydays/consts/firebase_consts.dart';
import 'package:dailydays/inner_screens/bookmarks_screen.dart';
import 'package:dailydays/screens/auth/login_screen.dart';
import 'package:dailydays/screens/home_screen.dart';
import 'package:dailydays/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import 'vertical_spacing.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final User? user = authInstance.currentUser;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/images/newspaper.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  const VerticalSpacing(20),
                  Flexible(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "DailyDays",
                            style: GoogleFonts.lobster(
                                textStyle: const TextStyle(
                                    fontSize: 20, letterSpacing: 0.6)),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            const VerticalSpacing(20),
            ListTilesWidget(
              label: "Home",
              icon: IconlyBold.home,
              fct: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const HomeScreen(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
            ),
            ListTilesWidget(
              label: "Bookmarks",
              icon: IconlyBold.bookmark,
              fct: () {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const BookmarkScreen(),
                      inheritTheme: true,
                      ctx: context),
                );
              },
            ),
            const Divider(
              thickness: 5,
            ),
            SwitchListTile(
                title: Text(
                  themeProvider.getDarkTheme ? 'Dark' : 'Light',
                  style: const TextStyle(fontSize: 20),
                ),
                secondary: Icon(
                  themeProvider.getDarkTheme
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                value: themeProvider.getDarkTheme,
                onChanged: (bool value) {
                  setState(() {
                    themeProvider.setDarkTheme = value;
                  });
                }),
            ListTilesWidget(
              label: user == null ? 'Login' : 'Logout',
              icon: user == null ? IconlyBold.login : IconlyBold.logout,
              fct: () {
                if (user == null) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  return;
                }
                GlobalMethods.warningDialog(
                    title: 'Sign out',
                    subtitle: 'Do you really want to sign out?',
                    fct: () async {
                      await authInstance.signOut();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListTilesWidget extends StatelessWidget {
  const ListTilesWidget({
    Key? key,
    required this.label,
    required this.fct,
    required this.icon,
  }) : super(key: key);
  final String label;
  final Function fct;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () {
        fct();
      },
    );
  }
}
