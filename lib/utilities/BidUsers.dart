import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class BidUsers extends StatefulWidget {
  final String postId;
  const BidUsers(this.postId, {Key? key}) : super(key: key);

  @override
  _BidUsersState createState() => _BidUsersState();
}

class _BidUsersState extends State<BidUsers> {
  @override
  Widget build(BuildContext context) {
    var postId = widget.postId;
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').doc(postId).collection('bid-users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData ){
            return Text((snapshot.data!.docs.length).toString());
          } else {
            return const Text('Loading Data');
          }
        }

    );
  }
}
