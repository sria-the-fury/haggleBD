// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haggle/model/Products.dart';

class ProductsDBService{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Products>> get getProducts{
    return firestore
        .collection('items').orderBy('addedAt' , descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((snapshot){
          return snapshot.docs.map((doc) => Products.fromSnapshot(doc)).toList();
    });
  }
}