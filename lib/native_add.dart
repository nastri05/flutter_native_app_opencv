import 'dart:ffi' as ffi; // For FFI

import 'dart:io';
import 'dart:typed_data'; // For Platform.isX

final ffi.DynamicLibrary nativeAddLib = Platform.isAndroid
    ? ffi.DynamicLibrary.open("libnative_opencv.so")
    : ffi.DynamicLibrary.process();
final int Function(int x, int y) nativeAdd = nativeAddLib
    .lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int32, ffi.Int32)>>(
        "native_add")
    .asFunction();
final ffi.Pointer<ffi.Int> Function(
        ffi.Pointer<ffi.Uint8> bytes, ffi.Pointer<ffi.Uint32>) process_image =
    nativeAddLib
        .lookup<
            ffi.NativeFunction<
                ffi.Pointer<ffi.Int> Function(ffi.Pointer<ffi.Uint8>,
                    ffi.Pointer<ffi.Uint32>)>>('image_ffi')
        .asFunction();

// final ffi.Int32 Function(
//         ffi.Pointer<ffi.Char> bytes, ffi.Int32 witdh, ffi.Int32 height)
//     process_image = nativeAddLib.lookup<
//             ffi.NativeFunction<
//                 ffi.Int32 Function(
//                     ffi.Pointer<ffi.Char>, ffi.Int32, ffi.Int32)>>('image_ffi')
//         as ffi.Int32 Function(
//             ffi.Pointer<ffi.Char> bytes, ffi.Int32 witdh, ffi.Int32 height);
