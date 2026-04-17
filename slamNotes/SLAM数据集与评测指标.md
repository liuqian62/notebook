# SLAM 数据集与评测指标

这页用来回答三个实际问题：

1. 做 SLAM 时常用哪些公开数据集
2. ATE、RPE、KITTI 指标分别在看什么
3. 论文和项目里应该怎么更稳地做评测

如果只记一句话：

- `ATE` 更偏全局一致性
- `RPE` 更偏局部漂移
- `KITTI odometry` 更强调长轨迹、分段误差和车载场景

## 1. 先按任务选数据集

### 1.1 视觉 / RGB-D 入门

#### TUM RGB-D

适合：

- RGB-D SLAM 入门
- 室内建图与轨迹评测
- 跑 ORB-SLAM2 / RGB-D、ElasticFusion 一类方法

特点：

- Kinect 采集的室内 RGB-D 数据
- 有高精度 motion capture ground truth
- 官方还提供 benchmark 和评测工具思路

官方页面说明该数据集包含 Kinect 的彩色图像、深度图和高精度真值轨迹，RGB-D 数据以 30 Hz 采集，真值由 100 Hz 动捕系统获得  
来源：<https://cvg.cit.tum.de/data/datasets/rgbd-dataset>

#### ScanNet

适合：

- 室内 RGB-D 稠密重建
- 语义 SLAM / 3D scene understanding
- 隐式表示和可渲染地图方法

特点：

- 大规模室内 RGB-D 视频数据
- 带 3D 相机位姿、表面重建和实例级语义标注

官方页面说明 ScanNet 含 250 万视角、1500 多个 scans，并提供 3D camera poses、surface reconstructions 和 instance-level semantic segmentations  
来源：<https://www.scan-net.org/ScanNet/>

#### Replica

适合：

- 高质量室内重建
- NeRF / implicit SLAM / 3DGS-SLAM
- 可渲染地图和新视角合成

特点：

- 高保真室内重建数据
- 几何、纹理、玻璃 / 镜面信息和语义标注较完整
- 很常被神经隐式 SLAM 用作评测环境

官方仓库将其描述为 high quality reconstructions of indoor spaces，并强调 clean dense geometry、HDR textures、glass and mirror surface information 以及 semantic annotations  
来源：<https://github.com/facebookresearch/Replica-Dataset>

### 1.2 VIO / VI-SLAM

#### EuRoC MAV

适合：

- 双目 + IMU 的 VIO 基准测试
- 跑 VINS-Mono、OpenVINS、ORB-SLAM3 visual-inertial
- 对比初始化、滑窗、回环前后的效果

特点：

- 双目图像 + 同步 IMU
- 高质量 ground truth
- 社区使用非常广，基本是 VIO 入门首选

ETH ASL 官方页面说明 EuRoC 含 stereo images、synchronized IMU measurements 和 accurate motion / structure ground-truth  
来源：<https://projects.asl.ethz.ch/datasets/euroc-mav/>

#### TUM VI

适合：

- 更高动态范围的视觉惯导评测
- 考察曝光变化、手持运动和室内外混合场景
- 测 photometric calibration 是否被利用

特点：

- 1024×1024 图像，20 Hz
- IMU 200 Hz
- 提供 photometric calibration
- 只在序列开头和结尾提供高精度 ground truth 区段，这点和 EuRoC 不同

TUM 官方论文页面说明该 benchmark 提供 1024×1024、20 Hz 的图像，200 Hz IMU，以及开始和结束区段的高频 ground truth  
来源：<https://portal.fis.tum.de/en/publications/the-tum-vi-benchmark-for-evaluating-visual-inertial-odometry/>

### 1.3 车载视觉 / 激光 / 多传感器

#### KITTI Odometry

适合：

- 车载 VO / V-SLAM / Lidar odometry / 多传感器 odometry
- 对比长轨迹漂移
- 和经典工作做横向比较

特点：

- 22 段 odometry 序列
- 00-10 有 ground truth，11-21 用于官方评测
- 支持单目 / 双目 / LiDAR / 融合方法

官方 benchmark 页面说明 odometry benchmark 包含 22 个 stereo sequences，其中 11 个训练序列有 ground truth，11 个测试序列用于 evaluation  
来源：<https://www.cvlibs.net/datasets/kitti/eval_odometry.php>

