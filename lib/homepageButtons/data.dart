import '../homepageButtons/buttonClass.dart';

class Buttons extends ButtonClass {
  static final List<ButtonClass> items = [
    ButtonClass(
      text: 'Maps',
      route: 'Maps',
      image: 'assets/images/map.png',
    ),
    ButtonClass(
      text: 'Timing',
      route: 'Timing',
      image: 'assets/images/route.png',
    ),
    ButtonClass(
      text: 'Tracking',
      route: 'Tracking',
      image: 'assets/images/position.png',
    ),
    ButtonClass(
      text: 'Booking',
      route: 'Booking',
      image: 'assets/images/seatbus.png',
    ),
  ];
  static ButtonClass fetchAny() {
    return Buttons.items[0];
  }

  static List<ButtonClass> fetchAll() {
    return Buttons.items;
  }
}
