# 数位dp

## 目录

- [DP61](#DP61)
- [DP62](#DP62)



### DP61
* DP61 串

描述
```
长度不超过n，且包含子序列“us”的、只由小写字母构成的字符串有多少个？ 答案对10^9+7取模。
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

输出文件中包含一行10个整数，分别表示0-9在[a,b]中出现了多少次。
输入：1 99
输出：9 20 20 20 20 20 20 20 20 20
```

我们设dp[i][j][k]表示长度为i，开头为j的数中k的个数，一开始就推算dp数组中每个元素的值，可以枚举所有长度为iii的数字中首位和第二位的数字，
有dp[i][j][z]+=dp[i−1][k][z]，其中iii为数字位数，jjj为开头的数字，kkk为上一个长度开头的数字，zzz为当前要统计的数码。
然后我们找到1到b的答案减去1到a-1答案，在找的时候分开统计答案，对于位数小于当前数的直接全部加上，剩余的拆分统计。
<!-- ![img]() -->
```cpp
#include<iostream>
#include<vector>
#include<string.h>
using namespace std;
 
const int maxn = 15;  //最大数字不超过12位
long long dp[maxn][maxn][maxn]; //十进制数中长度为i，开头为j的数中k的个数
long long bin[maxn]; //i位中所有首位为i的数的个数
long long res[maxn]; //记录0~9个数
int d[maxn];
  
void init(){  //递推计算出每个整数
    bin[1] = 1; //1位首位为1只有1个
    for(int i = 2; i <= 13; i++) //后续都是前一个的10倍
        bin[i] = bin[i - 1] * 10;
    for(int i = 0; i <= 9; i++) //长度为1，以i开头中i的个数都是1
        dp[1][i][i]=1;
    for(int i = 2; i <= 13; i++)
        for(int j = 0; j <= 9; j++)
            for(int z = 0; z <= 9; z++){
                for(int k = 0; k <= 9; k++)
                    dp[i][j][z] += dp[i - 1][k][z]; //累加前面的
                dp[i][z][z] += bin[i - 1];
            }
}
  
void solve(long long x,int flag){ //计算1到x的所有数码出现次数
    int dnum = 0;  //记录当前数的位数
    long long y = x;
    memset(d, 0, sizeof(d));
    while(y){  //连除法计算当前x的位数
        d[++dnum] = y % 10;
        y /= 10;
    }
    for(int i = 1; i <= dnum - 1; i++)//先计算位数小于当前数的位数
        for(int j = 1; j <= 9; j++)
            for(int k = 0; k <= 9; k++)
                res[k] += (dp[i][j][k] * flag); //累加，flag为1加，-1为减
    int temp = dnum;
    while(temp){//再计算位数等于当前数的位数
        for(int i = 0; i < d[temp]; i++){
            if(!i && temp == dnum)
                continue;//不能重复计算
            for(int j = 0; j <= 9; j++)
                res[j] += (dp[temp][i][j] * flag);
        }
        res[d[temp]] += (x % bin[temp] + 1) * flag;
        temp--;
    }
}
  
int main(){  
    init();
    long long a, b;
    cin >> a >> b;
    solve(b, 1); //计算1到b的所有数码次数
    solve(a - 1, -1);  //减去1到a-1的所有数码出现次数
    for(int i = 0; i <= 9; i++) //输出
        cout << res[i] << " ";
    cout << endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>

