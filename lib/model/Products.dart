
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Products extends Equatable{
  final String postId;
  final String userId;
  final String productDetails;
  final String productName;
  final bool isCompleted;
  final Timestamp addedAt;
  final Timestamp lastBidTime;
  final List itemImages;
  final List bidUsers;
  final int minBidPrice;
  final int lastBidPrice;
  final String lastBidUserId;

  const Products({
    required this.postId,
    required this.userId,
    required this.productDetails,
    required this.isCompleted,
    required this.addedAt,
    required this.lastBidTime,
    required this.itemImages,
    required this.bidUsers,
    required this.productName,
    required this.minBidPrice,
    required this.lastBidPrice,
    required this.lastBidUserId

});

  static Products fromSnapshot(DocumentSnapshot product){
    return Products(
      postId: product['postId'],
      userId: product['userId'],
      productDetails: product['productDetails'],
      isCompleted: product['isCompleted'],
        addedAt: product['addedAt'],
      lastBidTime: product['lastBidTime'],
        itemImages: product['itemImages'],
      bidUsers: product['bidUsers'],
        productName: product['productName'],
      minBidPrice: product['minBidPrice'],
      lastBidPrice: product['lastBidPrice'],
        lastBidUserId: product['lastBidUserId']
    );
  }
  @override
  List<Object?> get props => [
    postId,userId, productDetails, isCompleted, addedAt, lastBidTime, itemImages,bidUsers, productName, minBidPrice,lastBidPrice, lastBidUserId
  ];

}