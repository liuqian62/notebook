# 线性dp

## 目录

<div align="center">
 
   | [TOP1-10]| [TOP11-20] | [TOP21-30]| [TOP31-40]|
   | :---: | :---: |  :---: |   :---: | 
   |[1](#1)|[11](#11)| [21](#21)| [31](#31)| 
   |[2](#2)|[12](#12)| [22](#22)| [32](#32)| 
   |[3](#3)|[13](#13)| [23](#23)| [33](#33)| 
   |[4](#4)|[14](#14)| [24](#24)| 
   |[5](#5)|[15](#15)| [25](#25)| 
   |[6](#6)|[16](#16)| [26](#26)| 
   |[7](#7)|[17](#17)| [27](#27)| 
   |[8](#8)|[18](#18)| [28](#28)| 
   |[9](#9)|[19](#19)| [29](#29)| 
   |[10](#10)|[20](#20)| [30](#30)| 

 
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


