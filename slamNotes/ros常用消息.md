# ROS 中内置消息类型

## std_msgs

### 单类型



### 数组类型



### Head

std_msg中还包含一个特殊消息类型 :Head，表示包头，它是一个结构体，内置三个类型：

| uint32 seq      | \# 表示数据流的 sequenceID        |
| :-------------- | --------------------------------- |
| time stamp      | \# 表示时间戳                     |
| string frame_id | \# 表示当前帧数据的帧头（帧序号） |

Head类型常用于记录每帧数据的时间和序列信息，用于记录历史数据的情形。

 

以上消息类型是其他各种类型的基础，其他各种消息类型的嵌套定义归根结底都依赖以上几种类型。



## comm_msg

该类型是ros常用数据类型的集合，包括以下几种：actionlib_msgs、diagnostic_msgs、geometry_msgs、nav_msgs、sensor_msgs， 下面是几种最常用的类型的介绍：
