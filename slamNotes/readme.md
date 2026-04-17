# slamNotes

SLAM / ROS / 机器人方向学习笔记总目录。

这里既有学习笔记，也有开源方案索引、论文阅读入口、工具使用记录和阶段性项目总结。为了更容易查找，建议把这个目录当作一个独立知识域来使用。

## 推荐阅读顺序

### 如果想从基础开始

- [slam学习笔记](./slam学习笔记.md)
- [SLAM十四讲摘记](./14讲.md)
- [ROS 学习笔记](./ros学习笔记.md)
- [ROS 常用消息](./ros常用消息.md)

### 如果想快速了解方向和方案

- [slam 开源方案](./slam开源方案/readme.md)
- [激光 SLAM](./激光SLAM/readme.md)
- [SLAM 技术路线与资料索引](./SLAM技术路线与资料索引.md)
- [SLAM 数据集与评测指标](./SLAM数据集与评测指标.md)
- [SLAM 回环检测](./SLAM回环检测.md)
- [VIO 与 LIO 对比](./VIO与LIO对比.md)
- [初始化与标定](./初始化与标定.md)
- [地图表达与稀疏稠密隐式表示](./地图表达与稀疏稠密隐式表示.md)
- [动态SLAM与语义SLAM](./动态SLAM与语义SLAM.md)
- [SLAM 面试问题整理](./SLAM面试问题整理.md)

### 如果想查工具和格式

- [g2o 使用](./use_g2o.md)
- [Ceres 使用](./use_ceres.md)
- [OpenCV / Eigen / g2o / Ceres 在 SLAM 中的角色](./OpenCV_Eigen_g2o_Ceres在SLAM中的角色.md)
- [保存为 TUM / KITTI 格式](./TUM_KITTI.md)

### 如果想看项目和研究记录

- [2021 年项目记录](./2021.md)
- [2022 年项目记录](./2022.md)
- [2023 年项目记录](./2023.md)

## 目录导航

| 路径 | 内容 | 入口说明 |
| --- | --- | --- |
| `激光SLAM/` | 激光 SLAM / LIO / LVI 相关资料与笔记 | [激光SLAM/readme.md](./激光SLAM/readme.md) |
| `slam开源方案/` | 常见视觉、VIO、回环、融合方案的索引和速记 | [slam开源方案/readme.md](./slam开源方案/readme.md) |
| `slam论文阅读/` | 论文阅读入口和待补阅读清单 | [slam论文阅读/readme.md](./slam论文阅读/readme.md) |
| `3dGauss_splatting/` | 3D Gaussian Splatting 相关资料入口 | [3dGauss_splatting/readme.md](./3dGauss_splatting/readme.md) |
| `images/` | 本目录下笔记所用图片资源 | [images/readme.md](./images/readme.md) |

## 主笔记

- [slam学习笔记](./slam学习笔记.md)
- [SLAM十四讲摘记](./14讲.md)
- [SLAM 技术路线与资料索引](./SLAM技术路线与资料索引.md)
- [SLAM 数据集与评测指标](./SLAM数据集与评测指标.md)
- [SLAM 回环检测](./SLAM回环检测.md)
- [VIO 与 LIO 对比](./VIO与LIO对比.md)
- [初始化与标定](./初始化与标定.md)
- [地图表达与稀疏稠密隐式表示](./地图表达与稀疏稠密隐式表示.md)
- [动态SLAM与语义SLAM](./动态SLAM与语义SLAM.md)
- [ROS 学习笔记](./ros学习笔记.md)
- [ROS 常用消息](./ros常用消息.md)
- [SLAM 面试问题整理](./SLAM面试问题整理.md)

## 工具与实现细节

- [g2o 使用](./use_g2o.md)
- [Ceres 使用](./use_ceres.md)
- [OpenCV / Eigen / g2o / Ceres 在 SLAM 中的角色](./OpenCV_Eigen_g2o_Ceres在SLAM中的角色.md)
- [轨迹格式导出：TUM / KITTI](./TUM_KITTI.md)

说明：
- `image.png` 目前主要被 `use_g2o.md` 引用

## 项目记录

- [2021 年工作记录](./2021.md)
- [2022 年工作记录](./2022.md)
- [2023 年工作记录](./2023.md)

## 历史收集资料

下面这些链接主要作为历史收集入口保留，适合继续扩展到对应子目录：

- [视觉 SLAM 相关研究](https://github.com/wuxiaolang/Visual_SLAM_Related_Research)
- [深蓝学院视觉 SLAM](https://github.com/zhouyong1234/VIO-Course)
- [深蓝学院激光 SLAM](https://github.com/zhouyong1234/Laser-SLAM-Course)
- [古月居](https://www.guyuehome.com/)
- [FishROS](http://fishros.com/#/fish_home)

## 整理约定

- 目录下的 `readme.md` 优先只做导航和资料汇总
- 具体学习内容尽量写在独立 Markdown 文件中
- 专题专属图片优先放在对应专题目录；公共图片再放到 `images/`
