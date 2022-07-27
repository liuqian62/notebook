# 状压dp

## 目录

- [DP59](#DP59)
- [DP60](#DP60)

### DP59
* DP59 数位染色

描述
```
小红拿到了一个正整数 x\x  。她可以将其中一些数位染成红色。然后她想让所有染红的数位数字之和等于没染色的数位数字之和。
她不知道能不能达成目标。你能告诉她吗？

输入描述：
一个正整数 x，1≤x≤10^18
 

输出描述：
如果小红能按要求完成染色，输出"Yes"。否则输出"No"。

```

具体做法
```
首先使用连除法将nnn的每位数字依次记录在数组中，并在这个过程中求得所有位数之和，那我们要找的就是能否在这个数组中找到诺干个数字加起来等于位数之和的一半。

首先排除和为奇数的情况，无法构成一半。然后我们用一个长度为和一半的dp数组，dp[i]不为0表示和为iii的情况是可以被找到的，为0代表找不到，初始化都为0。
我们遍历数组中记录的每位数字sum[i]，每次再遍历sum/2到该数字，如果dp[j]可以被相加得到，说明j−sum[i]已经得到了，或者在之前的遍历中得到过，
于是就有转移方程dp[j]=dp[j]+dp[j−num[i]]，最后我们检查dp[sum/2]是否为0即可。
```
![img](https://uploadfiles.nowcoder.com/images/20211101/397721558_1635768819545/785D47AB0FD8801B29F0E87B4F5BD5EF)
```cpp
#include<bits/stdc++.h>
using namespace std;

int main(){
    string s;
    cin>>s;
    vector<int> num; //记录数每位
    int sum = 0;
    for(int i=0;i<s.size();i++){
        int tmp=s[i]-'0';
        num.push_back(tmp);
        sum+=tmp;        
    }    
    if(sum % 2){ //数位和为奇数，无法分成两半
        cout << "No" << endl;
        return 0;
    }
    vector<int> dp(sum / 2 + 1, 0); //dp[i]不为0，表示dp[i]可以被选出的数字相加得到
    dp[0] = 1;
    for(int i = 0; i < num.size(); i++){
        for(int j = sum / 2; j >= num[i]; j--)
            dp[j] = dp[j] + dp[j - num[i]]; //能够被这两个数相加得到
    }
    if(dp[sum / 2]) //不为0
        cout << "Yes" << endl;
    else
        cout << "No" << endl;    
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP60
* DP60 郊区春游

描述
```
今天春天铁子的班上组织了一场春游，在铁子的城市里有n个郊区和m条无向道路，第i条道路连接郊区Ai和Bi，路费是Ci。经过铁子和顺溜的提议，
他们决定去其中的R个郊区玩耍（不考虑玩耍的顺序），但是由于他们的班费紧张，所以需要找到一条旅游路线使得他们的花费最少，
假设他们制定的旅游路线为V1, V2 ,V3 ... VR，那么他们的总花费为从V1到V2的花费加上V2到V3的花费依次类推，
注意从铁子班上到V1的花费和从VR到铁子班上的花费是不需要考虑的，因为这两段花费由学校报销而且我们也不打算告诉你铁子学校的位置。
输入描述：
第一行三个整数n, m, R(2 ≤ n ≤ 200, 1 ≤ m ≤ 5000, 2 ≤ R ≤ min(n, 15))。
第二行R个整数表示需要去玩耍的郊区编号。
以下m行每行Ai, Bi, Ci(1 ≤ Ai, Bi ≤ n, Ai ≠ Bi, Ci ≤ 10000)
保证不存在重边。
输出描述：
输出一行表示最小的花费


```

具体做法
```

首先我们用邻接矩阵来表示这个图，矩阵记录两两点之间的距离，初始化为最大值，自己到自己都是0，再根据输入更新直接连接的两个点的距离，然后遍历所有的两两的点，更新所有的点之间的最短距离，得到的点之间的距离都是最短的。

然后我们用dp[i][j]dp[i][j]dp[i][j]表示状态值为iii、以jjj号地为终点的所有距离最小值，其中状态值是指我们用二进制的形式表示这个地方有没有走过，走过就是1，没走过就是0，一共需要2R2^R2 
R
 个位置来表示所有状态，我们用数组代替。

初始化的时候，每个点都是结束，但也只去过这个点，因此自己到自己始终都是0。后续我们枚举所有的状态，对每个状态枚举所有的起始位置和结束位置（需要排除刚刚初始化的位置），然后更新状态： dp[(1<<k)∣i][k]=min(dp[(1<<k)∣i][k],dp[i][j]+edges[visit[j]][visit[k]])，其中i为状态，j为起始位置，k为结束位置
```
![img](https://uploadfiles.nowcoder.com/images/20211101/397721558_1635773228229/21C5488FDD2C4BEC9B50479EAB2001B7)
```cpp
#include <bits/stdc++.h>
using namespace std;
 
const int INF = 0x3f3f3f3f;
int main(){
    int n, m, R;
    cin >> n >> m >> R;
    vector<int> visit(R); //需要去的R个郊区
    for(int i = 0; i < R; i++)
        cin >> visit[i];
    vector<vector<int>> edges(n + 1, vector<int>(n + 1, INF)); //邻接矩阵记录边的花费
    for(int i = 1; i <= n; i++)
        edges[i][i] = 0; // 自己到自己是0
    for(int i = 0; i < m; i++){
        int a, b, c;
        cin >> a >> b >> c;
        edges[a][b] = c; //构建边的花费
        edges[b][a] = c;
    }
    for(int k = 1; k <= n; k++){ //获取每两两结点间的距离花费
        for(int i = 1; i <= n; i++){
            for(int j = 1; j <= n; j++){
                if(edges[i][j] > edges[i][k] + edges[k][j])
                    edges[i][j] = edges[i][k] + edges[k][j]; //更新两两之间的花费为更小的值
            }
        }
    }
    vector<vector<int> > dp(1 << R, vector<int>(R + 1, INF));
    for(int i = 0; i < R; i++)
        dp[1 << i][i] = 0; //最开始走的那个，没有花费
    for(int i = 1; i < (1 << R) - 1; i++){ //枚举所有的状态
        for(int j = 0; j < R; j++){ //每个状态的所有起始位置
            if((1 << j) & i == 0) //走过了最开始位置
                continue;
            for(int k = 0; k < R; k++) //更新终点位置
                dp[(1 << k) | i][k] = min(dp[(1 << k) | i][k], dp[i][j] + edges[visit[j]][visit[k]]);
        }
    }
    int mincost = INT_MAX;
    for(int i = 0; i < R; i++) //获取每个位置为结束的最小花费
        mincost = min(mincost, dp[(1 << R) - 1][i]);
    cout << mincost << endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


