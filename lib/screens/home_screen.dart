import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_coffee_screen.dart';
import 'coffee_card_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isListView = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      // ユーザーがログインしていない場合はログイン画面に遷移
      if (FirebaseAuth.instance.currentUser == null) {
        print('User is not signed in');
        Navigator.pushNamed(context, '/login_signup');
      }
      else {
        print('User is signed in as ${FirebaseAuth.instance.currentUser!.email}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('coffeExp'),
          actions: [
            //user icon
            TextButton(
              child: 
                Row(children: [
                  Icon(Icons.account_circle),
                  //メールアドレスを表示
                  Text(FirebaseAuth.instance.currentUser!.email!)
                ]),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Account'),
                      content: Text('Email: ${FirebaseAuth.instance.currentUser!.email}'),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('Sign out'),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/login_signup');
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),           
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
            isListView ? CoffeeListView() : CoffeeGridView(),
            Center(child: Text('Favorites will be implemented here')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCoffeeScreen()),
            );
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
    // ユーザーのコーヒーデータをFirestoreから取得して表示する
    if (FirebaseAuth.instance.currentUser == null) {
      return Center(child: Text('User is not signed in'));
    }
    else {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('coffees')
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No coffee data available.'));
          }

          var coffeeList = snapshot.data!.docs;
          // データの確認
          print('coffeeList length: ${coffeeList.length}');
          for (var coffee in coffeeList) {
            print('coffee data: ${coffee.data()}');
          }

          // ListView.builder でデータを表示
          return ListView.builder(
            itemCount: coffeeList.length,
            itemBuilder: (context, index) {
              var coffeeData = coffeeList[index].data() as Map<String, dynamic>;  // ここでMap<String, dynamic>にキャスト

              // デバッグ: どのデータが取得できているか確認
              print('Displaying coffee: ${coffeeData['coffeeName']}');

              return ListTile(
                title: Text(coffeeData['coffeeName'] ?? 'No name'),  // データがnullでないことを確認
                subtitle: Text('Roast level: ${coffeeData['roastLevel'] ?? 'No level'}'),
                onTap: () {
                  // タップしたら詳細画面に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoffeeCardScreen(coffeeData: coffeeData),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }

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
