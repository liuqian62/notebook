# slam开源方案

这个目录用于整理常见 SLAM 开源方案，重点是做“快速索引”和“差异速记”，方便在学习、选型和面试前快速回顾。

## 快速索引

### 视觉 / 视觉惯导

| 方案 | 传感器 | 特点 | 链接 |
| --- | --- | --- | --- |
| VINS-Mono | 单目 + IMU | 经典 VIO 基线 | [GitHub](https://github.com/HKUST-Aerial-Robotics/VINS-Mono) |
| VINS-Fusion | 单目 / 双目 / 多传感器 | VINS 系列扩展版本 | [GitHub](https://github.com/HKUST-Aerial-Robotics/VINS-Fusion) |
| ORB-SLAM | 单目 | 经典特征法视觉 SLAM | [GitHub](https://github.com/raulmur/ORB_SLAM) |
| ORB-SLAM2 | 单目 / 双目 / RGB-D | 覆盖配置更完整 | [GitHub](https://github.com/raulmur/ORB_SLAM2) |
| ORB-SLAM3 | 视觉 / 视觉惯导 / 多地图 | 多传感器与多地图支持更强 | [GitHub](https://github.com/UZ-SLAMLab/ORB_SLAM3) |
| openVINS | VIO | 偏研究和工程结合 | [Docs](https://docs.openvins.com/gs-installing.html) |
| msckf_mono | 单目 + IMU | 经典滤波路线 | [GitHub](https://github.com/daniilidis-group/msckf_mono) |
| ov2slam | 双目视觉 | 偏轻量视觉前端方案 | [GitHub](https://github.com/ov2slam/ov2slam) |

### 回环检测相关

- [ibow-lcd](https://github1s.com/emiliofidalgo/ibow-lcd)
- [MILD](https://github.com/lhanaf/MILD)

### 融合与其他方案

- [gps+imu+eskf](https://github.com/liuqian62/eskf-gps-imu-fusion)

## 方案区别速记

- `ORB-SLAM`：以单目视觉 SLAM 为主，适合作为经典特征法入门参考
- `ORB-SLAM2`：在 `ORB-SLAM` 基础上扩展到双目和 RGB-D，工程可用性更强
- `ORB-SLAM3`：继续扩展到视觉惯导和多地图，是更完整的现代版本
- `msckf_mono` / `openVINS`：更偏滤波 / VIO 路线
- `VINS-Mono` / `VINS-Fusion`：更偏优化式 VIO 体系

## 使用建议

- 想做视觉 SLAM 入门：先看 `ORB-SLAM` 系列
- 想做 VIO：先看 `VINS-Mono`、`openVINS`
- 想看回环检测：看 `ibow-lcd`、`MILD`
- 想看融合定位：看 `gps+imu+eskf`

## 后续可以继续补的维度

- 数据集
- 前端特征类型
- 后端优化 / 滤波类型
- 回环检测方式
- 是否支持实时 / ROS / 多传感器
