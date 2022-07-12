# 线性dp

## 目录

<div align="center">
 
   | [1-10]| [11-20] | [21-30]| [31-40]|
   | :---: | :---: |  :---: |   :---: | 
   |[1](#DP1)|[11](#DP11)| [21](#DP21)| [31](#DP31)| 
   |[2](#DP2)|[12](#DP12)| [22](#DP22)| [32](#DP32)| 
   |[3](#DP3)|[13](#DP13)| [23](#DP23)| [33](#DP33)| 
   |[4](#DP4)|[14](#DP14)| [24](#DP24)| 
   |[5](#DP5)|[15](#DP15)| [25](#DP25)| 
   |[6](#DP6)|[16](#DP16)| [26](#DP26)| 
   |[7](#DP7)|[17](#DP17)| [27](#DP27)| 
   |[8](#DP8)|[18](#DP18)| [28](#DP28)| 
   |[9](#DP9)|[19](#DP19)| [29](#DP29)| 
   |[10](#DP10)|[20](#DP20)| [30](#3DP0)| 

 
 </div>

- [DP1](#DP1)
- [DP2](#DP2)
- [DP3](#DP3)
- [DP4](#DP4)
- [DP5](#DP5)
- [DP6](#DP6)
- [DP7](#DP7)
- [DP8](#DP8)
- [DP9](#DP9)
- [DP10](#DP10)
- [DP11](#DP11)
- [DP12](#DP12)
- [DP13](#DP13)
- [DP14](#DP14)
- [DP15](#DP15)
- [DP16](#DP16)
- [DP17](#DP17)
- [DP18](#DP18)
- [DP19](#DP19)
- [DP20](#DP20)
- [DP21](#DP21)
- [DP22](#DP22)
- [DP23](#DP23)
- [DP24](#DP24)
- [DP25](#DP25)
- [DP26](#DP26)
- [DP27](#DP27)
- [DP28](#DP28)
- [DP29](#DP29)
- [DP30](#DP30)
- [DP31](#DP31)
- [DP32](#DP32)
- [DP33](#DP33)


### DP1
* DP1 斐波那契数列

描述
```
大家都知道斐波那契数列，现在要求输入一个正整数 n ，请你输出斐波那契数列的第 n 项。
斐波那契数列是一个满足
```

$$
fib(x)=\left\{\begin{matrix}
1 &x=1,2  \\
fib(x-1)+fib(x-2) &x>2  \\
\end{matrix}\right.
$$


 ```
  的数列
数据范围：1≤n≤40
要求：空间复杂度 O(1)，时间复杂度 O(n) ，本题也有时间复杂度 O(logn) 的解法
```
<!-- ![img]() -->
```cpp
#include<bits/stdc++.h>
using namespace std;

int main(){
    int num1 = 1,num2 = 1;
    int temp;
    int n;
    cin>>n;
    if(n<3){
        cout<<"1"<<endl;
        return 0;
    }
    for(int i=3;i<=n;i++){
        temp  = num2;
        num2 = num1+num2;
        num1 = temp;
    }
    cout<<num2<<endl;
    return 0;
}

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP2 跳台阶

描述
```
一只青蛙一次可以跳上1级台阶，也可以跳上2级。求该青蛙跳上一个 n 级的台阶总共有多少种跳法（先后次序不同算不同的结果）。

数据范围：0≤n≤40
要求：时间复杂度：O(n) ，空间复杂度： O(1)
```
<!-- ![img]() -->
```cpp
#include<iostream>
using namespace std;

int res(int n){
    if(n == 0){
        return 0;
    }else if (n == 1){
        return 1;
    }else if (n==2){
        return 2;
    }
    int res1 =1,res2=2,res3 =3;
    for(int i=3;i<=n;i++){
        res3 = res1 + res2;
        res1 = res2;
        res2 = res3;
    }
    return res3;
}
int main(){
    int n;
    cin>>n;
    cout<<res(n);
    return 0;
    
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP3
* DP3 跳台阶扩展问题

描述
```
一只青蛙一次可以跳上1级台阶，也可以跳上2级……它也可以跳上n级。求该青蛙跳上一个n级的台阶(n为正整数)总共有多少种跳法。

数据范围：1≤n≤20
进阶：空间复杂度 O(1) ， 时间复杂度 O(1)
```
<!-- ![img]() -->

    这里的青蛙比前面两道题的青蛙更厉害一些，他一次可以跳1阶，2阶，3阶……。
    所以要想跳到第n个台阶，我们可以从第1个台阶跳上来，也可以从第2个台阶跳上来……，所以递推公式是

    f(n)=f(n-1)+f(n-2)+……+f(2)+f(1);


    同样如果我们想跳到第n-1个台阶，也可以列出下面这个公式

    f(n-1)=f(n-2)+……+f(2)+f(1);


    通过这两个公式我们可以得出

    f(n)=2*f(n-1)

    实际上他是个等比数列
```cpp
#include<iostream>
#include <cmath>
using namespace std;

int main(){
    int n;
    cin>>n;
    cout<<pow(2,n-1);
    return 0;
    
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP4
* DP4 最小花费爬楼梯

描述
```
给定一个整数数组 cost，其中 cost[i]是从楼梯第i个台阶向上爬需要支付的费用，下标从0开始。
一旦你支付此费用，即可选择向上爬一个或者两个台阶。

你可以选择从下标为 0 或下标为 1 的台阶开始爬楼梯。

请你计算并返回达到楼梯顶部的最低花费。

数据范围：数组长度满足1≤n≤10^5，数组中的值满足1≤costi ≤10^4
  
```

    如果到第i个台阶，我们可以从第i-1个台阶跳一步上来，也可以从第i-2个台阶跳两步上来。
    哪个花费少我们就选择从哪个跳上来。我们定义dp[i]表示到第i个台阶需要的最小花费，那么我们可以得出递推公式

    dp[i] = Math.min(dp[i - 2] + cost[i - 2], dp[i - 1] + cost[i - 1]);


    其中

    dp[i - 2] + cost[i - 2]表示从第i-2个台阶跳到第i个台阶的最小花费
    dp[i - 1] + cost[i - 1]表示从第i-1个台阶跳到第i个台阶的最小花费
<!-- ![img]() -->
```cpp
#include<iostream>
#include<vector>
#include<algorithm>
using namespace std;

int main(){
    int n;
    cin>>n;
    vector<int>cost(n);
    for(int i=0;i<n;i++){
        cin>>cost[i];
    }
    vector<int>dp(n+1,0);
    for(int i=2;i<=n;i++){
        dp[i]=min(dp[i-1]+cost[i-1],dp[i-2]+cost[i-2]);
    }
    cout<<dp[n];
    return 0;
    
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP5
* DP5 有多少个不同的二叉搜索树

描述
```
给定一个由节点值从 1 到 n 的 n 个节点。请问由多少种不同的方法用这 n 个节点构成互不相同的二叉搜索树。

数据范围： 1≤n≤19 

二叉搜索树：
①若任意节点的左子树不为空，则左子树上所有结点的值均小于它根节点的值
②若任意节点的右子树不为空，则右子树上所有结点的值均大于它根节点的值
③任意结点的左、右子树也是二叉搜索树
```
<!-- ![img]() -->

    设dp(n)表示有n个结点时搜索二叉树有多少种可能，则

    Ⅰ.当头结点的值为1时，左子树为空，右子树上有n - 1个结点，右子树的搜索二叉树个数为dp(n - 1)

    Ⅱ.当头结点的值为i(1 < i < n)时，左子树由结点1—>i-1构成，右子树由结点i+1—>n构成；
    左子树的搜索二叉树个数为dp(i-1),右子树的搜索二叉树个数为dp(n - i);
    此时搜索二叉树总的个数为dp(i - 1) * dp(n - i)

    Ⅲ.当头结点的值为n时，右子树为空，左子树上有n - 1个结点，左子树的搜索二叉树个数为dp(n - 1)

    所以，n个结点时搜索二叉树的个数上述三个步骤的和。

    递推公式：
    dp(n)=dp(0)dp(n-1)+dp(1)dp(n-2)+dp(2)dp(n-3)+…+dp(n-1)dp(0)

```cpp
#include <iostream>
#include <algorithm>
#include <vector>
 
using namespace std;
int res(int n){
    //dp[i]表示有i个结点时二叉树有多少种可能
        vector<int> dp(n + 1,0);
        //初始化
        dp[0] = 1;
        dp[1] = 1;
        
        //因为计算dp[n]需要知道dp[0]--->dp[n-1]。所以第一层循环是为了求dp[i]
        for (int i = 2; i <= n; i++) {
            //当有i个结点时，左子树的节点个数可以为0-->i-1个。剩下的是右子树。
            for (int j = 0; j < i; j++) {
                dp[i] += dp[j] * dp[i - j - 1];
            }
        }
        return dp[n];
}

int main(){
    int n;
    cin>>n;
    cout<<res(n)<<endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP6
* DP6 连续子数组最大和

描述
```
给定一个长度为 n的数组，数组中的数为整数。
请你选择一个非空连续子数组，使该子数组所有数之和尽可能大，子数组最小长度为1。求这个最大值。
输入描述：
第一行为一个正整数 n，代表数组的长度。 1≤n≤2∗10^5
 
第二行为 n个整数ai ，用空格隔开，代表数组中的每一个数。|ai|≤10^2
 
```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP1
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP2
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP3
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP3
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP3
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP3
* DP1 dosomething

描述
```

```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


