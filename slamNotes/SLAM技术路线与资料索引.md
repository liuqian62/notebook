# SLAM 技术路线与资料索引

这页的目标不是替代已有的基础笔记，而是把常见 SLAM 技术路线、代表性论文、开源项目和学习顺序串起来，作为后续继续扩展的导航页。

## 1. 先建立整体框架

可以先把 SLAM 按下面几个维度来理解：

### 1.1 按传感器划分

- 视觉 SLAM：单目、双目、RGB-D
- VIO / VI-SLAM：相机 + IMU
- 激光 SLAM：2D LiDAR / 3D LiDAR
- LIO / LVI：LiDAR + IMU，或 LiDAR + Vision + IMU
- 多传感器融合：再进一步接入 GPS、轮速计、磁力计、气压计等

### 1.2 按估计框架划分

- 滤波派：EKF、MSCKF、ESKF
- 优化派：滑窗优化、Bundle Adjustment、位姿图优化、因子图优化
- 混合派：前端实时估计 + 后端图优化 / 回环校正

### 1.3 按地图表达划分

- 稀疏地图：特征点、关键帧、路标点
- 半稠密 / 稠密地图：深度图、体素、TSDF、点云、网格
- 神经隐式 / 3DGS：NeRF、SDF、3D Gaussian Splatting

### 1.4 按目标能力划分

- 纯里程计：重点是短时位姿估计，允许漂移
- 完整 SLAM：有回环、全局一致性、重定位
- 语义 / 动态 SLAM：在定位建图之外还关心场景理解和动态物体

## 2. 目前主流技术路线怎么理解

### 2.1 经典视觉 SLAM

代表思路：

- 前端做特征提取、匹配、PnP / 三角化 / 局部 BA
- 后端做关键帧管理、位姿图优化、回环检测

适合：

- 入门理解完整 SLAM 系统分层
- 面试时解释前端、后端、回环和地图管理
- 做相机系统、小规模室内外建图原型

代表系统：

- ORB-SLAM
- ORB-SLAM2
- ORB-SLAM3

核心补充：

- ORB-SLAM3 进一步扩展到视觉惯导和多地图，官方仓库将其描述为支持 visual、visual-inertial 和 multi-map SLAM 的完整系统  
  来源：<https://github.com/UZ-SLAMLab/ORB_SLAM3>

### 2.2 VIO / VI-SLAM

这条线的核心是利用 IMU 弥补纯视觉在快速运动、短时遮挡、纹理较弱场景下的不稳定。

常见两类：

- 优化式 VIO：例如 VINS-Mono、VINS-Fusion
- 滤波式 VIO：例如 OpenVINS、MSCKF 系列

怎么选：

- 想理解工程上“完整系统怎么跑起来”，先看 VINS-Mono
- 想理解滤波派状态设计、误差状态、可观性、MSCKF，优先看 OpenVINS

资料点：

- VINS-Mono 仓库将自己定义为 optimization-based sliding window VIO，并包含初始化、在线外参标定、回环和位姿图优化  
  来源：<https://github.com/HKUST-Aerial-Robotics/VINS-Mono>
- OpenVINS 官方文档明确说明其核心是基于 EKF 和 MSCKF sliding window formulation 的视觉惯导估计平台  
  来源：<https://docs.openvins.com/>

### 2.3 激光 SLAM / LIO

激光路线的优势通常是几何约束更稳定、尺度天然可观，特别适合自动驾驶、机器人巡检、矿区和弱纹理环境。

典型演进可以粗略记成：

- LOAM：经典激光里程计与建图分离思路
- LIO-SAM：平滑与建图，因子图建模更清晰
- FAST-LIO / FAST-LIO2：更强调高频、直接法、实时性和工程鲁棒性

重点区别：

- LIO-SAM 偏“因子图 + 平滑优化”框架
- FAST-LIO 偏“紧耦合迭代 EKF”框架

资料点：

- LIO-SAM 仓库给出的论文标题是 “Tightly-coupled Lidar Inertial Odometry via Smoothing and Mapping”，并在 README 中说明同时维护地图优化与 IMU 预积分相关的两个因子图  
  来源：<https://github.com/TixiaoShan/LIO-SAM>
