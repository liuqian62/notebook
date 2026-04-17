# How to use Ceres
# 如何使用 Ceres

这页不是完整手册，而是一页“先能上手”的 Ceres 使用笔记。

如果只记一句话：

- `Ceres` 适合把问题写成“参数块 + 残差块 + 鲁棒核”的非线性最小二乘形式

在 SLAM 里它常用来做：

- 曲线拟合
- PnP / BA 精修
- 相机标定
- 多传感器外参优化

## 1. Ceres 在解决什么问题

`Ceres Solver` 官方教程说明它求解的是带 loss function 的非线性最小二乘问题：

$$
\min_{x}\ \frac{1}{2}\sum_i \rho_i \left(\|f_i(x_{i_1},...,x_{i_k})\|^2\right)
$$

来源：<https://ceres-solver.org/nnls_tutorial.html>

这和很多视觉问题天然匹配，因为我们经常就在最小化：

- 重投影误差
- 几何残差
- 外参误差

## 2. 先记住 Ceres 的四个核心对象

### 2.1 `Problem`

它是整个优化问题的容器。

你会往里面不断加：

- 参数块
- 残差块

```cpp
ceres::Problem problem;
```

### 2.2 `ParameterBlock`

参数块就是“待优化变量”。

例如：

- 相机位姿
- 路标点
- 曲线参数
- 相机内参

最简单时，它就是一段 `double*` 内存。

例如三维参数：

```cpp
double abc[3] = {0.0, 0.0, 0.0};
```

### 2.3 `ResidualBlock`

残差块就是一项观测误差。

比如一条观测可能对应：

- 一个 2D-3D 重投影误差
- 一个曲线拟合误差
- 一个外参约束误差

Ceres 会把很多 residual block 累加起来一起优化。

### 2.4 `LossFunction`

鲁棒核用来减小异常值的影响。

最常见的比如：

- `HuberLoss`
- `CauchyLoss`

这在 SLAM 里非常重要，因为：

- 匹配点里常常有 outlier
- 不加鲁棒核，优化容易被坏点拖偏

## 3. Ceres 最常见的建模方式

官方教程里最常见的方式是：

1. 定义一个 cost functor
2. 用自动求导包装成 `AutoDiffCostFunction`
3. 加到 `Problem`
4. 配置 `Solver::Options`
5. 调 `ceres::Solve`

## 4. 一个最小可运行示例

下面用最常见的曲线拟合例子说明。

目标：

$$
y = \exp(ax^2 + bx + c)
$$

根据一批观测点去估计 `a,b,c`。

### 4.1 定义残差

```cpp
struct CurveFittingCost {
  CurveFittingCost(double x, double y) : x_(x), y_(y) {}

  template <typename T>
  bool operator()(const T* const abc, T* residual) const {
    residual[0] = T(y_) - ceres::exp(abc[0] * T(x_) * T(x_) +
                                     abc[1] * T(x_) +
                                     abc[2]);
    return true;
  }

  const double x_;
  const double y_;
};
```

这里要点有三个：

1. `operator()` 是残差定义的核心  
2. `abc` 是参数块  
3. `residual[0]` 是这一条观测对应的误差

### 4.2 构建问题

```cpp
double abc[3] = {0.0, 0.0, 0.0};
ceres::Problem problem;

for (int i = 0; i < N; ++i) {
  ceres::CostFunction* cost_function =
      new ceres::AutoDiffCostFunction<CurveFittingCost, 1, 3>(
          new CurveFittingCost(x_data[i], y_data[i]));

  problem.AddResidualBlock(cost_function, nullptr, abc);
}
```

这行是关键：

```cpp
new ceres::AutoDiffCostFunction<CurveFittingCost, 1, 3>(...)
```

它的含义是：

- 残差类型是 `CurveFittingCost`
- 残差维度是 `1`
- 参数块维度是 `3`

### 4.3 配置求解器并求解

```cpp
ceres::Solver::Options options;
options.linear_solver_type = ceres::DENSE_NORMAL_CHOLESKY;
options.minimizer_progress_to_stdout = true;

ceres::Solver::Summary summary;
ceres::Solve(options, &problem, &summary);

std::cout << summary.BriefReport() << std::endl;
std::cout << abc[0] << " " << abc[1] << " " << abc[2] << std::endl;
```

## 5. 这段最小示例到底对应什么结构

可以直接记成：

- `double abc[3]`：参数块
- `CurveFittingCost`：残差定义
- `AutoDiffCostFunction`：自动求导包装器
- `AddResidualBlock(...)`：把一条观测加进优化问题
- `Solve(...)`：开始优化

## 6. 自动求导是怎么回事

`Ceres` 很好用的一个原因就是自动求导。

官方教程里强调：

- 通常优先使用自动求导
- 它比数值求导更准确
- 比手写雅可比更省事

来源：<https://ceres-solver.org/automatic_derivatives.html>

### 6.1 为什么自动求导适合 SLAM

因为很多残差长这样：

- 重投影误差
- 位姿变换后的像素误差
- 外参误差

它们都不算短，手写 Jacobian 容易错。

### 6.2 什么时候还会手写雅可比

通常在下面几种情况会考虑：

- 对效率特别敏感
- 残差结构已知且很好写
- 自动求导模板链太复杂

但入门和大多数中小问题，优先自动求导通常是更稳的选择。

## 7. 鲁棒核怎么加

如果你担心 outlier，可以在 `AddResidualBlock` 里传一个 loss function：

