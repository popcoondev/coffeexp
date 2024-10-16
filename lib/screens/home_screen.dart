import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/strings.dart';
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
      key: Key('home_screen'),
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.homeScreenAppBarTitle),
          actions: [
            //user icon
            TextButton(
              key: Key('user_icon'),
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
                      key: Key('alert_dialog'),
                      title: Text(Strings.homeScreenAlertDialogTitle),
                      content: Text('${Strings.homeScreenAlertDialogContent} ${FirebaseAuth.instance.currentUser!.email}'),
                      actions: [
                        TextButton(
                          key: Key('alert_dialog_cancel'),
                          child: Text(Strings.homeScreenAlertDialogCancel),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          key: Key('alert_dialog_sign_out'),
                          child: Text(Strings.homeScreenAlertDialogSignOut),
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
              key: Key('change_view_button'),
              icon: Icon(isListView ? Icons.grid_view : Icons.list),
              onPressed: () {
                setState(() {
                  isListView = !isListView;
                });
              },
            ),
            IconButton(
              key: Key('menu_button'),
              icon: Icon(Icons.menu),
              onPressed: () {
                // メニューの操作を実装予定
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: Strings.homeScreenTabBarMyCoffees, key: Key('my_coffees_tab')),
              Tab(text: Strings.homeScreenTabBarFavorites, key: Key('favorites_tab')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            isListView ? CoffeeListView() : CoffeeGridView(),
            Center(child: Text('Favorites will be implemented here'), key: Key('favorites_tab_view')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          key: Key('add_coffee_button'),
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
      return Center(child: Text(Strings.homeScreenUserAuthError));
    }
    else {
      return StreamBuilder<QuerySnapshot>(
        key: Key('coffee_list_view'),
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
            return Center(child: Text(Strings.homeScreenUserCoffeeDataNone));
          }

          var coffeeList = snapshot.data!.docs;
          // データの確認
          print('coffeeList length: ${coffeeList.length}');
          for (var coffee in coffeeList) {
            print('coffee data: ${coffee.data()}');
          }

          // ListView.builder でデータを表示
          return ListView.builder(
            key: Key('coffee_list'),
            itemCount: coffeeList.length,
            itemBuilder: (context, index) {
              var coffeeData = coffeeList[index].data() as Map<String, dynamic>;  // ここでMap<String, dynamic>にキャスト

              // デバッグ: どのデータが取得できているか確認
              print('Displaying coffee: ${coffeeData['coffeeName']}');

              return ListTile(
                key: Key('coffee_list_tile_$index'),
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
      key: Key('coffee_grid_view'),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 10, // 仮のデータ数
      itemBuilder: (context, index) {
        return Card(
          key: Key('coffee_card_$index'),
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