- FAST-LIO 仓库将自己描述为 tightly-coupled iterated extended Kalman filter 的 LiDAR-inertial odometry，并说明 FAST-LIO2 支持 raw point direct odometry、ikd-Tree 和多类 LiDAR  
  来源：<https://github.com/hku-mars/FAST_LIO>

### 2.4 学习式 / 神经隐式 / 3DGS-SLAM

这一方向的关注点不只是定位精度，还包括：

- 更高质量的稠密重建
- 可渲染的新视角合成
- 统一几何、外观和语义表示

常见代表：

- DROID-SLAM：学习式稠密跟踪与优化
- NICE-SLAM：Neural Implicit Scalable Encoding for SLAM
- Point-SLAM：神经点云表示
- Gaussian Splatting SLAM / GS-SLAM：把 3DGS 引入在线 SLAM

如何看待这一支：

- 如果目标是机器人实时定位，经典几何法和 VIO/LIO 仍然是主力
- 如果目标是高质量重建、数字孪生、可渲染地图，NeRF / 3DGS 路线很值得持续关注
- 这类方法通常对算力更敏感，且很多系统仍主要集中在室内 RGB-D 或受控场景

资料点：

- DROID-SLAM 论文标题为 “Deep Visual SLAM for Monocular, Stereo, and RGB-D Cameras”  
  来源：<https://github.com/princeton-vl/DROID-SLAM>
- NICE-SLAM 仓库说明其是 “Neural Implicit Scalable Encoding for SLAM”，强调 large-scale indoor scenes 的稠密几何和相机跟踪  
  来源：<https://github.com/cvg/nice-slam>
- 2024 年的 survey《How NeRFs and 3D Gaussian Splatting are Reshaping SLAM》很适合用来建立这一方向的总览  
  来源：<https://arxiv.org/abs/2402.13255>
- 3DGS 进入 SLAM 的早期代表之一是《Gaussian Splatting SLAM》  
  来源：<https://arxiv.org/abs/2312.06741>

## 3. 代表论文与项目索引

下面不是完整论文表，而是一份“先读这些就能形成主线”的清单。

### 3.1 经典视觉 SLAM

1. ORB-SLAM, 2015  
   作用：理解单目特征法经典框架  
   链接：<https://github.com/raulmur/ORB_SLAM>

2. ORB-SLAM2, 2017  
   作用：扩展到单目 / 双目 / RGB-D，工程可用性更强  
   链接：<https://github.com/raulmur/ORB_SLAM2>

3. ORB-SLAM3, 2021  
   作用：补齐视觉惯导、多地图和更完整的现代系统设计  
   链接：<https://github.com/UZ-SLAMLab/ORB_SLAM3>

### 3.2 VIO / VI-SLAM

1. VINS-Mono, 2018  
   关键词：滑窗优化、IMU 预积分、初始化、回环、4-DoF pose graph  
   链接：<https://github.com/HKUST-Aerial-Robotics/VINS-Mono>

2. OpenVINS, ICRA 2020  
   关键词：MSCKF、EKF、模块化状态设计、评估体系完整  
   文档：<https://docs.openvins.com/>  
   代码：<https://github.com/rpng/open_vins>

3. VINS-Fusion  
   关键词：多相机 / 多传感器扩展  
   链接：<https://github.com/HKUST-Aerial-Robotics/VINS-Fusion>

### 3.3 激光 SLAM / LIO

1. LOAM, 2014  
   作用：理解激光前端里程计与建图分离思路  
   链接：<https://www.researchgate.net/publication/282704722_LOAM_Lidar_Odometry_and_Mapping_in_Real-time>

2. LIO-SAM, 2020  
   关键词：因子图、平滑与建图、IMU 预积分、GPS 因子扩展  
   链接：<https://github.com/TixiaoShan/LIO-SAM>

3. FAST-LIO / FAST-LIO2, 2021  
   关键词：紧耦合迭代 EKF、直接点云配准、ikd-Tree、高频实时  
   链接：<https://github.com/hku-mars/FAST_LIO>

4. LVI-SAM  
   关键词：LiDAR + Vision + IMU 融合  
   链接：<https://github.com/TixiaoShan/LVI-SAM>

### 3.4 学习式 / 稠密 / 隐式表示

