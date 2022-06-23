import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haggle/utilities/FlutterToast.dart';
import 'package:url_launcher/url_launcher.dart';

class UserManagement {
  User? user = FirebaseAuth.instance.currentUser;
  storeNewUser(user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'userId': user.uid,
        'userName': user.displayName,
        'photoURL': user.photoURL,
        'address': '',
        'cellNumber': '',
        'joinedAt': DateTime.now()
      });
    } catch (e) {
      FlutterToast().errorToast('@store :', 'BOTTOM', 14.0, e);
    } finally {
      FlutterToast().successToast('user added', 'BOTTOM', 14.0, null);
    }
  }

  updateUserAddressAndCellNumber(userId, address, cellNumber) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({"address": address, 'cellNumber': cellNumber});
      FlutterToast().successToast(
          'Address and Cell Number Updated.', 'BOTTOM', 14.0, null);
    } catch (e) {
      FlutterToast().errorToast('@store :', 'BOTTOM', 14.0, e);
    }
  }

  getPostedUser(
      userId, isFullName, avatarSize, fontSize, colorWhite, isFontBold, isRow) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;
            return isRow
                ? Row(children: [
                    CachedNetworkImage(
                        imageUrl: userData!['photoURL'],
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: avatarSize,
                            ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Container(
                                  height: avatarSize,
                                  width: avatarSize,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: Colors.green,
                                  ),
                                )),
                    const SizedBox(
                      width: 5,
                    ),
                    getName(userData['userName'], isFullName, fontSize,
                        colorWhite, isFontBold)
                  ])
                : Column(children: [
                    CachedNetworkImage(
                        imageUrl: userData!['photoURL'],
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                              backgroundImage: imageProvider,
                              radius: avatarSize,
                            ),
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Container(
                                  height: avatarSize,
                                  width: avatarSize,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    value: downloadProgress.progress,
                                    color: Colors.green,
                                  ),
                                )),
                    const SizedBox(
                      width: 5,
                    ),
                    getName(userData['userName'], isFullName, fontSize,
                        colorWhite, isFontBold)
                  ]);
          } else {
            return isRow
                ? Row(children: [
                    CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: avatarSize,
                        child: const SizedBox(
                          width: 1,
                          height: 1,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 10,
                      width: 50,
                      color: Colors.grey,
                    )
                  ])
                : Column(children: [
                    CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: avatarSize,
                        child: const SizedBox(
                          width: 1,
                          height: 1,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 10,
                      width: 50,
                      color: Colors.grey,
                    )
                  ]);
          }
        });
  }

  getBidWinnerAddress(winnerId, showToSeller) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(winnerId)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;

            return userData!['address'] == '' || userData['cellNumber'] == ''
                ? Column(
                    children: [
                      Text(
                          showToSeller
                              ? 'Email buyer to add Address'
                              : 'Add Address and Cell Number in Profile.',
                          style: const TextStyle(
                              color: Colors.orange, fontSize: 14)),
                      showToSeller
                          ? InputChip(
                              avatar: const Icon(Icons.email),
                              label: const Text('Mail Buyer'),
                              onPressed: () async {
                                String? encodeQueryParameters(
                                    Map<String, String> params) {
                                  return params.entries
                                      .map((e) =>
                                          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                      .join('&');
                                }

                                final Uri launchUri = Uri(
                                    scheme: 'mailto',
                                    path: userData['email'],
                                    query:
                                        encodeQueryParameters(<String, String>{
                                      'subject':
                                          'Please update your address and cell number.',
                                      'body': 'Dear, ${userData['userName']},\n Please update your Address and Cell Phone Number from'
                                          ' your profile in HaggleBD as I can send your product as soon as possible.\n\nThanks and Regards,\n ${user!.displayName}\nSeller, HaggleBD.',
                                    }));

                                await launchUrl(launchUri);
                              },
                            )
                          : Container(),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                          showToSeller
                              ? 'Product must deliver @ ' + userData['address']
                              : "Product will deliver @ " + userData['address'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18)),
                      showToSeller
                          ? InputChip(
                              avatar: const Icon(Icons.call),
                              label: const Text('Make Contact'),
                              onPressed: () async {
                                final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: '+88' + userData['cellNumber']);

                                await launchUrl(launchUri);
                              },
                            )
                          : Container(),
                    ],
                  );
          } else {
            return Container();
          }
        });
  }

  getName(
    name,
    naming,
    fontSize,
    colorWhite,
    isFontBold,
  ) {
    List<String> nameList = name.split(" ");

    if (naming == 'SHORT_NAME') {
      return Text(nameList[0],
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: isFontBold ? FontWeight.bold : FontWeight.normal,
              color:
                  colorWhite ? Colors.white : Colors.black.withOpacity(0.7)));
    } else if (naming == "MODERATE_NAME" && nameList.length > 1) {
      return Text(nameList[0] + ' ' + nameList[1],
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: isFontBold ? FontWeight.bold : FontWeight.normal,
              color:
                  colorWhite ? Colors.white : Colors.black.withOpacity(0.7)));
    } else {
      return Text(name,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: isFontBold ? FontWeight.bold : FontWeight.normal,
              color:
                  colorWhite ? Colors.white : Colors.black.withOpacity(0.7)));
    }
  }
}
