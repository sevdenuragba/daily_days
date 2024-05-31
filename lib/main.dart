import 'package:dailydays/inner_screens/blog_details.dart';
import 'package:dailydays/providers/bookmarks_provider.dart';
import 'package:dailydays/providers/news_provider.dart';
import 'package:dailydays/screens/auth/forget_password.dart';
import 'package:dailydays/screens/auth/login_screen.dart';
import 'package:dailydays/screens/auth/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'consts/theme_data.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Need it to access the theme Provider
  ThemeProvider themeChangeProvider = ThemeProvider();

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  //Fetch the current theme
  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          //Notify about theme changes
          return themeChangeProvider;
        }),
        ChangeNotifierProvider(
          create: (_) => NewsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarksProvider(),
        ),
      ],
      child:
          //Notify about theme changes
          Consumer<ThemeProvider>(builder: (context, themeChangeProvider, ch) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Daily Days - Daily news for a new day.',
          theme: Styles.themeData(themeChangeProvider.getDarkTheme, context),
          home: const LoginScreen(),
          routes: {
            ForgetPasswordScreen.routeName: (ctx) =>
                const ForgetPasswordScreen(),
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            RegisterScreen.routeName: (ctx) => const RegisterScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            NewsDetailsScreen.routeName: (ctx) => const NewsDetailsScreen(),
          },
        );
      }),
    );
  }
}
