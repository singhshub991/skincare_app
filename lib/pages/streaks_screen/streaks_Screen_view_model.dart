

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/enums/view_state.dart';
import '../../core/models/skin_care_model.dart';
import '../../core/models/user_model.dart';
import '../../core/others/base_view_model.dart';
import '../../core/others/preferences.dart';
import '../home/home_page.dart';
import 'package:intl/intl.dart';
class StreakScreenViewModel extends BaseViewModel {
int? dailyStreak;
int? streakDays;
int? percentageChange;
List<FlSpot>? streakData;
int? todayGoal;
double? firstX;
StreakScreenViewModel(){

    fetchStreakData();
  }


  Future<void> fetchStreakData() async {
    setState(ViewState.busy);
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String? uid = await StorageUtils.getString("uid");

    final docRef = FirebaseFirestore.instance.collection("usersStreak").doc(uid);
    final docSnapshot = await docRef.get();

    try {
      if (docSnapshot.exists) {
        final List<dynamic> streakList = docSnapshot.data()?['streaks'] ?? [];
        final int todayGoal = docSnapshot.data()?['goal'] ?? 3; // 🔹 Default goal = 3

        // Convert to list of maps
        List<Map<String, dynamic>> streaks = streakList.map((e) => {
          "date": e["date"],
          "count": e["count"]
        }).toList();
          debugPrint(" List<Map<String, dynamic>> streaks:${streaks}");
        // Sort streaks by date
        streaks.sort((a, b) => a["date"].compareTo(b["date"]));

        // 🔹 Get Today's Streak
        DateTime today = DateTime.now();

        int dailyStreak =today.toString().contains(streaks.last["date"]) ? streaks.last["count"] : 0;

        // 🔹 Calculate Streak Length
        int streakDays = 0;
        for (int i = streaks.length - 1; i >= 0; i--) {
          if (streaks[i]["count"] == 0) break;
          streakDays++;
        }

        // 🔹 Calculate Last 30 Days % Change
        int last30Count = streaks
            .where((e) => DateTime.parse(e["date"]).isAfter(today.subtract(Duration(days: 30))))
            .fold<int>(0, (sum, e) => sum + (e["count"] as int));
        int previous30Count = streaks
            .where((e) =>  DateTime.parse(e["date"]).isBefore(today.subtract(Duration(days: 30))) &&
            DateTime.parse(e["date"]).isAfter(today.subtract(Duration(days: 60))))
            .fold<int>(0, (sum, e) => sum + (e["count"] as int));
        debugPrint("previous30Count:$previous30Count");
        int percentageChange = previous30Count == 0 ? 100 : (((last30Count - previous30Count) / previous30Count) * 100).toInt();

        // 🔹 Prepare Chart Data
        List<FlSpot> streakData = streaks.map((e) {
          return FlSpot( DateTime.parse(e["date"]).millisecondsSinceEpoch.toDouble(), e["count"].toDouble());
        }).toList();
        double firstX = streakData.first.x;
        List<FlSpot> normalizedData = streakData.map((e) => FlSpot(
          (e.x - firstX) / (1000 * 60 * 60 * 24), // Convert ms to days
          e.y,
        )).toList();
        debugPrint("previous30Count:$streakData");
        // 🔹 Update UI

          this.dailyStreak = dailyStreak;
          this.streakDays = streakDays;
          this.percentageChange = percentageChange;
          this.streakData = normalizedData;
          this.todayGoal = todayGoal;
          this.firstX=firstX;
        setState(ViewState.idle);
      }
    }on FirebaseAuthException catch(e){
      setState(ViewState.idle);
      Fluttertoast.showToast(msg:"${e.code.toString()}");

    };

  }

}
