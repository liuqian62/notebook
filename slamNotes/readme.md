# slam notes

- [常用开源方案](https://github.com/liuqian62/notebook/tree/main/slamNotes/slam%E5%BC%80%E6%BA%90%E6%96%B9%E6%A1%88)
- [视觉SLAM相关研究](https://github.com/wuxiaolang/Visual_SLAM_Related_Research)
- [如何使用g2o](https://github.com/liuqian62/notebook/blob/main/slamNotes/use_g2o.md)
- [如何使用Ceres]()

## slam 后端一般分为两种处理方法
* 扩展卡尔曼滤波（滤波方法）
* 图优化（非线性优化方法）

## 图优化
1. 构建图。机器人位姿作为顶点，位姿间关系作为边。
2. 优化图。调整机器人的位姿（顶点）来尽量满足边的约束，使得误差最小。