#### KITTI-360

适合：

- 大规模城市场景
- 语义 SLAM、可渲染地图、长程重建
- 多模态场景理解

特点：

- 更长里程和更丰富传感器
- 带 2D / 3D 语义与实例标注
- 很适合研究“建图表示”而不只是 odometry

KITTI-360 官方页面说明其覆盖 73.7 km、超过 320k 图像和 100k 激光扫描，并提供 2D / 3D 标注与精确地理定位  
来源：<https://www.cvlibs.net/datasets/kitti-360/>

#### NTU VIRAL

适合：

- LVI / 多传感器融合
- 无人机视角下的 VIO / LIO / UWB 融合
- 对多模态算法做更复杂验证

特点：

- 两个 3D LiDAR
- 两个同步相机
- 多个 IMU
- UWB ranging

官方页面说明 NTU VIRAL 是一个 Visual-Inertial-Ranging-Lidar 数据集，包含 two 3D lidars、two time-synchronized cameras、multiple IMUs 和 UWB nodes  
来源：<https://ntu-aris.github.io/ntu_viral_dataset/>

## 2. 一个实用的数据集选择表

| 目标 | 优先数据集 | 理由 |
| --- | --- | --- |
| RGB-D 室内 SLAM 入门 | TUM RGB-D | 小而经典，评测成熟 |
| 双目 VIO 基线 | EuRoC | 社区最常用，结果最好对齐 |
| 更难的视觉惯导 | TUM VI | HDR、手持、曝光变化更明显 |
| 车载长轨迹 odometry | KITTI | 经典 benchmark，横向比较方便 |
| 语义 / 大规模车载地图 | KITTI-360 | 多模态和语义信息更丰富 |
| 稠密重建 / 语义场景理解 | ScanNet | 室内 RGB-D 与语义标注丰富 |
| 隐式 SLAM / 3DGS-SLAM | Replica | 可渲染、高保真、常见于神经表示论文 |
| 多传感器无人机融合 | NTU VIRAL | 传感器组合丰富 |

## 3. 常见评测指标怎么理解

### 3.1 ATE

ATE 是 Absolute Trajectory Error，常看整体轨迹和真值之间的偏差。

更适合回答：

- 轨迹最终有没有“跑歪”
- 回环和全局优化后，整体一致性有没有变好
- 地图是否和真值坐标系更一致

注意：

- ATE 好，不代表局部跟踪一定稳定
- 如果做了对齐，尤其是单目加尺度对齐，结果解读要说明白

### 3.2 RPE

RPE 是 Relative Pose Error，比较相对运动误差，更偏局部漂移。

更适合回答：

- 局部帧间 / 短时间段估计是否稳定
- 前端 odometry 漂移速度有多快
- 没有回环时系统本体的里程计质量如何

通常比 ATE 更能反映：

- 前端跟踪质量
- 短程运动估计误差
- 漂移率

### 3.3 KITTI odometry benchmark 指标

KITTI 常见报告方式不是简单一条 ATE，而是：

- 对不同长度的子轨迹计算平移误差
- 对不同长度的子轨迹计算旋转误差
- 再按平均值做排序

官方页面说明其对所有可能的长度为 100 到 800 米的子序列计算 translational 和 rotational errors，并分别以百分比与度每米汇总  
来源：<https://www.cvlibs.net/datasets/kitti/eval_odometry.php>

这意味着：

- KITTI 很关注“跑长了以后漂移积累得怎么样”
- 特别适合车载 odometry 和 long-term drift 的比较

## 4. 指标怎么选才不容易误导

### 4.1 看完整 SLAM

建议至少报告：

- ATE
- RPE
- 是否启用回环
- 是否做 Sim(3) / SE(3) 对齐

因为：

- ATE 体现全局一致性
- RPE 体现局部精度
- 回环会显著影响 ATE，但不一定直接提升前端短时稳定性

### 4.2 看 VIO / LIO 前端

建议优先看：

- RPE
- 分段漂移率
- 失败次数 / 跟踪丢失率
- 不同速度、转角、退化场景下的表现

### 4.3 看稠密重建 / NeRF / 3DGS-SLAM

只看轨迹还不够，通常还要加：

