# Linux / Git / 服务器速查

这份笔记保留原来放在 `linux使用/readme.md` 里的命令手册内容，适合作为速查页。

## 内容范围

- 服务器连接与传文件
- Git 常用命令
- Linux 常用系统命令
- 包管理、压缩解压和文件操作

## 目录

- [Docker 教程](./docker.md)
- [linuxServer-master](https://github.com/cv-programmer/linuxServer)
- [服务器连接](#服务器连接)
- [Git 使用](#git-使用)
- [常用命令](#常用命令)

## 服务器连接

### FRP 和远程连接

```bash
apt install wget
wget https://github.com/fatedier/frp/releases/download/v0.44.0/frp_0.44.0_linux_amd64.tar.gz
tar -xzvf frp_0.44.0_linux_amd64.tar.gz
cd frp_0.44.0_linux_amd64/
./frps -c ./frps.ini
ufw disable
```

```bash
ssh mii2@140.82.40.39 -p 6000
ssh mii@140.82.40.39 -p 6009
```

### screen

```bash
screen -ls
screen -S rich
screen -r rich
screen -X rich
```

退出当前会话：

```text
Ctrl + A，然后按 D
```

参考资料：

- [部署网页](https://blog.csdn.net/qq_43596067/article/details/123443945?ops_request_misc=&request_id=&biz_id=102&utm_term=%E5%9C%A8%E6%9C%8D%E5%8A%A1%E5%99%A8%E4%B8%8A%E9%83%A8%E7%BD%B2%E4%B8%80%E4%B8%AA%E6%AD%A3%E5%B8%B8%E7%9A%84%E7%BD%91%E9%A1%B5&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-5-123443945.142^v56^new_blog_pos_by_title,201^v3^add_ask&spm=1018.2226.3001.4187)
- [个人网站](http://140.82.40.39/)

### SSH 和 SCP

```bash
sudo apt-get install openssh-server
sudo apt-get install net-tools
/etc/init.d/ssh start
/etc/init.d/ssh stop
/etc/init.d/ssh restart
ifconfig
ssh rich@113.54.217.148
ssh mii@192.168.0.116
```

上传：

```bash
scp -r amono_loop mii@192.168.0.116:/home/mii/extDisk/lq/slam
scp -r data mii@192.168.0.116:/home/mii/extDisk/lq
```

下载：

```bash
scp mii@192.168.0.116:/home/mii/picture1.jpg picture.jpg
```

免密和别名：

```bash
ssh-keygen
ssh-copy-id rich@113.54.215.241
cd ~/.ssh
touch config
gedit config
```

```text
Host rich
  HostName 113.54.215.241
  User rich
  Port 22
```

## Git 使用

### Windows

```bash
git config --global user.name "lirich674"
git config --global user.email "lirich674@gmail.com"
git init
git add -A
git add .
git add readme.txt
git commit -m "readme.txt提交"
git status
git diff readme.txt
git reflog
```

### Ubuntu

```bash
git config --global user.name "lirich674"
git config --global user.email "lirich674@gmail.com"
git init
git add -A
git add .
git commit -m "some information"
git reflog
```

### 远程仓库

```bash
ssh-keygen -t rsa -C "lirich674@gmail.com"
git remote add origin https://github.com/iredawen/yolo.git
git push -u origin master
git push origin master
```

### 分支速查

| 功能 | 命令 |
| --- | --- |
| 查看分支 | `git branch` |
| 创建分支 | `git branch name` |
| 切换分支 | `git checkout name` |
| 创建并切换分支 | `git checkout -b name` |
| 合并分支 | `git merge name` |
| 删除分支 | `git branch -D name` |

## 常用命令

### 关机 / 重启 / 注销

| 命令 | 作用 |
| --- | --- |
| `shutdown -h now` | 立即关机 |
| `shutdown -r now` | 立即重启 |
| `reboot` | 重启 |
| `poweroff` | 关机 |
| `logout` | 退出登录 shell |

### 系统信息

| 命令 | 作用 |
| --- | --- |
| `uname -a` | 查看内核 / OS / CPU 信息 |
| `hostname` | 查看主机名 |
| `whoami` | 查看当前用户 |
| `cat /proc/cpuinfo` | 查看 CPU 信息 |
| `free -m` | 查看内存 |
| `date` | 查看系统时间 |
| `htop` | 查看系统状态 |
| `top` | 查看进程状态 |

### 磁盘和分区

| 命令 | 作用 |
| --- | --- |
| `fdisk -l` | 查看分区 |
| `df -h` | 查看磁盘使用情况 |
| `du -sh /dir` | 查看目录大小 |
| `mount /dev/hda2 /mnt/hda2` | 挂载分区 |
| `umount -v /mnt/mymnt` | 卸载挂载点 |

### 用户和用户组

| 命令 | 作用 |
| --- | --- |
| `useradd codesheep` | 创建用户 |
| `userdel -r codesheep` | 删除用户 |
| `groupadd group_name` | 创建用户组 |
| `passwd` | 修改密码 |
| `id codesheep` | 查看用户信息 |

### 网络和进程

| 命令 | 作用 |
| --- | --- |
| `ifconfig` | 查看网卡配置 |
| `route -n` | 查看路由表 |
| `netstat -lntp` | 查看监听端口 |
| `ps -ef` | 查看进程 |
| `kill -s pid` | 结束进程 |

### 服务管理

| 命令 | 作用 |
| --- | --- |
| `service <服务名> status` | 查看服务状态 |
| `service <服务名> start` | 启动服务 |
| `systemctl status <服务名>` | 查看 systemd 服务状态 |
| `systemctl restart <服务名>` | 重启服务 |

### 文件和目录

| 命令 | 作用 |
| --- | --- |
| `cd` | 回到用户目录 |
| `pwd` | 查看当前路径 |
| `ls -la` | 查看目录内容 |
| `tree` | 查看树形结构 |
| `mkdir -p /tmp/dir1/dir2` | 递归创建目录 |
| `mv old_dir new_dir` | 移动或重命名 |
| `cp -a dir1 dir2` | 复制目录 |
| `find / -name file1` | 查找文件 |
| `chmod ugo+rwx dir1` | 修改权限 |
| `chown user1 file1` | 修改所有者 |

### 文件查看和处理

| 命令 | 作用 |
| --- | --- |
| `cat file1` | 查看文件内容 |
| `less file1` | 分页查看 |
| `head -2 file1` | 查看前两行 |
| `tail -f /log/msg` | 实时查看日志 |
| `grep codesheep hello.txt` | 搜索关键字 |
| `sed 's/s1/s2/g' hello.txt` | 替换文本 |
| `sort file1 file2` | 排序内容 |

### 打包和解压

| 命令 | 作用 |
| --- | --- |
| `zip -r xxx.zip file1 file2 dir1` | 打包 zip |
| `unzip xxx.zip` | 解压 zip |
| `tar -cvf xxx.tar file` | 打包 tar |
| `tar -xvf xxx.tar` | 解压 tar |
| `tar -cvfz xxx.tar.gz dir` | 打包 tar.gz |
| `tar -zxvf xxx.tar.gz` | 解压 tar.gz |
| `gzip filename` | gzip 压缩 |
| `gunzip xxx.gz` | gzip 解压 |

### RPM / YUM / DPKG / APT

| 工具 | 常用命令 |
| --- | --- |
| RPM | `rpm -qa` `rpm -ivh xxx.rpm` `rpm -e xxx` |
| YUM | `yum search pkg_name` `yum install pkg_name` `yum update` |
| DPKG | `dpkg -i xxx.deb` `dpkg -r pkg_name` `dpkg -l` |
| APT | `apt-get install pkg_name` `apt-get update` `apt-get upgrade` |

## 后续整理建议

- 如果服务器连接内容继续增长，优先拆成 `SSH与SCP.md`
- 如果 Git 命令越来越多，优先拆成 `Git速查.md`
- 当前这份文件更适合保留“常用命令总览”角色

