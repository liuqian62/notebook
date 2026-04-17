# OpenCV / Eigen / g2o / Ceres 在 SLAM 中的角色

这页想回答一个很工程的问题：

为什么很多 SLAM 项目里总能看到 `OpenCV`、`Eigen`、`g2o`、`Ceres` 一起出现？

最短答案是：

- `OpenCV` 更像视觉前端工具箱
- `Eigen` 更像线性代数与几何表达底座
- `g2o` 更像图优化框架
- `Ceres` 更像通用非线性最小二乘优化器

它们并不是互相替代关系，而是在一条典型实现链路里各自负责不同层。

## 1. 先从一条典型 SLAM 实现链看

如果把一个经典视觉 SLAM / VIO 系统粗略拆开，常见链路是：

1. 图像输入与预处理
2. 特征提取、匹配、几何估计
3. 位姿参数化、坐标变换、矩阵计算
4. 构建残差或图模型
5. 求解非线性优化
6. 输出轨迹、地图和误差指标

在这条链里通常对应：

- `OpenCV` 负责第 1、2 步的一大部分
- `Eigen` 负责第 3 步和一部分第 4、5 步的数据表达
- `g2o / Ceres` 负责第 4、5 步的求解

## 2. OpenCV 在 SLAM 里通常干什么

### 2.1 图像处理和特征前端

`OpenCV` 在 SLAM 中最常见的角色是：

- 图像读取与预处理
- 特征点检测
- 描述子提取
- 光流跟踪
- 双目 / RGB-D 基础处理

你可以把它理解成：

- 视觉前端最容易直接拿来用的工程工具箱

### 2.2 几何估计的现成接口

`OpenCV` 的 `calib3d` 模块里有很多 SLAM 前端常见接口，比如：

- `solvePnP`
- `findFundamentalMat`
- `findEssentialMat`
- `recoverPose`
- `triangulatePoints`
- `calibrateCamera`

OpenCV 官方 `calib3d` 文档明确说明 `solvePnP()` 用 3D-2D 对应来估计位姿，并返回把物体坐标系点变换到相机坐标系的旋转和平移  
来源：<https://docs.opencv.org/3.4/d9/d0c/group__calib3d.html>

### 2.3 OpenCV 的优点

- API 成熟
- 前端开发快
- 示例多
- 对原型验证很友好

### 2.4 OpenCV 的边界

`OpenCV` 虽然能做很多几何求解，但它通常不是完整 SLAM 后端的核心框架。

更准确地说：

- 它擅长“前端几何和图像处理”
- 但不等于“完整图优化系统”

## 3. Eigen 在 SLAM 里通常干什么

### 3.1 线性代数底座

`Eigen` 在很多 C++ SLAM 项目里几乎是默认底座，因为到处都要用：

- 向量
- 矩阵
- 线性方程
- 分解
- 变换

很多库本身也直接依赖 `Eigen`。

比如 `g2o` 的官方 README 就把 `Eigen3` 列为必需依赖  
来源：<https://github.com/RainerKuemmerle/g2o>

### 3.2 几何表示

在 SLAM 里，`Eigen` 不只是“矩阵库”，它还承担了很重要的几何表达职责，比如：

- `Matrix3d`
- `Vector3d`
- `Quaterniond`
- `AngleAxisd`
- `Affine3d`
- `Isometry3d`

Eigen 官方几何教程明确说明其 `Geometry` 模块提供旋转、平移、缩放以及 affine / projective transformation 的表达  
来源：<https://libeigen.gitlab.io/eigen/docs-nightly/group__TutorialGeometry.html>

### 3.3 Eigen 的典型位置

你在 SLAM 代码里最常见的几种情况是：

- 用 `Eigen` 表达状态量
- 用 `Eigen` 计算 Jacobian / Hessian
- 用 `Eigen` 做变换和坐标系换算
- 用 `Eigen` 存 residual 相关的小矩阵

一句话说：

- `Eigen` 是很多 SLAM 代码的“数学母语”

## 4. g2o 在 SLAM 里通常干什么

### 4.1 图优化框架

