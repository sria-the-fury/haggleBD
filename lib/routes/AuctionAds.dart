import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haggle/model/Products.dart';
import 'package:haggle/utilities/GesturedCard.dart';
import 'package:provider/provider.dart';
import 'ProfilePage.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AuctionAds extends StatefulWidget {
  const AuctionAds({Key? key}) : super(key: key);

  @override
  _AuctionAdsState createState() => _AuctionAdsState();
}

class _AuctionAdsState extends State<AuctionAds> {
  bool showCircular = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        showCircular = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    var userImage = user?.photoURL;

    List<Products> productList = Provider.of<List<Products>>(context);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  Center(
                      child: Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(right: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3))
                              ]),
                          child: Lottie.asset(
                              'assets/auction_lottie_haggle-bd.json'))),
                  const Text('Haggle BD', textAlign: TextAlign.left),
                ],
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                      return ProfilePage(productList: productList);
                    }));
                    //Navigator.of(context).pushNamed('/profilePage');
                  },
                  child: CachedNetworkImage(
                      imageUrl: userImage.toString(),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 25,
                          ),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: Colors.green,
                                ),
                              )))
            ],
          ),
        ),
        body: productList.isNotEmpty
            ? GesturedCard(items: productList)
            : Center(
                child: showCircular
                    ? CircularProgressIndicator(
                        color: Colors.blue[500],
                      )
                    : const Text('No Auction Ads Found!')));
  }
}
