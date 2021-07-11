class StopSchduleData {
  final String? name;
  final int? stopNo;
  final String? time;
  StopSchduleData({this.name, this.stopNo, this.time});
}

class StopSchduleDataUnit {
  List<StopSchduleData>? schedules = [];
  int count = 0;
  final int? id;
  StopSchduleDataUnit({this.id});
  addSchedule(StopSchduleData schd) {
    schedules!.add(schd);
    this.count += 1;
  }
}

class StopSchduleDataList {
  List<StopSchduleDataUnit>? scheduleUnits = [];
  int count = 0;
  final int? id;
  StopSchduleDataList({this.id});
  addSchedule(StopSchduleDataUnit schd) {
    scheduleUnits!.add(schd);
    this.count += 1;
    if (this.count >= 2) {
      scheduleUnits!.sort((a, b) => getFirstTime(a.schedules![0])
          .compareTo(getFirstTime(b.schedules![0])));
    }
  }

  getFirstTime(StopSchduleData schdData) {
    int tmp = int.parse(schdData.time!.replaceAll(":", ""));
    return tmp;
  }
}