`g2o` 的全名就是 General Graph Optimization。

官方 README 直接把它定义为：

- 用于优化 graph-based nonlinear error functions 的开源 C++ 框架
- 当前实现为多种 SLAM 和 BA 问题提供了解法

来源：<https://github.com/RainerKuemmerle/g2o>

### 4.2 为什么 SLAM 喜欢图

因为很多 SLAM 问题天然可以写成：

- 顶点：位姿、路标、偏置等状态
- 边：观测约束、回环约束、IMU 约束、投影误差等

这正好匹配 `g2o` 的建模方式。

### 4.3 g2o 的典型使用场景

- pose graph optimization
- bundle adjustment
- 回环后的全局优化
- 图结构清晰的 BA / SLAM 问题

### 4.4 g2o 的强项

- 和 SLAM 建模方式非常贴近
- 自定义顶点和边的思路清晰
- 对图优化问题表达自然

## 5. Ceres 在 SLAM 里通常干什么

### 5.1 通用非线性最小二乘求解器

`Ceres Solver` 官方教程说明它求解的是带 robust loss 的非线性最小二乘问题，并把问题组织成：

- `ParameterBlock`
- `ResidualBlock`
- `LossFunction`

来源：<https://ceres-solver.org/nnls_tutorial.html>

这和很多视觉优化问题非常契合。

### 5.2 Ceres 在视觉问题里的典型场景

- curve fitting
- camera calibration
- PnP refinement
- bundle adjustment
- 多传感器外参优化

官方教程也明确说写 Ceres 的一个主要原因就是解决 large scale bundle adjustment 问题  
来源：<https://ceres-solver.org/nnls_tutorial.html>

### 5.3 Ceres 的强项

- 问题建模通用
- 自动求导很方便
- robust loss 好用
- 对“残差块”式建模非常友好

一句话理解：

- 如果 `g2o` 更像“图优化视角”
- 那 `Ceres` 更像“最小二乘视角”

## 6. g2o 和 Ceres 到底怎么区分

### 6.1 从建模视角看

`g2o` 更强调：

- 图结构
- 顶点与边
- SLAM / BA 图优化问题

`Ceres` 更强调：

- 参数块
- 残差块
- 通用非线性最小二乘

### 6.2 从使用体验看

`g2o` 更像：

- 你已经知道这是一个图优化问题
- 想按顶点边来组织系统

`Ceres` 更像：

- 你只想把目标函数和残差写清楚
- 然后让求解器去处理数值优化

### 6.3 从工程感受看

粗略经验通常是：

- `g2o` 更 SLAM 原生
- `Ceres` 更通用、也更适合做局部优化模块

## 7. 为什么很多项目里 OpenCV + Eigen + g2o / Ceres 会同时出现

因为它们刚好覆盖了一条完整实现链：

### 7.1 一种典型组合

- `OpenCV`：图像、特征、匹配、PnP、基础几何
- `Eigen`：状态、矩阵、变换、雅可比
- `g2o`：图优化后端

这很像许多经典视觉 SLAM 项目。

### 7.2 另一种典型组合

- `OpenCV`：视觉前端
- `Eigen`：数学表达
- `Ceres`：重投影误差优化、外参标定、局部 BA

这在多传感器标定、SfM、小型 BA 项目里很常见。

## 8. 各库在 SLAM 开发中的“角色边界”

### 8.1 OpenCV 不是优化后端主力

它有一些优化相关函数，但一般不承担完整图优化职责。

### 8.2 Eigen 不是求解框架

它可以做矩阵运算和分解，但它本身不是完整的 BA / SLAM 优化器。

### 8.3 g2o / Ceres 不是视觉前端库

它们默认不负责：

- 图像读取
- 特征提取
- 描述子匹配

所以真正的 SLAM 工程几乎总是组合使用，而不是只选一个库包打天下。

## 9. 从一个 BA 问题看四个库怎么协作

以“PnP 初值 + BA 精修”为例：

