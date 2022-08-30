# slam学习笔记

## 目录
- [slam简介](#slam简介)
- [三维空间刚体运动](#三维空间刚体运动)
- [Eigen基本使用](#Eigen基本使用)
- [李群和李代数](#李群和李代数)
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

- $ u_{k} $为传感器的读数
- $ w_{k} $为噪声

观测方程

$$
z_{k, j}=h(y_{j}, x_{k}, v_{k, j})
$$

- 在$ x_{k} $位置看到路标点$ y_{i} $产生观测数据$ z_{k, j} $
- $ v_{k, j} $为观测噪声

### 编程基础

```cpp
#include <iostream>
using namespace std;

int main(int argc, char** argv){
    cout<<"Hello SLAM!"<<endl;
    return 0;
}
```
编译
```
g++ helloSLAM.cpp
```

CMakeLists.txt
```cmake
# 声明要求的 cmake 最低版本
cmake_minimum_required( VERSION 2.8 )

# 声明一个 cmake 工程
project( HelloSLAM )

# 添加一个可执行程序
# 语法：add_executable( 程序名 源代码文件 ）
add_executable( helloSLAM helloSLAM.cpp )

```

使用库
```cmake
cmake_minimum_required( VERSION 2.8 )

# 声明一个 cmake 工程
project( HelloSLAM )

add_library( hello_shared SHARED libHelloSLAM.cpp )

# 添加一个可执行程序
# 语法：add_executable( 程序名 源代码文件 ）
add_executable( useHello useHello.cpp )
target_link_libraries( useHello hello_shared )

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 三维空间刚体运动

### 旋转矩阵

内积



<div align="center">
    <img src="https://latex.codecogs.com/svg.image?a\cdot&space;b=a^{T}b=\sum_{i=1}^{3}a_{i}b_{i}=\left|a&space;\right|\left|b&space;\right|cos\left<a,b&space;\right>"   />
</div>

外积

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?a\times&space;b=\begin{bmatrix}i&space;&j&space;&space;&k&space;&space;\\a_{1}&space;&a_{2}&space;&space;&a_{3}&space;&space;\\b_{1}&space;&b_{2}&space;&space;&b_{3}&space;&space;\\\end{bmatrix}=\begin{bmatrix}a_{2}b_{3}-a_{3}b_{2}&space;\\a_{3}b_{1}-a_{1}b_{3}\\a_{1}b_{2}-a_{2}b_{1}\\\end{bmatrix}=\begin{bmatrix}0&space;&-a_{3}&space;&space;&a_{2}&space;&space;\\a_{3}&space;&0&space;&space;&-a_{1}&space;&space;\\-a_{2}&space;&a_{1}&space;&space;&0&space;&space;\\\end{bmatrix}b\triangleq&space;a^{\land}b&space;" title="https://latex.codecogs.com/svg.image?a\times b=\begin{bmatrix}i &j &k \\a_{1} &a_{2} &a_{3} \\b_{1} &b_{2} &b_{3} \\\end{bmatrix}=\begin{bmatrix}a_{2}b_{3}-a_{3}b_{2} \\a_{3}b_{1}-a_{1}b_{3}\\a_{1}b_{2}-a_{2}b_{1}\\\end{bmatrix}=\begin{bmatrix}0 &-a_{3} &a_{2} \\a_{3} &0 &-a_{1} \\-a_{2} &a_{1} &0 \\\end{bmatrix}b\triangleq a^{\land}b " />
</div>

坐标系的欧式变换

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?\begin{bmatrix}e_{1}&space;&e_{2}&space;&space;&e_{3}&space;&space;\\\end{bmatrix}\begin{bmatrix}&space;a_{1}\\&space;a_{2}\\a_{3}\\\end{bmatrix}=\begin{bmatrix}e_{1}'&space;&e_{2}'&space;&space;&e_{3}'&space;&space;\\\end{bmatrix}\begin{bmatrix}&space;a_{1}'\\&space;a_{2}'\\a_{3}'\\\end{bmatrix}" title="https://latex.codecogs.com/svg.image?\begin{bmatrix}e_{1} &e_{2} &e_{3} \\\end{bmatrix}\begin{bmatrix} a_{1}\\ a_{2}\\a_{3}\\\end{bmatrix}=\begin{bmatrix}e_{1}' &e_{2}' &e_{3}' \\\end{bmatrix}\begin{bmatrix} a_{1}'\\ a_{2}'\\a_{3}'\\\end{bmatrix}" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?\begin{bmatrix}&space;a_{1}\\&space;a_{2}\\a_{3}\\\end{bmatrix}=\begin{bmatrix}e_{1}^{T}e_{1}'&space;&e_{1}^{T}e_{2}'&space;&space;&e_{1}^{T}e_{3}'&space;&space;\\e_{2}^{T}e_{1}'&space;&e_{2}^{T}e_{2}'&space;&space;&e_{2}^{T}e_{3}'&space;&space;\\e_{3}^{T}e_{1}'&space;&e_{3}^{T}e_{2}'&space;&space;&e_{3}^{T}e_{3}'&space;&space;\\\end{bmatrix}\begin{bmatrix}&space;a_{1}'\\&space;a_{2}'\\a_{3}'\\\end{bmatrix}\triangleq&space;Ra'" title="https://latex.codecogs.com/svg.image?\begin{bmatrix} a_{1}\\ a_{2}\\a_{3}\\\end{bmatrix}=\begin{bmatrix}e_{1}^{T}e_{1}' &e_{1}^{T}e_{2}' &e_{1}^{T}e_{3}' \\e_{2}^{T}e_{1}' &e_{2}^{T}e_{2}' &e_{2}^{T}e_{3}' \\e_{3}^{T}e_{1}' &e_{3}^{T}e_{2}' &e_{3}^{T}e_{3}' \\\end{bmatrix}\begin{bmatrix} a_{1}'\\ a_{2}'\\a_{3}'\\\end{bmatrix}\triangleq Ra'" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?SO(n)=\begin{Bmatrix}R\in&space;\mathbb{R}^{n\times&space;n}|RR^{T}=I,det(R)=1\end{Bmatrix}" title="https://latex.codecogs.com/svg.image?SO(n)=\begin{Bmatrix}R\in \mathbb{R}^{n\times n}|RR^{T}=I,det(R)=1\end{Bmatrix}" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?a'=R^{-1}a=R^{T}a" title="https://latex.codecogs.com/svg.image?a'=R^{-1}a=R^{T}a" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?a'=Ra&plus;t" title="https://latex.codecogs.com/svg.image?a'=Ra+t" />
</div>


变换矩阵与齐次坐标
<div align="center">
    <img src="https://latex.codecogs.com/svg.image?b=R_{1}a&plus;t_{1},c=R_{2}b&plus;t_{2}" title="https://latex.codecogs.com/svg.image?b=R_{1}a+t_{1},c=R_{2}b+t_{2}" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?c=R_{2}(R_{1}a&plus;t_{1})&plus;t{2}" title="https://latex.codecogs.com/svg.image?c=R_{2}(R_{1}a+t_{1})+t{2}" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?\begin{bmatrix}&space;a'\\1\end{bmatrix}=\begin{bmatrix}R&space;&t&space;&space;\\0^{T}&space;&1&space;&space;\\\end{bmatrix}\begin{bmatrix}&space;a\\1\end{bmatrix}\triangleq&space;T\begin{bmatrix}&space;a\\1\end{bmatrix}" title="https://latex.codecogs.com/svg.image?\begin{bmatrix} a'\\1\end{bmatrix}=\begin{bmatrix}R &t \\0^{T} &1 \\\end{bmatrix}\begin{bmatrix} a\\1\end{bmatrix}\triangleq T\begin{bmatrix} a\\1\end{bmatrix}" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?SE(3)=\begin{Bmatrix}T=\begin{bmatrix}R&space;&t&space;&space;\\0^{T}&space;&1&space;&space;\\\end{bmatrix}\in&space;\mathbb{R}^{4\times&space;4}|R&space;\in&space;SO(3),t\in&space;\mathbb{R}^{3}\end{Bmatrix}" title="https://latex.codecogs.com/svg.image?SE(3)=\begin{Bmatrix}T=\begin{bmatrix}R &t \\0^{T} &1 \\\end{bmatrix}\in \mathbb{R}^{4\times 4}|R \in SO(3),t\in \mathbb{R}^{3}\end{Bmatrix}" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?T^{-1}=\begin{bmatrix}R^{T}&space;&-R^{T}t&space;&space;\\0^{T}&space;&1&space;&space;\\\end{bmatrix}" title="https://latex.codecogs.com/svg.image?T^{-1}=\begin{bmatrix}R^{T} &-R^{T}t \\0^{T} &1 \\\end{bmatrix}" />
</div>

### 旋转向量和欧拉角
旋转向量
```
方向与旋转轴一致，长度等于旋转角。（轴角）
```
欧拉角
```
绕物体的 Z 轴旋转，得到偏航角 yaw；
绕旋转之后的 Y 轴旋转，得到俯仰角 pitch；
绕旋转之后的 X 轴旋转，得到滚转角 roll。

万向锁问题（Gimbal Lock）:在俯仰角为±90◦ 时，第一次旋转与第三次旋转将使用同一个轴，使得系统丢失了一个自由度（由三次
旋转变成了两次旋转）。这被称为奇异性问题，在其他形式的欧拉角中也同样存在。
```
### 四元数
一个四元数 q 拥有一个实部和三个虚部
<div align="center">
    <img src="https://latex.codecogs.com/svg.image?q=q_{0}&plus;q_{1}i&plus;q_{2}j&plus;q_{3}k" title="https://latex.codecogs.com/svg.image?q=q_{0}+q_{1}i+q_{2}j+q_{3}k" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?\left\{\begin{matrix}&space;i^{2}=j^{2}=k^{2}=-1\\&space;ij=k,ji=-k\\&space;jk=i,kj=-i\\&space;ki=j,ik=-j\end{matrix}\right." title="https://latex.codecogs.com/svg.image?\left\{\begin{matrix} i^{2}=j^{2}=k^{2}=-1\\ ij=k,ji=-k\\ jk=i,kj=-i\\ ki=j,ik=-j\end{matrix}\right." />
</div>

由轴角$ n $, $ \theta $指定旋转，三维点p旋转后变成p'。

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?p=[0,x,y,z]=[0,v]" title="https://latex.codecogs.com/svg.image?p=[0,x,y,z]=[0,v]" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?q=[cos\frac{\theta}{2},nsin\frac{\theta}{2}]" title="https://latex.codecogs.com/svg.image?q=[cos\frac{\theta}{2},nsin\frac{\theta}{2}]" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?p'=qpq^{-1}" title="https://latex.codecogs.com/svg.image?p'=qpq^{-1}" />
</div>

### 相似、仿射、射影变换
欧式变换（6自由度）

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?T=\begin{bmatrix}R&space;&t&space;&space;\\0^{T}&space;&1&space;&space;\\\end{bmatrix}" title="https://latex.codecogs.com/svg.image?T=\begin{bmatrix}R &t \\0^{T} &1 \\\end{bmatrix}" />
</div>
相似变换（7自由度）

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?T_{s}=\begin{bmatrix}sR&space;&t&space;&space;\\0^{T}&space;&1&space;&space;\\\end{bmatrix}" title="https://latex.codecogs.com/svg.image?T_{s}=\begin{bmatrix}sR &t \\0^{T} &1 \\\end{bmatrix}" />
</div>
仿射变换（12自由度）

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?T_{A}=\begin{bmatrix}A&space;&t&space;&space;\\0^{T}&space;&1&space;&space;\\\end{bmatrix}" title="https://latex.codecogs.com/svg.image?T_{A}=\begin{bmatrix}A &t \\0^{T} &1 \\\end{bmatrix}" />
</div>
射影变换（15自由度）

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?T_{P}=\begin{bmatrix}A&space;&t&space;&space;\\a^{T}&space;&v&space;&space;\\\end{bmatrix}" title="https://latex.codecogs.com/svg.image?T_{P}=\begin{bmatrix}A &t \\a^{T} &v \\\end{bmatrix}" />
</div>
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## Eigen基本使用
CMakeLists.txt
```cmake
include_directories("/usr/include/eigen3")
```
各个模块

<!-- <div align="center">

| 模块 | 头文件 | 描述|
| :---: | :---: |  :---: |
| Core | #include<Eigen/Core> |Martix和Array类，基础的线性代数运算和数组操作 |
| Geometry | #include<Eigen/Geometry> |旋转、平移、缩放、2维和3维的各种变换 |
| LU | #include<Eigen/LU> |求逆，行列式，LU分解 |
| Cholesky | #include<Eigen/Cholesky> |LLT和DLT Cholesky分解 |
| Householder | #include<Eigen/Householder> |豪斯霍尔德变换，用于线性代数运算 |
| SVD | #include<Eigen/SVD> |SVD分解 |
| QR | #include<Eigen/QR> |QR分解 |
| Eigenvalues | #include<Eigen/Eigenvalues> |特征值，特征向量分解 |   
| Spares | #include<Eigen/Spares> |稀疏矩阵的存储和一些基本的线性运算 |
| Dense | #include<Eigen/Dense> |包括了Core/Geometry/LU/Cholesky/SVD/QR/Eigenvalues模块 |
| Eigen | #include<Eigen/Eigen> |包括Dense和Sparse(整合库) |
  
</div> -->

    
 运动相关
 ```
旋转矩阵（3 × 3）：Eigen::Matrix3d。
旋转向量（3 × 1）：Eigen::AngleAxisd。
欧拉角（3 × 1）：Eigen::Vector3d。
四元数（4 × 1）：Eigen::Quaterniond。
欧氏变换矩阵（4 × 4）：Eigen::Isometry3d。
仿射变换（4 × 4）：Eigen::Affine3d。
射影变换（4 × 4）：Eigen::Projective3d。
```
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

## 李群和李代数

<div align="center">
    <img src="./images/4_1.png" />
</div>

### 评估轨迹的误差
考虑一条估计轨迹$ T_{esti,i} $和真实轨迹$ T_{gt,i} $，其中i =1，...，N，那么我们可以定义
一些误差指标来描述它们之间的差别。
* 绝对轨迹误差（Absolute Trajectory Error,ATE）

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?ATE_{all}=\sqrt{\frac{1}{N}\sum_{i=1}^{N}\left\|log(T_{gt,i}^{-1}T_{esti,i})^{\vee&space;}&space;\right\|_{2}^{2}}" title="ATE_{all}=\sqrt{\frac{1}{N}\sum_{i=1}^{N}\left\|log(T_{gt,i}^{-1},T_{esti,i})^{\vee } \right\|_{2}^{2}}" />
</div>

    这实际上是每个位姿李代数的均方根误差（Root-Mean-Squared Error, RMSE）。这种误差可以刻画
    两条轨迹的旋转和平移误差。
* 绝对平移误差（Average Translational Error）  

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?ATE_{trans}=\sqrt{\frac{1}{N}\sum_{i=1}^{N}\left\|trans(T_{gt,i}^{-1}T_{esti,i})&space;\right\|_{2}^{2}}" title="ATE_{trans}=\sqrt{\frac{1}{N}\sum_{i=1}^{N}\left\|trans(T_{gt,i}^{-1}T_{esti,i}) \right\|_{2}^{2}}" />
</div>

* 相对位姿误差（Relative Pose Error, RPE）

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?RPE_{all}=\sqrt{\frac{1}{N-\Delta&space;t}\sum_{i=1}^{N-\Delta&space;t}\left\|log((T_{gt,i}^{-1}T_{gt,i&plus;\Delta&space;t})^{-1}(T_{esti,i}T_{esti,i&plus;\Delta&space;t}))^{\vee&space;}&space;\right\|_{2}^{2}}" title="RPE_{all}=\sqrt{\frac{1}{N-\Delta t}\sum_{i=1}^{N-\Delta t}\left\|log((T_{gt,i}^{-1}T_{gt,i+\Delta t})^{-1}(T_{esti,i}T_{esti,i+\Delta t}))^{\vee } \right\|_{2}^{2}}" />
</div>

* 相对平移误差（Relative Translational Error）

<div align="center">
    <img src="https://latex.codecogs.com/svg.image?RPE_{trans}=\sqrt{\frac{1}{N-\Delta&space;t}\sum_{i=1}^{N-\Delta&space;t}\left\|trans((T_{gt,i}^{-1}T_{gt,i&plus;\Delta&space;t})^{-1}(T_{esti,i}T_{esti,i&plus;\Delta&space;t}))&space;\right\|_{2}^{2}}" title="RPE_{trans}=\sqrt{\frac{1}{N-\Delta t}\sum_{i=1}^{N-\Delta t}\left\|trans((T_{gt,i}^{-1}T_{gt,i+\Delta t})^{-1}(T_{esti,i}T_{esti,i+\Delta t})) \right\|_{2}^{2}}" />
</div>

## 相机与图像
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>



## 非线性优化
### 状态估计问题

### 非线性最小二乘

### 实践曲线拟合问题
考虑一条满足以下方程的曲线：
<div align="center">
    <img src="https://latex.codecogs.com/svg.image?y=exp(ax^2&plus;bx&plus;c)&plus;w" title="https://latex.codecogs.com/svg.image?y=exp(ax^2+bx+c)+w" />
</div>

其中a,b,c为曲线方程，w为高斯噪声。假设我们有N个关于x,y的观测数据点，想根据这些数据点求出曲线的参数。那么，可以求解下面的最小二乘问题估计曲线参数：
<div align="center">
    <img src="https://latex.codecogs.com/svg.image?\underset{a,b,c}{min}\frac{1}{2}\sum_{i=1}^{N}\left\|y_{i}-exp(ax_{i}^{2}&plus;bx_{i}&plus;c)&space;\right\|^{2}" title="https://latex.codecogs.com/svg.image?\underset{a,b,c}{min}\frac{1}{2}\sum_{i=1}^{N}\left\|y_{i}-exp(ax_{i}^{2}+bx_{i}+c) \right\|^{2}" />
</div>
 
请注意，在这个问题中，待估计的变量是 a, b, c，而不是 x。我们的程序里先根据模型生成 x, y
的真值，然后在真值中添加高斯分布的噪声。随后，使用高斯牛顿法来从带噪声的数据拟合参数模
型。定义误差为:
<div align="center">
    <img src="https://latex.codecogs.com/svg.image?e_{i}=y_{i}-exp(ax_{i}^{2}&plus;bx_{i}&plus;c)&space;" title="https://latex.codecogs.com/svg.image?e_{i}=y_{i}-exp(ax_{i}^{2}+bx_{i}+c) " />
</div>
那么可以求出每个误差项对于状态变量的导数：

<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?\frac{\partial&space;e_{i}}{\partial&space;a}=-x_{i}^{2}exp(ax_{i}^{2}&plus;bx_{i}&plus;c)&space;" title="https://latex.codecogs.com/svg.image?\frac{\partial e_{i}}{\partial a}=-x_{i}^{2}exp(ax_{i}^{2}+bx_{i}+c) " />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?\frac{\partial&space;e_{i}}{\partial&space;b}=-x_{i}exp(ax_{i}^{2}&plus;bx_{i}&plus;c)&space;" title="https://latex.codecogs.com/svg.image?\frac{\partial e_{i}}{\partial b}=-x_{i}exp(ax_{i}^{2}+bx_{i}+c) " />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?\frac{\partial&space;e_{i}}{\partial&space;c}=-exp(ax_{i}^{2}&plus;bx_{i}&plus;c)&space;" title="https://latex.codecogs.com/svg.image?\frac{\partial e_{i}}{\partial c}=-exp(ax_{i}^{2}+bx_{i}+c) " />
</div>
于是，
<div align="center">
    <img src="https://latex.codecogs.com/svg.image?J_{i}=[\frac{\partial&space;e_{i}}{\partial&space;a},\frac{\partial&space;e_{i}}{\partial&space;b},\frac{\partial&space;e_{i}}{\partial&space;c}]^{T}" title="https://latex.codecogs.com/svg.image?J_{i}=[\frac{\partial e_{i}}{\partial a},\frac{\partial e_{i}}{\partial b},\frac{\partial e_{i}}{\partial c}]^{T}" />
</div>
高斯牛顿的增量方程为：
<div align="center">
    <img src="https://latex.codecogs.com/svg.image?(\sum_{i=1}^{100}J_{i}(\sigma^{2}&space;)^{-1}J_{i}^{T})\Delta&space;x_{k}=\sum_{i=1}^{100}-J_{i}(\sigma&space;^{2})^{-1}e_{i}" title="https://latex.codecogs.com/svg.image?(\sum_{i=1}^{100}J_{i}(\sigma^{2} )^{-1}J_{i}^{T})\Delta x_{k}=\sum_{i=1}^{100}-J_{i}(\sigma ^{2})^{-1}e_{i}" />
</div>


* 高斯牛顿代码

```cpp
#include <iostream>
#include <chrono>
#include <opencv2/opencv.hpp>
#include <Eigen/Core>
#include <Eigen/Dense>

using namespace std;
using namespace Eigen;

int main(int argc, char **argv) {
  double ar = 1.0, br = 2.0, cr = 1.0;         // 真实参数值
  double ae = 2.0, be = -1.0, ce = 5.0;        // 估计参数值
  int N = 100;                                 // 数据点
  double w_sigma = 1.0;                        // 噪声Sigma值
  double inv_sigma = 1.0 / w_sigma;
  cv::RNG rng;                                 // OpenCV随机数产生器

  vector<double> x_data, y_data;      // 数据
  for (int i = 0; i < N; i++) {
    double x = i / 100.0;
    x_data.push_back(x);
    y_data.push_back(exp(ar * x * x + br * x + cr) + rng.gaussian(w_sigma * w_sigma));
  }

  // 开始Gauss-Newton迭代
  int iterations = 100;    // 迭代次数
  double cost = 0, lastCost = 0;  // 本次迭代的cost和上一次迭代的cost

  chrono::steady_clock::time_point t1 = chrono::steady_clock::now();
  for (int iter = 0; iter < iterations; iter++) {

    Matrix3d H = Matrix3d::Zero();             // Hessian = J^T W^{-1} J in Gauss-Newton
    Vector3d b = Vector3d::Zero();             // bias
    cost = 0;

    for (int i = 0; i < N; i++) {
      double xi = x_data[i], yi = y_data[i];  // 第i个数据点
      double error = yi - exp(ae * xi * xi + be * xi + ce);
      Vector3d J; // 雅可比矩阵
      J[0] = -xi * xi * exp(ae * xi * xi + be * xi + ce);  // de/da
      J[1] = -xi * exp(ae * xi * xi + be * xi + ce);  // de/db
      J[2] = -exp(ae * xi * xi + be * xi + ce);  // de/dc

      H += inv_sigma * inv_sigma * J * J.transpose();
      b += -inv_sigma * inv_sigma * error * J;

      cost += error * error;
    }

    // 求解线性方程 Hx=b
    Vector3d dx = H.ldlt().solve(b);
    if (isnan(dx[0])) {
      cout << "result is nan!" << endl;
      break;
    }

    if (iter > 0 && cost >= lastCost) {
      cout << "cost: " << cost << ">= last cost: " << lastCost << ", break." << endl;
      break;
    }

    ae += dx[0];
    be += dx[1];
    ce += dx[2];

    lastCost = cost;

    cout << "total cost: " << cost << ", \t\tupdate: " << dx.transpose() <<
         "\t\testimated params: " << ae << "," << be << "," << ce << endl;
  }

  chrono::steady_clock::time_point t2 = chrono::steady_clock::now();
  chrono::duration<double> time_used = chrono::duration_cast<chrono::duration<double>>(t2 - t1);
  cout << "solve time cost = " << time_used.count() << " seconds. " << endl;

  cout << "estimated abc = " << ae << ", " << be << ", " << ce << endl;
  return 0;
}

```

* Ceres代码

```cpp
#include <iostream>
#include <opencv2/core/core.hpp>
#include <ceres/ceres.h>
#include <chrono>

using namespace std;

// 代价函数的计算模型
struct CURVE_FITTING_COST {
  CURVE_FITTING_COST(double x, double y) : _x(x), _y(y) {}

  // 残差的计算
  template<typename T>
  bool operator()(
    const T *const abc, // 模型参数，有3维
    T *residual) const {
    residual[0] = T(_y) - ceres::exp(abc[0] * T(_x) * T(_x) + abc[1] * T(_x) + abc[2]); // y-exp(ax^2+bx+c)
    return true;
  }

  const double _x, _y;    // x,y数据
};

int main(int argc, char **argv) {
  double ar = 1.0, br = 2.0, cr = 1.0;         // 真实参数值
  double ae = 2.0, be = -1.0, ce = 5.0;        // 估计参数值
  int N = 100;                                 // 数据点
  double w_sigma = 1.0;                        // 噪声Sigma值
  double inv_sigma = 1.0 / w_sigma;
  cv::RNG rng;                                 // OpenCV随机数产生器

  vector<double> x_data, y_data;      // 数据
  for (int i = 0; i < N; i++) {
    double x = i / 100.0;
    x_data.push_back(x);
    y_data.push_back(exp(ar * x * x + br * x + cr) + rng.gaussian(w_sigma * w_sigma));
  }

  double abc[3] = {ae, be, ce};

  // 构建最小二乘问题
  ceres::Problem problem;
  for (int i = 0; i < N; i++) {
    problem.AddResidualBlock(     // 向问题中添加误差项
      // 使用自动求导，模板参数：误差类型，输出维度，输入维度，维数要与前面struct中一致
      new ceres::AutoDiffCostFunction<CURVE_FITTING_COST, 1, 3>(
        new CURVE_FITTING_COST(x_data[i], y_data[i])
      ),
      nullptr,            // 核函数，这里不使用，为空
      abc                 // 待估计参数
    );
  }

  // 配置求解器
  ceres::Solver::Options options;     // 这里有很多配置项可以填
  options.linear_solver_type = ceres::DENSE_NORMAL_CHOLESKY;  // 增量方程如何求解
  options.minimizer_progress_to_stdout = true;   // 输出到cout

  ceres::Solver::Summary summary;                // 优化信息
  chrono::steady_clock::time_point t1 = chrono::steady_clock::now();
  ceres::Solve(options, &problem, &summary);  // 开始优化
  chrono::steady_clock::time_point t2 = chrono::steady_clock::now();
  chrono::duration<double> time_used = chrono::duration_cast<chrono::duration<double>>(t2 - t1);
  cout << "solve time cost = " << time_used.count() << " seconds. " << endl;

  // 输出结果
  cout << summary.BriefReport() << endl;
  cout << "estimated a,b,c = ";
  for (auto a:abc) cout << a << " ";
  cout << endl;

  return 0;
}

```

* g2o代码

```cpp
#include <iostream>
#include <g2o/core/g2o_core_api.h>
#include <g2o/core/base_vertex.h>
#include <g2o/core/base_unary_edge.h>
#include <g2o/core/block_solver.h>
#include <g2o/core/optimization_algorithm_levenberg.h>
#include <g2o/core/optimization_algorithm_gauss_newton.h>
#include <g2o/core/optimization_algorithm_dogleg.h>
#include <g2o/solvers/dense/linear_solver_dense.h>
#include <Eigen/Core>
#include <opencv2/core/core.hpp>
#include <cmath>
#include <chrono>

using namespace std;

// 曲线模型的顶点，模板参数：优化变量维度和数据类型
class CurveFittingVertex : public g2o::BaseVertex<3, Eigen::Vector3d> {
public:
  EIGEN_MAKE_ALIGNED_OPERATOR_NEW

  // 重置
  virtual void setToOriginImpl() override {
    _estimate << 0, 0, 0;
  }

  // 更新
  virtual void oplusImpl(const double *update) override {
    _estimate += Eigen::Vector3d(update);
  }

  // 存盘和读盘：留空
  virtual bool read(istream &in) {}

  virtual bool write(ostream &out) const {}
};

// 误差模型 模板参数：观测值维度，类型，连接顶点类型
class CurveFittingEdge : public g2o::BaseUnaryEdge<1, double, CurveFittingVertex> {
public:
  EIGEN_MAKE_ALIGNED_OPERATOR_NEW

  CurveFittingEdge(double x) : BaseUnaryEdge(), _x(x) {}

  // 计算曲线模型误差
  virtual void computeError() override {
    const CurveFittingVertex *v = static_cast<const CurveFittingVertex *> (_vertices[0]);
    const Eigen::Vector3d abc = v->estimate();
    _error(0, 0) = _measurement - std::exp(abc(0, 0) * _x * _x + abc(1, 0) * _x + abc(2, 0));
  }

  // 计算雅可比矩阵
  virtual void linearizeOplus() override {
    const CurveFittingVertex *v = static_cast<const CurveFittingVertex *> (_vertices[0]);
    const Eigen::Vector3d abc = v->estimate();
    double y = exp(abc[0] * _x * _x + abc[1] * _x + abc[2]);
    _jacobianOplusXi[0] = -_x * _x * y;
    _jacobianOplusXi[1] = -_x * y;
    _jacobianOplusXi[2] = -y;
  }

  virtual bool read(istream &in) {}

  virtual bool write(ostream &out) const {}

public:
  double _x;  // x 值， y 值为 _measurement
};

int main(int argc, char **argv) {
  double ar = 1.0, br = 2.0, cr = 1.0;         // 真实参数值
  double ae = 2.0, be = -1.0, ce = 5.0;        // 估计参数值
  int N = 100;                                 // 数据点
  double w_sigma = 1.0;                        // 噪声Sigma值
  double inv_sigma = 1.0 / w_sigma;
  cv::RNG rng;                                 // OpenCV随机数产生器

  vector<double> x_data, y_data;      // 数据
  for (int i = 0; i < N; i++) {
    double x = i / 100.0;
    x_data.push_back(x);
    y_data.push_back(exp(ar * x * x + br * x + cr) + rng.gaussian(w_sigma * w_sigma));
  }

  // 构建图优化，先设定g2o
  typedef g2o::BlockSolver<g2o::BlockSolverTraits<3, 1>> BlockSolverType;  // 每个误差项优化变量维度为3，误差值维度为1
  typedef g2o::LinearSolverDense<BlockSolverType::PoseMatrixType> LinearSolverType; // 线性求解器类型

  // 梯度下降方法，可以从GN, LM, DogLeg 中选
  auto solver = new g2o::OptimizationAlgorithmGaussNewton(
    g2o::make_unique<BlockSolverType>(g2o::make_unique<LinearSolverType>()));
  g2o::SparseOptimizer optimizer;     // 图模型
  optimizer.setAlgorithm(solver);   // 设置求解器
  optimizer.setVerbose(true);       // 打开调试输出

  // 往图中增加顶点
  CurveFittingVertex *v = new CurveFittingVertex();
  v->setEstimate(Eigen::Vector3d(ae, be, ce));
  v->setId(0);
  optimizer.addVertex(v);

  // 往图中增加边
  for (int i = 0; i < N; i++) {
    CurveFittingEdge *edge = new CurveFittingEdge(x_data[i]);
    edge->setId(i);
    edge->setVertex(0, v);                // 设置连接的顶点
    edge->setMeasurement(y_data[i]);      // 观测数值
    edge->setInformation(Eigen::Matrix<double, 1, 1>::Identity() * 1 / (w_sigma * w_sigma)); // 信息矩阵：协方差矩阵之逆
    optimizer.addEdge(edge);
  }

  // 执行优化
  cout << "start optimization" << endl;
  chrono::steady_clock::time_point t1 = chrono::steady_clock::now();
  optimizer.initializeOptimization();
  optimizer.optimize(10);
  chrono::steady_clock::time_point t2 = chrono::steady_clock::now();
  chrono::duration<double> time_used = chrono::duration_cast<chrono::duration<double>>(t2 - t1);
  cout << "solve time cost = " << time_used.count() << " seconds. " << endl;

  // 输出优化值
  Eigen::Vector3d abc_estimate = v->estimate();
  cout << "estimated model: " << abc_estimate.transpose() << endl;

  return 0;
}

```

* CMakeLists代码

```cmake
cmake_minimum_required(VERSION 2.8)
project(ch6)

set(CMAKE_BUILD_TYPE Release)
set(CMAKE_CXX_FLAGS "-std=c++14 -O3")

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

# OpenCV
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

# Ceres
find_package(Ceres REQUIRED)
include_directories(${CERES_INCLUDE_DIRS})

# g2o
find_package(G2O REQUIRED)
include_directories(${G2O_INCLUDE_DIRS})

# Eigen
include_directories("/usr/include/eigen3")

add_executable(gaussNewton gaussNewton.cpp)
target_link_libraries(gaussNewton ${OpenCV_LIBS})

add_executable(ceresCurveFitting ceresCurveFitting.cpp)
target_link_libraries(ceresCurveFitting ${OpenCV_LIBS} ${CERES_LIBRARIES})

add_executable(g2oCurveFitting g2oCurveFitting.cpp)
target_link_libraries(g2oCurveFitting ${OpenCV_LIBS} ${G2O_CORE_LIBRARY} ${G2O_STUFF_LIBRARY})

```
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 特征点法
### 特征点
#### 常用特征点
- SIFT(尺度不变特征变换，Scale-Invariant Feature Transform) （1000个特征5228.7ms)
- SURF（1000个特征217.3ms)
- ORB（Oriented FAST and Rotated BRIEF）（1000个特征15.3ms)

#### 人工特征点的性质
- 可重复性（Repeatability）：相同的“区域”可以在不同的图像中被找到。
- 可区别性（Distinctiveness）：不同的“区域”有不同的表达。
- 高效率（Efficiency）：同一图像中，特征点的数量应远小于像素的数量。
- 本地性（Locality）：特征仅与一小片图像区域相关。


#### 特征点的构成
 - 关键点（Key-point）
 - 描述子（Descriptor）

#### ORB特征
- FAST角点

- BRIEF描述子（Binary Robust Independent Elementary Features）

#### 特征匹配
- 暴力匹配（Brute-Force Matcher）
- 快速近似最近邻（FLANN）

### 2D-2D：对极几何

### 三角测量

### 3D-2D：PnP

### 3D-3D：ICP


<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


## 直接法
### 引入

### 光流（Optical Flow）

### 直接法（Direct Methods）

### 直接法优缺点总结

 
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

## 高斯分布的性质
### 高斯分布
* 一维高斯分布
我们说一个随机变量 x 服从高斯分布 N (μ, σ)，那么它的概率密度函数为：
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?p(x)=\frac{1}{\sqrt{2\pi&space;}\sigma&space;}exp(-\frac{1}{2}\frac{(x-u)^{2}}{\sigma&space;^2})" title="https://latex.codecogs.com/svg.image?p(x)=\frac{1}{\sqrt{2\pi }\sigma }exp(-\frac{1}{2}\frac{(x-u)^{2}}{\sigma ^2})" />
</div>

* 高维高斯分布
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?p(x)=\frac{1}{\sqrt{(2\pi)^{N}det(\Sigma)&space;}&space;}exp(-\frac{1}{2}(x-\mu)^{T}\Sigma&space;^{-1}(x-\mu))" title="https://latex.codecogs.com/svg.image?p(x)=\frac{1}{\sqrt{(2\pi)^{N}det(\Sigma) } }exp(-\frac{1}{2}(x-\mu)^{T}\Sigma ^{-1}(x-\mu))" />
</div>
### 高斯分布的运算
* 线性运算
设两个独立的高斯分布：

<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?x\sim&space;N(\mu_{x},\Sigma_{xx}),y\sim&space;N(\mu_{y},\Sigma_{yy})" title="https://latex.codecogs.com/svg.image?x\sim N(\mu_{x},\Sigma_{xx}),y\sim N(\mu_{y},\Sigma_{yy})" />
</div>
那么，它们的和仍是高斯分布：
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?x&plus;y\sim&space;N(\mu_{x}&plus;\mu_{y},\Sigma_{xx}&plus;\Sigma_{yy})" title="https://latex.codecogs.com/svg.image?x+y\sim N(\mu_{x}+\mu_{y},\Sigma_{xx}+\Sigma_{yy})" />
</div>
如果以常数 a 乘以 x，那么 ax 满足：
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?ax\sim&space;N(a\mu_{x},a^{2}\Sigma_{xx})" title="https://latex.codecogs.com/svg.image?ax\sim N(a\mu_{x},a^{2}\Sigma_{xx})" />
</div>
如果取 y = Ax，那么 y 满足:
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?y\sim&space;N(A\mu_{x},A\Sigma_{xx}A^{T})" title="https://latex.codecogs.com/svg.image?y\sim N(A\mu_{x},A\Sigma_{xx}A^{T})" />
</div>

* 乘积

设两个高斯分布的乘积满足 p (xy) = N (μ, Σ)，那么:

<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?\Sigma&space;^{-1}=\Sigma_{xx}^{-1}&plus;\Sigma_{yy}^{-1}" title="https://latex.codecogs.com/svg.image?\Sigma ^{-1}=\Sigma_{xx}^{-1}+\Sigma_{yy}^{-1}" />
    <br /><br /><img src="https://latex.codecogs.com/svg.image?\Sigma&space;_{\mu}=\Sigma_{xx}^{-1}\mu_{x}&plus;\Sigma_{yy}^{-1}\mu_{y}" title="https://latex.codecogs.com/svg.image?\Sigma _{\mu}=\Sigma_{xx}^{-1}\mu_{x}+\Sigma_{yy}^{-1}\mu_{y}" />
</div>

* 复合运算

同样考虑 x 和 y，当它们不独立时，其复合分布为：
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?p(x,y)=N(\begin{bmatrix}&space;\mu_{x}\\\mu_{y}\end{bmatrix},\begin{bmatrix}&space;\Sigma_{xx}&\Sigma_{xy}&space;&space;\\&space;\Sigma_{yx}&\Sigma_{yy}&space;&space;\\\end{bmatrix})" title="https://latex.codecogs.com/svg.image?p(x,y)=N(\begin{bmatrix} \mu_{x}\\\mu_{y}\end{bmatrix},\begin{bmatrix} \Sigma_{xx}&\Sigma_{xy} \\ \Sigma_{yx}&\Sigma_{yy} \\\end{bmatrix})" />
</div>
由条件分布展开式 p (x, y) = p (x|y) p (y) 推出可以推出，条件概率 p(x|y) 满足:
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?p(x|y)=N(\mu_{x}&plus;\Sigma_{xy}\Sigma_{yy}^{-1}(y-\mu_{y}),\Sigma_{xx}-\Sigma_{xy}\Sigma_{yy}^{-1}\Sigma_{yx})" title="https://latex.codecogs.com/svg.image?p(x|y)=N(\mu_{x}+\Sigma_{xy}\Sigma_{yy}^{-1}(y-\mu_{y}),\Sigma_{xx}-\Sigma_{xy}\Sigma_{yy}^{-1}\Sigma_{yx})" />
</div>

* 复合运算的例子

下面我们举一个和卡尔曼滤波器相关的例子。考虑随机变量 x ∼ N (μx, Σxx)，另一变
量 y 满足：
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?y=Ax&plus;b&plus;w" title="https://latex.codecogs.com/svg.image?y=Ax+b+w" />
</div>
其中 A, b 为线性变量的系数矩阵和偏移量，w 为噪声项，为零均值的高斯分布：w ∼
N (0, R)。我们来看 y 的分布。根据前面的介绍，可以推出：
<div align="center">
    <br /><img src="https://latex.codecogs.com/svg.image?p(y)=N(A\mu_{x}&plus;b,A\Sigma_{xx}A^{T}&plus;R)" title="https://latex.codecogs.com/svg.image?p(y)=N(A\mu_{x}+b,A\Sigma_{xx}A^{T}+R)" />
</div>
 
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

