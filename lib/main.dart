import 'package:flutter/material.dart';
import 'package:haggle/database-services/ProductsDBService.dart';
import 'package:haggle/model/Products.dart';
import 'package:haggle/routes/HomePage.dart';
import 'package:haggle/routes/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;


    return MaterialApp(
        home: user?.uid != null ? StreamProvider<List<Products>>.value(value: ProductsDBService().getProducts, initialData: const [], child: const HomePage(),) : const LoginPage(),
        routes: user?.uid != null ? (<String, WidgetBuilder>{
          '/landingPage': (BuildContext context) => const LoginPage(),
          '/homePage': (BuildContext context) => StreamProvider<List<Products>>.value(value: ProductsDBService().getProducts, initialData: const [], child: const HomePage(),),
        }) :  (<String, WidgetBuilder>{
          '/landingPage': (BuildContext context) => const LoginPage(),
          '/homePage': (BuildContext context) => StreamProvider<List<Products>>.value(value: ProductsDBService().getProducts, initialData: const [], child: const HomePage(),),
        })
    );
  }
}