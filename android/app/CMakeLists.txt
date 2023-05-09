cmake_minimum_required(VERSION 3.10.2)

# opencv
set(OpenCV_STATIC ON)
# tai opencv android -> system propertires -> advanced
#-> Environment variable-> them đường link vào den opencv:OPENCV_ANDROID
set(OpenCV_DIR $ENV{OPENCV_ANDROID}/sdk/native/jni)
find_package (OpenCV REQUIRED)

add_library( # Sets the name of the library.
        native_opencv
        SHARED
        # Provides a relative path to your source file(s).
        src/main/cpp/native_add.cpp
        )


find_library(log-lib log)

#set(DLIB_DIR "E:/hoc tap/20213/dlib-19.24")
#include_directories(${DLIB_DIR}/include)
#add_library( lib_dlib SHARED IMPORTED )
#target_link_libraries( native_opencv lib_dlib)
#set_target_properties(lib_dlib PROPERTIES IMPORTED_LOCATION ${DLIB_DIR}/${ANDROID_ABI}/libdlib.so)

target_link_libraries( # Specifies the target library.
        native_opencv
        ${OpenCV_LIBS}
        ${log-lib}
        )
