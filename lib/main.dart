import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('coffeExp'),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // メニューの操作を実装
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Coffees'),
              Tab(text: 'Add Coffee'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // コーヒー一覧
            CoffeeListView(),
            // 新規コーヒー追加
            AddCoffeeView(),
          ],
        ),
      ),
    );
  }
}

class CoffeeListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // 仮のデータ数
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(Icons.local_cafe),
            title: Text('Coffee $index'),
            subtitle: Text('Description for Coffee $index'),
            onTap: () {
              // コーヒー詳細画面への遷移を実装
            },
          ),
        );
      },
    );
  }
}

class AddCoffeeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // 新規コーヒーの追加操作を実装
        },
        child: Text('Add a New Coffee'),
      ),
    );
  }
}