import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haggle/firebase/UserManagement.dart';
import 'package:haggle/routes/BidsItemDetails.dart';

import 'package:haggle/utilities/Carousel.dart';
import 'AuctionTime.dart';

class GesturedCard extends StatefulWidget {
  final List items;
  const GesturedCard({Key? key, required this.items}) : super(key: key);

  @override
  _GesturedCardState createState() => _GesturedCardState();
}

class _GesturedCardState extends State<GesturedCard> {
  @override
  Widget build(BuildContext context) {
    var item = widget.items;
    User? currentUser = FirebaseAuth.instance.currentUser;

    return ListView.builder(
        itemCount: item.length,
        key: UniqueKey(),
        itemBuilder: (context, index) {
          var itemData = item[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BidsItemDetails(
                        itemDetails: itemData,
                      )));
            },
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UserManagement().getPostedUser(itemData.userId,
                              'MODERATE_NAME', 10.0, 14.0, false, false, true),
                          Text(AuctionTime().getPostedDay(itemData.addedAt))
                        ],
                      )),
                  Carousel().imageCarousel(itemData.itemImages, 180.0),
                  Container(
                    child: AuctionTime().getCountDown(itemData.lastBidTime,
                        itemData.postId, itemData.isCompleted),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 0, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            itemData.productName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.topLeft,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Min Bid: ৳${itemData.minBidPrice}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Bid Before : ' +
                                      AuctionTime()
                                          .getTime(itemData.lastBidTime),
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 5.0),
                          child: Chip(
                            avatar: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.people,
                                size: 15,
                                color: itemData.bidUsers.isNotEmpty ? Colors.blue : Colors.black.withOpacity(0.5),
                              ),
                            ),
                            label: Text(itemData.bidUsers.isNotEmpty
                                ? itemData.bidUsers.length.toString()
                                : '0', style: TextStyle(fontSize: 18, color: itemData.bidUsers.isNotEmpty ? Colors.blue : Colors.grey.withOpacity(0.5)), ),
                          )),
                      Container(
                          padding:
                              const EdgeInsets.only(right: 10.0, bottom: 5.0),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor:

                            itemData.bidUsers.isNotEmpty &&
                                    itemData.bidUsers.contains(currentUser!.uid)
                                ? Colors.orange
                                : Colors.grey.withOpacity(0.5),
                            child: Text('৳', style: TextStyle(color: itemData.bidUsers.isNotEmpty &&
                                itemData.bidUsers.contains(currentUser!.uid) ? Colors.white : Colors.grey.withOpacity(0.7), fontSize: 18, fontWeight: FontWeight.bold ),),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
