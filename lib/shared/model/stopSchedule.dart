class StopSchduleData {
  final String? name;
  final int? stopNo;
  final String? time;
  StopSchduleData({this.name, this.stopNo, this.time});
}

class StopSchduleDataList {
  List<StopSchduleData>? schedules = [];
  int count = 0;
  final int? id;
  StopSchduleDataList({this.id});
  addSchedule(StopSchduleData schd) {
    this.count += 1;
    schedules!.add(schd);
  }
}
