# ROS 中内置消息类型

## std_msgs

### 单类型



### 数组类型



### Head

std_msg中还包含一个特殊消息类型 :Head，表示包头，它是一个结构体，内置三个类型：

```cpp
uint32 seq			# 表示数据流的 sequenceID
time stamp			# 表示时间戳
string frame_id  	# 表示当前帧数据的帧头（帧序号）
```



Head类型常用于记录每帧数据的时间和序列信息，用于记录历史数据的情形。 

以上消息类型是其他各种类型的基础，其他各种消息类型的嵌套定义归根结底都依赖以上几种类型。



## comm_msg

源代码：https://github.com/ros/common_msgs

该类型是ros常用数据类型的集合，包括以下几种：actionlib_msgs、diagnostic_msgs、geometry_msgs、nav_msgs、sensor_msgs， 下面是几种最常用的类型的介绍：

### geometry_msgs

是最常用的几何消息类型，定义了描述机器人状态的各种类型，比如点、速度、加速度、位姿等。



#### Vector3、Vector3Stamped

* geometry_msgs/Vector3.msg

表示自由空间的三维向量，是一个结构体，内置三个类型：

```cpp
 float64 x
 float64 y
 float64 z
```



注意：该类型仅用于表示方向，tf2中只能应用于（rotation）旋转，不能应用于变换（transtion）,若想用于变换，需要用到geometry_msgs/Point类型。

* geometry_msgs/Vector3Stamped.msg

表示带有时间戳和参考坐标系的三维向量

```cpp
std_msgs/Header header
geometry_msgs/Vector3 vector
```



#### Quaternion、QuaternionStamped

* geometry_msgs/Quaternion.msg

用四元数表示自由空间中的旋转：

```cpp
float64 x
float64 y
float64 z
float64 w
```



* geometry_msgs/QuaternionStamped.msg

表示带有参考坐标系和时间戳的旋转：

```cpp
std_msgs/Header header
geometry_msgs/Quaternion quaternion
```



#### Transform、TransformStamped

* geometry_msgs/Transform.msg

表示自由空间的两个坐标系之间的变换关系，包括旋转和平移。旋转用四元数表示，平移用平移向量表示：

```cpp
geometry_msgs/Vector3 translation
geometry_msgs/Quaternion rotation
```

* geometry_msgs/TransformStamped.msg

表示从Head里面的坐标系到子坐标系的变换：

```cpp
std_msgs/Header header
string child_frame_id                               #子坐标系
geometry_msgs/Transform transform
```

#### Point、Point32、PointStamped

* geometry_msgs/Point.msg

表示自由空间中的点：

```cpp
float64 x
float64 y
float64 z
```

* geometry_msgs/Point32.msg

为了在发送点云时减少数据量，ros提供了压缩版的point32：

```cpp
float32 x
float32 y
float32 z
```

* geometry_msgs/PointStamped.msg

带有参考坐标系和时间戳的point：

```cpp
std_msgs/Header header
geometry_msgs/Point point
```

#### Pose、Pose2D、PoseArray、PoseStamped、PoseWithCovariance、PoseWithCovarianceStamp

* geometry_msgs/Pose.msg

位姿，即位置和姿态，用point表示位置，用四元数表示姿态：

```cpp
geometry_msgs/Point position
geometry_msgs/Quaternion orientation
```

* geometry_msgs/Pose2D.msg

表示二维平面上面的一个点(表示2D流形上的位置和方向)：

```cpp
float64 x
float64 y
float64 theta
```

* geomtry_msgs/PoseArray.msg

表示全局坐标系下的一组轨迹点：

```cpp
std_msgs/Header header                         #head里面保存了参考系
geometry_msgs/Pose[] poses
```

* geometry_msgs/PoseStamped.msg

表示带有时间戳和参考系的位姿：

```cpp
std_msgs/Header header
geometry_msgs/Pose pose
```

* geometry_msgs/PoseWithCovariance.msg

表示带有协方差矩阵的位姿估计，协方差矩阵表示其不确定度，用6*6的矩阵表示协方差，对应表示绕xyz三轴的不确定度

```cpp
geometry_msgs/Pose pose
float64[36] covariance
```

* geometry_msgs/PoseWithCovarianceStamped.msg

表示带有时间戳和坐标系的位姿估计

```cpp
Header header
PoseWithCovariance pose
```

#### Twist、TwistStamped、TwistWithCovariance、TwistWithCovarianceStamped

* geometry_msgs/Twist.msg

表示自由空间的一组速度，包括线速度和角速度

```cpp
geometry_msgs/Vector3 linear
geometry_msgs/Vector3 angular
```

* geometry_msgs/TwistStamped.msg

表示带有时间戳和参考坐标系的速度

```cpp
std_msgs/Header header
geometry_msgs/Twist twist
```

* geometry_msgs/TwistWithCovariance.msg

表示带有协方差表示不确定度的速度估计

```cpp
geometry_msgs/Twist twist
float64[36] covariance
```

* geometry_msgs/TwistWithCovarianceStamped.msg

表示带有时间戳和参考坐标系的速度估计

```cpp
std_msgs/Header header
geometry_msgs/TwistWithCovariance twist
```

#### Accel、AccelStamped、AccelWithCovariance、AccelWithCovarianceStamped

* geometry_msgs/Accel.msg

表示自由空间的一组加速度，包括线加速度和角加速度

```cpp
geometry_msgs/Vector3 linear
geometry_msgs/Vector3 angular
```

* geometry_msgs/AccelStamped.msg

表示带有时间戳和参考坐标系的加速度

```cpp
std_msgs/Header header
geometry_msgs/Accel accel
```

* geometry_msgs/AccelWithCovariance.msg

表示带有协方差表示不确定度的加速度估计

```cpp
geometry_msgs/Accel accel
float64[36] covariance
```

* geometry_msgs/AccelWithCovarianceStamped.msg

表示带有时间戳和参考坐标系的加速度估计

```cpp
std_msgs/Header header
geometry_msgs/AccelWithCovariance accel
```

#### Ploygon、PloygonStamped

* geometry_msgs/Accel.msg

表示自由空间的一块区域，用首位相连的一组点表示

```cpp
geometry_msgs/Point32[] points
```

* geometry_msgs/AccelStamped.msg

表示带有参考坐标系和时间戳的自由空间的一块区域

```cpp
std_msgs/Header header
geometry_msgs/Polygon polygon
```

