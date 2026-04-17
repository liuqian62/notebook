# notebook

个人学习笔记仓库，内容主要围绕以下几类主题：

- SLAM / 机器人相关学习与资料整理
- C++、算法刷题与面试准备
- 计算机基础四大件
- Linux / Python 常用笔记

这个仓库现在更偏“知识库”而不是单一项目，所以整理的重点放在导航、归类和入口说明上，尽量让每一层目录都能顺着找下去。

## 仓库怎么用

- 从根目录先选主题，再进入对应一级目录的 `readme.md`
- 一级目录负责“导航”，具体内容尽量放到独立笔记文件里
- 想快速定位内容时，优先看 [仓库地图](./docs/仓库地图.md)

## 一级目录导航

| 目录 | 主要内容 | 推荐入口 |
| --- | --- | --- |
| `slamNotes/` | SLAM 学习笔记、论文阅读、开源方案、激光 SLAM、3D Gaussian Splatting | [slamNotes/readme.md](./slamNotes/readme.md) |
| `牛客网刷题笔记/` | 牛客/力扣刷题笔记、TOP101、动态规划专项、算法入门 | [牛客网刷题笔记/readme.md](./牛客网刷题笔记/readme.md) |
| `基础四大件/` | 数据结构、算法、操作系统、计网、计组、数据库、设计模式 | [基础四大件/readme.md](./基础四大件/readme.md) |
| `learnCpp/` | C++ 学习笔记、面经、英语相关记录 | [learnCpp/readme.md](./learnCpp/readme.md) |
| `linux使用/` | Linux 常用命令、服务器连接、Git、Docker、开发环境 | [linux使用/readme.md](./linux使用/readme.md) |
| `python相关/` | Python 基础、虚拟环境、requirements、OpenCV、mmdetection | [python相关/readme.md](./python相关/readme.md) |

## 按目标快速找内容

- 想补 SLAM：先看 [slamNotes/readme.md](./slamNotes/readme.md)
- 想准备算法面试：先看 [牛客网刷题笔记/readme.md](./牛客网刷题笔记/readme.md)
- 想过一遍计算机基础：先看 [基础四大件/readme.md](./基础四大件/readme.md)
- 想查 Linux / Python 常用命令：看 [linux使用/readme.md](./linux使用/readme.md) 和 [python相关/readme.md](./python相关/readme.md)
- 想快速理解整个仓库：看 [docs/仓库地图.md](./docs/仓库地图.md)

## 常用快捷链接

- ROS 一键安装：<https://fishros.github.io/install/#/>
- FishROS 安装命令：

```bash
wget http://fishros.com/install -O fishros && . fishros
```

## 维护约定

- 新内容优先放进最接近主题的一级目录，不轻易新增新的同级分类
- 一级目录尽量维护自己的 `readme.md`，作为该目录的总入口
- 主题相关图片优先放在对应主题目录内，避免根目录堆积零散资源
- 旧路径尽量保持稳定，优先补索引和说明，避免大规模改名导致原有链接失效

## 附加文档

- [仓库地图](./docs/仓库地图.md)
- [README 写作备忘](./docs/README写作备忘.md)
- [文档整理约定](./docs/文档整理约定.md)

## 协作者

当前根 README 保留仓库协作者信息，便于回溯来源：

- [李琦](https://github.com/liuqian62)
- [陈玥锦](https://github.com/210-297)
- [周林峰](https://github.com/against43)
- [才昌照](https://github.com/caichangzhao)
- [荀钰婷](https://github.com/iredawen)
- [钟志超](https://github.com/WillenChung)
- [夏青云](https://github.com/delecloud)
- [李金洋](https://github.com/nankelli)
- [张亚东](https://github.com/WestMemoery)
- [杜凯](https://github.com/kayky233)
- [王轶](https://github.com/ybyzy)
- [李天晓](https://github.com/EwrinCat)
