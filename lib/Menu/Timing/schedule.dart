import 'package:flutter/material.dart';
import 'package:passenger_app/shared/Styling/colors.dart';
import 'package:passenger_app/shared/loading.dart';
import 'package:passenger_app/shared/model/stopSchedule.dart';
import 'package:passenger_app/shared/services/firebaseServices/database.dart';
import 'package:passenger_app/shared/services/mapServices/mapState.dart';
import 'package:provider/provider.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  Widget build(BuildContext context) {
    final appState = Provider.of<MapState>(context);
    // final schd = MapDatabaseService(routeName: appState.routeName).scheduleData;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   actions: [],
      //   backgroundColor: Colors.white,
      // ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: FutureBuilder<StopSchduleDataList>(
            future:
                MapDatabaseService(routeName: appState.routeName).scheduleData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.none ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Loading(),
                );
              }
              StopSchduleDataList data = snapshot.data!;
              return ListView(
                physics: ScrollPhysics(),
                children: [
                  Container(
                    child: SizedBox(
                      height: 35,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                              "",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Quicksand',
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text(
                              "Name",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Quicksand',
                                  color: Colors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Text(
                              "Time",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Quicksand',
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.count,
                      itemBuilder: (context, int index_1) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: salmonColor,
                                  borderRadius:
                                      BorderRadius.all((Radius.circular(10)))),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: data.scheduleUnits![index_1].count,
                                itemBuilder: (context, int index_2) {
                                  return Container(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            data.scheduleUnits![index_1]
                                                .schedules![index_2].stopNo
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Quicksand',
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Text(
                                            data.scheduleUnits![index_1]
                                                .schedules![index_2].name
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Quicksand',
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            data.scheduleUnits![index_1]
                                                .schedules![index_2].time
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Quicksand',
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }
}
