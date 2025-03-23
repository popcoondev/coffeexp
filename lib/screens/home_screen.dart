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
        Navigator.pushReplacementNamed(context, '/login_signup');
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
                            Navigator.pushNamedAndRemoveUntil(context, '/login_signup', (route) => false);
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
            FavoritesView(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          key: Key('add_coffee_button'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddCoffeeScreen()),
            );
          },
          icon: Icon(Icons.add),
          label: Text('コーヒーを追加'),
          tooltip: 'あなたの新しいコーヒー体験を記録しましょう',
        ),
      ),
    );
  }
}

class CoffeeListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return _buildAuthError(context);
    }
    
    return StreamBuilder<QuerySnapshot>(
      key: Key('coffee_list_view'),
      stream: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('coffees')
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingView();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyView(context);
        }

        var coffeeList = snapshot.data!.docs;

        // createdAtの降順でソート
        try {
          coffeeList.sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            return (bData['createdAt'] ?? '').toString().compareTo((aData['createdAt'] ?? '').toString());
          });
        } catch (e) {
          // ソートエラーをハンドリング
          print('Sort error: $e');
        }

        // リストビュー表示
        return RefreshIndicator(
          onRefresh: () async {
            // 手動更新のアクション
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('データを更新しました'), duration: Duration(seconds: 1))
            );
          },
          child: ListView.builder(
            key: Key('coffee_list'),
            itemCount: coffeeList.length,
            itemBuilder: (context, index) {
              var coffeeData = coffeeList[index].data() as Map<String, dynamic>;
              coffeeData['documentId'] = coffeeList[index].id;
              
              return _buildCoffeeListItem(context, coffeeData, coffeeList[index].id);
            },
          ),
        );
      },
    );
  }

  Widget _buildCoffeeListItem(BuildContext context, Map<String, dynamic> coffeeData, String documentId) {
    bool isFavorite = coffeeData['isFavorite'] ?? false;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2.0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: _getRoastLevelColor(coffeeData['roastLevel']),
          child: Icon(Icons.coffee, color: Colors.white),
        ),
        title: Text(
          coffeeData['coffeeName'] ?? 'No name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.0),
            Row(
              children: [
                Icon(Icons.place, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${coffeeData['originCountryName'] ?? ''} ${coffeeData['region'] ?? ''}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.0),
            Row(
              children: [
                Icon(Icons.spa, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${coffeeData['variety'] ?? 'Unknown variety'}, ${coffeeData['process'] ?? 'Unknown process'}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            coffeeData['flavorNotes'] != null && coffeeData['flavorNotes'].toString().isNotEmpty
              ? Padding(
                  padding: EdgeInsets.only(top: 2.0),
                  child: Row(
                    children: [
                      Icon(Icons.description, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          coffeeData['flavorNotes'],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                _toggleFavorite(documentId, isFavorite);
              },
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          _showCoffeeDetails(context, coffeeData);
        },
        onLongPress: () {
          _showOptionsMenu(context, coffeeData, documentId);
        },
      ),
    );
  }

  void _toggleFavorite(String documentId, bool currentStatus) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('coffees')
      .doc(documentId)
      .update({
        'isFavorite': !currentStatus,
        'updatedAt': DateTime.now().toString(),
      });
  }

  void _showCoffeeDetails(BuildContext context, Map<String, dynamic> coffeeData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoffeeCardScreen(coffeeData: coffeeData),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context, Map<String, dynamic> coffeeData, String documentId) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('編集'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCoffeeScreen(documentId: documentId),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text(coffeeData['isFavorite'] ?? false ? 'お気に入りから削除' : 'お気に入りに追加'),
                onTap: () {
                  _toggleFavorite(documentId, coffeeData['isFavorite'] ?? false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('削除', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, coffeeData, documentId);
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> coffeeData, String documentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('このコーヒーを削除しますか？'),
          content: Text('「${coffeeData['coffeeName']}」を削除します。この操作は元に戻せません。'),
          actions: [
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('削除', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('coffees')
                    .doc(documentId)
                    .delete();
                  
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('「${coffeeData['coffeeName']}」を削除しました'),
                      action: SnackBarAction(
                        label: '元に戻す',
                        onPressed: () {
                          // 削除を元に戻す処理 (coffeeDataを使って再作成)
                          FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('coffees')
                            .add(Map<String, dynamic>.from(coffeeData)..remove('documentId'));
                        },
                      ),
                    ),
                  );
                } catch (e) {
                  print('Delete error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('削除中にエラーが発生しました')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Color _getRoastLevelColor(String? roastLevel) {
    if (roastLevel == null) return Colors.brown;
    
    switch (roastLevel.toLowerCase()) {
      case 'light':
      case 'ライト':
      case 'ライトロースト':
        return Color(0xFFC8A780);
      case 'medium light':
      case 'ミディアムライト':
        return Color(0xFFB38867);
      case 'medium':
      case 'ミディアム':
      case 'ミディアムロースト':
        return Color(0xFF9F744D);
      case 'medium dark':
      case 'ミディアムダーク':
        return Color(0xFF8B5C34);
      case 'dark':
      case 'ダーク':
      case 'ダークロースト':
        return Color(0xFF77441B);
      default:
        return Colors.brown;
    }
  }

  Widget _buildAuthError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            Strings.homeScreenUserAuthError,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login_signup');
            },
            child: Text('ログイン'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('データを読み込んでいます...'),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            Strings.homeScreenUserCoffeeDataNone,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('最初のコーヒーを追加'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCoffeeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CoffeeGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return _buildAuthError(context);
    }
    
    return StreamBuilder<QuerySnapshot>(
      key: Key('coffee_grid_view'),
      stream: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('coffees')
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingView();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyView(context);
        }

        var coffeeList = snapshot.data!.docs;

        // createdAtの降順でソート
        try {
          coffeeList.sort((a, b) {
            var aData = a.data() as Map<String, dynamic>;
            var bData = b.data() as Map<String, dynamic>;
            return (bData['createdAt'] ?? '').toString().compareTo((aData['createdAt'] ?? '').toString());
          });
        } catch (e) {
          print('Sort error: $e');
        }

        // グリッドビュー表示
        return RefreshIndicator(
          onRefresh: () async {
            // 手動更新のアクション
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('データを更新しました'), duration: Duration(seconds: 1))
            );
          },
          child: GridView.builder(
            key: Key('coffee_grid'),
            padding: EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: coffeeList.length,
            itemBuilder: (context, index) {
              var coffeeData = coffeeList[index].data() as Map<String, dynamic>;
              coffeeData['documentId'] = coffeeList[index].id;
              
              return _buildCoffeeGridItem(context, coffeeData, coffeeList[index].id);
            },
          ),
        );
      },
    );
  }

  Widget _buildCoffeeGridItem(BuildContext context, Map<String, dynamic> coffeeData, String documentId) {
    bool isFavorite = coffeeData['isFavorite'] ?? false;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoffeeCardScreen(coffeeData: coffeeData),
          ),
        );
      },
      onLongPress: () {
        _showOptionsMenu(context, coffeeData, documentId);
      },
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // カードのヘッダー部分（焙煎度に応じた色）
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: _getRoastLevelColor(coffeeData['roastLevel']),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.coffee,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        _toggleFavorite(documentId, isFavorite);
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // カードのコンテンツ部分
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffeeData['coffeeName'] ?? 'No name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${coffeeData['originCountryName'] ?? ''}',
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${coffeeData['variety'] ?? ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    '${coffeeData['process'] ?? ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  // 焙煎度表示
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${coffeeData['roastLevel'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleFavorite(String documentId, bool currentStatus) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('coffees')
      .doc(documentId)
      .update({
        'isFavorite': !currentStatus,
        'updatedAt': DateTime.now().toString(),
      });
  }

  void _showOptionsMenu(BuildContext context, Map<String, dynamic> coffeeData, String documentId) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  coffeeData['coffeeName'] ?? 'No name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.visibility),
                title: Text('詳細を表示'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoffeeCardScreen(coffeeData: coffeeData),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('編集'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCoffeeScreen(documentId: documentId),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text(coffeeData['isFavorite'] ?? false ? 'お気に入りから削除' : 'お気に入りに追加'),
                onTap: () {
                  _toggleFavorite(documentId, coffeeData['isFavorite'] ?? false);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(coffeeData['isFavorite'] ?? false 
                        ? 'お気に入りから削除しました' 
                        : 'お気に入りに追加しました'
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('削除', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, coffeeData, documentId);
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> coffeeData, String documentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('このコーヒーを削除しますか？'),
          content: Text('「${coffeeData['coffeeName']}」を削除します。この操作は元に戻せません。'),
          actions: [
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('削除', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection('coffees')
                    .doc(documentId)
                    .delete();
                  
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('「${coffeeData['coffeeName']}」を削除しました'),
                      action: SnackBarAction(
                        label: '元に戻す',
                        onPressed: () {
                          // 削除を元に戻す処理
                          FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('coffees')
                            .add(Map<String, dynamic>.from(coffeeData)..remove('documentId'));
                        },
                      ),
                    ),
                  );
                } catch (e) {
                  print('Delete error: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('削除中にエラーが発生しました')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Color _getRoastLevelColor(String? roastLevel) {
    if (roastLevel == null) return Colors.brown;
    
    switch (roastLevel.toLowerCase()) {
      case 'light':
      case 'ライト':
      case 'ライトロースト':
        return Color(0xFFC8A780);
      case 'medium light':
      case 'ミディアムライト':
        return Color(0xFFB38867);
      case 'medium':
      case 'ミディアム':
      case 'ミディアムロースト':
        return Color(0xFF9F744D);
      case 'medium dark':
      case 'ミディアムダーク':
        return Color(0xFF8B5C34);
      case 'dark':
      case 'ダーク':
      case 'ダークロースト':
        return Color(0xFF77441B);
      default:
        return Colors.brown;
    }
  }

  Widget _buildAuthError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            Strings.homeScreenUserAuthError,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login_signup');
            },
            child: Text('ログイン'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('データを読み込んでいます...'),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            Strings.homeScreenUserCoffeeDataNone,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('最初のコーヒーを追加'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddCoffeeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return _buildAuthError(context);
    }
    
    return StreamBuilder<QuerySnapshot>(
      key: Key('favorites_view'),
      stream: FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('coffees')
        .where('isFavorite', isEqualTo: true)
        .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingView();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyFavoritesView(context);
        }

        var favoritesList = snapshot.data!.docs;

        // リストビュー表示
        return ListView.builder(
          key: Key('favorites_list'),
          itemCount: favoritesList.length,
          itemBuilder: (context, index) {
            var coffeeData = favoritesList[index].data() as Map<String, dynamic>;
            coffeeData['documentId'] = favoritesList[index].id;
            
            return _buildFavoriteItem(context, coffeeData, favoritesList[index].id);
          },
        );
      },
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Map<String, dynamic> coffeeData, String documentId) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2.0,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: _getRoastLevelColor(coffeeData['roastLevel']),
          child: Icon(Icons.coffee, color: Colors.white),
        ),
        title: Text(
          coffeeData['coffeeName'] ?? 'No name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.0),
            Row(
              children: [
                Icon(Icons.place, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    '${coffeeData['originCountryName'] ?? ''}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.0),
            coffeeData['flavorNotes'] != null && coffeeData['flavorNotes'].toString().isNotEmpty
              ? Row(
                  children: [
                    Icon(Icons.description, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        coffeeData['flavorNotes'],
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : Container(),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                _removeFavorite(context, documentId, coffeeData['coffeeName']);
              },
            ),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoffeeCardScreen(coffeeData: coffeeData),
            ),
          );
        },
      ),
    );
  }

  void _removeFavorite(BuildContext context, String documentId, String coffeeName) {
    FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('coffees')
      .doc(documentId)
      .update({
        'isFavorite': false,
        'updatedAt': DateTime.now().toString(),
      });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('「$coffeeName」をお気に入りから削除しました'),
        action: SnackBarAction(
          label: '元に戻す',
          onPressed: () {
            // 削除を元に戻す処理
            FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('coffees')
              .doc(documentId)
              .update({
                'isFavorite': true,
                'updatedAt': DateTime.now().toString(),
              });
          },
        ),
      ),
    );
  }

  Color _getRoastLevelColor(String? roastLevel) {
    if (roastLevel == null) return Colors.brown;
    
    switch (roastLevel.toLowerCase()) {
      case 'light':
      case 'ライト':
      case 'ライトロースト':
        return Color(0xFFC8A780);
      case 'medium light':
      case 'ミディアムライト':
        return Color(0xFFB38867);
      case 'medium':
      case 'ミディアム':
      case 'ミディアムロースト':
        return Color(0xFF9F744D);
      case 'medium dark':
      case 'ミディアムダーク':
        return Color(0xFF8B5C34);
      case 'dark':
      case 'ダーク':
      case 'ダークロースト':
        return Color(0xFF77441B);
      default:
        return Colors.brown;
    }
  }

  Widget _buildAuthError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            Strings.homeScreenUserAuthError,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login_signup');
            },
            child: Text('ログイン'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('お気に入りを読み込んでいます...'),
        ],
      ),
    );
  }

  Widget _buildEmptyFavoritesView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'お気に入りに登録したコーヒーがありません',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'コーヒーリストでハートアイコンをタップすると\nお気に入りに追加できます',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
