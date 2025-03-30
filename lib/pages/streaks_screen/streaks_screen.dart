import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:skincare_app/core/enums/view_state.dart';
import 'package:skincare_app/pages/streaks_screen/streaks_Screen_view_model.dart';

class StreakScreen extends StatelessWidget {
  final int streakDays = 2;
  final int dailyStreak = 2;
  final List<FlSpot> streakData = [
    FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2), FlSpot(3, 4), FlSpot(4, 3),
    FlSpot(5, 5), FlSpot(6, 2), FlSpot(7, 4),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StreakScreenViewModel(),
      child:  Consumer<StreakScreenViewModel>(
          builder: (context, model, child) {
          return ModalProgressHUD(
            opacity: 0.5,
            progressIndicator: CircularProgressIndicator(color: Color(0XFF964F66),),
            inAsyncCall: model.state == ViewState.busy,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Today's Goal: ${model.todayGoal} streak days",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    // SizedBox(height: 8),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0XFFF2E8EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Streak Days", style: TextStyle(fontSize: 16)),
                          Text("${model.streakDays}",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // SizedBox(height: 20),
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Daily Streak", style: TextStyle(fontSize: 16)),
                        Text("${model.dailyStreak}",
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ],
                    ),

                    Row(
                      children: [
                        Text("Last 30 Days", style: TextStyle(color: Color(0XFF964F66))),
                        Text("+${model.percentageChange}%", style: TextStyle(color: Colors.green)),
                      ],
                    ),

                    // **📊 Streak Chart**

                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0XFFF2E8EB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),

                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              drawBelowEverything: false, // Hide Y-axis labels
                            ),
                            rightTitles: AxisTitles(
                              drawBelowEverything: false, // Hide right Y-axis labels if any
                            ),
                            topTitles: AxisTitles(
                              drawBelowEverything: false, // Hide top labels if any
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  // Convert value back to readable date
                                  DateTime date =
                                  DateTime.fromMillisecondsSinceEpoch(model.firstX!.toInt())
                                      .add(Duration(days: value.toInt()));

                                  return Text(
                                    DateFormat('MMM d').format(date), // Format as 'Oct 2'
                                    style: TextStyle(fontSize: 10),
                                  );
                                },
                                interval: 1,
                                // getTitlesWidget: (value, meta) {
                                //   switch (value.toInt()) {
                                //     case 0: return Text("1D", style: TextStyle(color: Color(0XFF964F66)));
                                //     case 1: return Text("1W", style: TextStyle(color: Color(0XFF964F66)));
                                //     case 2: return Text("1M", style: TextStyle(color: Color(0XFF964F66)));
                                //     case 3: return Text("3M", style: TextStyle(color: Color(0XFF964F66)));
                                //     case 4: return Text("1Y", style: TextStyle(color: Color(0XFF964F66)));
                                //     default: return Text("");
                                //   }
                                // },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots:model.streakData??[],
                              isCurved: true,
                              color: Color(0XFF964F66),
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0XFF964F66).withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Keep it up! You're on a roll."),
                      ],
                    ),
                    SizedBox(height: 10),

                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
