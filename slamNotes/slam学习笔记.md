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
[ros21讲](https://github.com/huchunxu/ros_21_tutorials)   
[ros学习笔记](./ros学习笔记.md)  
[ros常用消息](./ros常用消息.md)
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

### 根据特征点匹配计算相机运动
根据特征点匹配计算相机运动.根据相机的成像原理不同,分为以下3种情况：

当相机为单目时,我们只知道匹配点的像素坐标,是为2D-2D匹配,使用对极几何求解.  
当相机为双目或RGB-D时,我们就知道匹配点的像素坐标和深度坐标,是为3D-3D匹配,使用ICP求解.  
如果有3D点及其在相机的投影位置,也能估计相机的运动,是为3D-2D匹配,使用PnP求解.  

### 2D-2D：对极几何

* 对极约束

![7-7](./images/7-7.png)
我们希望求取两帧图像 I1; I2 之间的运动，设第一帧到第二帧的运动为 R; t。两
个相机中心分别为 O1; O2。现在，考虑 I1 中有一个特征点 p1，它在 I2 中对应着特征点 p2。我们知道
两者是通过特征匹配得到的。如果匹配正确，说明它们确实是同一个空间点在两个成像平面上的投
影。这里需要一些术语来描述它们之间的几何关系。首先，连线 !
O1p1 和连线 !
O2p2 在三维空间中会
相交于点 P 。这时候点 O1; O2; P 三个点可以确定一个平面，称为极平面（Epipolar plane）。O1O2 连
线与像平面 I1; I2 的交点分别为 e1; e2。e1; e2 称为极点（Epipoles），O1O2 被称为基线（Baseline）。
我们称极平面与两个像平面 I1; I2 之间的相交线 l1; l2 为极线（Epipolar line）。
直观讲，从第一帧的角度看，射线 !
O1p1 是某个像素可能出现的空间位置——因为该射线上的
所有点都会投影到同一个像素点。同时，如果不知道 P 的位置，那么当我们在第二幅图像上看时，
连线 !e2p2（也就是第二幅图像中的极线）就是 P 可能出现的投影的位置，也就是射线 !
O1p1 在第二
个相机中的投影。现在，由于我们通过特征点匹配确定了 p2 的像素位置，所以能够推断 P 的空间位
置，以及相机的运动。要提醒读者的是，这多亏了正确的特征匹配。如果没有特征匹配，我们就没
法确定 p2 到底在极线的哪个位置了。那时，就必须在极线上搜索以获得正确的匹配，这将在第 12
讲中提到。
现在，我们从代数角度来看一下这里的几何关系。在第一帧的坐标系下，设 P 的空间位置为
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?P=[X,Y,Z]^T" title="https://latex.codecogs.com/svg.image?P=[X,Y,Z]^T" />
</div>
根据针孔相机模型，我们知道两个像素点 p1; p2 的像素位置为
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?s_{1}p_{1}=KP,s_{2}p_{2}=K(RP&plus;t)" title="https://latex.codecogs.com/svg.image?s_{1}p_{1}=KP,s_{2}p_{2}=K(RP+t)" />
</div>
这里 K 为相机内参矩阵，R; t 为两个坐标系的相机运动。具体来说，这里计算的是 R21 和 t21，
因为它们把第一个坐标系下的坐标转换到第二个坐标系下。如果我们愿意，也可以把它们写成李代
数形式。
有时候，我们会使用齐次坐标表示像素点。在使用齐次坐标时，一个向量将等于它自身乘上任
意的非零常数。这通常用于表达一个投影关系。例如 s1p1 和 p1 成投影关系，它们在齐次坐标的意
义下是相等的。我们称这种相等关系为尺度意义下相等（equal up to a scale），记作
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?sp\simeq&space;p" title="https://latex.codecogs.com/svg.image?sp\simeq p" />
</div>
那么，上述两个投影关系可写为：
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?p_{1}\simeq&space;KP,p_{2}\simeq&space;K(RP&plus;t)" title="https://latex.codecogs.com/svg.image?p_{1}\simeq KP,p_{2}\simeq K(RP+t)" />
</div>
现在，取:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?x_{1}=K^{-1}P_{1},x_{2}=K^{-1}P_{2}" title="https://latex.codecogs.com/svg.image?x_{1}=K^{-1}P_{1},x_{2}=K^{-1}P_{2}" />
</div>
这里的 x1; x2 是两个像素点的归一化平面上的坐标。代入上式，得:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?x_{2}\simeq&space;Rx_{1}&plus;t" title="https://latex.codecogs.com/svg.image?x_{2}\simeq Rx_{1}+t" />
</div>
两边同时左乘 t^。回忆 ^ 的定义，这相当于两侧同时与 t 做外积：
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?t^{\wedge&space;}x_{2}\simeq&space;t^{\wedge&space;}Rx_{1}" title="https://latex.codecogs.com/svg.image?t^{\wedge }x_{2}\simeq t^{\wedge }Rx_{1}" />
</div>
然后，两侧同时左乘 $ x_{2}^{T} $ ：
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?x_{2}^{T}t^{\wedge&space;}x_{2}\simeq&space;x_{2}^{T}t^{\wedge&space;}Rx_{1}" title="https://latex.codecogs.com/svg.image?x_{2}^{T}t^{\wedge }x_{2}\simeq x_{2}^{T}t^{\wedge }Rx_{1}" />
</div>
观察等式左侧，t^x2 是一个与 t 和 x2 都垂直的向量。把它再和 x2 做内积时，将得到 0。由于
等式左侧严格为零，那么乘以任意非零常数之后也为零，于是我们可以把 ≃ 写成通常的等号。因此，
我们就得到了一个简洁的式子
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?x_{2}^{T}t^{\wedge&space;}Rx_{1}=0" title="https://latex.codecogs.com/svg.image?x_{2}^{T}t^{\wedge }Rx_{1}=0" />
</div>
重新代入 p1; p2，有:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?p_{2}^{T}K^{-T}t^{\wedge&space;}RK^{-1}p_{1}=0" title="https://latex.codecogs.com/svg.image?p_{2}^{T}K^{-T}t^{\wedge }RK^{-1}p_{1}=0" />
</div>
这两个式子都称为对极约束，它以形式简洁著名。它的几何意义是 O1; P; O2 三者共面。对极约
束中同时包含了平移和旋转。我们把中间部分记作两个矩阵：基础矩阵（Fundamental Matrix）F 和
本质矩阵（Essential Matrix）E，于是可以进一步简化对极约束：
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?E=t^{\wedge&space;}R,F=K^{-T}EK^{-1},x_{2}^{T}Ex_{2}=p_{2}^{T}Fp_{1}=0" title="https://latex.codecogs.com/svg.image?E=t^{\wedge }R,F=K^{-T}EK^{-1},x_{2}^{T}Ex_{2}=p_{2}^{T}Fp_{1}=0" />
</div>

对极约束简洁地给出了两个匹配点的空间位置关系。于是，相机位姿估计问题变为以下两步：
1.根据配对点的像素位置求出 E 或者 F 
2.根据 E 或者 F 求出 R; t
由于 E 和 F 只相差了相机内参，而内参在 SLAM 中通常是已知的，所以实践当中往往使用
形式更简单的 E。

* 本质矩阵

根据定义，本质矩阵 E = t^R。它是一个 3 x3 的矩阵，内有 9 个未知数。那么，是不是任意
一个 3 x3 的矩阵都可以被当成本质矩阵呢？从 E 的构造方式上看，有以下值得注意的地方：
• 本质矩阵是由对极约束定义的。由于对极约束是等式为零的约束，所以对 E 乘以任意非零
常数后，对极约束依然满足。我们把这件事情称为 E 在不同尺度下是等价的。
• 根据 E = t^R，可以证明，本质矩阵 E 的奇异值必定是 [; ; 0]T 的形式。这称为本质矩
阵的内在性质。
• 另一方面，由于平移和旋转各有 3 个自由度，故 t^R 共有 6 个自由度。但由于尺度等价性，
故 E 实际上有 5 个自由度。
E 具有 5 个自由度的事实，表明我们最少可以用 5 对点来求解 E。但是，E 的内在性质是一
种非线性性质，在估计时会带来麻烦，因此，也可以只考虑它的尺度等价性，使用 8 对点来估计 E
——这就是经典的八点法（Eight-point-algorithm）。八点法只利用了 E 的线性性质，因此可
以在线性代数框架下求解。下面我们来看八点法是如何工作的。
考虑一对匹配点，它们的归一化坐标为 x1 = [u1; v1; 1]T, x2 = [u2; v2; 1]T。根据对极约束，有
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?(u_{2},v_{2},1)\begin{pmatrix}e_{1}&space;&e_{2}&space;&space;&e_{3}&space;&space;\\e_{4}&space;&e_{5}&space;&space;&e_{6}&space;&space;\\e_{7}&space;&e_{8}&space;&space;&e_{9}&space;\\\end{pmatrix}\begin{pmatrix}u_{1}&space;\\v_{1}&space;\\1\end{pmatrix}=0" title="https://latex.codecogs.com/svg.image?(u_{2},v_{2},1)\begin{pmatrix}e_{1} &e_{2} &e_{3} \\e_{4} &e_{5} &e_{6} \\e_{7} &e_{8} &e_{9} \\\end{pmatrix}\begin{pmatrix}u_{1} \\v_{1} \\1\end{pmatrix}=0" />
</div>
我们把矩阵 E 展开，写成向量的形式:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?e=[e_{1},e_{2},e_{3},e_{4},e_{5},e_{6},e_{7},e_{8},e_{9}]^{T}" title="https://latex.codecogs.com/svg.image?e=[e_{1},e_{2},e_{3},e_{4},e_{5},e_{6},e_{7},e_{8},e_{9}]^{T}" />
</div>
那么对极约束可以写成与 e 有关的线性形式:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?[u_{2}u_{1},u_{2}v_{1},u_{2},v_{2}u_{1},v_{2}v_{1},v_{2},u_{1},v_{1},1]\cdot&space;e=0" title="https://latex.codecogs.com/svg.image?[u_{2}u_{1},u_{2}v_{1},u_{2},v_{2}u_{1},v_{2}v_{1},v_{2},u_{1},v_{1},1]\cdot e=0" />
</div>
同理，对于其他点对也有相同的表示。我们把所有点都放到一个方程中，变成线性方程组(ui,vi表示第i个特征点)：
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\begin{pmatrix}&space;u_{2}^{1}u_{1}^{1}&u_{2}^{1}v_{1}^{1}&space;&space;&u_{2}^{1}&space;&space;&v_{2}^{1}u_{1}^{1}&space;&space;&v_{2}^{1}v_{1}^{1}&space;&space;&v_{2}^{1}&space;&space;&u_{1}^{1}&space;&space;&v_{1}^{1}&space;&space;&1&space;&space;\\&space;u_{2}^{2}u_{1}^{2}&u_{2}^{2}v_{1}^{2}&space;&space;&u_{2}^{2}&space;&space;&v_{2}^{2}u_{1}^{2}&space;&space;&v_{2}^{2}v_{1}^{2}&space;&space;&v_{2}^{2}&space;&space;&u_{1}^{2}&space;&space;&v_{1}^{2}&space;&space;&1&space;&space;\\&space;\vdots&space;&\vdots&space;&space;&space;&\vdots&space;&space;&space;&\vdots&space;&space;&space;&\vdots&space;&space;&space;&\vdots&space;&space;&space;&\vdots&space;&space;&space;&\vdots&space;&space;&space;&\vdots&space;&space;&space;\\&space;u_{2}^{8}u_{1}^{8}&u_{2}^{8}v_{1}^{8}&space;&space;&u_{2}^{8}&space;&space;&v_{2}^{8}u_{1}^{8}&space;&space;&v_{2}^{8}v_{1}^{8}&space;&space;&v_{2}^{8}&space;&space;&u_{1}^{8}&space;&space;&v_{1}^{8}&space;&space;&1&space;&space;\\\end{pmatrix}\begin{pmatrix}&space;e_{1}\\&space;e_{2}\\&space;e_{3}\\&space;e_{4}\\&space;e_{5}\\&space;e_{6}\\&space;e_{7}\\&space;e_{8}\\e_{9}\end{pmatrix}=0" title="https://latex.codecogs.com/svg.image?\begin{pmatrix} u_{2}^{1}u_{1}^{1}&u_{2}^{1}v_{1}^{1} &u_{2}^{1} &v_{2}^{1}u_{1}^{1} &v_{2}^{1}v_{1}^{1} &v_{2}^{1} &u_{1}^{1} &v_{1}^{1} &1 \\ u_{2}^{2}u_{1}^{2}&u_{2}^{2}v_{1}^{2} &u_{2}^{2} &v_{2}^{2}u_{1}^{2} &v_{2}^{2}v_{1}^{2} &v_{2}^{2} &u_{1}^{2} &v_{1}^{2} &1 \\ \vdots &\vdots &\vdots &\vdots &\vdots &\vdots &\vdots &\vdots &\vdots \\ u_{2}^{8}u_{1}^{8}&u_{2}^{8}v_{1}^{8} &u_{2}^{8} &v_{2}^{8}u_{1}^{8} &v_{2}^{8}v_{1}^{8} &v_{2}^{8} &u_{1}^{8} &v_{1}^{8} &1 \\\end{pmatrix}\begin{pmatrix} e_{1}\\ e_{2}\\ e_{3}\\ e_{4}\\ e_{5}\\ e_{6}\\ e_{7}\\ e_{8}\\e_{9}\end{pmatrix}=0" />
</div>
这 8 个方程构成了一个线性方程组。它的系数矩阵由特征点位置构成，大小为 8  9。e 位于该
矩阵的零空间中。如果系数矩阵是满秩的（即秩为 8），那么它的零空间维数为 1，也就是 e 构成一
条线。这与 e 的尺度等价性是一致的。如果 8 对匹配点组成的矩阵满足秩为 8 的条件，那么 E 的各
元素就可由上述方程解得。
接下来的问题是如何根据已经估得的本质矩阵 E，恢复出相机的运动 R; t。这个过程是由奇异
值分解（SVD）得到的。设 E 的 SVD 分解为
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?E=U\Sigma&space;&space;V^{T}" title="https://latex.codecogs.com/svg.image?E=U\Sigma V^{T}" />
</div>
其中 U ; V 为正交阵，Σ 为奇异值矩阵。根据 E 的内在性质，我们知道 Σ = diag(; ; 0)。在 SVD
分解中，对于任意一个 E，存在两个可能的 t; R 与它对应：
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\begin{matrix}&space;t_{1}^{\wedge&space;}=UR_{Z}(\frac{\pi&space;}{2})\Sigma&space;U^{T},R_{1}=UR_{Z}^{T}(\frac{\pi&space;}{2})V^{T}\\t_{2}^{\wedge&space;}=UR_{Z}(-\frac{\pi&space;}{2})\Sigma&space;U^{T},R_{2}=UR_{Z}^{T}(-\frac{\pi&space;}{2})V^{T}\end{matrix}" title="https://latex.codecogs.com/svg.image?\begin{matrix} t_{1}^{\wedge }=UR_{Z}(\frac{\pi }{2})\Sigma U^{T},R_{1}=UR_{Z}^{T}(\frac{\pi }{2})V^{T}\\t_{2}^{\wedge }=UR_{Z}(-\frac{\pi }{2})\Sigma U^{T},R_{2}=UR_{Z}^{T}(-\frac{\pi }{2})V^{T}\end{matrix}" />
</div>
其中 RZ ( π
2 ) 表示沿 Z 轴旋转 90◦ 得到的旋转矩阵。同时，由于 E 和 E 等价，所以对任意一
个 t 取负号，也会得到同样的结果。因此，从 E 分解到 t; R 时，一共存在 4 个可能的解。

![7-10](./images/7-10.png)

剩下的问题还有一个：根据线性方程解出的 E，可能不满足 E 的内在性质——它的奇异值不一
定为 ; ; 0 的形式。这时，我们会刻意地把 Σ 矩阵调整成上面的样子。通常的做法是，对八点法求
得的 E 进行 SVD 分解后，会得到奇异值矩阵 Σ = diag(1; 2; 3)，不妨设 1 ⩾ 2 ⩾ 3。取：
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?E=Udiag(\frac{\sigma&space;_{1}&plus;\sigma&space;_{2}}{2},\frac{\sigma&space;_{1}&plus;\sigma&space;_{2}}{2},0)V^{T}" title="https://latex.codecogs.com/svg.image?E=Udiag(\frac{\sigma _{1}+\sigma _{2}}{2},\frac{\sigma _{1}+\sigma _{2}}{2},0)V^{T}" />
</div>

这相当于是把求出来的矩阵投影到了 E 所在的流形上。当然，更简单的做法是将奇异值矩阵取成
diag(1; 1; 0)，因为 E 具有尺度等价性，所以这样做也是合理的。

* 单应矩阵

除了基本矩阵和本质矩阵，二视图几何中还存在另一种常见的矩阵：单应矩阵（Homography）
H，它描述了两个平面之间的映射关系。若场景中的特征点都落在同一平面上（比如墙、地面等），
则可以通过单应性来进行运动估计。这种情况在无人机携带的俯视相机或扫地机携带的顶视相机中
比较常见。由于之前没有提到过单应，因此这里稍微介绍一下。
单应矩阵通常描述处于共同平面上的一些点在两张图像之间的变换关系。考虑在图像 I1 和 I2
有一对匹配好的特征点 p1 和 p2。这些特征点落在平面 P 上，设这个平面满足方程：
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?n^{T}P&plus;d=0" title="https://latex.codecogs.com/svg.image?n^{T}P+d=0" />
</div>
即
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?-\frac{n^{T}P}{d}=1" title="https://latex.codecogs.com/svg.image?-\frac{n^{T}P}{d}=1" />
</div>
得
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\begin{align*}&space;p_{2}&=K(RP&plus;t)&space;\\&space;&=K(RP&plus;t\cdot&space;(-\frac{n^{T}P}{d}))&space;\\&space;&=K(R-\frac{tn^{T}}{d})P&space;\\&space;&=K(R-\frac{tn^{T}}{d})K^{-1}p_{1}\end{align*}" title="https://latex.codecogs.com/svg.image?\begin{align*} p_{2}&=K(RP+t) \\ &=K(RP+t\cdot (-\frac{n^{T}P}{d})) \\ &=K(R-\frac{tn^{T}}{d})P \\ &=K(R-\frac{tn^{T}}{d})K^{-1}p_{1}\end{align*}" />
</div>
于是，我们得到了一个直接描述图像坐标 p1 和 p2 之间的变换，把中间这部分记为 H，于是:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?p_{2}\simeq&space;Hp_{1}" title="https://latex.codecogs.com/svg.image?p_{2}\simeq Hp_{1}" />
</div>
它的定义与旋转、平移及平面的参数有关。与基础矩阵 F 类似，单应矩阵 H 也是一个 3 x3 的
矩阵，求解时的思路也和 F 类似，同样可以先根据匹配点计算 H，然后将它分解以计算旋转和平
移。把上式展开，得：

 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\begin{pmatrix}&space;u_{2}\\&space;v_{2}\\1\end{pmatrix}=\begin{pmatrix}&space;h_{1}&h_{2}&space;&space;&h_{3}&space;&space;\\&space;h_{4}&h_{5}&space;&space;&h_{6}&space;&space;\\&space;h_{7}&h_{8}&space;&space;&h_{9}&space;&space;\\\end{pmatrix}\begin{pmatrix}u_{1}&space;\\v_{1}&space;\\1\end{pmatrix}" title="https://latex.codecogs.com/svg.image?\begin{pmatrix} u_{2}\\ v_{2}\\1\end{pmatrix}=\begin{pmatrix} h_{1}&h_{2} &h_{3} \\ h_{4}&h_{5} &h_{6} \\ h_{7}&h_{8} &h_{9} \\\end{pmatrix}\begin{pmatrix}u_{1} \\v_{1} \\1\end{pmatrix}" />
</div>
请注意，这里的等号是在非零因子下成立的。我们在实际处理中通常乘以一个非零因子使得
h9 = 1（在它取非零值时）。然后根据第 3 行，去掉这个非零因子，于是有:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\begin{matrix}&space;u_{2}=\frac{h_{1}u_{1}&plus;h_{2}v_{1}&plus;h_{3}}{h_{7}u_{1}&plus;h_{8}v_{1}&plus;h_{9}}\\&space;v_{2}=\frac{h_{4}u_{1}&plus;h_{5}v_{1}&plus;h_{6}}{h_{7}u_{1}&plus;h_{8}v_{1}&plus;h_{9}}\end{matrix}" title="https://latex.codecogs.com/svg.image?\begin{matrix} u_{2}=\frac{h_{1}u_{1}+h_{2}v_{1}+h_{3}}{h_{7}u_{1}+h_{8}v_{1}+h_{9}}\\ v_{2}=\frac{h_{4}u_{1}+h_{5}v_{1}+h_{6}}{h_{7}u_{1}+h_{8}v_{1}+h_{9}}\end{matrix}" />
</div>
整理得:

 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\begin{matrix}&space;h_{1}u_{1}&plus;h_{2}v_{1}&plus;h_{3}-h_{7}u_{1}u_{2}-h_{8}v_{1}u_{2}=u_{2}\\&space;h_{4}u_{1}&plus;h_{5}v_{1}&plus;h_{6}-h_{7}u_{1}v_{2}-h_{8}v_{1}v_{2}=v_{2}\end{matrix}" title="https://latex.codecogs.com/svg.image?\begin{matrix} h_{1}u_{1}+h_{2}v_{1}+h_{3}-h_{7}u_{1}u_{2}-h_{8}v_{1}u_{2}=u_{2}\\ h_{4}u_{1}+h_{5}v_{1}+h_{6}-h_{7}u_{1}v_{2}-h_{8}v_{1}v_{2}=v_{2}\end{matrix}" />
</div>
这样一组匹配点对就可以构造出两项约束（事实上有三个约束，但是因为线性相关，只取前两
个），于是自由度为 8 的单应矩阵可以通过 4 对匹配特征点算出（注意，这些特征点不能有三点共
线的情况），即求解以下的线性方程组（当 h9 = 0 时，右侧为零）:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\begin{pmatrix}&space;u_{1}^{1}&v_{1}^{1}&space;&space;&1&space;&space;&0&space;&space;&0&space;&space;&0&space;&space;&-u_{1}^{1}u_{2}^{1}&space;&space;&-v_{1}^{1}u_{2}^{1}&space;&space;\\&space;0&0&space;&space;&0&space;&space;&u_{1}^{1}&v_{1}^{1}&space;&space;&1&space;&space;&-u_{1}^{1}v_{2}^{1}&space;&space;&-v_{1}^{1}v_{2}^{1}&space;&space;\\&space;u_{1}^{2}&v_{1}^{2}&space;&space;&1&space;&space;&0&space;&space;&0&space;&space;&0&space;&space;&-u_{1}^{2}u_{2}^{2}&space;&space;&-v_{1}^{2}u_{2}^{2}&space;&space;\\&space;0&0&space;&space;&0&space;&space;&u_{1}^{2}&v_{1}^{2}&space;&space;&1&space;&space;&-u_{1}^{2}v_{2}^{2}&space;&space;&-v_{1}^{2}v_{2}^{2}&space;&space;\\&space;u_{1}^{3}&v_{1}^{3}&space;&space;&1&space;&space;&0&space;&space;&0&space;&space;&0&space;&space;&-u_{1}^{3}u_{2}^{3}&space;&space;&-v_{1}^{3}u_{2}^{3}&space;&space;\\&space;0&0&space;&space;&0&space;&space;&u_{1}^{3}&v_{1}^{3}&space;&space;&1&space;&space;&-u_{1}^{3}v_{2}^{3}&space;&space;&-v_{1}^{3}v_{2}^{3}&space;&space;\\&space;u_{1}^{4}&v_{1}^{4}&space;&space;&1&space;&space;&0&space;&space;&0&space;&space;&0&space;&space;&-u_{1}^{4}u_{2}^{4}&space;&space;&-v_{1}^{4}u_{2}^{4}&space;&space;\\&space;0&0&space;&space;&0&space;&space;&u_{1}^{4}&v_{1}^{4}&space;&space;&1&space;&space;&-u_{1}^{4}v_{2}^{4}&space;&space;&-v_{1}^{4}v_{2}^{4}&space;&space;\\\end{pmatrix}\begin{pmatrix}&space;h_{1}\\&space;h_{2}\\&space;h_{3}\\&space;h_{4}\\&space;h_{5}\\&space;h_{6}\\&space;h_{7}\\h_{8}\end{pmatrix}=\begin{pmatrix}&space;u_{2}^{1}\\&space;v_{2}^{1}\\&space;u_{2}^{2}\\&space;v_{2}^{2}\\&space;u_{2}^{3}\\&space;v_{2}^{3}\\&space;u_{2}^{4}\\v_{2}^{4}\end{pmatrix}" title="https://latex.codecogs.com/svg.image?\begin{pmatrix} u_{1}^{1}&v_{1}^{1} &1 &0 &0 &0 &-u_{1}^{1}u_{2}^{1} &-v_{1}^{1}u_{2}^{1} \\ 0&0 &0 &u_{1}^{1}&v_{1}^{1} &1 &-u_{1}^{1}v_{2}^{1} &-v_{1}^{1}v_{2}^{1} \\ u_{1}^{2}&v_{1}^{2} &1 &0 &0 &0 &-u_{1}^{2}u_{2}^{2} &-v_{1}^{2}u_{2}^{2} \\ 0&0 &0 &u_{1}^{2}&v_{1}^{2} &1 &-u_{1}^{2}v_{2}^{2} &-v_{1}^{2}v_{2}^{2} \\ u_{1}^{3}&v_{1}^{3} &1 &0 &0 &0 &-u_{1}^{3}u_{2}^{3} &-v_{1}^{3}u_{2}^{3} \\ 0&0 &0 &u_{1}^{3}&v_{1}^{3} &1 &-u_{1}^{3}v_{2}^{3} &-v_{1}^{3}v_{2}^{3} \\ u_{1}^{4}&v_{1}^{4} &1 &0 &0 &0 &-u_{1}^{4}u_{2}^{4} &-v_{1}^{4}u_{2}^{4} \\ 0&0 &0 &u_{1}^{4}&v_{1}^{4} &1 &-u_{1}^{4}v_{2}^{4} &-v_{1}^{4}v_{2}^{4} \\\end{pmatrix}\begin{pmatrix} h_{1}\\ h_{2}\\ h_{3}\\ h_{4}\\ h_{5}\\ h_{6}\\ h_{7}\\h_{8}\end{pmatrix}=\begin{pmatrix} u_{2}^{1}\\ v_{2}^{1}\\ u_{2}^{2}\\ v_{2}^{2}\\ u_{2}^{3}\\ v_{2}^{3}\\ u_{2}^{4}\\v_{2}^{4}\end{pmatrix}" />
</div>

这种做法把 H 矩阵看成了向量，通过解该向量的线性方程来恢复 H，又称直接线性变换法
（Direct Linear Transform）。与本质矩阵相似，求出单应矩阵以后需要对其进行分解，才可以得到相
应的旋转矩阵 R 和平移向量 t。分解的方法包括数值法[52, 53] 与解析法[54]。与本质矩阵的分解类似，
单应矩阵的分解同样会返回 4 组旋转矩阵与平移向量，并且同时可以计算出它们分别对应的场景点
所在平面的法向量。如果已知成像的地图点的深度全为正值（即在相机前方），则又可以排除两组
解。最后仅剩两组解，这时需要通过更多的先验信息进行判断。通常我们可以通过假设已知场景平
面的法向量来解决，如场景平面与相机平面平行，那么法向量 n 的理论值为 1T。
单应性在 SLAM 中具有重要意义。当特征点共面或者相机发生纯旋转时，基础矩阵的自由度下
降，这就出现了所谓的退化（degenerate）。现实中的数据总包含一些噪声，这时候如果继续使用八
点法求解基础矩阵，基础矩阵多余出来的自由度将会主要由噪声决定。为了能够避免退化现象造成
的影响，通常我们会同时估计基础矩阵 F 和单应矩阵 H，选择重投影误差比较小的那个作为最终
的运动估计矩阵。





### 三角测量

在单目 SLAM 中，仅通过单张图像无法
获得像素的深度信息，我们需要通过三角测量（Triangulation）（或三角化）的方法来估计地图点的
深度。
![7-11](./images/7-11.png)

三角测量是指，通过在两处观察同一个点的夹角，从而确定该点的距离。三角测量最早由高斯
提出并应用于测量学中，它在天文学、地理学的测量中都有应用。例如，我们可以通过不同季节观
察到的星星的角度，估计它离我们的距离。在 SLAM 中，我们主要用三角化来估计像素点的距离。
和上一节类似，考虑图像 I1 和 I2，以左图为参考，右图的变换矩阵为 T。相机光心为 O1 和 O2。
在 I1 中有特征点 p1，对应 I2 中有特征点 p2。理论上直线 O1p1 与 O2p2 在场景中会相交于一点 P，
该点即两个特征点所对应的地图点在三维场景中的位置。然而由于噪声的影响，这两条直线往往无
法相交。因此，可以通过最二小乘法求解。

按照对极几何中的定义，设 x1, x2 为两个特征点的归一化坐标，那么它们满足：

<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?s_{1}x_{1}=s_{2}Rx_{2}&plus;t" title="https://latex.codecogs.com/svg.image?s_{1}x_{1}=s_{2}Rx_{2}+t" />
</div>

现在我们已经知道了 R, t，想要求解的是两个特征点的深度 s1, s2。当然这两个深度是可以分开
求的，比如，先来看 s2。如果要算 s2，那么先对上式两侧左乘一个 x∧1 ，得：

<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?s_{1}x_{1}^{\wedge&space;}x_{1}=0=s_{2}x_{1}^{\wedge&space;}Rx_{2}&plus;x_{1}^{\wedge&space;}t" title="https://latex.codecogs.com/svg.image?s_{1}x_{1}^{\wedge }x_{1}=0=s_{2}x_{1}^{\wedge }Rx_{2}+x_{1}^{\wedge }t" />
</div>

该式左侧为零，右侧可看成 s2 的一个方程，可以根据它直接求得 s2。有了 s2，s1 也非常容易
求出。于是，我们就得到了两帧下的点的深度，确定了它们的空间坐标。当然，由于噪声的存在，我
们估得的 R, t 不一定精确使式为零，所以更常见的做法是求最小二乘解而不是零解。





### 3D-2D：PnP
2D-2D的对极几何方法需要8个或8个以上的点对（以八点法为例），且存在着初始化、纯旋转和尺度的问题。然而，  
如果两张图像中其中一张特征点的3D位置已知，那么最少只需3个点对（需要至少一个额外点验证结果）就可以估计相机运动。

在双目或RGB-D的视觉里程计中，我们可以直接使用PnP估计相机运动。而在单目视觉里程计中，必须先进行初始化，然后才能使用PnP。

PnP问题有多种解决方法:

1. 直接线性表变换(DLT): 先求解相机位姿,再求解空间点位置  
2. P3P: 先求解空间点位置,再求解相机位姿
3. Bundle Adjustment: 最小化重投影误差,同时求解空间点位置和相机位姿

* 直接线性变换(DLT): 先求解相机位姿,再求解空间点位置
考虑某个空间点P PP的齐次世界坐标为P = ( X , Y , Z , 1 )^T .在图像I_1
 中投影到特征点的归一化像素坐标x 1 = ( u 1 , v 1 , 1 )^T .此时相机的位姿Rt是未知的,定义增广矩阵[R∣t](不同于变换矩阵T)
 为一个3×4的矩阵,包含了旋转与平移信息,展开形式如下:
 <div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?s\begin{pmatrix}&space;u_{1}\\&space;v_{1}\\1\end{pmatrix}=\begin{pmatrix}&space;t_{1}&t_{2}&space;&space;&t_{3}&space;&space;&t_{4}&space;&space;\\&space;t_{5}&t_{6}&space;&space;&t_{7}&space;&space;&t_{8}&space;&space;\\&space;t_{9}&t_{10}&space;&space;&t_{11}&space;&space;&t_{12}&space;&space;\\\end{pmatrix}\begin{pmatrix}&space;X\\&space;Y\\&space;Z\\1\end{pmatrix}" title="https://latex.codecogs.com/svg.image?s\begin{pmatrix} u_{1}\\ v_{1}\\1\end{pmatrix}=\begin{pmatrix} t_{1}&t_{2} &t_{3} &t_{4} \\ t_{5}&t_{6} &t_{7} &t_{8} \\ t_{9}&t_{10} &t_{11} &t_{12} \\\end{pmatrix}\begin{pmatrix} X\\ Y\\ Z\\1\end{pmatrix}" />
</div>
 用最后一行把s消去,得到两个约束:
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\left\{\begin{matrix}t_{1}^{T}P-t_{3}^{T}Pu_{1}=0&space;\\t_{2}^{T}P-t_{3}^{T}Pv_{1}=0\end{matrix}\right." title="https://latex.codecogs.com/svg.image?\left\{\begin{matrix}t_{1}^{T}P-t_{3}^{T}Pu_{1}=0 \\t_{2}^{T}P-t_{3}^{T}Pv_{1}=0\end{matrix}\right." />
</div>
其中t 1 = ( t 1 , t 2 , t 3 , t 4 ) ^T ,t 2 = ( t 5 , t 6 , t 7 , t 8 ) ^T  ,t 3 = ( t 9 , t 10 , t 11 , t 12 ) ^T .
t 1 ,t 2  ,t 3 为待求量.将N NN对匹配的特征点代入方程中,得到线性方程组:
<div align="center"> 
  <br />
</div>

* P3P: 先求解空间点位置,再求解相机位姿

<div align="center"> 
  <br />
</div>
<div align="center"> 
  <br />
</div>
* Bundle Adjustment: 最小化重投影误差,同时求解空间点位置和相机位姿

<div align="center"> 
  <br />
</div>
<div align="center"> 
  <br />
</div>
<div align="center"> 
  <br />
</div>
<div align="center"> 
  <br />
</div>
<div align="center"> 
  <br />
</div>
<div align="center"> 
  <br />
</div>
<div align="center"> 
  <br />
</div>
<div align="center"> 
  <br />
</div>
### 3D-3D：ICP
对于一组已配对好的3D点:
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?P=\left\{&space;p_{1},\ldots,p_{n}\right\},P'=\left\{&space;p_{1}',\ldots,p_{n}'\right\}" title="https://latex.codecogs.com/svg.image?P=\left\{ p_{1},\ldots,p_{n}\right\},P'=\left\{ p_{1}',\ldots,p_{n}'\right\}" />
</div>
现在,想要找一个欧氏变换R,t使得:
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\forall&space;i,&space;p_{i}=Rp_{i}'&plus;t" title="https://latex.codecogs.com/svg.image?\forall i, p_{i}=Rp_{i}'+t" />
</div>
ICP问题的求解包含两种方式:

利用线性代数的求解(主要是SVD)  
利用非线性优化方式的求解(类似于Bundle Adjustment)  
* SVD方法

定义第i对点的误差项为：
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?e_{i}=p_{i}-(Rp_{i}'&plus;t)" title="https://latex.codecogs.com/svg.image?e_{i}=p_{i}-(Rp_{i}'+t)" />
</div>
定义两组点的质心:

<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?p=\frac{1}{n}\sum_{i=1}^{n}(p_{i}),p'=\frac{1}{n}\sum_{i=1}^{n}(p_{i}')" title="https://latex.codecogs.com/svg.image?p=\frac{1}{n}\sum_{i=1}^{n}(p_{i}),p'=\frac{1}{n}\sum_{i=1}^{n}(p_{i}')" />
</div>
构建最小二乘问题,求取最合适的R,t:
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\underset{R,t}{min}J&space;=\frac{1}{2}\sum_{i=1}^{n}\left\|(p_{i}-(Rp_{i}'&plus;t))&space;\right\|_{2}^{2}=&space;\frac{1}{2}\sum_{i=1}^{n}\left\|p_{i}-p-R(p_{i}'-p')&space;\right\|^{2}&plus;\left\|p-Rp'-t&space;\right\|^{2}" title="https://latex.codecogs.com/svg.image?\underset{R,t}{min}J =\frac{1}{2}\sum_{i=1}^{n}\left\|(p_{i}-(Rp_{i}'+t)) \right\|_{2}^{2}= \frac{1}{2}\sum_{i=1}^{n}\left\|p_{i}-p-R(p_{i}'-p') \right\|^{2}+\left\|p-Rp'-t \right\|^{2}" />
</div>
左边只和旋转矩阵R相关,而右边既有R也有t,但只和质心相关.因此令左边取最小值解出R,代入到右边令式子等于0求出t.

定义去质心坐标qi=pi-p,qi'=pi'-p',则优化目标可写成:
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?R^{*}&space;=&space;\underset{R}{min}\sum_{i=1}^{n}\left\|p_{i}-p-R(p_{i}'-p')&space;\right\|^{2}&space;\\&space;=&space;\underset{R}{min}\sum_{i=1}^{n}-q_{i}^{T}Rq_{i}'&space;\\=-tr(R\sum_{i=1}^{n}q_{i}'q_{i}^{T})" title="https://latex.codecogs.com/svg.image?R^{*} = \underset{R}{min}\sum_{i=1}^{n}\left\|p_{i}-p-R(p_{i}'-p') \right\|^{2} \\ = \underset{R}{min}\sum_{i=1}^{n}-q_{i}^{T}Rq_{i}' \\=-tr(R\sum_{i=1}^{n}q_{i}'q_{i}^{T})" />
</div>
定义矩阵:
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?W=\sum_{i=1}^{n}q_{i}q_{i}'^{T}" title="https://latex.codecogs.com/svg.image?W=\sum_{i=1}^{n}q_{i}q_{i}'^{T}" />
</div>
对矩阵W WW进行SVD分解得到:
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?W=U\Sigma&space;V^{T}" title="https://latex.codecogs.com/svg.image?W=U\Sigma V^{T}" />
</div>

* 非线性优化方法
使用李代数表达表达位姿,目标函数可以写成

<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\underset{\xi&space;}{min}\frac{1}{2}\sum_{i=1}^{n}\left\|(p_{i}-exp(\xi&space;^{\Lambda&space;})p_{i}')&space;\right\|_{2}^{2}" title="https://latex.codecogs.com/svg.image?\underset{\xi }{min}\frac{1}{2}\sum_{i=1}^{n}\left\|(p_{i}-exp(\xi ^{\Lambda })p_{i}') \right\|_{2}^{2}" />
</div>
误差项关于位姿的导数可以用李代数求导的扰动模型,计算导数得到:
<div align="center"> 
  <br /><img src="https://latex.codecogs.com/svg.image?\frac{\partial&space;e}{\partial&space;\delta&space;\xi&space;}=-(exp(\xi&space;^{\Lambda&space;})p_{i}')" title="https://latex.codecogs.com/svg.image?\frac{\partial e}{\partial \delta \xi }=-(exp(\xi ^{\Lambda })p_{i}')" />
</div>
可以直接使用最小二乘优化方法求解位姿.

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

