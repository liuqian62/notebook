# VIO 与 LIO 对比

这页想解决一个很实际的问题：

做定位建图时，什么时候该优先看 VIO，什么时候该优先看 LIO？

最短答案是：

- 视觉信息丰富、硬件轻、成本敏感时，优先考虑 `VIO`
- 场景弱纹理、光照变化大、追求几何稳定时，优先考虑 `LIO`
- 如果预算和传感器允许，`LVI / LIVO` 往往比只用单一路径更稳

## 1. 先把概念区分清楚

### 1.1 VIO 是什么

VIO 是 Visual-Inertial Odometry，也就是：

- 相机提供外观和几何约束
- IMU 提供高频角速度和加速度约束

它的目标通常是：

- 在短时内稳定估计位姿
- 弥补纯视觉在快速运动时的脆弱性

代表系统：

- VINS-Mono
- VINS-Fusion
- OpenVINS
- ORB-SLAM3 visual-inertial

`VINS-Mono` 官方页面将其描述为 optimization-based sliding window visual-inertial odometry，并包含 IMU preintegration、自动初始化、在线外参标定、回环和全局位姿图优化  
来源：<https://ri.hkust.edu.hk/vins-mono>

`OpenVINS` 官方文档说明其核心是基于 EKF 和 MSCKF sliding window formulation 的 filter-based visual-inertial estimator  
来源：<https://docs.openvins.com/>

### 1.2 LIO 是什么

LIO 是 LiDAR-Inertial Odometry，也就是：

- LiDAR 提供稳定的几何结构观测
- IMU 提供高频运动先验和去畸变支持

它的目标通常是：

- 在大运动、高动态、弱纹理环境下保持稳定
- 提供更可靠的尺度和几何一致性

代表系统：

- LIO-SAM
- FAST-LIO / FAST-LIO2
- Point-LIO

`LIO-SAM` 论文标题就是 “Tightly-coupled Lidar Inertial Odometry via Smoothing and Mapping”，并在论文中把 IMU 预积分、lidar odometry、GPS、loop closure 都建成因子加入图优化  
来源：<https://www.researchgate.net/publication/342623264_LIO-SAM_Tightly-coupled_Lidar_Inertial_Odometry_via_Smoothing_and_Mapping>

`FAST-LIO` 官方仓库将其描述为 tightly-coupled iterated extended Kalman filter 的 LIO 系统，强调 fast-motion、noisy/cluttered environments 下的实时鲁棒性  
来源：<https://github.com/hku-mars/FAST_LIO>

## 2. VIO 和 LIO 的核心差别到底在哪

### 2.1 观测来源不同

VIO 更依赖：

- 图像纹理
- 特征点 / 光度信息
- 视角变化带来的几何约束

LIO 更依赖：

- 点云几何结构
- 面、边、局部表面分布
- 扫描与地图之间的空间配准

一句话理解：

- `VIO` 更看“看到了什么”
- `LIO` 更看“空间结构长什么样”

### 2.2 退化模式不同

VIO 更怕：

- 低纹理
- 纯旋转
- 光照突变
- 动态遮挡
- 运动模糊

LIO 更怕：

- 几何重复
- 长直走廊
- 空旷大平面
- 点云稀疏
- 某些 LiDAR 运动畸变和视场不足

### 2.3 尺度可观性不同

对单目 VIO 来说：

- 如果没有 IMU，尺度天然不确定
- 加 IMU 后尺度通常可以恢复
- 但初始化质量和激励条件很关键

对 LIO 来说：

- LiDAR 的几何尺度直接来自物理测距
- 尺度天然更稳定

所以很多项目里会觉得：

- VIO 更轻更灵活
- LIO 更“稳”和更有安全感

## 3. 它们各自典型的系统结构

### 3.1 VIO 常见结构

一个典型 VIO 系统通常包括：

- 图像预处理
- 特征跟踪或直接法前端
- IMU 预积分
- 初始化
- 滑窗优化或滤波更新
- 可选的回环和位姿图优化

### 3.2 LIO 常见结构

一个典型 LIO 系统通常包括：

- IMU 驱动的运动补偿 / 去畸变
- 点云特征提取或直接点云对齐
- scan-to-scan 或 scan-to-map 配准
- IMU 融合
- 后端地图优化
- 可选回环和全局图优化

### 3.3 为什么 LIO 更强调去畸变

