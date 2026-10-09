import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CountProvider()),
        FutureProvider<List<String>>(
          create: (_) async {
            await Future.delayed(const Duration(milliseconds: 500));
            return List.generate(10, (index) => "TEST");
          },
          initialData: const ["TEST", "TEST", "TEST", "TEST", "TEST"],
        ),
        StreamProvider<int>(
          create: (_) => Stream<int>.periodic(
            const Duration(seconds: 1),
            (count) => count,
          ),
          initialData: 0,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Provider Demo",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Provider Demo"),
              centerTitle: true,
              bottom: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(icon: Icon(Icons.add)),
                  Tab(icon: Icon(Icons.person)),
                  Tab(icon: Icon(Icons.message)),
                ],
              ),
            ),
            body: const TabBarView(
              children: [MyCountPage(), MyUserPage(), MyEventPage()],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== 1. TAB: ChangeNotifierProvider ====================
class CountProvider extends ChangeNotifier {
  int _count = 0;
  int get counterValue => _count;

  void incrementCount() {
    _count++;
    notifyListeners();
  }

  void decrementCount() {
    _count--;
    notifyListeners();
  }
}

class MyCountPage extends StatelessWidget {
  const MyCountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = Provider.of<CountProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ChangeNotifierProvider Example",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            Text(
              "${counter.counterValue}",
              style: const TextStyle(fontSize: 36, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: counter.decrementCount,
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                  iconSize: 32,
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: counter.incrementCount,
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                  iconSize: 32,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== 2. TAB: FutureProvider ====================
class MyUserPage extends StatelessWidget {
  const MyUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<String>>(context);

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Text(
              "FutureProvider Example, users loaded from a File",
              style: TextStyle(fontSize: 16, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      users[index],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 3. TAB: StreamProvider ====================
class MyEventPage extends StatelessWidget {
  const MyEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    final streamValue = Provider.of<int>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "StreamProvider Example",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 40),
            Text(
              "$streamValue",
              style: const TextStyle(fontSize: 36, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
