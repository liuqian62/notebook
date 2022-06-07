# slam学习笔记

## 目录
- [slam简介](#slam简介)
- [三维空间刚体运动](#三维空间刚体运动)
- [Eigen基本使用](#Eigen基本使用)
- [相机与图像](#相机与图像)


- [非线性优化](#非线性优化)
- [特征点法](#特征点法)
- [直接法](#直接法)
- [协方差矩阵](#协方差矩阵)
- [卡尔曼滤波](#卡尔曼滤波)
- [图优化](#图优化)
- [回环检测](#回环检测)


## slam简介

### 引入

我在什么地方？--定位  
周围的环境是什么样？--建图

----
传感器：GPS，轮式编码器，激光雷达，惯性测量单元（Inertial Measurement Unit,IMU)，相机等

----
相机：单目（Monocular）,双目（Stereo）和深度相机（RGB-D)

单目：成本低，尺度不确定

### 经典视觉slam框架

* 传感器数据：在在视觉 SLAM 中主要为相机图像信息的读取和预处理。如果在机器人中，还可能有码盘、惯性传感器等信息的读取和同步。
* 前端--视觉里程计（Visual Odometry,VO)：视觉里程计任务是估算相邻图像间相机的运动，以及局部地图的样子。VO 又称为前端（Front End）。
* 后端--非线性优化(Optimization):后端接受不同时刻视觉里程计测量的相机位姿，以及回环检测的信息，对它们进行优化，得到全局一致的轨迹和地图。由于接在 VO 之后，又称为后端（Back End）
* 回环检测(Loop Closing):回环检测判断机器人是否曾经到达过先前的位置。如果检测到回环，它会把信息提供给后端进行处理。
* 建图(Mapping):它根据估计的轨迹，建立与任务要求对应的地图。

### SLAM问题的数学表述
运动方程
<div align="center">
    <img src="https://latex.codecogs.com/svg.image?x_{k}=f(x_{k-1},u_{k},w_{k})" title="https://latex.codecogs.com/svg.image?x_{k}=f(x_{k-1},u_{k},w_{k})" />
</div>

- $$ u_{k} $$为

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 三维空间刚体运动
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## Eigen基本使用
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 相机与图像
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>



## 非线性优化
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 特征点法
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 直接法



 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 协方差矩阵

- 方差
- 
<div align="center">
 
  <br /><img src="https://latex.codecogs.com/svg.image?{\sigma&space;_{x}}^{2}=\frac{1}{n-1}\sum_{i=1}^{n}(x_{i}-\bar{x})^{2}" title="https://latex.codecogs.com/svg.image?{\sigma _{x}}^{2}=\frac{1}{n-1}\sum_{i=1}^{n}(x_{i}-\bar{x})^{2}" />
  
</div>

- 协方差


<div align="center">
 
  <br /><img src="https://latex.codecogs.com/svg.image?\sigma(x,y)=\frac{1}{n-1}\sum_{i=1}^{n}(x_{i}-\bar{x})(y_{i}-\bar{y})" title="https://latex.codecogs.com/svg.image?\sigma(x,y)=\frac{1}{n-1}\sum_{i=1}^{n}(x_{i}-\bar{x})(y_{i}-\bar{y})" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?Cov(X,Y)=E[(X-\bar{x})(Y-\bar{y})]" title="https://latex.codecogs.com/svg.image?Cov(X,Y)=E[(X-\bar{x})(Y-\bar{y})]" />
  
</div>

- 相关系数

<div align="center">
 
  <br /><img src="https://latex.codecogs.com/svg.image?\rho&space;=\frac{Cov(X,Y)}{\sigma&space;_{X}\sigma_{Y}}" title="https://latex.codecogs.com/svg.image?\rho =\frac{Cov(X,Y)}{\sigma _{X}\sigma_{Y}}" />
  
</div>

- 协方差矩阵

<div align="center">
 
  <br /><img src="https://latex.codecogs.com/svg.image?\sigma(x_{m},x_{k})=\frac{1}{n-1}\sum_{i=1}^{n}(x_{mi}-\bar{x_{m}})(x_{ki}-\bar{x_{k}})" title="https://latex.codecogs.com/svg.image?\sigma(x_{m},x_{k})=\frac{1}{n-1}\sum_{i=1}^{n}(x_{mi}-\bar{x_{m}})(x_{ki}-\bar{x_{k}})" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?\sum=\begin{bmatrix}\sigma(x_{1},x_{1})&space;&...&space;&space;&\sigma(x_{1},x_{d})&space;&space;\\...&space;&...&space;&space;&...&space;&space;\\\sigma(x_{d},x_{1})&space;&...&space;&space;&\sigma(x_{d},x_{d})&space;&space;\\\end{bmatrix}\in&space;\mathbb{R}^{d\times&space;d}" title="https://latex.codecogs.com/svg.image?\sum=\begin{bmatrix}\sigma(x_{1},x_{1}) &... &\sigma(x_{1},x_{d}) \\... &... &... \\\sigma(x_{d},x_{1}) &... &\sigma(x_{d},x_{d}) \\\end{bmatrix}\in \mathbb{R}^{d\times d}" />
  
</div>

- 信息矩阵

<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?\Omega&space;=\Sigma&space;^{-1}" title="https://latex.codecogs.com/svg.image?\Omega =\Sigma ^{-1}" />
</div>


<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

## 卡尔曼滤波
* [卡尔曼滤波推导](https://blog.csdn.net/qq_25458977/article/details/111597163?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522165277069516780366540200%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=165277069516780366540200&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-111597163-null-null.142^v10^pc_search_result_control_group,157^v4^control&utm_term=%E5%8D%A1%E5%B0%94%E6%9B%BC%E6%BB%A4%E6%B3%A2%E5%8D%8F%E6%96%B9%E5%B7%AE%E7%9F%A9%E9%98%B5&spm=1018.2226.3001.4187)

 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 图优化
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 回环检测
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


