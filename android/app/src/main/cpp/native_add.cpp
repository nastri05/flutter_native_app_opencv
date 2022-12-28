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
extern "C" __attribute__((visibility("default"))) __attribute__((used))
float* image_ffi (uchar *buf, uint *size) {
    std::vector <uchar> v(buf, buf + size[0]);
    cv::Mat img = cv::imdecode(cv::Mat(v), cv::IMREAD_COLOR);


    cv::GaussianBlur(img, img, cv::Size(151, 151), 0, 0);
    //cv::putText(, , cv::Size(10, 10), 1, 1.5, 2, 8);
    //cv::putText(img,"Hello World!",cv::Point(50,100),cv::FONT_HERSHEY_DUPLEX,5,cv::Scalar(0,255,0),2,false);
    //std::cout<<'đc';
    std::vector <uchar> retv;
    cv::imencode(".jpg", img, retv);
    memcpy(buf, retv.data(), retv.size());
    size[0] = retv.size();
    std::vector<float> output;
    output.push_back(img.cols);
    output.push_back(img.rows);

    // Copy result bytes as output vec will get freed
    unsigned int total = sizeof(float) * output.size();
    float* jres = (float*)malloc(total);
    memcpy(jres, output.data(), total);
    return jres;
}


