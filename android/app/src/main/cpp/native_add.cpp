//
// Created by ASUS on 12/5/2022.
//
#include <opencv2/core.hpp>
#include <opencv2/opencv.hpp>
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#include <opencv2/objdetect.hpp>
#include<iostream>
#include <vector>
extern "C" __attribute__((visibility("default"))) __attribute__((used))
int32_t native_add(int32_t x, int32_t y,char * path) {
    cv::Mat img = cv::Mat::zeros(x, y, CV_8UC3);

    //cv::VideoCapture cap("http://192.168.1.133:4747/video");
    //cv::Mat img;
    //cap.read(img);
    //cv::waiKey(33);
    //delete cap;
     return img.rows + img.cols;
}
extern "C" __attribute__((visibility("default"))) __attribute__((used))
int *image_ffi (uchar *bytes, uint * size) {
    std::vector <uchar> v (bytes, bytes + size[0]);
    std::vector<cv::Rect> face;
    cv::Mat img = cv::imdecode(cv::Mat(v), cv::IMREAD_COLOR);
    cv::CascadeClassifier facedetect("haarcascade_eye.xml");
    facedetect.detectMultiScale(img,face,1.1,4,cv:: CASCADE_SCALE_IMAGE,cv::Size(30,30));
   std::vector<int> output;
    output.push_back(img.cols);
    output.push_back(img.rows);

    // Copy result bytes as output vec will get freed
    unsigned int total = sizeof(int) * output.size();
    int *result = (int*)malloc(total);
    memcpy(result, output.data(), total);
    return result;
}


