import 'dart:isolate';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class RequiredArgs {
  late final SendPort sendPort;
  late InAppWebViewController controller;

  RequiredArgs(this.controller, this.sendPort);
}
