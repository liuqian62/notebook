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

    定义 dp[i]为前 i个数中，以第 i个数结尾的子数组最大连续和。

    于是有转移方程：

    dp[i]=max(dp[i−1]+a[i],a[i])

    其中，前面部分代表选择前面的区间的最大值，后面部分代表直接选择a[i]。

    最终答案是所有的dp[i] 的最大值。
```cpp
#include <iostream>
#include <vector>
using namespace std;
int main() {
    int n;
    cin >> n;
    vector<int> v(n);
    for (int i = 0; i < n; ++i) cin>>v[i];
    vector<int> dp(n);
    dp[0] = v[0];
    int res = dp[0];
    for (int i = 1; i < n; ++i) {
        dp[i] = max(dp[i - 1] + v[i], v[i]);
        res = max(dp[i], res);
    }
    cout << res;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP7
* DP7 连续子数组的最大乘积

描述
```
输入一个长度为 n 的整型数组 nums，数组中的一个或连续多个整数组成一个子数组。求所有子数组的乘积的最大值。
1.子数组是连续的，且最小长度为 1 ，最大长度为 n
2.长度为 1 的子数组，乘积视为其本身，比如 [4] 的乘积为 4
3.该题的数据保证最大的乘积不会超过 int 的范围，即不超过2^{32}-1
数据范围:
1 <= n <= 2x10^5
-100 <= a[i] <= 100
```
![img](https://uploadfiles.nowcoder.com/images/20220315/691631423_1647345163713/D11A25F36CA3155277D5A75CD576EA8D)
```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
    int n;cin>>n;
    vector<int>nums(n);
    for(int i=0;i<n;i++) cin>>nums[i];
    int maxF=nums[0],minF=nums[0],ans=nums[0];
    for(int i=1;i<nums.size();i++){
        int maxf=maxF,minf=minF;
        maxF=max(maxf*nums[i],max(nums[i],minf*nums[i]));
        minF=min(minf*nums[i],min(nums[i],maxf*nums[i]));
        ans=max(maxF,ans);
    }
    cout<<ans;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP8
* DP8 乘积为正数的最长连续子数组

描述
```
给定一个长度为 n 的整数数组，请你找出其中最长的乘积为正数的子数组长度。
子数组的定义是原数组中一定长度的连续数字组成的数组。

数据范围：1≤n≤10^5, 数组中的元素满足 |val|<=10^9 
  
```
    pos[i]为到第i个数为止乘积为正数的最长长度；
    neg[i]为到第i个数为止乘积为负数的最长长度；
<!-- ![img]() -->
```cpp
#include<bits/stdc++.h>

using namespace std;
int main(){
    int n; cin>>n;
    vector<int> a(n);
    for(int i=0;i<n;i++) cin>>a[i];
    vector<int>pos(n),neg(n);
    pos[0]=(a[0]>0)? 1:0;
    neg[0]=(a[0]<0)? 1:0;
    int res=0;
    for(int i=1;i<n;i++){
        if(a[i]>0){
            pos[i]=pos[i-1]+1;
            if(neg[i-1]>0) neg[i]=neg[i-1]+1;
        }else if(a[i]==0){
            pos[i]=0;
            neg[i]=0;
        }else{
            neg[i]=pos[i-1]+1;
            if(neg[i-1]>0) pos[i]=neg[i-1]+1;
        }
        res = max(res,pos[i]);
    }
    cout<<res<<endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP9
* DP9 环形数组的连续子数组最大和

描述
```
给定一个长度为 nn 的环形整数数组，请你求出该数组的 非空 连续子数组 的最大可能和 。