1. DROID-SLAM, 2021  
   关键词：学习式稠密 BA、单目 / 双目 / RGB-D  
   链接：<https://github.com/princeton-vl/DROID-SLAM>

2. NICE-SLAM, CVPR 2022  
   关键词：Neural Implicit、室内稠密 SLAM  
   链接：<https://github.com/cvg/nice-slam>

3. Point-SLAM, 2023  
   关键词：神经点云表示、稠密建图  
   链接：<https://github.com/eriksandstroem/Point-SLAM>

4. Gaussian Splatting SLAM, 2023  
   关键词：3DGS 在线跟踪与建图  
   链接：<https://arxiv.org/abs/2312.06741>

5. GS-SLAM, 2023  
   关键词：Dense Visual SLAM with 3D Gaussian Splatting  
   链接：<https://arxiv.org/abs/2311.11700>

## 4. 建议学习顺序

如果目标是系统入门：

1. 先读 [slam学习笔记](./slam学习笔记.md) 和 [14讲](./14讲.md)
2. 再补 ORB-SLAM2 / ORB-SLAM3，建立完整系统观
3. 然后选一条分支深入：VINS-Mono 或 OpenVINS
4. 再补激光方向：LIO-SAM 或 FAST-LIO2
5. 最后看 DROID-SLAM、NICE-SLAM、3DGS-SLAM 作为现代扩展

如果目标是求职 / 面试：

优先把下面几个问题说清楚：

- 前端、后端、回环、建图分别做什么
- 滤波和优化的差异
- 单目、双目、RGB-D、VIO、LIO 的适用场景
- ORB-SLAM3、VINS-Mono、OpenVINS、LIO-SAM、FAST-LIO 的框架差异
- 为什么会漂移，回环和全局优化怎么抑制漂移

如果目标是做项目落地：

- 资源受限、追求稳定实时：先看 VIO / LIO
- 场景弱纹理、光照变化大：优先考虑 LIO 或多传感器融合
- 追求高质量重建与渲染：关注 NICE-SLAM、Point-SLAM、GS-SLAM、Gaussian Splatting SLAM

## 5. 后续还值得补的专题

- 回环检测路线：DBoW2、Bag of Words、Scan Context、学习式 place recognition
- 地图表达：稀疏点、稠密点云、TSDF、ESDF、神经隐式、3DGS
- 初始化问题：单目初始化、VIO 初始化、LIO 初始化
- 标定问题：相机内参、相机-IMU 外参、时间同步
- 评测问题：ATE、RPE、绝对轨迹误差、鲁棒性与退化场景
- 数据集与工具链：EuRoC、TUM-VI、KITTI、KITTI-360、NTU VIRAL、Replica、ScanNet

## 6. 可以和本仓库现有内容联动阅读

- 基础： [slam学习笔记](./slam学习笔记.md)
- 课程摘记： [14讲](./14讲.md)
- 开源方案索引： [slam开源方案/readme.md](./slam开源方案/readme.md)
- 激光方向： [激光SLAM/readme.md](./激光SLAM/readme.md)
- 论文阅读入口： [slam论文阅读/readme.md](./slam论文阅读/readme.md)

## 7. 本页使用的外部资料

- ORB-SLAM3 GitHub: <https://github.com/UZ-SLAMLab/ORB_SLAM3>
- VINS-Mono GitHub: <https://github.com/HKUST-Aerial-Robotics/VINS-Mono>
- OpenVINS Docs: <https://docs.openvins.com/>
- OpenVINS GitHub: <https://github.com/rpng/open_vins>
- LIO-SAM GitHub: <https://github.com/TixiaoShan/LIO-SAM>
- FAST-LIO GitHub: <https://github.com/hku-mars/FAST_LIO>
- DROID-SLAM GitHub: <https://github.com/princeton-vl/DROID-SLAM>
- NICE-SLAM GitHub: <https://github.com/cvg/nice-slam>
- Point-SLAM GitHub: <https://github.com/eriksandstroem/Point-SLAM>
- NeRF / 3DGS-SLAM Survey: <https://arxiv.org/abs/2402.13255>
- Gaussian Splatting SLAM: <https://arxiv.org/abs/2312.06741>
- GS-SLAM: <https://arxiv.org/abs/2311.11700>
