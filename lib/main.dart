import 'dart:ffi';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_native/circle.dart';
import 'package:project_native/native_add.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final channel =
        IOWebSocketChannel.connect(Uri.parse('ws://192.168.1.188:81'));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(channel: channel),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.channel});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final WebSocketChannel channel;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int _counter = 0;
  Uint8List? bytes;
  bool check = true;
  Image? img;
  Uint8List? imageData;

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // double height_1 = MediaQuery.of(context).size.height;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('1+2 = ${nativeAdd(1, 2)}'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: Stack(
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height,
              child: StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (imageData == null && !snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  } else {
                    imageData = snapshot.data;
                    return Image.memory(
                      imageData!,
                      gaplessPlayback: true,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
            // check
            //     ? Container(
            //         child: Positioned(
            //           top: 50,
            //           left: 50,
            //           child: Container(
            //             width: 50,
            //             height: 50,
            //             child: CustomPaint(
            //               foregroundPainter: Circle(),
            //               //CirclePain(),
            //             ),
            //           ),
            //         ),
            //       )
            //     : Container(),

            // check
            //     ? Container(
            //         width: 300,
            //         height: 300,
            //         child: const Image(
            //           image: AssetImage("assets/den+thobaymau.png"),
            //           fit: BoxFit.fill,
            //         ))
            //     : Container(
            //         width: 300, height: 300, child: Image.memory(imageData!)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: CreateNewIsolate,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void CreateNewIsolate() {
    var receivePort = ReceivePort();

    // if (value != null) {
    //   print('ko loi');
    //   imageData = value;
    //   check = false;
    //   setState(() {});
    //   //Isolate.spawn(taskRunner, [receivePort.sendPort, value]);
    // }
    // RequiredArgs requiredArgs =
    //     RequiredArgs(webViewController!, receivePort.sendPort);

    // Future.delayed(Duration(seconds: 3), () {
    //   newIsolate?.kill(priority: Isolate.immediate);
    //   newIsolate = null;
    //   print("kill");
    // });
    receivePort.listen((message) {
      print(message);
      // newIsolate?.kill(priority: Isolate.immediate);
      //newIsolate = null;
      // check = true;
      // setState(() {});
    });
  }

  static void taskRunner(List<dynamic> args) {
    var sendPort = args[0] as SendPort;
    // Future.delayed(Duration(seconds: 2), () {
    //   sendPort.send(args[1]);
    // });
    // var sendPort = args[0] as SendPort;
    var image = args[1] as Uint8List;
    // late final controller = args[1] as InAppWebViewController;
    // controller!.takeScreenshot().then((image) {
    Pointer<Uint32> s = malloc.allocate(1);
    s[0] = image.length;
    final pointer = malloc<Uint8>(image.length);
    for (int i = 0; i < image.length; i++) {
      pointer[i] = image[i];
    }
    Float32List size = sizeImage(pointer, s).asTypedList(2);
    print(size.toList());
    // imageffi(pointer, s);
    //Image img1 = Image.memory(pointer.asTypedList(s[0]));
    malloc.free(pointer);
    malloc.free(s);
    //print(size.toList());
    //   Isolate.exit(sendPort, size.toList());
    sendPort.send(size.toList());
    // });
  }
}
