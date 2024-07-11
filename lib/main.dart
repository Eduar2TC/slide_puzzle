import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_puzzle/pages/eight_page/provider/game_state.dart';
import 'package:slide_puzzle/pages/eight_page/eight_page.dart';
import 'package:slide_puzzle/pages/eight_page/provider/game_state_animations.dart';
import 'package:slide_puzzle/pages/eight_page/utils/handle_timer.dart';
import 'package:slide_puzzle/pages/home_page/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HandleTimer()),
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(create: (_) => GameStateGridAnimation()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //create custom scheme colors
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.orange,
          cardColor: Colors.green,
          backgroundColor: Colors.white,
          errorColor: Colors.purple,
          brightness: Brightness.dark,
        ).copyWith(secondary: Colors.red),
        useMaterial3: true,
      ),
      home: const Home(),
      routes: {
        '/game': (context) => const EightPage(),
      },
    );
  }
}
