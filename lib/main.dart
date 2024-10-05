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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isListView = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('coffeExp'),
          actions: [
            IconButton(
              icon: Icon(isListView ? Icons.grid_view : Icons.list),
              onPressed: () {
                setState(() {
                  isListView = !isListView;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                // メニューの操作を実装予定
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: 'My Coffees'),
              Tab(text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // コーヒー一覧ビュー
            isListView ? CoffeeListView() : CoffeeGridView(),
            // お気に入り（仮実装）
            Center(child: Text('Favorites will be implemented here')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // 新規コーヒー記録画面への遷移を実装予定
          },
          child: Icon(Icons.add),
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
              // コーヒー詳細画面への遷移を実装予定
            },
          ),
        );
      },
    );
  }
}

class CoffeeGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 10, // 仮のデータ数
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_cafe, size: 50),
              SizedBox(height: 8.0),
              Text('Coffee $index'),
              Text('Description for Coffee $index'),
            ],
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
          // 新規コーヒーの追加操作を実装予定
        },
        child: Text('Add a New Coffee'),
      ),
    );
  }
}