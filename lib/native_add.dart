import 'dart:ffi'; // For FFI

import 'dart:io'; // For Platform.isX

final DynamicLibrary nativeAddLib = Platform.isAndroid
    ? DynamicLibrary.open("libnative_opencv.so")
    : DynamicLibrary.process();
typedef _c_ffi = Pointer<Float> Function(Pointer<Uint8>, Pointer<Uint32>);
typedef _dart_ffi = Pointer<Float> Function(Pointer<Uint8>, Pointer<Uint32>);
final int Function(int x, int y) nativeAdd = nativeAddLib
    .lookup<NativeFunction<Int32 Function(Int32, Int32)>>("native_add")
    .asFunction();
// final int imageffi = nativeAddLib.lookupFunction<
//     int Function(Pointer<Uint8>, Pointer<Uint32>),
//     int Function(Pointer<Uint8>, Pointer<Uint32>)>('image_ffi');
final sizeImage = nativeAddLib.lookupFunction<_c_ffi, _dart_ffi>('image_ffi');