```cpp
problem.AddResidualBlock(
    cost_function,
    new ceres::HuberLoss(1.0),
    abc);
```

这表示：

- 这条残差用 Huber 核

### 7.1 为什么 SLAM 里经常需要鲁棒核

因为视觉匹配里常有：

- 错误匹配
- 动态点
- 深度异常
- 遮挡导致的大误差

不加鲁棒核时，少数坏点就可能严重影响优化。

### 7.2 常见几种核怎么记

- `HuberLoss`：最常用，比较稳
- `CauchyLoss`：对大残差压制更强
- `nullptr`：不加鲁棒核

## 8. Ceres 里一个更贴近 BA 的思路

在 BA 里，一条观测通常会依赖多个参数块，比如：

- 相机位姿
- 三维点
- 相机内参

这时残差 functor 的输入就会变成多个参数块：

```cpp
template <typename T>
bool operator()(const T* const pose,
                const T* const point,
                const T* const intrinsics,
                T* residual) const {
  ...
  return true;
}
```

然后 `AddResidualBlock` 时把多个参数块一起传进去。

这也是 Ceres 和 “手写高斯牛顿”最大的使用体验差别之一：

- 你更关注残差怎么写
- 求解器负责大部分求导和线性化细节

## 9. `Solver::Options` 里最常见的几个选项

### 9.1 `linear_solver_type`

决定增量方程怎么解。

在教程和小例子里常见：

- `DENSE_NORMAL_CHOLESKY`

更大问题里还会看到：

- `SPARSE_NORMAL_CHOLESKY`
- `DENSE_QR`

### 9.2 `minimizer_progress_to_stdout`

是否把优化过程打印到终端。

```cpp
options.minimizer_progress_to_stdout = true;
```

调试时很有用。

### 9.3 `max_num_iterations`

最大迭代次数。

```cpp
options.max_num_iterations = 100;
```

### 9.4 `num_threads`

线程数。

问题比较大时可以关注。

## 10. Ceres 和 g2o 的使用差异

这一点最值得单独记。

### 10.1 Ceres 怎么想问题

你会更习惯这样想：

- 我有哪些参数
- 我有哪些残差
- 每条残差依赖哪些参数块

### 10.2 g2o 怎么想问题

你会更习惯这样想：

- 图里有哪些顶点
- 顶点之间有哪些边
- 每条边的测量和信息矩阵是什么

### 10.3 一个很实用的记忆法

- `g2o` 更像“图优化语言”
- `Ceres` 更像“残差优化语言”

## 11. 什么时候更想用 Ceres

更适合：

- 先快速验证一个最小二乘问题
- 做标定
- 做局部 BA
- 做多传感器外参优化
- 想少写 Jacobian

## 12. 什么时候更想用 g2o

更适合：

- pose graph
- 回环优化
- 顶点边结构非常明显的 BA / SLAM 问题
- 代码组织天然就是图模型

## 13. 常见坑

### 13.1 维度写错

最容易错的地方之一是：

- `AutoDiffCostFunction<Cost, residual_dim, param_dim...>`

只要这里维度错了，问题就会直接出错或结果异常。

### 13.2 参数块生命周期

参数块本质上还是你自己的内存。

也就是说：

- 传给 `Problem` 的 `double*` 要在求解期间保持有效

### 13.3 残差定义里类型没用模板 `T`

自动求导要求你在 `operator()` 里尽量用：

- `T(x_)`
- `ceres::exp(...)`

而不是混着写普通 `double` 运算。

### 13.4 一上来就不加鲁棒核

在真实 SLAM 数据里，很多时候：

- 没鲁棒核会比“算法思想不对”更早出问题

## 14. 一个最小使用模板

以后临时写 Ceres，小抄可以直接记成：

```cpp
double params[...] = {...};
ceres::Problem problem;

for (...) {
  ceres::CostFunction* cost_function =
      new ceres::AutoDiffCostFunction<MyCost, residual_dim, param_dim...>(
          new MyCost(...));

  problem.AddResidualBlock(cost_function,
                           new ceres::HuberLoss(1.0),
                           params);
}

ceres::Solver::Options options;
options.linear_solver_type = ceres::DENSE_NORMAL_CHOLESKY;
options.minimizer_progress_to_stdout = true;

ceres::Solver::Summary summary;
ceres::Solve(options, &problem, &summary);
```

## 15. 面试里怎么答“怎么用 Ceres”

一个比较顺的答法：

1. 先把问题写成非线性最小二乘  
2. 把待优化变量组织成 parameter blocks  
3. 把观测误差写成 residual blocks  
4. 需要的话加 robust loss  
5. 交给 Ceres 做自动求导和求解  

如果再补一句会更完整：

- 在视觉问题里我一般优先用自动求导，先把残差写对，再考虑性能优化和手写雅可比

## 16. 和本仓库其它内容怎么联动

- `Ceres` 在工具链里的角色总览见 [OpenCV_Eigen_g2o_Ceres在SLAM中的角色.md](./OpenCV_Eigen_g2o_Ceres在SLAM中的角色.md)
- `g2o` 速记见 [use_g2o.md](./use_g2o.md)
- 曲线拟合和基础优化例子见 [slam学习笔记.md](./slam学习笔记.md)
- 课程摘记里的示例见 [14讲.md](./14讲.md)

## 17. 本页使用的外部资料

- Ceres non-linear least squares tutorial: <https://ceres-solver.org/nnls_tutorial.html>
- Ceres automatic derivatives: <https://ceres-solver.org/automatic_derivatives.html>
