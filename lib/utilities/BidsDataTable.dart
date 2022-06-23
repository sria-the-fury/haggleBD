

import 'package:flutter/material.dart';
import 'package:haggle/firebase/UserManagement.dart';
import 'package:haggle/modals/BottomModal.dart';
import 'package:haggle/utilities/AuctionTime.dart';
import 'dart:core';


class BidsDataTable {

  table(bidUsers, context, bidPrice, postId, currentUserId, lastBidPrice){



    return bidUsers.length != 0 ? Column (
          children: [

            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 5.0, bottom: 15.0) ,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3)
                    )
                  ],
                ),
                padding: const EdgeInsets.all(5.0),
                child : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child : DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Bid Price(৳)',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Time',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ],
                        rows: bidUsers.map<DataRow>((user)=>
                         DataRow(
                          color: MaterialStateColor.resolveWith((states) => currentUserId == user['userId'] ?  Colors.black.withOpacity(0.2) : Colors.transparent),
                          cells:  <DataCell>[
                            DataCell(
                                UserManagement().getPostedUser(user['userId'], 'SHORT_NAME', 10.0, 14.0, false, false, true)

                            ),
                            DataCell(
                                user['userId'] == currentUserId ?
                                Text(user['bidPrice'].toString()+'   EDIT', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)

                                    : Text(user['bidPrice'].toString()),
                                onTap: user['userId'] == currentUserId ? () {
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
                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                            child: BottomModal(bidPrice, postId, user['userId'], user['bidPrice'], 'UPDATE', lastBidPrice),

                                          ),
                                        );
                                      });
                                } : null),
                            DataCell(Text(AuctionTime().getPostedDay(user['bidAt']))),
                          ],
                        ),).toList(),
                      ),
                    )
                )
            ),


          ]) : Container();
  }

}