- 渲染指标：PSNR、SSIM、LPIPS
- 重建质量：Chamfer、depth error、mesh accuracy / completion
- 轨迹指标：ATE、RPE

也就是说，这类方法往往是“双评测”：

- 一条线评定位
- 一条线评地图 / 渲染

## 5. 实际做实验时的常见坑

### 5.1 对齐方式没说清楚

最常见的问题之一是：

- 是否做了时间同步
- 是否做了坐标系对齐
- 是否允许尺度对齐

尤其单目方法，如果用了 Sim(3) 对齐，指标会比不做尺度对齐好不少，必须写清楚。

### 5.2 把回环结果和纯里程计结果混在一起

建议分开报告：

- odometry only
- full SLAM

否则很容易看不出：

- 前端到底强不强
- 提升是来自前端还是回环 / 后端

### 5.3 只报均值，不报失败情况

有些方法在成功序列上很好看，但：

- 跑不完
- 经常丢跟踪
- 对初始化特别敏感

所以除了均值，最好补：

- 成功序列数
- 中位数
- 标准差
- 典型失败案例

### 5.4 不区分场景退化来源

建议把退化分开看：

- 低纹理
- 动态物体
- 高速运动
- 光照变化
- 纯旋转
- 平面退化
- 激光场景重复结构 / 几何退化

这样后面分析系统问题会更直接。

## 6. 常用工具链

### 6.1 evo

`evo` 是目前很常用的轨迹评测工具，支持：

- TUM trajectory files
- KITTI pose files
- EuRoC MAV ground truth / trajectory
- ROS / ROS2 bag 轨迹消息

官方文档说明 `evo` 提供 `evo_ape`、`evo_rpe`、`evo_traj` 等工具来处理、评测和比较 odometry / SLAM 输出轨迹  
来源：<https://michaelgrupp.github.io/evo/>

最常见的几个命令思路：

```bash
evo_ape tum gt.txt est.txt --align
evo_rpe tum gt.txt est.txt --delta 1 --delta_unit m
evo_traj tum est.txt --ref gt.txt -p
```

### 6.2 本仓库已有相关内容

- 轨迹导出格式见 [TUM_KITTI.md](./TUM_KITTI.md)
- ATE / RPE 公式见 [slam学习笔记.md](./slam学习笔记.md)

## 7. 一个最小评测模板

如果后面要给自己的项目写实验记录，建议至少按下面格式记：

### 7.1 实验设置

- 数据集与序列
- 传感器配置
- 是否使用 IMU / LiDAR / 回环
- 运行平台
- 是否实时

### 7.2 轨迹评测

- ATE RMSE
- RPE translational
- RPE rotational
- 对齐方式
- 成功率 / 是否丢跟踪

### 7.3 地图评测

- 地图类型
- 重建指标
- 是否可渲染
- 内存与速度

### 7.4 定性分析

- 轨迹图
- 误差曲线
- 失败片段截图
- 典型退化场景

## 8. 推荐阅读顺序

1. 先看 [SLAM技术路线与资料索引](./SLAM技术路线与资料索引.md)
2. 再看本页，建立“数据集和指标”视角
3. 然后回到具体系统，比如 ORB-SLAM3、OpenVINS、LIO-SAM、FAST-LIO
4. 最后再看论文时，主动记录它用了什么数据集、什么指标、有没有回环、有没有尺度对齐

## 9. 本页使用的外部资料

- TUM RGB-D: <https://cvg.cit.tum.de/data/datasets/rgbd-dataset>
- EuRoC MAV: <https://projects.asl.ethz.ch/datasets/euroc-mav/>
- TUM VI benchmark: <https://portal.fis.tum.de/en/publications/the-tum-vi-benchmark-for-evaluating-visual-inertial-odometry/>
- KITTI odometry: <https://www.cvlibs.net/datasets/kitti/eval_odometry.php>
- KITTI-360: <https://www.cvlibs.net/datasets/kitti-360/>
- ScanNet: <https://www.scan-net.org/ScanNet/>
- Replica: <https://github.com/facebookresearch/Replica-Dataset>
- NTU VIRAL: <https://ntu-aris.github.io/ntu_viral_dataset/>
- evo: <https://michaelgrupp.github.io/evo/>
