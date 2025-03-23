import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import '../models/coffee.dart';
import '../models/tasting.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ����n��������֗
  Stream<QuerySnapshot> getCoffees() {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("����L�<U�fD~[�");
    }
    
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('coffees')
        .snapshots();
  }

  // ����������
  Future<DocumentReference> addCoffee(Coffee coffee) async {
    User? user = _auth.currentUser;
    if (user == null) {
      // ƹ�(n����ID�(
      return _firestore
          .collection('users')
          .doc('test_user')
          .collection('coffees')
          .add(coffee.toJson());
    }
    
    try {
      // ����ɭ����LX(WjD4o\
      await _initUserDocument(user.uid);
      
      return await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('coffees')
          .add(coffee.toJson());
    } catch (e) {
      print('Error adding coffee: $e');
      throw e;
    }
  }

  // ����ɭ����LX(WjD4k
  Future<void> _initUserDocument(String uid) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(uid).set({
          'email': _auth.currentUser?.email,
          'created_at': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error initializing user document: $e');
    }
  }

  // ����������
  Future<void> updateCoffee(String documentId, Coffee coffee) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("����L�<U�fD~[�");
    }
    
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('coffees')
        .doc(documentId)
        .update(coffee.toJson());
  }

  // ��������Jd
  Future<void> deleteCoffee(String documentId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("����L�<U�fD~[�");
    }
    
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('coffees')
        .doc(documentId)
        .delete();
  }

  // �������ns0�֗
  Future<DocumentSnapshot> getCoffeeDetail(String documentId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("����L�<U�fD~[�");
    }
    
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('coffees')
        .doc(documentId)
        .get();
  }

  // ;ϒ������
  Future<String> uploadImage(String path, List<int> imageData) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = _storage.ref().child('user_files/${user.uid}/$fileName');
    
    UploadTask uploadTask = ref.putData(
      Uint8List.fromList(imageData),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
  
  // Save tasting feedback for a specific coffee
  Future<DocumentReference> addTasting(String coffeeId, Tasting tasting) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    
    try {
      // Add tasting to the tastings subcollection
      final tastingRef = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('coffees')
          .doc(coffeeId)
          .collection('tastings')
          .add(tasting.toJson());
          
      // Update the coffee document with the new tasting
      await _updateCoffeeTastings(coffeeId);
          
      return tastingRef;
    } catch (e) {
      print('Error adding tasting: $e');
      throw e;
    }
  }
  
  // Get all tastings for a specific coffee
  Future<List<Tasting>> getTastings(String coffeeId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('coffees')
          .doc(coffeeId)
          .collection('tastings')
          .orderBy('date', descending: true)
          .get();
          
      return snapshot.docs
          .map((doc) => Tasting.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting tastings: $e');
      throw e;
    }
  }
  
  // Delete a tasting
  Future<void> deleteTasting(String coffeeId, String tastingId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('coffees')
          .doc(coffeeId)
          .collection('tastings')
          .doc(tastingId)
          .delete();
          
      // Update the coffee document with the updated tastings list
      await _updateCoffeeTastings(coffeeId);
    } catch (e) {
      print('Error deleting tasting: $e');
      throw e;
    }
  }
  
  // Helper method to update coffee document with latest tastings
  Future<void> _updateCoffeeTastings(String coffeeId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    
    try {
      // Get all tastings for this coffee
      final tastings = await getTastings(coffeeId);
      
      // Get the coffee document
      final coffeeDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('coffees')
          .doc(coffeeId)
          .get();
          
      // Create Coffee object from document
      final coffee = Coffee.fromJson(coffeeDoc.data() as Map<String, dynamic>);
      
      // Update coffee with tastings
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('coffees')
          .doc(coffeeId)
          .update({
            'tastings': tastings.map((t) => t.toJson()).toList(),
            'updatedAt': DateTime.now().toIso8601String(),
          });
    } catch (e) {
      print('Error updating coffee tastings: $e');
      throw e;
    }
  }
}