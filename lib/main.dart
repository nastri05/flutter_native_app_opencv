import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:async';
import 'painter/face_detector_painter.dart';
import 'rectan_face.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NativeScreen(),
    );
  }
}

class NativeScreen extends StatefulWidget {
  NativeScreen({
    super.key,
  });

  @override
  State<NativeScreen> createState() => _NativeScreenState();
}

class _NativeScreenState extends State<NativeScreen> {
  MyBloc bloc = MyBloc();
  String Url = '10.97.6.136';
  Uint8List? bytes;
  bool loadanh = false;
  File? file;
  Image? img;
  Uint8List? imageData;
  IOWebSocketChannel? channel;
  var receivePort;
  final faceDetector = FaceDetector(
      options: FaceDetectorOptions(
    // enableClassification: f,
    performanceMode: FaceDetectorMode.accurate,
  ));

  @override
  void initState() {
    // receivePort = ReceivePort();
    // receivePort.listen((message) {
    //   print(message);
    // });
    Timer mytimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      //code to run on every 5 seconds
      if (imageData != null) {
        buildwidget(imageData);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    faceDetector.close();
    channel!.sink.close();
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    channel = IOWebSocketChannel.connect(Uri.parse('ws://${Url}:81'));
    //InputImageData? data_image;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              Container(
                  width: size.width,
                  height: size.height,
                  child: StreamBuilder(
                      stream: channel?.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          //imageData = (assetName)
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.deepOrange),
                            ),
                          );
                        } else {
                          imageData = snapshot.data;
                          //setState(() {});
                          return Image.memory(
                            imageData!,
                            width: 672,
                            height: 360,
                            gaplessPlayback: true,
                            fit: BoxFit.contain,
                          );
                        }
                      })),
              Center(
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: StreamBuilder(
                    stream: bloc.counterStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Rectan_face data = snapshot.data;
                        print(
                            ' ${data.Check_face}  + ${data.top} +  ${data.left}');
                        if (data.Check_face == true) {
                          return CustomPaint(
                            foregroundPainter: FaceDetectorPainter(
                                data,
                                Size(672, 360),
                                InputImageRotation.rotation0deg),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        print('not data');
                        return Container();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //buildwidget(imageData);
            channel!.sink.close();
            channel = IOWebSocketChannel.connect(Uri.parse('ws://${Url}:81'));
            setState(() {});
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  // }
  buildwidget(Uint8List? data) async {
    //print('123');
    final dir = (await getTemporaryDirectory()).path;
    final imageFile = File('$dir/a.png')..writeAsBytesSync(imageData!);
    final image = InputImage.fromFile(imageFile);
    processImage(image);
  }

  Future<void> processImage(InputImage inputImage) async {
    final faces = await faceDetector.processImage(inputImage);
    if (faces.length == 0) {
      //print('Hong co ai');
      Rectan_face data =
          Rectan_face(Check_face: false, top: 0, left: 0, bot: 0, right: 0);
      bloc.SendFace(data);
      return;
    } else {
      // if (inputImage.inputImageData?.size != null &&
      //     inputImage.inputImageData?.imageRotation != null) {
      //   //   final painter = FaceDetectorPainter(
      //   //       faces,
      //   //       inputImage.inputImageData!.size,
      //   //       inputImage.inputImageData!.imageRotation);
      //   //   // _customPaint = CustomPaint(painter: painter);
      String text = 'Faces found 1 : ${faces.length}\n\n';
      for (final face in faces) {
        text +=
            'face 1 :  ${face.boundingBox}  ${face.boundingBox.width} ${face.boundingBox.height} \n\n';
        Rectan_face data = Rectan_face(
          Check_face: true,
          top: face.boundingBox.top,
          left: face.boundingBox.left,
          bot: face.boundingBox.bottom,
          right: face.boundingBox.right,
        );
        bloc.SendFace(data);
        print(text);
        return;
      }
    }
    //_isBusy = false;
    // if (mounted) {
    //   setState(() {});
    // }
  }
}