环形数组 意味着数组的末端将会与开头相连呈环状。例如，对于数组 [1,3,-5,2,-4][1,3,−5,2,−4]而言，
第一个数1的前一个数是最后一个数−4。
```
<!-- ![img]() -->

    切换看法，按照普通最大连续和的思路，即在dp的过程中可以得到最大的连续子数组和。
    同理，如果再求一个最小的连续子数组和，就会发现一个特性。
    假设用sum记录整个数组的和，那么最大连续子数组和dpmax 和最小连续子数组dpmin和一定是相连的两部分，
    因为假设不想连，中间这一段要么大于0，那么它应该属于最大子数组连续和，
    否则它应该属于最小连续子数组和。
    故最后求得sum，dpmax，dpmin以后就可以进行判定。
    假设dpmax+dpmin<sumdpmax + dpmin < sumdpmax+dpmin<sum这说明数组两边的端点只和是正值，
    故应该把这一部分留给
    dpmax(dpmax=sum−dpmin)(dpmax = sum - dpmin)(dpmax=sum−dpmin)，否则直接返回dpmax即可，
    当然这里有一个特例（在初始化dpmax的时候给予了数组的第一个值v[0]v[0]v[0]，
    如果其是负数，则必定有dpmax+dpmin<sumdpmax +dpmin < sumdpmax+dpmin<sum 故此处应该特判，
    如果dpmax<0dpmax < 0dpmax<0直接返回即可）
```cpp
#include<bits/stdc++.h>
using namespace std;
int solve(vector<int> &v){
    int sum, dpmx, dpmn, mx, mn;
    dpmx = dpmn = mx = mn = sum = v[0];
    for(int i = 1; i < v.size(); ++i){
        mx = max(mx + v[i], v[i]);
        mn = min(mn + v[i], v[i]);
        dpmx = max(dpmx, mx);
        dpmn = min(dpmn, mn);
        sum += v[i];
    }
    if(dpmx< 0) return dpmx;
    if (dpmx + dpmn < sum) dpmx = sum - dpmn;
    return dpmx;
}
int main(){
    int n;
    cin >>n;
    vector<int> v(n);
    for(int i = 0; i < n; ++i){
        cin>>v[i];
    }
    cout<<solve(v)<<endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP10
* DP10 最大子矩阵

描述
```
已知矩阵的大小定义为矩阵中所有元素的和。给定一个矩阵，你的任务是找到最大的非空(大小至少是1 * 1)子矩阵。 比如，如下4 * 4的矩阵 0 -2 -7 0 9 2 -6 2 -4 1 -4 1 -1 8 0 -2 的最大子矩阵是 9 2 -4 1 -1 8 这个子矩阵的大小是15。
```

    数组b吧表示数组a的i~j行对应列元素的和，用动态规划计算b的最大子段和。
<!-- ![img]() -->
```cpp
#include <iostream>
#include <climits>
#define N 100
using namespace std;
int buf[N][N];
int tmp[N][N];//辅助矩阵，其中tmp[i][j]存储的是前i行的第j列的累加之和
int b[N];
int max(int a,int b){return a>b?a:b;}
int main()
{
    int n;
    cin>>n;
    for(int i=0;i<n;i++){
        for(int j=0;j<n;j++){
            cin>>buf[i][j];
        }
    }
    for(int i=0;i<n;i++)//初始化第一行
        tmp[0][i]=buf[0][i];
    for(int i=1;i<n;i++){
        for(int k=0;k<n;k++){
            tmp[i][k]=tmp[i-1][k]+buf[i][k];//累加上一行的值求和
        }
    }
    int maxsum = INT_MIN;
    for(int i=0;i<n;i++){
        for(int j=i;j<n;j++){
            int cursum=0;
            for(int k=0;k<n;k++){
                if(i==0){
                    b[k]=tmp[j][k];
                }
                else{
                    b[k]=tmp[j][k]-tmp[i-1][k];//得到第i行到第j行的累加之和
                }
                cursum=max(b[k],b[k]+cursum);
                maxsum=max(maxsum,cursum);
            }
        }
    }
    cout<<maxsum<<endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP11
* DP11 矩阵的最小路径和

描述
```
给定一个 n * m 的矩阵 a，从左上角开始每次只能向右或者向下走，最后到达右下角的位置，路径上所有的数字累加起来就是路径和，输出所有的路径中最小的路径和。

数据范围: 1≤n,m≤500，矩阵中任意值都满足0≤ai,j ≤100
要求：时间复杂度 O(nm)

例如：当输入[[1,3,5,9],[8,1,3,4],[5,0,6,1],[8,8,4,0]]时，对应的返回值为12，
所选择的最小累加和路径如下图所示：
```
![img](https://uploadfiles.nowcoder.com/images/20220122/423483716_1642823916509/06EB123C153852AF55ED51448BEAD1BA)

    到达出口只能从出口左边或者上边来，这样就很容易写出递归式,并且进行记忆化搜索。
    也可以使用状态方程dp[i][j]=min(dp[i−1][j],dp[i][j−1])+v[i][j]进行递推，处理好边界即可。
```cpp
#include <iostream>
#include <vector>
 
using namespace std;
int main(){
    int n,m;
    cin>>n>>m;
    vector<vector<int>> mat(n,vector<int>(m,0));
    for(int i=0;i<n;i++){
        for(int j=0;j<m;j++){
            cin>>mat[i][j];
        }
    }
    vector<vector<int>> dp(n,vector<int>(m,0));
    dp[0][0]=mat[0][0];
    for(int i=1;i<n;i++) dp[i][0] = dp[i-1][0]+mat[i][0];
    for(int i=1;i<m;i++) dp[0][i] = dp[0][i-1]+mat[0][i];
    for(int i=1;i<n;i++){
        for(int j=1;j<n;j++){
            dp[i][j] = min(dp[i-1][j],dp[i][j-1])+mat[i][j];
        }
    }
    cout<<dp[n-1][m-1]<<endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP12
* DP12 龙与地下城游戏问题

描述
```
给定一个二维数组map，含义是一张地图，例如，如下矩阵
-2 -3  3
-5 -10 1
0  30 -5
游戏的规则如下:
1）骑士从左上角出发，每次只能向右或向下走，最后到达右下角见到公主。
2）地图中每个位置的值代表骑士要遭遇的事情。如果是负数，说明此处有怪兽，要让骑士损失血量。如果是非负数，代表此处有血瓶，能让骑士回血。
3）骑士从左上角到右下角的过程中，走到任何一个位置时，血量都不能少于1。为了保证骑土能见到公主，初始血量至少是多少?
根据map,输出初始血量。
```

    逆推，当某一个位置少于1是，要取1
    终点：dp[-1][-1]=max(1-nums[-1][-1],1)
    最后1行： dp[m-1][i-1]=max(dp[m-1][i]-nums[m-1][i-1],1)
    最后1列：dp[i-1][n-1]=max(dp[i][n-1]-nums[i-1][n-1],0)
    其它位置：dp[i-1][j-1]=max(min(dp[i-1][j]-nums[i-1][j-1],dp[i][j-1]-nums[i-1][j-1]),1)      
    结果在dp[0][0]
<!-- ![img]() -->
```cpp
#include<bits/stdc++.h>
using namespace std;
int main(){
     int n,m;
    cin>>n>>m;
    vector<vector<int>>map(n,vector<int>(m));
    for(int i=0;i<n;i++)
        for(int j=0;j<m;j++)
            cin>>map[i][j];
    vector<vector<int>>dp(n,vector<int>(m));
    dp[n-1][m-1]=max(1-map[n-1][m-1],1);
    for(int i=n-2;i>=0;i--) dp[i][m-1]=max(dp[i+1][m-1]-map[i][m-1],1);
    for(int i=m-2;i>=0;i--) dp[n-1][i]=max(dp[n-1][i+1]-map[n-1][i],1);
    for(int i=n-1;i>0;i--){
        for(int j=m-1;j>0;j--){
            dp[i-1][j-1]=max(min(dp[i-1][j]-map[i-1][j-1],dp[i][j-1]-map[i-1][j-1]),1);
        }
    }
    cout<<dp[0][0]<<endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP13
* DP13 [NOIP2002 普及组] 过河卒

描述
```
棋盘上 A点有一个过河卒，需要走到目标 B点。卒行走的规则：可以向下、或者向右。同时在棋盘上 C 点有一个对方的马，该马所在的点和所有跳跃一步可达的点称为对方马的控制点。因此称之为“马拦过河卒”。

棋盘用坐标表示，A 点 (0, 0)、B点(n,m)，同样马的位置坐标是需要给出的。
现在要求你计算出卒从 A点能够到达 B点的路径的条数，假设马的位置(x,y)是固定不动的，并不是卒走一步马走一步。
注：马一次跳跃到达的点(x1,y1)和马原坐标(x,y)的关系是 |x1-x|+|y1-y|=3 ，且x1!= x ,y1!=y 

数据范围：1≤n,m≤20 ，马的坐标 0≤x,y≤20 
```
![img](https://uploadfiles.nowcoder.com/images/20220311/557336_1646986476229/40254CC5B75C0777974DC1597948729A)

    利用二维数组dp
    卒子只能两个方向走，一个是向右，一个是向下。可得状态方程dp[i][j]=dp[i−1][j]+dp[i][j−1]。
    在处理马点的时候，应该做出判断，如果该点是马点或者马可以跳到的点则应该设置为0，
    即abs(i-x)+abs(j-y) && i != x && j !=y和马点(x,y)(x,y)(x,y)处设置为0
    初始化dp[0][0]=1,dp[i][0]=dp[i−1][0],dp[0][j]=dp[0][j−1]
    注意最后一个坑点，int存储不了，得使用long long
```cpp
#include<bits/stdc++.h>
using namespace std;
int check(int i, int j, int x, int y){//判断马点
    return (abs(i-x) + abs(j-y) == 3 && i != x && j != y) || (i == x && j == y);
}
int main(){
     int n,m,x,y;
    cin>>n>>m>>x>>y;
    long long mp[n+1][m+1];
    mp[0][0] = 1;
    for(int i = 1; i <= n; ++i){//初始化第一列
        mp[i][0] = (check(i, 0, x, y)? 0 : mp[i-1][0]);   
    }
    for(int j = 1; j <=m; ++j){//初始化第一行
        mp[0][j] = (check(0,j,x,y)? 0 : mp[0][j-1]);
    }
    for(int i = 1; i <= n; ++i){
        for(int j = 1; j <= m; ++j){//状态转移计算
            mp[i][j] = (check(i,j,x,y)? 0:mp[i-1][j] + mp[i][j-1]);
        }
    }
    cout<<mp[n][m]<<endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP14
* DP14 最长上升子序列(一)

描述
```
给定一个长度为 n 的数组 arr，求它的最长严格上升子序列的长度。
所谓子序列，指一个数组删掉一些数（也可以不删）之后，形成的新数组。例如 [1,5,3,7,3] 数组，其子序列有：[1,3,3]、[7] 等。但 [1,6]、[1,3,5] 则不是它的子序列。
我们定义一个序列是 严格上升 的，当且仅当该序列不存在两个下标i 和j 满足i<j且 arr_i>=arr_j。
数据范围：0≤n≤1000 , |arr_i|<=10^9 
  
要求：时间复杂度 O(n^2)， 空间复杂度 O(n)
```
<!-- ![img]() -->

    状态设计：dp[i]代表以a[i]结尾的LIS的长度
    状态转移：dp[i]=max(dp[i], dp[j]+1) (0<=j< i, a[j]< a[i])
    边界处理：dp[i]=1 (0<=j< n)
    时间复杂度：O(N^2)
    举例： 对于序列(1, 7, 3, 5, 9, 4, 8)，dp的变化过程如下
 <div class="table-box"><table><thead><tr><th>dp[i]</th><th>初始值</th><th>j=0</th><th>j=1</th><th>j=2</th><th>j=3</th><th>j=4</th><th>j=5</th></tr></thead><tbody><tr><td>dp[0]</td><td>1</td><td></td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>dp[1]</td><td>1</td><td>2</td><td></td><td></td><td></td><td></td><td></td></tr><tr><td>dp[2]</td><td>1</td><td>2</td><td>2</td><td></td><td></td><td></td><td></td></tr><tr><td>dp[3]</td><td>1</td><td>2</td><td>2</td><td>3</td><td></td><td></td><td></td></tr><tr><td>dp[4]</td><td>1</td><td>2</td><td>3</td><td>3</td><td>4</td><td></td><td></td></tr><tr><td>dp[5]</td><td>1</td><td>2</td><td>2</td><td>3</td><td>3</td><td>3</td><td></td></tr><tr><td>dp[6]</td><td>1</td><td>2</td><td>3</td><td>3</td><td>4</td><td>4</td><td>4</td></tr></tbody></table></div>   

```cpp
#include <bits/stdc++.h>
using namespace std;
const int MAXX=100000+5;
const int INF=INT_MAX;

int a[MAXX],dp[MAXX]; // a数组为数据，dp[i]表示以a[i]结尾的最长递增子序列长度

int main()
{
    int n;
    while(cin>>n)
    {
        for(int i=0; i<n; i++)
        {
            cin>>a[i];
            dp[i]=1; // 初始化为1，长度最短为自身
        }
        int ans=1;
        for(int i=1; i<n; i++)
        {
            for(int j=0; j<i; j++)
            {
                if(a[i]>a[j])
                {
                    dp[i]=max(dp[i],dp[j]+1);  // 状态转移
                }
            }
            ans=max(ans,dp[i]);  // 比较每一个dp[i],最大值为答案
        }
        cout<<ans<<endl;
    }
    return 0;
}


```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP15
* DP15 拦截导弹

描述
```
某国为了防御敌国的导弹袭击，发展出一种导弹拦截系统。但是这种导弹拦截系统有一个缺陷：虽然它的第一发炮弹能够到达任意的高度，但是以后每一发炮弹都不能高于前一发的高度。某天，雷达捕捉到敌国的导弹来袭。由于该系统还在试用阶段，所以只一套系统，因此有可能不能拦截所有的导弹。
输入导弹依次飞来的高度（雷达给出的高度数据是不大于1000的正整数），计算这套系统最多能拦截多少导弹，如果要拦截所有导弹最少要配备多少套这种导弹拦截系统。

数据范围：导弹个数 n 满足1≤n≤1000  ，导弹的高度 m 满足1≤m≤1000 
```
<!-- ![img]() -->
    Dilworth定理:
    最少的下降序列个数就等于整个序列最长上升子序列的长度
```cpp
#include<iostream>
#define INT_MIN     (-2147483647 - 1)
#define INT_MAX       2147483647
using namespace std;
 
int cost(int* hight,int num){
    int last_min = hight[0];
    int max_num = INT_MIN;
    int* long_list = new int[num];
    for (int i = 0; i < num; i++) long_list[i] = 1;
    for (int i = 1; i < num; i++) {
        for (int j = 0; j < i; j++) {
            if (hight[j] >= hight[i])
            {
                long_list[i] = max(long_list[i],long_list[j]+1);
            }
        }
        max_num = max (max_num,long_list[i]);
         
    }
     
    return max_num;
}
 
//Dilworth定理 最少的下降序列个数就等于整个序列最长上升子序列的长度
int times(int* lists, int num){
    int last_min = lists[0];
    int max_num = INT_MIN;
    int* long_list = new int[num];
    for (int i = 0; i < num; i++) long_list[i] = 1;
    for (int i = 1; i < num; i++) {
        for (int j = 0; j < i; j++) {
            if (lists[j] < lists[i])
            {
                long_list[i] = max(long_list[i],long_list[j]+1);
            }
        }
        max_num = max (max_num,long_list[i]);
         
    }
    return max_num;
}
 
int main(){
    int num;
    int* hight;
    cin >> num;
    hight = new int[num];
     
    for( int i = 0;i < num; i++){
        cin >> hight[i];
    }
     
    cout << cost(hight,num) << endl;
    cout << times(hight,num) <<endl;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP16
* DP16 合唱队形

描述
```
N位同学站成一排，音乐老师要请其中的 (N-K) 位同学出列，使得剩下的K位同学排成合唱队形。

合唱队形是指这样的一种队形：设K位同学从左到右依次编号为 1，2…，K，他们的身高分别为 T1，T2，…，TK，  则他们的身高满足 t_1 < t_2 ... < t_i > t_{i+1} > ... > t_{k-1} > t_k  (1≤i≤k) 

你的任务是，已知所有 n 位同学的身高，计算最少需要几位同学出列，可以使得剩下的同学排成合唱队形。

数据范围：1≤n≤1000  ，身高满足130≤t ≤230 
```
    dp动态规划 题目是求出最少出来几人满足队形，反向思考 求满足队形的最多人数是多少？ 
    这个题目左边的身高要比当前身高小，右边也是要比当前身高小并且是线性。与求最长的升
    序子序列问题类似，只不过本题目需要从两个维度去思考，左边和右边，左边是升序，右边降序。
    思路： 计算每个位置截止的最大上升长度和每个位置开始的最大下降长度，求和减一取最大值。
<!-- ![img]() -->
```cpp
#include<iostream>
#define INT_MIN     (-2147483647 - 1)
#define INT_MAX       2147483647
using namespace std;
 
int get_down(int* hight,int num,int* long_list){
    int last_min = hight[0];
    int max_num = INT_MIN;
    for (int i = 0; i < num; i++) long_list[i] = 1;
    for (int i = num-1; i>=0; i--) {
        for (int j = num-1; j >i; j--) {
            if (hight[i] > hight[j])
            {
                long_list[i] = max(long_list[i],long_list[j]+1);
            }
        }
        max_num = max (max_num,long_list[i]);
         
    }
     
    return max_num;
}

 int get_up(int* lists, int num,int* long_list){
    int last_min = lists[0];
    int max_num = INT_MIN;
    for (int i = 0; i < num; i++) long_list[i] = 1;
    for (int i = 1; i < num; i++) {
        for (int j = 0; j < i; j++) {
            if (lists[j] < lists[i])
            {
                long_list[i] = max(long_list[i],long_list[j]+1);
            }
        }
        max_num = max (max_num,long_list[i]);
         
    }
    return max_num;
}
 
int main(){
    int num;
    int* hight;
    cin >> num;
    hight = new int[num];
     
    for( int i = 0;i < num; i++){
        cin >> hight[i];
    }
    int* up_list = new int[num];
    int* down_list = new int[num];
    get_up(hight,num, up_list);
    get_down(hight,num, down_list);
    int maxUpDown = 1;
    //记录先上升后下降的最长序列长度
    for (int i = 0; i < num; ++i){
        maxUpDown = max(maxUpDown,up_list[i] + down_list[i] -  1);
    }
    //求剔除人数
    int res = num - maxUpDown;
    cout<<res<<endl;
     return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP17
* DP17 信封嵌套

描述
```
给 n 个信封的长度和宽度。如果信封 a 的长和宽都小于信封 b ，那么信封 a 可以放到信封 b 里，请求出信封最多可以嵌套多少层。

数据范围：1≤n≤2×10^3, 1≤letters[i][0],letters[i][1]≤2×10^3
 
要求：空间复杂度 O(n)，时间复杂度 O(n^2) 
要求：空间复杂度 O(n)O(n) ，时间复杂度 O(nlogn)O(nlogn)
```
    先对宽度 w 进行升序排序，如果遇到 w 相同的情况，则按照高度 h 降序排序。
    之后把所有的 h 作为一个数组，在这个数组上计算 LIS 的长度就是答案。
<!-- ![img]() -->
```cpp
#include <bits/stdc++.h>
using namespace std;
 
struct node
{
    int a; //长
    int b; //宽
}arr[2005];
 
int n;
int dp[2005];
 
//按照a从小到大排序，若a相等按照b从小到大排序
bool cmp(node x, node y)
{
    if(x.a == y.a)
    {
        return x.b < y.b;
    }
    return x.a < y.a;
}
int main()
{
    cin >> n;
    for(int i = 1; i <= n; i++)
    {
        cin >> arr[i].a;
        cin >> arr[i].b;
    }
     
    sort(arr+1, arr+1+n, cmp); //将信封从小到大排序
    
     
    // 求最长上升子序列
    int ans = 0;
    for(int i = 1; i <= n; i++)
    {
        dp[i] = 1;
        for(int j = 1; j < i; j++)
        {
            if(arr[j].a < arr[i].a && arr[j].b < arr[i].b)
            {
                dp[i] = max(dp[i], dp[j]+1);
            }    
        }
        ans = max(ans, dp[i]);
    }
    cout << ans << endl;
    return 0;
}
```

<div align="right">
    <b><a href="#目录">↥ Back To Top</a></b>
</div>


### DP18


<details>
<summary><b>点击查看：DP18 滑雪</b></summary>
* DP18 滑雪

描述
```
给定一个n×m 的矩阵，矩阵中的数字表示滑雪场各个区域的高度，你可以选择从任意一个区域出发，并滑向任意一个周边的高度严格更低的区域（周边的定义是上下左右相邻的区域）。请问整个滑雪场中最长的滑道有多长？(滑道的定义是从一个点出发的一条高度递减的路线）。
(本题和矩阵最长递增路径类似，该题是当年NOIP的一道经典题)

数据范围：1≤n,m≤100 ，矩阵中的数字满足1≤val≤1000 
输入描述：
第一行输入两个正整数 n 和 m 表示矩阵的长宽。
后续 n 行输入中每行有 m 个正整数，表示矩阵的各个元素大小。

输出描述：
输出最长递减路线。
```

</details>

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


