# slam 开源方案总结和对比

<div align="center">
  
| 开源方案 | 传感器类型 | 测试数据集 | 精度 |
| :---: | :---: |  :---: |   :---: | 
|[vins-Mono](https://github.com/HKUST-Aerial-Robotics/VINS-Mono)|mono+IMU| EuRoC|  |
|[Vins-Fusion]()|stereo/stereo+IMU/mono+IMU| EuRoC| | 
|[ORB_SLAM](https://github.com/raulmur/ORB_SLAM)|75.05| ？| |
|[ORB_SLAM2](https://github.com/raulmur/ORB_SLAM2)|74.70| ？|   |
|[ORB_SLAM3](https://github.com/UZ-SLAMLab/ORB_SLAM3)|74.70| ？|   |
  
  
</div>

## 区别
* ORB_SLAM：`只针对的是单目SLAM系统`
* ORB_SLAM2：`可以用于单目、双目、RGB_D相机。（并且作者公开的源码中包含ROS版本，可以实时跑自己的数据）`
* ORB_SLAM3：`在2的基础上，还可以用于鱼眼相机；增加了视觉+imu的系统（VIO）。`

## 详情
* ORB_SLAM：`ORB_SLAM：a Versatile and Accurate Monocular SLAM System
(ORB_SLAM：一种通用精确的单目SLAM系统)
摘要：本文提出了一种基于特征的单目ORB-SLAM系统，该系统可在大小、室内和室外环境中实时运行。该系统对严重的运动杂波具有鲁棒性，允许宽基线的回环和重定位，并包括全自动初始化。基于近年来的优秀算法，我们从零开始设计了一个新的系统，它与所有SLAM系统使用了相同的功能:跟踪、建图、重定位和回环。采用优胜者汰的策略，选取特征点和用于重定位的关键帧 只有场景发生大的变化，这样增加了系统的鲁棒性，并形成一个紧凑和可跟踪的地图，系统允许长时间的运行。我们从最流行的数据集中选取27个序列进行评估。与其他最先进的单目SLAM系统相比，ORB_SLAM展现了最优的性能。（源码公开）`
* ORB_SLAM2：`ORB_SLAM2：An Open-Source SLAM System for Monocular,Stereo,and RGB-D Cameras
(ORB_SLAM2：一个用于单目、双目和RGB-D相机的开源SLAM系统）
摘要：我们提出ORB-SLAM2，一个完整的同时定位和地图构建(SLAM)系统，用于单目、双目和RGB-D相机，包括地图复用、回环和重定位功能。该系统在标准的中央处理单元上实时工作，适用于各种环境，从小型手持室内序列，到工业环境中的无人机飞行和在城市中行驶的汽车。我们的后端基于单目和双目观测的BA优化，允许使用公制尺度进行精确的轨迹估计。我们的系统包括一个轻量级的定位模式，利用视觉里程计跟踪未建图的区域，并与地图点匹配，允许零漂移定位。使用29个公开序列的评价表明，我们的方法达到了最先进的精度，在大多数情况下是最准确的SLAM方案。（源码公开）`
* ORB_SLAM3：`ORB_SLAM3：An Accurate Open-Source Library for Visual,Visual-Inertial,and Multimap SLAM
(ORB_SLAM3：一个用于视觉，视觉惯导融合和多地图SLAM的精确开源库）
摘要：本文介绍了ORB-SLAM3，这是第一个能够使用针孔和鱼眼镜头模型，使用单目、双目和RGB-D相机执行视觉、视觉惯性和多地图 SLAM的系统。第一个主要的创新之处是一个紧密集成的视觉惯性SLAM系统，它完全依赖于最大后验估计(MAP)，即使在IMU初始化期间，也能在大小型、室内和室外环境中实现实时鲁棒操作，比以前的方法精确2到10倍。第二个主要的创新之处是多地图系统，它依赖于一种新的位置识别方法和改进的召回，ORB_SLAM3能够在一段弱视觉信息的场景下成功运行：当它丢失时，系统会启用一个新的地图，当访问到之前的区域时，它能与之前的地图进行连接合并。与只使用最后几秒信息的视觉里程计系统相比，ORB-SLAM3是第一个能够在所有算法阶段重用所有先前信息的系统，即使它们时间上相差很远，或者来自之前地图。提高了系统的准确性。
我们的实验表明，在所有传感器配置中，ORB-SLAM3与现有文献中最好的系统具有一样的鲁棒性，而且明显更精确。值得注意的是，我们的双目惯性SLAM在EuRoC无人机上达到了3.5 cm的平均精度，在TUM-VI数据集（AR/VR场景下），在快速手持动作下达到了9 mm的平均精度。（源码公开）`
## 视觉slam
## 回环检测相关项目
- [ov2slam](https://github.com/ov2slam/ov2slam)
- [ibow-lcd](https://github1s.com/emiliofidalgo/ibow-lcd)
- [MILD](https://github.com/lhanaf/MILD)

### 基于滤波
* [msckf_mono](https://github.com/daniilidis-group/msckf_mono)   查看[代码](https://github1s.com/daniilidis-group/msckf_mono)
* [openVins](https://docs.openvins.com/gs-installing.html)



### 基于图优化
* [vins-Mono](https://github.com/HKUST-Aerial-Robotics/VINS-Mono)
* [ORB_SLAM](https://github.com/raulmur/ORB_SLAM)
* [ORB_SLAM2](https://github.com/raulmur/ORB_SLAM2)
* [ORB_SLAM3](https://github.com/UZ-SLAMLab/ORB_SLAM3)
* 

## 其他优秀slam

* [gps+imu+eskf](https://github.com/liuqian62/eskf-gps-imu-fusion)


## 激光slam
* legoslam

```
简介

```
