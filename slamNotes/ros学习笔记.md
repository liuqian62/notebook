# ros学习笔记
[ros21讲](https://github.com/huchunxu/ros_21_tutorials)

## 目录
* [基础概述](#基础概述)
* [核心概念](#核心概念)
* [编程基础](#编程基础)
* [常用组件](#常用组件)
* [进阶展望](#进阶展望)

### 基础概述
**课程介绍**

**Linux系统介绍及安装**

**Linux系统基础操作**

**C++/Python极简基础**

**安装ROS系统**


<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### 核心概念

**ROS是什么**

**ROS中的核心概念**

**ROS命令行工具使用**


<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### 编程基础

**创建工作空间与功能包**


**话题编程**

**服务编程**

**参数的使用与编程方法**



<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### 常用组件

**tf坐标系统**

**launch启动文件的使用方法**

Launch文件：通过XML文件实现多节点的配置和启动（可自动启动ROS Master）
```launch
<launch>
    <node pkg="learning_topic" type="person_subscriber" name="talker" output="screen" />
    <node pkg="learning_topic" type="person_publisher" name="listener" output="screen" /> 
</launch>
```
* `<node>`
  * 启动节点
```launch
<node pkg="package-name" type="executable-name" name="node-name"  />
```
  * pkg:节点所在的功能包名称
  * type:节点的可执行文件名称
  * name:节点运行时的名称
  * output,respawn,required,ns,args

* 参数设置
  * `<param>/<rosparam>`
设置ROS系统运行中的参数，存储在参数服务器中
```launch
<param name="output_frame"   value="odom"/>
```
   * name:参数名
   * value:参数值

加载参数文件中的多个参数：
```launch
<rosparam file="$(find learning_launch)/config/param.yaml" command="load" ns="params"/>
```
param.yaml
```yaml
A: 123
B: "hello"

group:
  C: 456
  D: "hello"
```

  * `<arg>`
launch文件内部的局部变量，仅限于launch文件使用
```launch
<arg name="arg-name"   default="arg-value"/>
```
   * name:参数名
   * value:参数值
调用
```launch
<param name="foo"   value="$(arg arg-name"/>
<node name="node" pkg="package" type="type" args="$(arg arg-name)"/>
```
* 重映射
  * `<remap>`
重映射ROS计算图资源的命名
```launch
<remap from="/turtlebot/cmd_vel"   to="/cmd_vel"/>
```
   * from:原命名
   * to:映射之后的命名

* 嵌套
  * `<include>`
包含其他launch文件，类似C语言中的头文件包含
```launch
<include file="$(dirname)/other.launch"/>
```
   * file:包含的其他launch文件的路径

示例
```launch
<launch>

	<param name="/turtle_number"   value="2"/>

    <node pkg="turtlesim" type="turtlesim_node" name="turtlesim_node">
		<param name="turtle_name1"   value="Tom"/>
		<param name="turtle_name2"   value="Jerry"/>

		<rosparam file="$(find learning_launch)/config/param.yaml" command="load"/>
	</node>

    <node pkg="turtlesim" type="turtle_teleop_key" name="turtle_teleop_key" output="screen"/>

</launch>
```



**常用可视化工具使用**

* Qt工具箱
  * 日志输出工具--rqt_console
  * 计算图可视化工具--rqt_graph
  * 数据绘图工具--rqt_plot
  * 图像渲染工具--rqt_image_view

* Rviz--一款三维可视化工具
  * 机器人模型
  * 坐标
  * 运动规划
  * 导航
  * 点云
  * 图像 

```
3D视图区
工具栏
显示项列表
视角设置区
时间显示区
```

* Gazebo--三维物理仿真平台
  * 具备强大的物理引擎
  * 高质量的图形渲染
  * 方便的编程与图形接口
  * 开源免费

典型应用场景包括
* 测试机器人算法
* 机器人的设计
* 现实场景下的回溯测试

```
3D视图区
工具栏
模型列表
模型属性项
时间显示区
```


<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### 进阶展望

**课程总结与进阶攻略**

* 机器人仿真与控制
* 同时定位与建图
* 运动规划
* 资源整理
  * [ROS](https://www.ros.org/)
  * [ROS Wiki](http://wiki.ros.org/cn)
  * [ROSCon2012~2019](https://roscon.ros.org/2022/)
  * [ROS Robots](https://robots.ros.org/)
  * [Ubuntu Wiki](https://wiki.ubuntu.com/)
  * [古月居](https://www.gyj.ai)
  * [zhangerlay的专栏](https://blog.csdn.net/zhangrelay)
  * [易科机器人实验室](https://blog.exbot.net/)
  * [开源机器人学学习指南](https://github.com/qqfly/how-to-learn-robotics)


<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

