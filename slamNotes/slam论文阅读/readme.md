# slam论文阅读

这个目录用于记录 SLAM 论文阅读入口。

当前先按“技术路线”整理一份最小可用的阅读索引，后续再逐篇补阅读笔记。

## 阅读时建议统一记录的维度

- 研究问题
- 传感器配置
- 核心方法
- 地图表示
- 优点 / 局限
- 适用场景
- 是否开源
- 和已有方法的区别

## 第一批建议优先读的论文

### 1. 经典视觉 SLAM

1. ORB-SLAM, 2015  
   作用：经典单目特征法视觉 SLAM  
   代码：<https://github.com/raulmur/ORB_SLAM>

2. ORB-SLAM2, 2017  
   作用：扩展到双目和 RGB-D，工程参考价值高  
   代码：<https://github.com/raulmur/ORB_SLAM2>

3. ORB-SLAM3, 2021  
   作用：补足视觉惯导、多地图、现代系统设计  
   代码：<https://github.com/UZ-SLAMLab/ORB_SLAM3>

### 2. VIO / VI-SLAM

1. VINS-Mono, 2018  
   关键词：滑窗优化、IMU 预积分、回环、位姿图  
   论文信息：<https://researchportal.hkust.edu.hk/en/publications/vins-mono-a-robust-and-versatile-monocular-visual-inertial-state-/>  
   代码：<https://github.com/HKUST-Aerial-Robotics/VINS-Mono>

2. OpenVINS, ICRA 2020  
   关键词：MSCKF、EKF、研究平台、评测工具  
   文档：<https://docs.openvins.com/>  
   代码：<https://github.com/rpng/open_vins>

### 3. 激光 SLAM / LIO

1. LOAM, 2014  
   作用：经典激光 SLAM 路线  
   论文入口：<https://www.researchgate.net/publication/282704722_LOAM_Lidar_Odometry_and_Mapping_in_Real-time>

2. LIO-SAM, 2020  
   关键词：因子图、平滑与建图  
   代码：<https://github.com/TixiaoShan/LIO-SAM>

3. FAST-LIO / FAST-LIO2, 2021  
   关键词：迭代 EKF、直接法、高频实时  
   代码：<https://github.com/hku-mars/FAST_LIO>

4. LVI-SAM  
   关键词：多传感器融合  
   代码：<https://github.com/TixiaoShan/LVI-SAM>

### 4. 学习式 / 稠密 / 隐式表示

1. DROID-SLAM, 2021  
   关键词：Deep Visual SLAM、Dense BA  
   代码：<https://github.com/princeton-vl/DROID-SLAM>

2. NICE-SLAM, CVPR 2022  
   关键词：Neural Implicit、室内稠密 SLAM  
   代码：<https://github.com/cvg/nice-slam>

3. Point-SLAM, 2023  
   关键词：神经点云表示  
   代码：<https://github.com/eriksandstroem/Point-SLAM>

4. Gaussian Splatting SLAM, 2023  
   关键词：3D Gaussian Splatting、在线 SLAM  
   论文：<https://arxiv.org/abs/2312.06741>

5. GS-SLAM, 2023  
   关键词：Dense Visual SLAM with 3D Gaussian Splatting  
   论文：<https://arxiv.org/abs/2311.11700>

## Survey 入口

1. Visual SLAM survey, 2022  
   `Macario Barros A, Michel M, Moline Y, et al. A comprehensive survey of visual slam algorithms[J]. Robotics, 2022, 11(1): 24.`

2. NeRF / 3DGS 与 SLAM 的综述, 2024  
   `Tosi F, Zhang Y, Gong Z, et al. How NeRFs and 3D Gaussian Splatting are Reshaping SLAM: a Survey.`
   论文：<https://arxiv.org/abs/2402.13255>

## 后续可继续扩展的方向

- 回环检测
- 动态 SLAM
- 低纹理与退化场景鲁棒定位
- 语义 SLAM
- 多机器人 / 多会话地图
- 大规模重建与可渲染地图
