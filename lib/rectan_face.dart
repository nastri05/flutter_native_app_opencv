import 'dart:async';

class Rectan_face {
  bool Check_face;
  double top;
  double left;
  double bot;
  double right;
  Rectan_face(
      {required this.Check_face,
      required this.top,
      required this.left,
      required this.bot,
      required this.right});
}

class MyBloc {
  StreamController _streamController = new StreamController<Rectan_face>();
  Stream get counterStream => _streamController.stream;
  void SendFace(Rectan_face data) {
    _streamController.sink.add(data);
  }

  void dispose() {
    _streamController.close();
  }
}