因为 LiDAR 一帧扫描通常不是“瞬时拍下来的”，而是：

- 在一个扫描周期里逐点采集

如果载体在这一周期内在运动，就会出现 motion distortion。

IMU 在 LIO 里一个非常关键的作用就是：

- 帮助完成点云 deskew

这一点通常比 VIO 里“只是作为运动先验”更直观、更刚需。

## 4. 从估计框架上看：优化派和滤波派

这部分不是 VIO / LIO 独有，但在面试和项目选型里很常被放在一起问。

### 4.1 VIO 里的两条经典路线

#### 优化式 VIO

代表：

- VINS-Mono
- VINS-Fusion
- ORB-SLAM3 visual-inertial

特点：

- 滑窗优化
- 容易融合更多约束
- 精度通常较强
- 工程结构更“SLAM 化”

#### 滤波式 VIO

代表：

- MSCKF
- OpenVINS

特点：

- 递推式更新
- 延迟低
- 资源控制更直接
- 对系统状态设计和可观性分析更清晰

`OpenVINS` 文档明确写到它使用 Extended Kalman filter，并用 MSCKF sliding window 形式融合视觉特征轨迹  
来源：<https://docs.openvins.com/>

### 4.2 LIO 里的两条典型风格

#### 因子图 / 平滑优化

代表：

- LIO-SAM
- LVI-SAM

特点：

- 建模直观
- 后端扩展性强
- 适合接 GPS、回环、多传感器

#### 迭代 EKF / 紧耦合滤波

代表：

- FAST-LIO
- FAST-LIO2

特点：

- 高频
- 实时性强
- 前端和融合耦合得更紧

所以可以粗略记成：

- `LIO-SAM` 更偏“后端图优化思维”
- `FAST-LIO` 更偏“高频里程计思维”

## 5. 代表系统之间怎么快速区分

### 5.1 VINS-Mono

适合：

- 学 VIO 全流程
- 看优化式滑窗
- 理解初始化、IMU 预积分、回环和 pose graph

优点：

- 经典
- 资料多
- 结构完整

### 5.2 OpenVINS

适合：

- 学 MSCKF
- 学滤波式 VIO
- 看评测工具链和工程化研究平台

优点：

- 文档完整
- 评测体系成熟
- 状态建模和误差分析很清楚

`OpenVINS` 官方文档还提供了系统评测页面，明确把 ATE、RPE、RMSE、NEES、timing、hardware usage 列为关键指标  
来源：<https://docs.openvins.com/evaluation.html>

### 5.3 LIO-SAM

适合：

- 学图优化风格的 LIO
- 看 IMU 预积分如何接入因子图
- 看回环、GPS 因子、多源约束怎么扩展

优点：

- 系统结构清晰
- 很适合从“SLAM 系统设计”角度理解 LIO

### 5.4 FAST-LIO / FAST-LIO2

适合：

- 学高频实时 LIO
- 看紧耦合 iEKF
- 看直接点云配准和 ikd-Tree

优点：

- 实时性强
- 工程鲁棒性高
- 对不同 LiDAR 适配能力好

官方仓库说明 FAST-LIO2 支持 raw point direct odometry、ikd-Tree，以及 spinning 和 solid-state 等多类 LiDAR  
来源：<https://github.com/hku-mars/FAST_LIO>

### 5.5 LVI-SAM

适合：

- 学多传感器互补
- 看视觉、激光、IMU 如何相互增强

论文摘要里明确写到：

- VIS 利用 LIS 估计辅助初始化
- 视觉特征可借助 LiDAR 提供深度
- LIS 又利用 VIS 估计提供 scan matching 初值
- 回环先由 VIS 发现，再由 LIS 精化

来源：<https://researchwith.stevens.edu/en/publications/lvi-sam-tightly-coupled-lidar-visual-inertial-odometry-via-smooth/>

## 6. 项目落地时怎么选

### 6.1 优先选 VIO 的场景

- 无人机、小型机器人，载荷和功耗受限
- 相机成本低、安装方便
- 室内外纹理较丰富
- 需要轻量化视觉感知链路

### 6.2 优先选 LIO 的场景

- 自动驾驶、巡检车、矿区、仓储机器人
- 场景弱纹理、强光照变化、夜间、烟尘等环境
- 对尺度稳定性和几何可靠性要求高
- 平台算力和传感器预算允许

### 6.3 优先选 LVI / LIVO 的场景

