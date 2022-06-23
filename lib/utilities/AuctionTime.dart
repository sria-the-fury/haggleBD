import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:haggle/firebase/BidsManagement.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


class AuctionTime{
   getCountDown(lastBidTime, postId, isCompleted){

    var timeInMilliSeconds = (lastBidTime.seconds * 1000);

    return CountdownTimer(
      endTime: timeInMilliSeconds,
      widgetBuilder: (BuildContext context, CurrentRemainingTime? time) {

        if (time == null) {
          if(isCompleted == false) {
            BidsManagement().auctionCompleted(postId);
          }
          return Chip(
           avatar: const Icon(Icons.timer_off, size: 15, color: Colors.white,),
           label: Text("BID OVER "+getPostedDay(lastBidTime), style: const TextStyle(color: Colors.white),),
            backgroundColor: Colors.red[300],
          );
        }
        else {
          return Chip(
            avatar: Icon(Icons.timer, size: 20, color: Colors.blue[500],),
            label: Text(
              '${time.days ?? 0} DAY(s)  ${time.hours ?? 0} HOUR(s)  ${time.min ?? 0} MIN(s)  ${time.sec} SEC',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),),
          );}
      },
    );
  }

   getTime(time) {
     DateTime date = DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000, );

     return DateFormat.yMMMd().add_jms().format(date);
   }

   getAuctionPostedTime(time){


     return DateFormat.yMMMd().add_jms().format(time);
   }

   getPostedDay(time){
     DateTime date = DateTime.fromMillisecondsSinceEpoch(time.seconds * 1000, );
     final ago = date.subtract(const Duration());
     return timeago.format(ago);

   }
}