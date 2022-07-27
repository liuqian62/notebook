# 数位dp

## 目录

- [DP61](#DP61)
- [DP62](#DP62)



### DP61
* DP61 串

描述
```
长度不超过nn，且包含子序列“us”的、只由小写字母构成的字符串有多少个？ 答案对10^9+7取模。
所谓子序列，指一个字符串删除部分字符（也可以不删）得到的字符串。
例如，"unoacscc"包含子序列"us"，但"scscucu"则不包含子序列"us"
```

![img](https://uploadfiles.nowcoder.com/images/20210201/554662_1612175535813/8341171079082A21EC15AC4785FE83A5)
```cpp
#include <bits/stdc++.h>
using namespace std;
long long f[1000100][4];
const int p = 1e9+7;
int n;
int main()
{
    long long ans = 0;
    cin >> n;
    f[1][0] = 25;
    f[1][1] = 1;
    f[1][2] = 0;
    for (int i = 2; i <= n; i++)
    {
        f[i][0] = (f[i-1][0] * 25) % p;;
        f[i][1] = (f[i-1][1] * 25 + f[i-1][0]) % p ;
        f[i][2] = (f[i-1][1] + f[i-1][2] * 26) % p ;
        ans = (ans+ f[i][2])%p;
    }
    cout << ans;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP62
* DP62 COUNT 数字计数

描述
```
给定两个正整数a和b，求在[a,b]中的所有整数中，每个数码(digit)各出现了多少次。
```
<!-- ![img]() -->
```cpp

```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

