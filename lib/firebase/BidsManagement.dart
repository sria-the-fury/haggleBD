import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haggle/utilities/FlutterToast.dart';

class BidsManagement {
  makeBid(bidPrice, user, postId) async {
    try {
      await FirebaseFirestore.instance.
      collection('items')
          .doc(postId)
          .collection('bid-users').doc(user.uid)
          .set({
        'bidPrice': int.parse(bidPrice),
        'userId': user.uid,
        'postId': postId,
        'bidAt': DateTime.now()
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance.
      collection('items')
          .doc(postId)
          .set({
        'bidUsers': FieldValue.arrayUnion([user.uid])
      }, SetOptions(merge: true));
    } catch (e) {
      FlutterToast().errorToast('@store :', 'BOTTOM', 14.0, e);
    }
    finally {
      FlutterToast().successToast('Bid has been made', 'BOTTOM', 14.0, null);
    }
  }

  updateBid(editedBidPrice, userId, postId) async {
    try {
      await FirebaseFirestore.instance.
      collection('items')
          .doc(postId)
          .collection('bid-users').doc(userId)
          .update({
        'bidPrice': int.parse(editedBidPrice),
        'bidAt': DateTime.now()
      });
    } catch (e) {
      FlutterToast().errorToast('@store :', 'BOTTOM', 14.0, e);
    }
    finally {
      FlutterToast().successToast('Bid has been updated', 'BOTTOM', 14.0, null);
    }
  }

  addItem(productName, productDetails, bidPrice, bidEndTime, userId, images,
      postId) async {
    try {
      await FirebaseFirestore.instance.
      collection('items')
          .doc(postId)
          .set({
        'productName': productName,
        'postId': postId,
        'itemImages': images,
        'productDetails': productDetails,
        'isCompleted': false,
        'lastBidTime': bidEndTime,
        'bidUsers': [],
        'minBidPrice': int.parse(bidPrice),
        'userId': userId,
        'lastBidUserId': '',
        'lastBidPrice': 0,
        'addedAt': DateTime.now()
      }, SetOptions(merge: true));
    } catch (e) {
      FlutterToast().errorToast('@error ', "BOTTOM", 14.0, e.toString());
    }

  }

  auctionCompleted(postId) async {
    try {
      await FirebaseFirestore.instance.collection('items').doc(postId).update({
        'isCompleted': true
      });
    } catch (e) {
      FlutterToast().errorToast('@error ', "BOTTOM", 14.0, e.toString());

    }
  }

  updateLastBidAndBidder(postId, lastBidUserId, lastBidPrice) async{
    try {
      await FirebaseFirestore.instance.collection("items").doc(postId).set({
        "lastBidUserId": lastBidUserId,
        "lastBidPrice": int.parse(lastBidPrice)
      }, SetOptions(merge: true));
    }
    catch (e){
      FlutterToast().errorToast(e.toString(), "BOTTOM", 14.0, null);
    }
  }

}