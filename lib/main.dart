import 'package:flutter/material.dart';
import 'package:flutter_avanzado1/pages/home.dart';
import 'package:flutter_avanzado1/pages/status.dart';
import 'package:flutter_avanzado1/services/socket_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        initialRoute: 'status',
        routes: {
          'home': (_) => const HomePage(),
          'status': (_) => const StatusPage()
        },
      ),
    );
  }
}
