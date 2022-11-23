# ros学习笔记
[ros21讲](https://github.com/huchunxu/ros_21_tutorials)  
[ros控制小乌龟走弓字形](https://github.com/liuqian62/turtlesim_plan)  
[ros常用消息](./ros常用消息.md)

## 目录
* [基础概述](#基础概述)
* [核心概念](#核心概念)
* [编程基础](#编程基础)
* [常用组件](#常用组件)
* [进阶展望](#进阶展望)

任务：在rich目录下创建工作空间，然后创建一个test包，实现velcity_publisher
```bash
cd rich
mkdir -p catkin_ws/src
cd catkin_ws
catkin_make
cd src
catkin_create_pkg test roscpp rospy std_msgs geometry_msgs turtlesim

```
* cpp版
```bash
cd test/src
touch velocity_publisher.cpp
写入相应程序
修改CMakeLists.txt
add_executable(velocity_publisher src/velocity_publisher.cpp)
target_link_libraries(velocity_publisher ${catkin_LIBRARIES})

编译
运行

roscore
rosrun test velocity_publisher
```
* python版

```bash
cd test
mkdir scripts
cd scripts
touch velocity_publisher.py
chmod +x velocity_publisher.py

修改CMakeLists.txt
catkin_install_python(PROGRAMS
  scripts/velocity_publisher.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
    
编译运行
roscore
rosrun test velocity_publisher

```


### 基础概述
**课程介绍**

**Linux系统介绍及安装**

**Linux系统基础操作**

**C++/Python极简基础**

**安装ROS系统**
不同版本ubuntu对应的ros

|ubuntu版本|ros版本|
| :---: | :---: |
|16.04|Kinetic|
|18.04|Melodic|
|20.04|Noetic|


* 以安装18.04的`Melodic`为例
1. 设置软件源：
```bash
sudo sh -c '. /etc/lsb-release && echo "deb http://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ $DISTRIB_CODENAME main" > /etc/apt/sources.list.d/ros-latest.list'

```
2. 添加密钥
```bash
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654

```
3. 安装ROS
```bash
sudo apt-get update

sudo apt-get install ros-melodic-desktop-full

sudo apt-get install ros-melodic-rqt*

```
4. 初始化
```bash
sudo rosdep init
rosdep update

```
5. 设置环节变量
```bash
echo "source /opt/ros/melodic/setup.bash">>~/.bashrc
source ~/.bashrc
```
6. 安装rosinstall
```bash
sudo apt install python-rosinstall python-rosintsall-generator python-wstool build-essential
```
海龟示例
* 启动ROS Master
```bash
roscore
```
* 启动小海龟仿真器
```bash
rosrun turtlesim turtlesim_node
```
* 启动海龟控制节点
```bash
rosrun turtlesim turtle_teleop_keye_teleop_key
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### 核心概念

**ROS是什么**

**ROS中的核心概念**

* 节点与节点管理器
  * 节点（Node）--执行单元
    * 执行具体任务的进程、独立运行的可执行文件；
    * 不同节点可使用不同的编程语言，可分布式运行在不同的主机；
    * 节点在系统中的名称必须是唯一的。
  * 节点管理器（ROS Master）--控制中心
    * 为节点提供命名和注册服务；
    * 跟踪和记录话题/服务通信，辅助节点相互查找、建立连接；
    * 提供参数服务器，节点使用此服务器存储和检索运行时的参数。
* 话题通信
  * 话题（Topic）--异步通信机制
    * 节点间用来传输数据的重要总线；
    * 使用发布/订阅模型，数据由发布者传输到订阅者，同一个话题的订阅者或发布者可以不唯一。
  * 消息（Message）--话题数据
    * 具有一定的类型和数据结构，包括ROS提供的标准类型和用户自定义类型；
    * 使用编程语言无关的.msg文件定义，编译过程中生成对应的代码文件。
* 服务通信
  * 服务（Service）--同步通信机制
    * 使用客户端/服务器（C/S）模型，客户端发送请求数据，服务器完成处理后返回应答数据；
    * 使用编程语言无关的.srv文件定义请求和应答数据结构，编译过程中生成对应的代码文件。  

* 话题vs服务
<div align="center">
	
||话题|服务|  
|:---:|:---:|:---:|
|同步性|异步|同步|
|通信模型|发布/订阅|服务器/客户端|
|底层协议|ROSTCP/TOSUDP|ROSTCP/ROSUDP|
|反馈机制|无|有|
|缓冲区|有|无|
|实时性|弱|强|
|节点关系|多对多|一对多（一个server）|
|适用场景|数据传输|逻辑处理|
	
</div>

* 参数
  * 参数（Parameter）--全局共享字典
    * 可通过网络访问的共享、多变量字典；
    * 节点使用此服务器来存储和检索运行时的参数；
    * 适合存储静态、非二进制的配置参数，不适合存储动态配置的数据。

* 文件系统
  * 功能包（Package）
    * ROS软件中的基本单元，包含节点源码、配置文件、数据定义等
  * 功能包清单（Package manifest）
    * 记录功能包的基本信息，包含作者信息，许可信息、依赖选项、编译标志等
  * 元功能包（Meta Packages）
    * 组织多个用于同一目的的功能包      






**ROS命令行工具使用**
* 常用命令
  * rostopic
  * rosservice
  * rosnode
  * rosparam
  * rosmsg
  * rossrv
* 以小海龟为例

启动ROS Master
```bash
roscore
```
启动小海龟仿真器
```bash
rosrun turtlesim turtlesim_node
```
启动海龟控制节点
```bash
rosrun turtlesim turtle_teleop_key
```
查看计算图
```bash
rqt_graph
```
查看话题列表
```bash
rostopic list
```
发布话题消息
```bash
rostopic pub -r 10 /turtle1/cmd_vel geometry_msgs/Twist "linear:
x:1.0
y:0.0
x:0.0
angular:
x:0.0
y:0.0
z:0.0"
```
发布服务请求
```bash
rosservice call /spawn "x:5.0
y:5.0
theta:0.0
name: 'tuttle1'"
```
话题记录
```bash
rosbag record -a -O cmd_record
```
话题复现
```bash
rosbag play cmd_record.bag
```
<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### 编程基础

**创建工作空间与功能包**
* 工作空间（workspace）是一个存放工程开发相关文件的文件夹
	* src:代码空间(Source Space)
	* build:编译空间(Build Space)
	* devel:开发空间(Development Space)
	* install:安装空间(Install Space)
* 创建工作空间
```bash
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
catkin_init_workspace
```
* 编译工作空间
```bash
cd ~/catkin_ws/
catkin_make
```
* 设置环节变量
```bash
source devel/setup.bash
```
* 检查环节变量
```bash
echo $ROS_PACKAGE_PATH
```
* 创建功能包
`catkin_create_pkg <package_name> [depend1] [depend2] [depend3]`
  * 创建功能包

```bash
cd ~/catkin_ws/src
catkin_create_pkg test_pkg std_msgs rospy roscpp
```
  * 编译功能包

```bash
cd ~/catkin_ws/src
catkin_make
source ~/catkin_ws/devel/setup.bash
```

同一个工作空间下，不允许存在同名功能包

**话题编程**
* 发布者Publisher的编程实现

创建功能包
```bash
cd ~/catkin_ws/src
catkin_create_pkg learning_topic roscpp rospy std_msgs geometry_msgs turtlesim
```
* velocity_publisher.cpp

```cpp
/**
 * 该例程将发布turtle1/cmd_vel话题，消息类型geometry_msgs::Twist
 */
 
#include <ros/ros.h>
#include <geometry_msgs/Twist.h>

int main(int argc, char **argv)
{
	// ROS节点初始化
	ros::init(argc, argv, "velocity_publisher");

	// 创建节点句柄
	ros::NodeHandle n;

	// 创建一个Publisher，发布名为/turtle1/cmd_vel的topic，消息类型为geometry_msgs::Twist，队列长度10
	ros::Publisher turtle_vel_pub = n.advertise<geometry_msgs::Twist>("/turtle1/cmd_vel", 10);

	// 设置循环的频率
	ros::Rate loop_rate(10);

	int count = 0;
	while (ros::ok())
	{
	    // 初始化geometry_msgs::Twist类型的消息
		geometry_msgs::Twist vel_msg;
		vel_msg.linear.x = 0.5;
		vel_msg.angular.z = 0.2;

	    // 发布消息
		turtle_vel_pub.publish(vel_msg);
		ROS_INFO("Publsh turtle velocity command[%0.2f m/s, %0.2f rad/s]", 
				vel_msg.linear.x, vel_msg.angular.z);

	    // 按照循环频率延时
	    loop_rate.sleep();
	}

	return 0;
}
```
* CMakeLists.txt

```cmake
add_executable(velocity_publisher src/velocity_publisher.cpp)
target_link_libraries(velocity_publisher ${catkin_LIBRARIES})
```
* 编译并运行发布者

```bash
cd ~/catkin_ws
catkin_make
source devel/setup.bash
roscore
rosrun turtlesim turtlesim_node
rosrun learning_topic velocity_publisher
```
* velocity_publisher.py

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-


# 该例程将发布turtle1/cmd_vel话题，消息类型geometry_msgs::Twist

import rospy
from geometry_msgs.msg import Twist

def velocity_publisher():
	# ROS节点初始化
    rospy.init_node('velocity_publisher', anonymous=True)

	# 创建一个Publisher，发布名为/turtle1/cmd_vel的topic，消息类型为geometry_msgs::Twist，队列长度10
    turtle_vel_pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)

	#设置循环的频率
    rate = rospy.Rate(3) 

    while not rospy.is_shutdown():
		# 初始化geometry_msgs::Twist类型的消息
        vel_msg = Twist()
        vel_msg.linear.x = 0.5
        vel_msg.angular.z = 0.2

		# 发布消息
        turtle_vel_pub.publish(vel_msg)
        rospy.loginfo("Publsh turtle velocity command[%0.2f m/s, %0.2f rad/s]", vel_msg.linear.x, vel_msg.angular.z)
    	# rospy.loginfo("Publsh turtle velocity command[%0.2f m/s, %0.2f rad/s]", vel_msg.linear.x, vel_msg.angular.z)
		# 按照循环频率延时
        rate.sleep()

if __name__ == '__main__':
    try:
        velocity_publisher()
    except rospy.ROSInterruptException:
        pass

```

* 订阅者Subcriber的编程实现

pose_subscriber.cpp
```cpp
/**
 * 该例程将订阅/turtle1/pose话题，消息类型turtlesim::Pose
 */
 
#include <ros/ros.h>
#include "turtlesim/Pose.h"

// 接收到订阅的消息后，会进入消息回调函数
void poseCallback(const turtlesim::Pose::ConstPtr& msg)
{
    // 将接收到的消息打印出来
    ROS_INFO("Turtle pose: x:%0.6f, y:%0.6f", msg->x, msg->y);
}

int main(int argc, char **argv)
{
    // 初始化ROS节点
    ros::init(argc, argv, "pose_subscriber");

    // 创建节点句柄
    ros::NodeHandle n;

    // 创建一个Subscriber，订阅名为/turtle1/pose的topic，注册回调函数poseCallback
    ros::Subscriber pose_sub = n.subscribe("/turtle1/pose", 10, poseCallback);

    // 循环等待回调函数
    ros::spin();

    return 0;
}
```
* CMakeLists.txt

```cmake
add_executable(pose_subscriber src/pose_subscriber.cpp)
target_link_libraries(pose_subscriber ${catkin_LIBRARIES})
```
* 编译并运行订阅者

```bash
cd ~/catkin_ws
catkin_make
source devel/setup.bash
roscore
rosrun turtlesim turtlesim_node
rosrun learning_topic pose_subscriber
```
* pose_subcriber.py
```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-


# 该例程将订阅/turtle1/pose话题，消息类型turtlesim::Pose

import rospy
from turtlesim.msg import Pose

def poseCallback(msg):
    rospy.loginfo("Turtle pose: x:%0.6f, y:%0.6f", msg.x, msg.y)

def pose_subscriber():
	# ROS节点初始化
    rospy.init_node('pose_subscriber', anonymous=True)

	# 创建一个Subscriber，订阅名为/turtle1/pose的topic，注册回调函数poseCallback
    rospy.Subscriber("/turtle1/pose", Pose, poseCallback)

	# 循环等待回调函数
    rospy.spin()

if __name__ == '__main__':
    pose_subscriber()

```
* 话题消息的定义与使用

自定义话题消息
Person.msg
```
string name
uint8  age
uint8  sex

uint8 unknown = 0
uint8 male    = 1
uint8 female  = 2
```
* 在package.xml中添加功能包依赖

```xml
<build_depend>message_generation</build_depend>
<exec_depend>message_runtime</exec_depend>
```
* 在CMakeLists.txt添加编译选项

```cmake
find_package(...... message_generation)
add_message_files(  FILES  Person.msg)

generate_messages(  DEPENDENCIES  std_msgs)
catkin_package(   ...... message_runtime)
```
* person_publisher.cpp

```cpp
/**
 * 该例程将发布/person_info话题，自定义消息类型learning_topic::Person
 */
 
#include <ros/ros.h>
#include "learning_topic/Person.h"

int main(int argc, char **argv)
{
    // ROS节点初始化
    ros::init(argc, argv, "person_publisher");

    // 创建节点句柄
    ros::NodeHandle n;

    // 创建一个Publisher，发布名为/person_info的topic，消息类型为learning_topic::Person，队列长度10
    ros::Publisher person_info_pub = n.advertise<learning_topic::Person>("/person_info", 10);

    // 设置循环的频率
    ros::Rate loop_rate(1);

    int count = 0;
    while (ros::ok())
    {
        // 初始化learning_topic::Person类型的消息
    	learning_topic::Person person_msg;
		person_msg.name = "Tom";
		person_msg.age  = 18;
		person_msg.sex  = learning_topic::Person::male;

        // 发布消息
		person_info_pub.publish(person_msg);

       	ROS_INFO("Publish Person Info: name:%s  age:%d  sex:%d", 
				  person_msg.name.c_str(), person_msg.age, person_msg.sex);

        // 按照循环频率延时
        loop_rate.sleep();
    }

    return 0;
}

```

* person_subscriber.cpp

```cpp
/**
 * 该例程将订阅/person_info话题，自定义消息类型learning_topic::Person
 */
 
#include <ros/ros.h>
#include "learning_topic/Person.h"

// 接收到订阅的消息后，会进入消息回调函数
void personInfoCallback(const learning_topic::Person::ConstPtr& msg)
{
    // 将接收到的消息打印出来
    ROS_INFO("Subcribe Person Info: name:%s  age:%d  sex:%d", 
			 msg->name.c_str(), msg->age, msg->sex);
}

int main(int argc, char **argv)
{
    // 初始化ROS节点
    ros::init(argc, argv, "person_subscriber");

    // 创建节点句柄
    ros::NodeHandle n;

    // 创建一个Subscriber，订阅名为/person_info的topic，注册回调函数personInfoCallback
    ros::Subscriber person_info_sub = n.subscribe("/person_info", 10, personInfoCallback);

    // 循环等待回调函数
    ros::spin();

    return 0;
}
```
* CMakeLists.txt

```cmake
add_executable(person_publisher src/person_publisher.cpp)
target_link_libraries(person_publisher ${catkin_LIBRARIES})
add_dependencies(person_publisher ${PROJECT_NAME}_generate_messages_cpp)

add_executable(person_subscriber src/person_subscriber.cpp)
target_link_libraries(person_subscriber ${catkin_LIBRARIES})
add_dependencies(person_subscriber ${PROJECT_NAME}_generate_messages_cpp)
```
* 编译并运行发布者和订阅者

```bash
cd ~/catkin_ws
catkin_make
source devel/setup.bash
roscore
rosrun learning_topic person_subscriber
rosrun learning_topic person_publisher
```
* person_publisher.py

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-


# 该例程将发布/person_info话题，自定义消息类型learning_topic::Person

import rospy
from learning_topic.msg import Person

def velocity_publisher():
	# ROS节点初始化
    rospy.init_node('person_publisher', anonymous=True)

	# 创建一个Publisher，发布名为/person_info的topic，消息类型为learning_topic::Person，队列长度10
    person_info_pub = rospy.Publisher('/person_info', Person, queue_size=10)

	#设置循环的频率
    rate = rospy.Rate(10) 

    while not rospy.is_shutdown():
		# 初始化learning_topic::Person类型的消息
    	person_msg = Person()
    	person_msg.name = "Tom";
    	person_msg.age  = 18;
    	person_msg.sex  = Person.male;

		# 发布消息
        person_info_pub.publish(person_msg)
    	rospy.loginfo("Publsh person message[%s, %d, %d]", 
				person_msg.name, person_msg.age, person_msg.sex)

		# 按照循环频率延时
        rate.sleep()

if __name__ == '__main__':
    try:
        velocity_publisher()
    except rospy.ROSInterruptException:
        pass
```
* person_subscriber.py

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-


# 该例程将订阅/person_info话题，自定义消息类型learning_topic::Person

import rospy
from learning_topic.msg import Person

def personInfoCallback(msg):
    rospy.loginfo("Subcribe Person Info: name:%s  age:%d  sex:%d", 
			 msg.name, msg.age, msg.sex)

def person_subscriber():
	# ROS节点初始化
    rospy.init_node('person_subscriber', anonymous=True)

	# 创建一个Subscriber，订阅名为/person_info的topic，注册回调函数personInfoCallback
    rospy.Subscriber("/person_info", Person, personInfoCallback)

	# 循环等待回调函数
    rospy.spin()

if __name__ == '__main__':
    person_subscriber()
```


**服务编程**
* 客户端Client的编程实现
  * 创建功能包

```bash
cd ~/catkin_ws/src
catkin_create_pkg learning_service roscpp rospy std_msgs geometry_msgs turtlesim

```

* tuttle_spawn.cpp
```cpp
/**
 * 该例程将请求/spawn服务，服务数据类型turtlesim::Spawn
 */

#include <ros/ros.h>
#include <turtlesim/Spawn.h>

int main(int argc, char** argv)
{
    // 初始化ROS节点
	ros::init(argc, argv, "turtle_spawn");

    // 创建节点句柄
	ros::NodeHandle node;

    // 发现/spawn服务后，创建一个服务客户端，连接名为/spawn的service
	ros::service::waitForService("/spawn");
	ros::ServiceClient add_turtle = node.serviceClient<turtlesim::Spawn>("/spawn");

    // 初始化turtlesim::Spawn的请求数据
	turtlesim::Spawn srv;
	srv.request.x = 2.0;
	srv.request.y = 2.0;
	srv.request.name = "turtle2";

    // 请求服务调用
	ROS_INFO("Call service to spwan turtle[x:%0.6f, y:%0.6f, name:%s]", 
			 srv.request.x, srv.request.y, srv.request.name.c_str());

	add_turtle.call(srv);

	// 显示服务调用结果
	ROS_INFO("Spwan turtle successfully [name:%s]", srv.response.name.c_str());

	return 0;
};
```
* CMakeLists.txt

```cmake
add_executable(turtle_spawn src/turtle_spawn.cpp)
target_link_libraries(turtle_spawn ${catkin_LIBRARIES})
```
* 编译并运行客户端

```bash
cd ~/catkin_ws
catkin_make
source devel/setup.bash
roscore
rosrun turtlesim turtlesim_node
rosrun learning_service turtle_spawn
```

* turtle_spawn.py

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-


# 该例程将请求/spawn服务，服务数据类型turtlesim::Spawn

import sys
import rospy
from turtlesim.srv import Spawn

def turtle_spawn():
	# ROS节点初始化
    rospy.init_node('turtle_spawn')

	# 发现/spawn服务后，创建一个服务客户端，连接名为/spawn的service
    rospy.wait_for_service('/spawn')
    try:
        add_turtle = rospy.ServiceProxy('/spawn', Spawn)

		# 请求服务调用，输入请求数据
        response = add_turtle(2.0, 2.0, 0.0, "turtle2")
        return response.name
    except rospy.ServiceException, e:
        print "Service call failed: %s"%e

if __name__ == "__main__":
	#服务调用并显示调用结果
    print "Spwan turtle successfully [name:%s]" %(turtle_spawn())
```
* 服务端Server的编程实现

* turtle_command_server.cpp

```cpp
/**
 * 该例程将执行/turtle_command服务，服务数据类型std_srvs/Trigger
 */
 
#include <ros/ros.h>
#include <geometry_msgs/Twist.h>
#include <std_srvs/Trigger.h>

ros::Publisher turtle_vel_pub;
bool pubCommand = false;

// service回调函数，输入参数req，输出参数res
bool commandCallback(std_srvs::Trigger::Request  &req,
         			std_srvs::Trigger::Response &res)
{
	pubCommand = !pubCommand;

    // 显示请求数据
    ROS_INFO("Publish turtle velocity command [%s]", pubCommand==true?"Yes":"No");

	// 设置反馈数据
	res.success = true;
	res.message = "Change turtle command state!";

    return true;
}

int main(int argc, char **argv)
{
    // ROS节点初始化
    ros::init(argc, argv, "turtle_command_server");

    // 创建节点句柄
    ros::NodeHandle n;

    // 创建一个名为/turtle_command的server，注册回调函数commandCallback
    ros::ServiceServer command_service = n.advertiseService("/turtle_command", commandCallback);

	// 创建一个Publisher，发布名为/turtle1/cmd_vel的topic，消息类型为geometry_msgs::Twist，队列长度10
	turtle_vel_pub = n.advertise<geometry_msgs::Twist>("/turtle1/cmd_vel", 10);

    // 循环等待回调函数
    ROS_INFO("Ready to receive turtle command.");

	// 设置循环的频率
	ros::Rate loop_rate(10);

	while(ros::ok())
	{
		// 查看一次回调函数队列
    	ros::spinOnce();
		
		// 如果标志为true，则发布速度指令
		if(pubCommand)
		{
			geometry_msgs::Twist vel_msg;
			vel_msg.linear.x = 0.5;
			vel_msg.angular.z = 0.2;
			turtle_vel_pub.publish(vel_msg);
		}

		//按照循环频率延时
	    loop_rate.sleep();
	}

    return 0;
}
```
CMakeLists.txt
```cmake
add_executable(turtle_command_server src/turtle_command_server.cpp)
target_link_libraries(turtle_command_server ${catkin_LIBRARIES})
```
* 编译并运行服务器

```bash
cd ~/catkin_ws
catkin_make
source devel/setup.bash
roscore
rosrun turtlesim turtlesim_node
rosrun learning_service turtle_command_server
rosservice call /turtle_command "{}"
```
* turtle_command_server.py

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 该例程将执行/turtle_command服务，服务数据类型std_srvs/Trigger

import rospy
import thread,time
from geometry_msgs.msg import Twist
from std_srvs.srv import Trigger, TriggerResponse

pubCommand = False;
turtle_vel_pub = rospy.Publisher('/turtle1/cmd_vel', Twist, queue_size=10)

def command_thread():	
	while True:
		if pubCommand:
			vel_msg = Twist()
			vel_msg.linear.x = 0.5
			vel_msg.angular.z = 0.2
			turtle_vel_pub.publish(vel_msg)
			
		time.sleep(0.1)

def commandCallback(req):
	global pubCommand
	pubCommand = bool(1-pubCommand)

	# 显示请求数据
	rospy.loginfo("Publish turtle velocity command![%d]", pubCommand)

	# 反馈数据
	return TriggerResponse(1, "Change turtle command state!")

def turtle_command_server():
	# ROS节点初始化
    rospy.init_node('turtle_command_server')

	# 创建一个名为/turtle_command的server，注册回调函数commandCallback
    s = rospy.Service('/turtle_command', Trigger, commandCallback)

	# 循环等待回调函数
    print "Ready to receive turtle command."

    thread.start_new_thread(command_thread, ())
    rospy.spin()

if __name__ == "__main__":
    turtle_command_server()

```

* 服务数据的定义与使用

自定义服务数据
* Person.srv

```
string name
uint8  age
uint8  sex

uint8 unknown = 0
uint8 male    = 1
uint8 female  = 2

---
string result
```
* 在package.xml中添加功能包依赖

```xml
  <build_depend>message_generation</build_depend>
  <exec_depend>message_runtime</exec_depend>
```
* 在CMakeLists.txt中添加编译选项

```cmake
find_package(...... message_generation)

add_service_file(FILES Person.srv)
generate_messages(DEPENDENCIES std_msgs)

catkin_package(...... message_runtime)

```
* person_server.cpp

```cpp
/**
 * 该例程将执行/show_person服务，服务数据类型learning_service::Person
 */
 
#include <ros/ros.h>
#include "learning_service/Person.h"

// service回调函数，输入参数req，输出参数res
bool personCallback(learning_service::Person::Request  &req,
         			learning_service::Person::Response &res)
{
    // 显示请求数据
    ROS_INFO("Person: name:%s  age:%d  sex:%d", req.name.c_str(), req.age, req.sex);

	// 设置反馈数据
	res.result = "OK";

    return true;
}

int main(int argc, char **argv)
{
    // ROS节点初始化
    ros::init(argc, argv, "person_server");

    // 创建节点句柄
    ros::NodeHandle n;

    // 创建一个名为/show_person的server，注册回调函数personCallback
    ros::ServiceServer person_service = n.advertiseService("/show_person", personCallback);

    // 循环等待回调函数
    ROS_INFO("Ready to show person informtion.");
    ros::spin();

    return 0;
}
```
* person_client.cpp

```cpp
/**
 * 该例程将请求/show_person服务，服务数据类型learning_service::Person
 */

#include <ros/ros.h>
#include "learning_service/Person.h"

int main(int argc, char** argv)
{
    // 初始化ROS节点
	ros::init(argc, argv, "person_client");

    // 创建节点句柄
	ros::NodeHandle node;

    // 发现/spawn服务后，创建一个服务客户端，连接名为/spawn的service
	ros::service::waitForService("/show_person");
	ros::ServiceClient person_client = node.serviceClient<learning_service::Person>("/show_person");

    // 初始化learning_service::Person的请求数据
	learning_service::Person srv;
	srv.request.name = "Tom";
	srv.request.age  = 20;
	srv.request.sex  = learning_service::Person::Request::male;

    // 请求服务调用
	ROS_INFO("Call service to show person[name:%s, age:%d, sex:%d]", 
			 srv.request.name.c_str(), srv.request.age, srv.request.sex);

	person_client.call(srv);

	// 显示服务调用结果
	ROS_INFO("Show person result : %s", srv.response.result.c_str());

	return 0;
};
```
* 在CMakeLists.txt中配置编译规则

```cmake
add_executable(person_server src/person_server.cpp)
target_link_libraries(person_server ${catkin_LIBRARIES})
add_dependencies(person_server ${PROJECT_NAME}_gencpp)

add_executable(person_client src/person_client.cpp)
target_link_libraries(person_client ${catkin_LIBRARIES})
add_dependencies(person_client ${PROJECT_NAME}_gencpp)

```
* 编译并运行客户端和服务端

```bash
cd ~/catkin_ws
catkin_make
source devel/setup.bash
roscore
rosrun learning_service person_server
rosrun learning_service person_client

```

* person_server.py

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-


# 该例程将执行/show_person服务，服务数据类型learning_service::Person

import rospy
from learning_service.srv import Person, PersonResponse

def personCallback(req):
	# 显示请求数据
    rospy.loginfo("Person: name:%s  age:%d  sex:%d", req.name, req.age, req.sex)

	# 反馈数据
    return PersonResponse("OK")

def person_server():
	# ROS节点初始化
    rospy.init_node('person_server')

	# 创建一个名为/show_person的server，注册回调函数personCallback
    s = rospy.Service('/show_person', Person, personCallback)

	# 循环等待回调函数
    print "Ready to show person informtion."
    rospy.spin()

if __name__ == "__main__":
    person_server()
```
* person_client.py

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 该例程将请求/show_person服务，服务数据类型learning_service::Person

import sys
import rospy
from learning_service.srv import Person, PersonRequest

def person_client():
	# ROS节点初始化
    rospy.init_node('person_client')

	# 发现/spawn服务后，创建一个服务客户端，连接名为/spawn的service
    rospy.wait_for_service('/show_person')
    try:
        person_client = rospy.ServiceProxy('/show_person', Person)

		# 请求服务调用，输入请求数据
        response = person_client("Tom", 20, PersonRequest.male)
        return response.result
    except rospy.ServiceException, e:
        print "Service call failed: %s"%e

if __name__ == "__main__":
	#服务调用并显示调用结果
    print "Show person result : %s" %(person_client())
```



**参数的使用与编程方法**

* 创建功能包

```bash
cd ~/catkin_ws/src
catkin_create_pkg learning_parameter roscpp rospy std_srvs

```
YAML参数文件
```yaml
background_b: 255
background_g: 86
background_r: 69
rosdistro: 'melodic'
roslaunch:
  uris: {host_hcx_vpc__43763: 'http://hcx-vpc:43763/'}
rosversion: '1.14.3'
run_id: 077058de-a38b-11e9-818b-000c29d22e4d
```

rosparam
* 列出当前所有参数
```bash
rosparam list
```
* 显示某个参数值
```bash
rosparam get param_key
```
* 设置某个参数值
```bash
rosparam set param_key param_value
```
* 保存参数到文件
```bash
rosparam dump file_name
```
* 从文件读取参数
```bash
rosparam load file_name
```
* 删除参数
```bash
rosparam delete param_key
```
parameter_config.cpp
```cpp
/**
 * 该例程设置/读取海龟例程中的参数
 */
#include <string>
#include <ros/ros.h>
#include <std_srvs/Empty.h>

int main(int argc, char **argv)
{
	int red, green, blue;

    // ROS节点初始化
    ros::init(argc, argv, "parameter_config");

    // 创建节点句柄
    ros::NodeHandle node;

    // 读取背景颜色参数
	ros::param::get("/background_r", red);
	ros::param::get("/background_g", green);
	ros::param::get("/background_b", blue);

	ROS_INFO("Get Backgroud Color[%d, %d, %d]", red, green, blue);

	// 设置背景颜色参数
	ros::param::set("/background_r", 255);
	ros::param::set("/background_g", 255);
	ros::param::set("/background_b", 255);

	ROS_INFO("Set Backgroud Color[255, 255, 255]");

    // 读取背景颜色参数
	ros::param::get("/background_r", red);
	ros::param::get("/background_g", green);
	ros::param::get("/background_b", blue);

	ROS_INFO("Re-get Backgroud Color[%d, %d, %d]", red, green, blue);

	// 调用服务，刷新背景颜色
	ros::service::waitForService("/clear");
	ros::ServiceClient clear_background = node.serviceClient<std_srvs::Empty>("/clear");
	std_srvs::Empty srv;
	clear_background.call(srv);
	
	sleep(1);

    return 0;
}

```
CMakeLists.txt中配置代码编译规则
* 设置需要编译的代码和生成的可执行文件
* 设置链接库

```CMake
add_executable(parameter_config src/parameter_config.cpp)
target_link_libraries(parameter_config ${catkin_LIBRARIES})
```
* 编译并运行发布者
```bash
cd ~/catkin_ws
catkin_make
source devel/setup.bash
roscore
rosrun turtlesim turtlesim_node
rosrun learning_parameter parameter_config
```
* parameter_config.py

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

# 该例程设置/读取海龟例程中的参数

import sys
import rospy
from std_srvs.srv import Empty

def parameter_config():
	# ROS节点初始化
    rospy.init_node('parameter_config', anonymous=True)

	# 读取背景颜色参数
    red   = rospy.get_param('/background_r')
    green = rospy.get_param('/background_g')
    blue  = rospy.get_param('/background_b')

    rospy.loginfo("Get Backgroud Color[%d, %d, %d]", red, green, blue)

	# 设置背景颜色参数
    rospy.set_param("/background_r", 255);
    rospy.set_param("/background_g", 255);
    rospy.set_param("/background_b", 255);

    rospy.loginfo("Set Backgroud Color[255, 255, 255]");

	# 读取背景颜色参数
    red   = rospy.get_param('/background_r')
    green = rospy.get_param('/background_g')
    blue  = rospy.get_param('/background_b')

    rospy.loginfo("Get Backgroud Color[%d, %d, %d]", red, green, blue)

	# 发现/spawn服务后，创建一个服务客户端，连接名为/spawn的service
    rospy.wait_for_service('/clear')
    try:
        clear_background = rospy.ServiceProxy('/clear', Empty)

		# 请求服务调用，输入请求数据
        response = clear_background()
        return response
    except rospy.ServiceException, e:
        print "Service call failed: %s"%e

if __name__ == "__main__":
    parameter_config()

```


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
  * [古月居](http://www.gyh.ai)
  * [zhangerlay的专栏](https://blog.csdn.net/zhangrelay)
  * [易科机器人实验室](http://blog.exbot.net/)
  * [开源机器人学学习指南](https://github.com/qqfly/how-to-learn-robotics)


<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

