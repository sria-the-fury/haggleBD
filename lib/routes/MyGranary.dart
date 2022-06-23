import 'package:flutter/material.dart';
import 'package:haggle/model/Products.dart';
import 'package:haggle/utilities/GesturedCard.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

var _selectOptionBid = false;
var _selectOptionItem = true;

class MyGranary extends StatefulWidget {
  const MyGranary({Key? key}) : super(key: key);

  @override
  _MyGranaryState createState() => _MyGranaryState();
}

class _MyGranaryState extends State<MyGranary> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    List productList = Provider.of<List<Products>>(context);
    final Iterable myProducts =
        productList.where((product) => product.userId == currentUser?.uid);
    final Iterable myBids = productList.where((product) {
      return product.bidUsers.contains(currentUser!.uid);
    });

    var raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: _selectOptionBid ? Colors.white : Colors.blue[500],
      primary: _selectOptionBid ? Colors.blue[500] : Colors.white,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );

    var raisedButtonStyle2 = ElevatedButton.styleFrom(
      onPrimary: _selectOptionItem ? Colors.white : Colors.blue[500],
      primary: _selectOptionItem ? Colors.blue[500] : Colors.white,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: raisedButtonStyle2,
              onPressed: () {
                setState(() {
                  _selectOptionBid = false;
                  _selectOptionItem = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.sell,
                    color: _selectOptionItem ? Colors.white : Colors.blue[500],
                    size: 20.0,
                  ),
                  const Text(
                    'My Items',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            ),
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
                setState(() {
                  _selectOptionItem = false;
                  _selectOptionBid = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.attach_money,
                    color: _selectOptionBid ? Colors.white : Colors.blue[500],
                    size: 20.0,
                  ),
                  const Text(
                    'My Bids',
                    style: TextStyle(fontSize: 18),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: productList.isNotEmpty
          ? (_selectOptionItem
              ? (myProducts.toList().isNotEmpty
                  ? GesturedCard(items: myProducts.toList())
                  : const Center(child: Text('You have not added any product')))
              : (myBids.toList().isNotEmpty
                  ? GesturedCard(items: myBids.toList())
                  : const Center(child: Text('You have not made any bid yet'))))
          : const Center(child: Text('No Data')),
    );
  }
}