1. `OpenCV` 提取和匹配特征
2. `OpenCV` 用 `solvePnP` 给出初值
3. `Eigen` 表达位姿、点、内参、小矩阵
4. `g2o` 或 `Ceres` 构造重投影误差
5. 优化器最小化 residual
6. 输出 refined pose 和 points

这就是一个很典型的组合式工程链。

## 10. 如果按学习顺序来学，怎么排更顺

建议顺序通常是：

### 10.1 先学 OpenCV + Eigen

先把这些打稳：

- 图像和特征
- 相机模型
- PnP / 对极几何
- 向量矩阵和 SE(3) 基础表达

### 10.2 再学 Ceres 或 g2o

如果你想更快进入“残差建模”思维：

- 先学 `Ceres`

如果你想更快进入“SLAM 后端图模型”思维：

- 先学 `g2o`

### 10.3 最后回到完整系统

再去读：

- ORB-SLAM
- VINS-Mono
- OpenVINS
- LIO-SAM

你会更容易看懂每块代码到底在干嘛。

## 11. 从“适合什么任务”来选库

### 11.1 OpenCV

更适合：

- 视觉前端
- 原型验证
- 标定和基础几何

### 11.2 Eigen

更适合：

- 几何与状态表达
- 线性代数底层实现
- 自己写小型 Gauss-Newton / EKF / Jacobian

### 11.3 g2o

更适合：

- pose graph
- BA
- 回环优化
- 明显图结构的 SLAM 后端

### 11.4 Ceres

更适合：

- 残差块式建模
- 通用最小二乘问题
- 相机标定
- 外参优化
- 小到中型 BA

## 12. 一个很实用的对比表

| 库 | 在 SLAM 中更像什么 | 典型职责 | 强项 | 边界 |
| --- | --- | --- | --- | --- |
| OpenCV | 视觉前端工具箱 | 特征、匹配、PnP、标定、图像处理 | 前端开发快、接口成熟 | 不是完整后端优化框架 |
| Eigen | 数学与几何底座 | 矩阵、向量、变换、分解 | 轻量、表达自然、几乎无处不在 | 不是完整 BA/图优化器 |
| g2o | 图优化后端 | 顶点边建模、pose graph、BA | 非常贴近 SLAM 图模型 | 对纯通用最小二乘不如 Ceres 直观 |
| Ceres | 通用非线性最小二乘后端 | 残差建模、BA、标定、参数优化 | 自动求导、robust loss、通用性强 | 不负责图像前端，本身不是视觉工具箱 |

## 13. 面试里怎么答“这些库分别是干什么的”

一个比较顺的答法是：

1. `OpenCV` 主要做视觉前端和基础几何
2. `Eigen` 主要做矩阵、向量和位姿等数学表达
3. `g2o` 主要做 SLAM 风格的图优化
4. `Ceres` 主要做通用非线性最小二乘，比如 BA、标定和参数优化
5. 它们在工程上通常是配合使用，不是互相替代

如果再补一句，会更完整：

- 真正完整的 SLAM 系统一般是 `OpenCV + Eigen + g2o/Ceres + 自己的系统逻辑`

## 14. 和本仓库现有内容怎么联动

- `Eigen` 基础见 [slam学习笔记.md](./slam学习笔记.md)
- `g2o` 速记见 [use_g2o.md](./use_g2o.md)
- `Ceres` 速记见 [use_ceres.md](./use_ceres.md)
- 工具入口在 [readme.md](./readme.md)

## 15. 后续最值得继续补的子页

这页之后如果继续拆，最值得补的是两页：

- `Ceres` 最小可运行示例：参数块、残差块、自动求导、鲁棒核
- `OpenCV + Eigen + g2o` 做一次最小 BA 流程

## 16. 本页使用的外部资料

- OpenCV calib3d docs: <https://docs.opencv.org/3.4/d9/d0c/group__calib3d.html>
- Eigen Geometry tutorial: <https://libeigen.gitlab.io/eigen/docs-nightly/group__TutorialGeometry.html>
- g2o GitHub: <https://github.com/RainerKuemmerle/g2o>
- Ceres non-linear least squares tutorial: <https://ceres-solver.org/nnls_tutorial.html>
