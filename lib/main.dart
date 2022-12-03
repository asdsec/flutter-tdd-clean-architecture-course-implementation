import 'package:flutter/material.dart';
import 'package:flutter_with_clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter_with_clean_architecture/injection_container.dart' as di;

Future<void> main() async {
  await di.setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const NumberTriviaPage(),
    );
  }
}
