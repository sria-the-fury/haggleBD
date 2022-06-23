import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:haggle/utilities/FlutterToast.dart';
import 'package:haggle/utilities/pie-chart/PieChartPage.dart';
import 'LoginPage.dart';
import 'package:haggle/modals/updateAddressAndPhoneModal.dart';

class ProfilePage extends StatefulWidget {
  final List productList;
  const ProfilePage({Key? key, required this.productList}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  late StreamSubscription userSub;
  Map? userData;
  @override
  void initState() {
    userSub = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .snapshots()
        .listen((snap) {
      setState(() {
        userData = snap.data()!;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Iterable myProducts =
        widget.productList.where((product) => product.userId == user?.uid);

    final Iterable myBids = widget.productList.where((product) =>
        product.isCompleted == true &&
        product.bidUsers.contains(user?.uid) &&
        product.lastBidUserId == user?.uid);

    var userImage = user?.photoURL;

    getTotalValue(myProducts) {
      int totalValue = 0;
      myProducts.forEach((product) {
        int bidPrice = product.minBidPrice;
        totalValue += bidPrice;
      });

      return totalValue;
    }

    getTotalSell(myProducts) {
      int totalSell = 0;
      final Iterable completed = myProducts.where((product) =>
          product.isCompleted == true &&
          product.lastBidPrice > product.minBidPrice);
      completed.toList().forEach((product) {
        int lastBidPrice = product.lastBidPrice;
        totalSell += lastBidPrice;
      });

      return totalSell;
    }

    getTotalBuy(biddingProduct) {
      int totalBuy = 0;
      biddingProduct.toList().forEach((product) {
        int lastBidPrice = product.lastBidPrice;
        totalBuy += lastBidPrice;
      });
      return totalBuy;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('PROFILE'),
            IconButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                  } catch (e) {
                    FlutterToast()
                        .errorToast('@error - Log out', 'BOTTOM', 14.0, e);
                  } finally {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (Route<dynamic> route) => false);
                    FlutterToast()
                        .warningToast('Log out', 'BOTTOM', 14.0, null);
                  }
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue[500],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  )),
              height: 130,
              padding: const EdgeInsets.all(5.0),
              child: Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      CachedNetworkImage(
                          imageUrl: userImage.toString(),
                          imageBuilder: (context, imageProvider) => CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 65,
                          ),
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              CircularProgressIndicator(value: downloadProgress.progress, color: Colors.green,)
                      ),

                      const SizedBox(
                        width: 15.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: 150, child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "  " + user!.displayName!,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  maxLines: 1,
                                  softWrap: false,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              )
                            ],
                          ),
                          userData != null && userData!['cellNumber'] != ''
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.call,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    Text("  " + userData!['cellNumber'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                        maxLines: 1,
                                        textAlign: TextAlign.left),
                                  ],
                                )
                              : Container(),
                          Row(
                            children: [
                              const Icon(
                                Icons.email,
                                size: 20,
                                color: Colors.white,
                              ),

                              SizedBox(width: 150, child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text("  " + user!.email!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                    maxLines: 1,
                                    textAlign: TextAlign.left),
                              ),
                              )

                            ],
                          ),
                          userData != null && userData!['address'] != ''
                              ? Row(
                                  children: [
                                    const Icon(
                                      Icons.person_pin_circle,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    Text("  " + userData!['address'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                        maxLines: 1,
                                        textAlign: TextAlign.left),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: -15,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            enableDrag: true,
                            useRootNavigator: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: Colors.white,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            builder: (BuildContext context) {
                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: UpdateAddressAndPhoneModal(
                                    userAddress: userData != null &&
                                            userData!['address'] != ''
                                        ? userData!['address']
                                        : '',
                                    userCellNumber: userData != null &&
                                            userData!['cellNumber'] != ''
                                        ? userData!['cellNumber']
                                        : '',
                                  ),
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 25,
                        color: Colors.white,
                      ),
                      tooltip: 'update address and phone number',
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.align_vertical_bottom,
                        color: Colors.blue,
                      ),
                      Text(
                        'Dashboard',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  Divider(
                    height: 10,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.blue.withOpacity(0.3),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'SELL',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          widget.productList.isNotEmpty &&
                                  myProducts.toList().isNotEmpty
                              ? Column(
                                  children: [
                                    PieChartPage(
                                        myProducts: myProducts.toList()),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total Value: ৳${getTotalValue(myProducts)}',
                                          style:
                                              const TextStyle(fontSize: 20.0),
                                        ),
                                        const SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                            'Total Sell: ৳${getTotalSell(myProducts)}',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                color:
                                                    getTotalSell(myProducts) >
                                                            getTotalValue(
                                                                myProducts)
                                                        ? Colors.green
                                                        : Colors.red)),
                                      ],
                                    )
                                  ],
                                )
                              : const Text('Add Product'),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: 10,
                    thickness: 1,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.blue.withOpacity(0.3),
                  ),
                  Column(
                    children: [
                      const Text(
                        'BUY',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      myBids.toList().isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Total Buy: ৳${getTotalBuy(myBids)}',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.blue)),
                                  Text('Bid Win: ${myBids.toList().length}',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.green)),
                                ],
                              ),
                            )
                          : const Text('Bid and Win a product.'),
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 3))
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(5.0),
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
          ],
        ),
      ),
    );
  }
}
