//
// Created by ASUS on 12/5/2022.
//
#include <stdint.h>
//#include <opencv2/core.hpp>
#include <opencv2/opencv.hpp>
extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t native_add(int32_t x, int32_t y) {
    //cv:: Mat src = cv::imread("E:/hoc tap/20213/project_native/assets/den+thobaymau.png");
    cv::Mat img = cv::Mat::zeros(x, y, CV_8UC3);
    //cv::VideoCapture cap("http://192.168.1.133:4747/video");
    //cv::Mat img;
    //cap.read(img);
    //cv::waiKey(33);
    //delete cap;
     return img.rows + img.cols;
}


