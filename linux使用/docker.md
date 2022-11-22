# docker
## 目录



- [安装](#安装)
- [常用命令](#常用命令)
- [挂载文件](#挂载文件)
- [提交镜像](#提交镜像)
- [dockerfile](#dockerfile)



## 安装

- [官方教程](https://docs.docker.com/engine/install/ubuntu/)


1. 卸载旧版本docker

```shell
sudo apt-get remove docker docker-engine docker.io containerd runc
```




2. 更新及安装工具软件

```shell
sudo apt-get update
```

```shell
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

```shell
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

```

```shell
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```






3. 安装docker 

```shell
sudo apt-get update
```

```shell
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

```




4. 查看是否启动docker

```shell
ps aux|grep docker
```




5. 测试运行一个docker容器

```shell
sudo docker run hello-world
```



<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

## 常用命令

* 启动docker

```bash
systemctl start docker
```
* 关闭docker

```bash
systemctl stop docker
```
* 重启docker

```bash
systemctl restart docker
```
* docker设置随服务启动而自启动

```bash
systemctl enable docker
```
* 查看docker 运行状态

```bash
systemctl status docker
```
* 查看docker 版本号信息

```bash
docker version
docker info
```
* docker帮助命令

```bash
docker --help
docker pull --help  #docker 命令 --help
```
* 查看自己服务器中docker 镜像列表

```bash
docker images
```
* 搜索镜像

```bash
docker search mysql
docker search --filter=STARS=9000 mysql
```
* 拉取镜像

```bash
docker pull mysql
docker pull mysql:5.7.30  #docker pull 镜像名:tag
```
* 运行镜像

```bash
docker run tomcat
docker run mysql:5.7.30 #docker run 镜像名:Tag
```
* 删除镜像

```bash
docker rmi -f mysql #docker rmi -f 镜像名/镜像ID
docker rmi -f mysql tomcat #删除多个
docker rmi -f $(docker images -aq) #删除全部
```
* 启动docker

```bash
systemctl start docker
```

* 强制删除镜像

```bash
docker image rm 镜像名称/镜像ID
```

* 保存镜像

```bash
docker save tomcat -o /myimg.tar
```

* 加载镜像

```bash
docker load -i myimg.tar
```


* 查看正在运行容器列表

```bash
docker ps
```


* 查看所有容器

```bash
docker ps -a
```


* 运行一个容器

```bash
docker run -it -d --name 要取的别名 镜像名:Tag /bin/bash 
docker run -it -d --name redis001 redis:5.0.5 /bin/bash
```


* 停止容器

```bash
docker stop 容器名/容器ID
docker stop redis001
```

* 删除容器

```bash
#删除一个容器
docker rm -f 容器名/容器ID
#删除多个容器 空格隔开要删除的容器名或容器ID
docker rm -f 容器名/容器ID 容器名/容器ID 容器名/容器ID
#删除全部容器
docker rm -f $(docker ps -aq)
```

* 容器端口与服务器端口映射

```bash
-p 宿主机端口:容器端口
docker run -itd --name redis002 -p 8888:6379 redis:5.0.5 /bin/bash
```

* 进入容器

```bash
docker exec -it 容器名/容器ID /bin/bash

#进入 前面的 redis001容器   
docker exec -it redis001 /bin/bash
docker attach 容器名/容器ID
```

* 退出容器

```bash
#-----直接退出  未添加 -d(持久化运行容器) 时 执行此参数 容器会被关闭  
exit
# 优雅退出 --- 无论是否添加-d 参数 执行此命令容器都不会被关闭
Ctrl + p + q
```
* kill容器

```bash
docker kill 容器ID/容器名
```
* 容器文件拷贝

```bash
#docker cp 容器ID/名称:文件路径  要拷贝到外部的路径   |     要拷贝到外部的路径  容器ID/名称:文件路径
#从容器内 拷出
docker cp 容器ID/名称: 容器内路径  容器外路径
#从外部 拷贝文件到容器内
docker  cp 容器外路径 容器ID/名称: 容器内路径
```
* 查看容器日志

```bash
docker logs -f --tail=要查看末尾多少行 默认all 容器ID
```
* 容器随docker服务启动而自动启动--restart=always

```bash
docker run -itd --name redis002 -p 8888:6379 --restart=always  redis:5.0.5 /bin/bash
```



<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

## 挂载文件

* 命令

```bash
-v 宿主机文件存储位置:容器内文件位置
-v 宿主机文件存储位置:容器内文件位置 -v 宿主机文件存储位置:容器内文件位置 -v 宿主机文件存储位置:容器内文件位置
# 运行一个docker redis 容器 进行 端口映射 两个数据卷挂载 设置开机自启动
docker run -d -p 6379:6379 --name redis505 --restart=always  -v /var/lib/redis/data/:/data -v /var/lib/redis/conf/:/usr/local/etc/redis/redis.conf  redis:5.0.5 --requirepass "password"

```



<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>
## 提交镜像
* 提交自己的镜像

```bash
docker commit -m="提交信息" -a="作者信息" 容器名/容器ID 提交后的镜像名:Tag
```






<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>
## dockerfile





<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>