- 既有低纹理又有几何退化
- 既会遇到视觉恶化也会遇到 LiDAR 退化
- 需要系统在复杂环境下尽量不掉线

## 7. 一个很实用的对比表

| 维度 | VIO | LIO |
| --- | --- | --- |
| 主要传感器 | Camera + IMU | LiDAR + IMU |
| 主要信息来源 | 纹理 / 视觉几何 | 空间几何结构 |
| 尺度稳定性 | 有赖于 IMU 初始化与融合 | 天然更稳定 |
| 常见退化 | 低纹理、曝光变化、模糊 | 几何重复、空旷场景、稀疏点云 |
| 算法典型 | 滑窗优化、MSCKF | 因子图、iEKF、scan-to-map |
| 代表系统 | VINS-Mono、OpenVINS | LIO-SAM、FAST-LIO2 |
| 典型优势 | 轻量、成本低、信息丰富 | 稳定、尺度可靠、抗光照变化 |
| 典型代价 | 对视觉条件敏感 | 传感器更贵，点云处理更重 |

## 8. 常见误区

### 8.1 误区一：LIO 一定比 VIO 好

不一定。

如果平台是：

- 小无人机
- 室内轻量机器人
- 成本敏感设备

那 VIO 可能反而更合理。

### 8.2 误区二：VIO 只是“视觉加了个 IMU”

也不对。

真正可用的 VIO 难点很多：

- 初始化
- IMU 偏置估计
- 外参和时间同步
- 可观性处理
- 滑窗边缘化或滤波一致性

### 8.3 误区三：LIO 只是在点云前端后面加个 IMU

也过于简单。

在很多 LIO 系统里，IMU 不只是辅助，而是直接影响：

- 去畸变
- 初值预测
- 状态传播
- 融合稳定性

## 9. 面试里怎么答“VIO 和 LIO 的区别”

一个比较顺的答法可以是：

1. 先说两者共同点  
   都是把高频 IMU 和低频空间观测结合起来做位姿估计

2. 再说主要差异  
   VIO 依赖图像纹理和视觉几何，LIO 依赖点云空间结构

3. 再说各自优势  
   VIO 轻量、成本低；LIO 尺度稳定、抗光照变化、弱纹理下更稳

4. 最后说退化场景  
   VIO 怕低纹理和模糊，LIO 怕几何退化和重复结构

如果再补一句项目视角，会更完整：

- 真正落地时通常不是二选一，而是看平台预算、环境类型、实时性和鲁棒性要求

## 10. 建议阅读顺序

1. 先看 [SLAM技术路线与资料索引](./SLAM技术路线与资料索引.md)
2. 再看 [SLAM数据集与评测指标](./SLAM数据集与评测指标.md)
3. 然后读本页，建立 VIO / LIO 的选型视角
4. 接着具体读 `VINS-Mono`、`OpenVINS`、`LIO-SAM`、`FAST-LIO`
5. 最后再看 [SLAM回环检测](./SLAM回环检测.md) 和 `LVI-SAM`

## 11. 可与本仓库现有内容联动

- 开源方案入口： [slam开源方案/readme.md](./slam开源方案/readme.md)
- 激光方向入口： [激光SLAM/readme.md](./激光SLAM/readme.md)
- LIO-SAM 入口： [激光SLAM/LIO-SAM学习笔记.md](./激光SLAM/LIO-SAM学习笔记.md)
- LVI-SAM 入口： [激光SLAM/LVI-SAM学习笔记.md](./激光SLAM/LVI-SAM学习笔记.md)
- 面试问题： [SLAM面试问题整理.md](./SLAM面试问题整理.md)

## 12. 本页使用的外部资料

- VINS-Mono: <https://ri.hkust.edu.hk/vins-mono>
- OpenVINS: <https://docs.openvins.com/>
- OpenVINS Evaluation: <https://docs.openvins.com/evaluation.html>
- LIO-SAM paper entry: <https://www.researchgate.net/publication/342623264_LIO-SAM_Tightly-coupled_Lidar_Inertial_Odometry_via_Smoothing_and_Mapping>
- FAST-LIO GitHub: <https://github.com/hku-mars/FAST_LIO>
- LVI-SAM paper entry: <https://researchwith.stevens.edu/en/publications/lvi-sam-tightly-coupled-lidar-visual-inertial-odometry-via-smooth/>
